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
                                print(friends)
                                do{
                                    try DataBaseService.saveFriends(friends: friends)
                                } catch {
                                    print("Error while saving users to db")
                                    }
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
                                print(groups)
                                
                                do{
                                    try DataBaseService.saveGroups(groups: groups)
                                } catch {
                                    print("Error while saving groups to db")
                                    }
                              }
        }
    }
    
    func getPhotos(token: String, completion: @escaping ([Photos]) -> Void) {
        
        let path = "photos.get"
        
        let params: Parameters = [
            "access_token" : token,
            "owner_id" : -1,
            "v" : "5.103"
        ]
        
        let requestURL = vkURL + path
            AF.request(requestURL,
                              method: .post,
                              parameters: params).responseJSON { [completion] (response) in
                              if let error = response.error {
                                  print(error)
                              } else {
                                  guard let data = response.data else { return }
                                  
                                let photos = self.parser.parsePhotos(data: data)
                                    //print(photos)
                                      
                                      completion(photos)
                                  }
        }
    }
   
    func getNews(token: String) {
        
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
                                do{
                                    try DataBaseService.saveNews(news: news)
                                    try DataBaseService.saveSourceGroups(sourseGroups: sourceGroups)
                                    try DataBaseService.saveSourceUsers(sourseUsers: sourceUsers)
                                } catch {
                                    print("Error while saving groups to db")
                                    }
                                  }
        }
    }
}

