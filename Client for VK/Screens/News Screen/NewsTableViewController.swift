//
//  NewsTableViewController.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 17/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

// MARK: HW №1 -performance
import UIKit
import RealmSwift

class NewsViewController: UITableViewController {
    
    var castomRefreshControl = UIRefreshControl()
    private let queue: DispatchQueue = DispatchQueue(label: "News_queue", qos: .userInteractive, attributes: [.concurrent])
    let vkAPI = VKApi()
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
              results.observe { (changes) in
                  switch changes {
                  case .initial:
                      self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                      
                  case .update(_, let deletions, let insertions, let modifications):
                      self.tableView.beginUpdates()
                      self.tableView.deleteRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                      self.tableView.insertRows(at: insertions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                      self.tableView.reloadRows(at: modifications.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                      self.tableView.endUpdates()
                  
                  case .error(let error):
                      print(error.localizedDescription)
                  
                  }
              }
          )
      }

    /*var newsArray = ["Boeing приостанавливает производство 737 MAX. Это связано с отказом американского авиарегулятора разрешить полеты этих самолетов в текущем году. Почему производство 737 MAX не было прекращено сразу после запрета?"]*/
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "MyNews")
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        vkAPI.getNews {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadNewsSections()
            }
            
        }
        addRefreshControl()
    }
    
    //Индикатор обновления при потягивании экрана вниз
    func addRefreshControl() {
        castomRefreshControl.attributedTitle = NSAttributedString(string: "Обновление...")
        castomRefreshControl.addTarget(self, action: #selector(addRefreshTable), for: .valueChanged)
        tableView.addSubview(castomRefreshControl)
    }
   
    @objc func addRefreshTable() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.castomRefreshControl.endRefreshing()
        }
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNews", for: indexPath) as? NewsCell
        let news = sections[indexPath.section][indexPath.row]
        cell?.news.text = news.text
        
        
        if let source = self.db.getNewsSourceById(id: news.sourceId) {
            cell?.username.text = source.name
            cell?.time.text = dateConverter(inputDate: news.date)
            let imageURL = source.photo
            queue.async {
                if let image = self.vkAPI.getImageByURL(imageUrl: imageURL) {
                    
                    DispatchQueue.main.async {
                        cell?.avatar.image = image
                    }
                }
            }
        }
        
        cell?.pic.image = UIImage(imageLiteralResourceName: "pic")
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
    
    private func dateConverter(inputDate: Double) -> String {
        let dateFormatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: inputDate)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let convertedDate = dateFormatter.string(from: date as Date)
        return convertedDate
    }

    
}
