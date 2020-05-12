//
//  NewsCell.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 17/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

// MARK: HW №1 -performance
import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var news: UILabel!
    
    @IBAction func addLike(_ sender: Any) {
            (sender as! LikeButton).like()
    }
    

}
