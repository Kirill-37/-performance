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
    
    func saveObjects(objects: [Object]) {
                do {
                    let realm = try Realm()
                    print(realm.configuration.fileURL!)
                    realm.beginWrite()
                    realm.add(objects, update: .modified)
                    try realm.commitWrite()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
    
    
    func saveObject(object: Object) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(object, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteObject(object: Object) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(object)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
        
    }

    func getNewsSourceById(id: Int) -> NewsSource? {
        do {
            let realm = try Realm()
            let newsSource = realm.objects(NewsSource.self).filter("id = %@", abs(id)).first
            return newsSource
            
        } catch {
            print(error.localizedDescription)
            return NewsSource()
        }

    }
    
    func getUserPhotos(ownerId: Int) -> [Photos] {
        do {
            let realm = try Realm()
            let photos = realm.objects(Photos.self).filter("ownerId = %@", ownerId)
            return Array(photos)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    

    
    
        
}

