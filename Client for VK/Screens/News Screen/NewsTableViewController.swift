//
//  NewsTableViewController.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 17/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var castomRefreshControl = UIRefreshControl()

    var newsArray = ["Boeing приостанавливает производство 737 MAX. Это связано с отказом американского авиарегулятора разрешить полеты этих самолетов в текущем году. Почему производство 737 MAX не было прекращено сразу после запрета?"]
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "MyNews")
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
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
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNews", for: indexPath) as? NewsCell
        cell?.news.text = newsArray[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
}
