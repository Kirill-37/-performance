//
//  GroupsClass.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 06/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import RealmSwift
import UIKit

class Groups: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var type: String = ""
    
    override class func primaryKey() -> String? {
           return "id"
       }
}


