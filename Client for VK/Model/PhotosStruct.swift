//
//  PhotosStruct.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 31.03.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import RealmSwift
import UIKit

class Photos: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageURL: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
