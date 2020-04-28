//
//  NewsSource.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 28.04.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import UIKit
import RealmSwift

class NewsSource: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
