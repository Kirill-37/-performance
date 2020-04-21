//
//  GroupSeachList.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 06/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit

class GroupSeachList: UITableViewController {
    
    var groups = ["Природа приморского края",
                  "Камчатка как она есть",
                  "Чукотка глазами фотографа",
                  "Рыбалка здесь и сейчас"]
        
        override func viewDidLoad() {
            super.viewDidLoad()

        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return groups.count
        }
        
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! GroupSeachCell
        cell.textLabel?.text = groups[indexPath.row]
            return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groups[indexPath.row])
    }
        
}
