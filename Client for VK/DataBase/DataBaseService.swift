//
//  DataBase.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 06.04.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseService {
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func saveFriends(friends: [Friends],
              configaration: Realm.Configuration = deleteIfMigration,
                     update: Realm.UpdatePolicy = .modified) throws {
    let realm = try Realm(configuration: configaration)
    print(realm.configuration.fileURL)
    try realm.write {
        realm.add(friends, update: update)
        }
    }
    
    static func saveGroups(groups: [Groups],
                    configaration: Realm.Configuration = deleteIfMigration,
                     update: Realm.UpdatePolicy = .modified) throws {
    let realm = try Realm(configuration: configaration)
    try realm.write {
        realm.add(groups, update: update)
        }
    }

    static func savePhotos(_ photos: [Photos], friendId: Int) {

        guard let realm = try? Realm(),
              let friend = realm.object(ofType: Friends.self, forPrimaryKey: friendId) else { return }

        try? realm.write {
            realm.add(photos, update: .modified)
            friend.photos.append(objectsIn: photos)
        }
    }
        
}

