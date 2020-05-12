//
//  ParserService.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 28.04.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ParserService {

func parseFriends(data: Data) -> [Friends] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Friends in
                let friend = Friends()
                
                friend.id = item["id"].intValue
                friend.name = item["first_name"].stringValue
                friend.surname = item["last_name"].stringValue
                friend.photo = item["photo_50"].stringValue
                
                return friend
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func parseGroups(data: Data) -> [Groups] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
         let result = array.map { item -> Groups in
             let groups = Groups()
            
                 groups.name = item["name"].stringValue
                 groups.photo = item["photo_50"].stringValue
                 groups.type = item["activity"].stringValue
                 groups.id = item["id"].intValue
                
                return groups
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

      


        func parsePhotos(data: Data) -> [Photos] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Photos in
                let photo = Photos()
                
                photo.id = item["id"].intValue
                photo.ownerId = item["owner_id"].intValue
                
                let sizeValues = item["sizes"].arrayValue
                if let first = sizeValues.first(where: { $0["type"].stringValue == "z" }) {
                    photo.imageURL = first["url"].stringValue
                }
                
                return photo
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func parseNews(data: Data) -> [News] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> News in
                
                let news = News()
                
                news.postId = item["post_id"].intValue
                news.sourceId = item["source_id"].intValue
                news.date = item["date"].doubleValue
                news.text = item["text"].stringValue
                
                let photoSet = item["attachments"].arrayValue.first?["photo"]["sizes"].arrayValue
                if let first = photoSet?.first (where: { $0["type"].stringValue == "z" } ) {
                    news.imageURL = first["url"].stringValue
                }
                
                
                news.views = item["views"]["count"].intValue
                news.likes = item["likes"]["count"].intValue
                news.comments = item["comments"]["count"].intValue
                news.reposts = item["reposts"]["count"].intValue
                
                return news
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func parseSourceGroups(data: Data) -> [NewsSource] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["groups"].arrayValue
            
            let result = array.map { item -> NewsSource in
            
                let sourceGroup = NewsSource()
                
                sourceGroup.id = item["id"].intValue
                sourceGroup.name = item["name"].stringValue
                sourceGroup.photo = item["photo_50"].stringValue
                
                
                return sourceGroup
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func parseSourceUsers(data: Data) -> [NewsSource] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["profiles"].arrayValue
            
            let result = array.map { item -> NewsSource in
                
                let sourceUser = NewsSource()
                sourceUser.id = item["id"].intValue
                sourceUser.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                sourceUser.photo = item["photo_50"].stringValue
                
                
                return sourceUser
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
