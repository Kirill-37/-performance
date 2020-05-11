//
//  VKApi.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 15.03.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift



class VKApi {
    
    private var parser = ParserService()
    private var db: DataBaseService = .init()
    private let queue = DispatchQueue(label: "Api_queue")
    let vkURL = "https://api.vk.com/method/"
    
    func getFriends(token: String) {
        
        let path = "friends.get"
        
        let params: Parameters = [
            "access_token" : token,
            "fields" : "photo_50",
            "v" : "5.103"
        ]
        
        let requestURL = vkURL + path
        
        AF.request(requestURL,
                   method: .post,
                   parameters: params).responseJSON(queue: queue) { (response) in
                    if let error = response.error {
                        print(error)
                    } else {
                        guard let data = response.data else { return }
                        
                        let friends: [Friends] = self.parser.parseFriends(data: data)
                        //print(friends)
                        self.db.saveObjects(objects: friends)
                        
                    }
                    
        }
    }
    
    
    func getGroups(token: String) {
        
        let path = "groups.get"
        
        let params: Parameters = [
            "access_token" : token,
            "extended" : 1,
            "v" : "5.103"
        ]
        
        
        let requestURL = vkURL + path
        AF.request(requestURL,
                   method: .post,
                   parameters: params).responseJSON(queue: queue) { (response) in
                    if let error = response.error {
                        print(error)
                    } else {
                        guard let data = response.data else { return }
                        
                        let groups = self.parser.parseGroups(data: data)
                        //print(groups)
                        
                        self.db.saveObjects(objects: groups)
                        
                    }
        }
    }
    
    func getPhotos(userID: Int, completion: @escaping () -> Void) {
        
        let path = "photos.get"
        
        let params: Parameters = [
            "owner_id" : userID,
            "album_id" : "profile",
            "v" : "5.103"
        ]
        
        let requestURL = vkURL + path
        AF.request(requestURL,
                   method: .post,
                   parameters: params).responseJSON(queue:queue) { [completion] (response) in
                    if let error = response.error {
                        print(error)
                    } else {
                        guard let data = response.data else { return }
                        
                        let photos = self.parser.parsePhotos(data: data)
                        print(photos)
                        
                        self.db.saveObjects(objects: photos)
                        
                        completion()
                    }
        }
    }
    
    func getImageByURL(imageUrl: String) -> UIImage? {
              let urlString = imageUrl
                  guard let url = URL(string: urlString) else { return nil }
                  
                  if let imageData: Data = try? Data(contentsOf: url) {
                      return UIImage(data: imageData)
                  }
                  
                  return nil
          }
    
    func getNews(completion: @escaping () -> Void) {
        
        let path = "newsfeed.get"
        
        let params: Parameters = [
            "access_token" : UserSession.shared.token,
            "filters" : "post",
            "v" : "5.103"
        ]
        
        let requestURL = vkURL + path
        AF.request(requestURL,
                   method: .post,
                   parameters: params).responseJSON(queue: queue) { (response) in
                    if let error = response.error {
                        print(error)
                    } else {
                        guard let data = response.data else { return }
                        
                        let news = self.parser.parseNews(data: data)
                        print(news)
                        let sourceGroups = self.parser.parseSourceGroups(data: data)
                        let sourceUsers = self.parser.parseSourceUsers(data: data)
                        
                        self.db.saveObjects(objects: news)
                        self.db.saveObjects(objects: sourceGroups)
                        self.db.saveObjects(objects: sourceUsers)
                        
                    }
        }
    }
}

