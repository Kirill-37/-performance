//
//  FriendList.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 05/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import Alamofire


class FriendList: UITableViewController {
    
    let vkAPI = VKApi()
    lazy var photoService: PhotoService = PhotoService(container: self.tableView)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sections: [Results<Friends>] = []
    var tokens: [NotificationToken] = []
    var cachedAvatars = [String: UIImage]()
    var requestHandler: UInt = 0
    
    private let requestUrl = "https://api.vk.com/method/friends.get"
    private let params: Parameters = [
        "access_token" : UserSession.shared.token,
        "fields" : "photo_50",
        "v" : "5.103"
    ]
    
    private let opq = OperationQueue()
    
    func loadFriendsSections() {
        do {
            let realm = try Realm()
            let friendsLetters = Array( Set( realm.objects(Friends.self).compactMap{ $0.name.first?.lowercased() } ) ).sorted()
            sections = friendsLetters.map{ realm.objects(Friends.self).filter("name BEGINSWITH[cd] %@", $0) }
            tokens.removeAll()
            sections.enumerated().forEach{ observeChanges(for: $0.offset, results: $0.element) }
            tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func observeChanges(for section: Int, results: Results<Friends>) {
        tokens.append( results.observe { [weak self](changes) in
            switch changes {
            case .initial:
                self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                self?.tableView.endUpdates()
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opq.qualityOfService = .userInteractive
        
        let request = AF.request(requestUrl, parameters: params)
        
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        
        let parseUser = ParseUserOperation()
        
        parseUser.addDependency(getDataOperation)
        opq.addOperation(parseUser)
        
        
        parseUser.completionBlock = {
            OperationQueue.main.addOperation {
                self.loadFriendsSections()
                
            }
        }
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        
        
        cell.username.text = sections[indexPath.section][indexPath.row].name + " " + sections[indexPath.section][indexPath.row].surname
        
        let url = sections[indexPath.section][indexPath.row].photo
        cell.avatar.image = photoService.photo(atIndexpath: indexPath, byUrl: url)
        
        return cell
    }
    
    
    func addFriend( with name: String, withID : Int? = nil ) -> Int {
        do {
            let realm = try Realm()
            let newFriend = Friends()
            newFriend.name = name
            newFriend.id = (realm.objects(Friends.self).max(ofProperty: "id") as Int? ?? 0) + 1
            
            if let ownId = withID {
                newFriend.id = ownId
            }
            realm.beginWrite()
            realm.add(newFriend)
            try realm.commitWrite()
            
            if let firstLetter = name.first?.uppercased(),
                let currentLetters = sectionIndexTitles(for: tableView),
                !currentLetters.contains(firstLetter) {
                loadFriendsSections()
            }
            
            return newFriend.id
        }
        catch {
            print(error.localizedDescription)
            return -1
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let friend = sections[indexPath.section][indexPath.row]
        
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(friend)
                try realm.commitWrite()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPhoto" {
            guard let friendPhotoController = segue.destination as? PhotoController else { return }
            
            if let indexPath = tableView.indexPathForSelectedRow {
                friendPhotoController.user = sections[indexPath.section][indexPath.row]
            }
            
            
        }
    }
}




