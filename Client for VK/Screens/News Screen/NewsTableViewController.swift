//
//  NewsTableViewController.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 17/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UITableViewController {
    
    var castomRefreshControl = UIRefreshControl()
    private let queue: DispatchQueue = DispatchQueue(label: "News_queue", qos: .userInteractive, attributes: [.concurrent])
    let vkAPI = VKApi()
    lazy var photoService: PhotoService = PhotoService(container: self.tableView)
    let db = DataBaseService()
    var sections: [Results<News>] = []
    var tokens: [NotificationToken] = []
    var like = LikeButton()
    
    func loadNewsSections() {
        do {
            tokens.removeAll()
            let realm = try Realm()
            sections = Array( arrayLiteral: realm.objects(News.self).sorted(byKeyPath: "date", ascending: false) )
            sections.enumerated().forEach{ observeChanges(section: $0.offset, results: $0.element) }
            tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func observeChanges(section: Int, results: Results<News>) {
        tokens.append(
            results.observe { [weak self] (changes) in
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
            }
        )
    }
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "MyNews")
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        vkAPI.getNews {
            DispatchQueue.main.async {
                self.loadNewsSections()
                self.tableView.reloadData()
            }
        }
        addRefreshControl()
    }
    
    //Индикатор обновления при потягивании экрана вниз
    func addRefreshControl() {
        castomRefreshControl.attributedTitle = NSAttributedString(string: "Обновление...")
        castomRefreshControl.addTarget(self, action: #selector(reloadNews), for: .valueChanged)
        tableView.addSubview(castomRefreshControl)
    }
    
    @objc func reloadNews() {
        
        vkAPI.getNews {
            DispatchQueue.main.async {
                
                self.loadNewsSections()
                self.tableView.reloadData()
                self.castomRefreshControl.endRefreshing()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNews", for: indexPath) as? NewsCell
        let news = sections[indexPath.section][indexPath.row]
        cell?.news.text = news.text
        
        
        if let source = self.db.getNewsSourceById(id: news.sourceId) {
            cell?.username.text = source.name
            cell?.time.text = getCellDateText(forIndexPath: indexPath, andTimestamp: news.date)
            let imageURL = source.photo
            cell?.avatar.image = photoService.photo(atIndexpath: indexPath, byUrl: imageURL)
            let imageNewsURL = news.imageURL
            cell?.pic.image = photoService.photo(atIndexpath: indexPath, byUrl: imageNewsURL)
            cell?.likeButton.likeCount = news.likes
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy HH:mm"
        return formatter
    }()
    
    private var dateCache: [IndexPath: String] = [:]
    
    
    func getCellDateText(forIndexPath indexPath: IndexPath, andTimestamp timestamp: Double) -> String {
            if let stringDate = dateCache[indexPath] {
                return stringDate
            } else {
                let date = Date(timeIntervalSince1970: timestamp)
                let stringDate = dateFormatter.string(from: date)
                dateCache[indexPath]  = stringDate
                return stringDate
            }
        }

}
