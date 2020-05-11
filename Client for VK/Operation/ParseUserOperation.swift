//
//  ParseUserOperation.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 11.05.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import UIKit
import SwiftyJSON

class ParseGroupsOperation: Operation {
    
    private let db = DataBaseService()
    
    var outputData: [Friends] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        
        do {
            let json = try JSON(data: data)
            let friends: [Friends] = json["response"]["items"].compactMap {
                let friend = Friends()
                
                friend.id = $0.1["id"].intValue
                friend.name = $0.1["first_name"].stringValue
                friend.surname = $0.1["last_name"].stringValue
                friend.photo = $0.1["photo_50"].stringValue
                return friend
            }
            outputData = friends
            
            try db.saveObjects(objects: outputData)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
