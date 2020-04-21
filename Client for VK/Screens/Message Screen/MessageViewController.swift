//
//  MessageViewController.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 16/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {
    
    var castomRefreshControl = UIRefreshControl()
    
    var messageArray = ["Привет! как дела?",
                        "Во сколько тебя ждать? и где встречаемся, давай определимся?",
                        "Заеду в 20:00",
                        "В этом году ниразу не был в отпуске, устал, хочу уехать месяца на три в Тайланд"]
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "SimpleMessage")
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        addRefreshControl()
    }
    
    //Индикатор бновления при потягивании экрана вниз
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
        return messageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleMessage", for: indexPath) as? MessageCell
        cell?.message.text = messageArray[indexPath.row]
        return cell!
    }
}
