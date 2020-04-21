//
//  Like.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 13/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import Foundation
import UIKit

class LikeButton: UIButton {
    private var liked: Bool = false {
        didSet {
            if liked {
                setLiked()
            } else {
                disableLike()
            }
        }
    }
    
    private var likeCount = 776
    func like() {
        liked = !liked
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefault()
    }
    
    private func setupDefault() {
        setImage(UIImage(named: "like"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = liked ? .red : .gray
        
        imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    private func setLiked() {
        likeCount += 1
        setImage(UIImage(named: "like"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .red
        animateAuthButton()
    }
    
    private func disableLike() {
        likeCount -= 1
        setImage(UIImage(named: "like"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .gray
        animateAuthButton()
    }
    
    //реализация анимации лайк-дизлайк
    func animateAuthButton() {
       let animation = CASpringAnimation(keyPath: "transform.scale")
           animation.fromValue = 1.2
           animation.toValue = 1
           animation.stiffness = 600
           animation.mass = 1
           animation.duration = 3
           animation.fillMode = CAMediaTimingFillMode.both
           layer.add(animation, forKey: nil)
       }
    
}
