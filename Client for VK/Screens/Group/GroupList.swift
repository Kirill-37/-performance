//
//  GroupList.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 05/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift


class GroupList: UITableViewController {
    
      @IBOutlet weak var searchBarGroup: UISearchBar!
    
    let vkAPI = VKApi()
    
    
    
    var sections: [Results<Groups>] = []
    var tokens: [NotificationToken] = []
    var cachedAvatars = [String: UIImage]()
    var requestHandler: UInt = 0
    
    func loadGroupsSections() {
    do {
        let realm = try Realm()
        let groupsLetters = Array( Set( realm.objects(Groups.self).compactMap{ $0.name.first?.lowercased() } ) ).sorted()
        sections = groupsLetters.map{ realm.objects(Groups.self).filter("name BEGINSWITH[c] %@", $0) }
        tokens.removeAll()
        sections.enumerated().forEach{ observeChanges(for: $0.offset, results: $0.element) }
        tableView.reloadData()
    }
    catch {
        print(error.localizedDescription)
    }
    }
    
    func observeChanges(for section: Int, results: Results<Groups>) {
        tokens.append( results.observe { (changes) in
            switch changes {
            case .initial:
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                self.tableView.beginUpdates()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                self.tableView.insertRows(at: insertions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                self.tableView.endUpdates()
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroupsSections()
        vkAPI.getGroups(token: UserSession.shared.token)
        
        //searchBar.delegate = self
        
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections[section].count
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sections[section].first?.name.first?.uppercased()
        }
        
        override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            let sectionsJoined = sections.joined()
            let letterArray = sectionsJoined.compactMap{ $0.name.first?.uppercased() }
            let set = Set(letterArray)
            return Array(set).sorted()
        }
        
        
        let queue = DispatchQueue(label: "Groups_avatar_download_queue")
        
        private func downloadImage( for url: String, indexPath: IndexPath ) {
            queue.async {
                if self.cachedAvatars[url] == nil {
                    if let image = self.vkAPI.getImageByURL(imageUrl: url) {
                        self.cachedAvatars[url] = image
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
           
           override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as? GroupCell else {
               return UITableViewCell()
           }
            
            
            cell.groupId.text = sections[indexPath.section][indexPath.row].name
            
            let url = sections[indexPath.section][indexPath.row].photo
            if let cashed = cachedAvatars[url] {
                cell.groupAva.image = cashed
            } else {
                downloadImage(for: url, indexPath: indexPath)
            }
                
                return cell
            }
        
        
        func addGroups( with name: String, withID : Int? = nil ) -> Int {
            do {
                let realm = try Realm()
                let newGroup = Groups()
                newGroup.name = name
                newGroup.id = (realm.objects(Groups.self).max(ofProperty: "id") as Int? ?? 0) + 1
                
                if let ownId = withID {
                    newGroup.id = ownId
                }
                realm.beginWrite()
                realm.add(newGroup)
                try realm.commitWrite()
                
                if let firstLetter = name.first?.uppercased(),
                    let currentLetters = sectionIndexTitles(for: tableView),
                    !currentLetters.contains(firstLetter) {
                    loadGroupsSections()
                }
                
                return newGroup.id
            }
            catch {
                print(error.localizedDescription)
                return -1
            }
        }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let group = sections[indexPath.section][indexPath.row]
        
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
  

