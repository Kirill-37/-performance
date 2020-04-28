//
//  NewsStruct.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 28.04.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import UIKit
import RealmSwift

class News: Object {
    
    @objc dynamic var postId: Int = 0
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var date: Double = 0
    @objc dynamic var text: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var views: Int = 0
    @objc dynamic var likes: Int = 0
    @objc dynamic var comments: Int = 0
    @objc dynamic var reposts: Int = 0
    
    override class func primaryKey() -> String? {
        return "postId"
    }
       
}
