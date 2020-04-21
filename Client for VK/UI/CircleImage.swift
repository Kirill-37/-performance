//
//  CircleImage.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 13/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit

class CircleImageView: UIView {
    var circleImage: UIImageView!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
    }
    
  
    
    func addImage() {
        circleImage = UIImageView(frame: frame)
        addSubview(circleImage)
    }
    
    override func layoutSubviews() {
        circleImage.frame = bounds
        
        layer.backgroundColor = UIColor.clear.cgColor
        /*layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0*/
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        circleImage.layer.cornerRadius = bounds.height / 2
        circleImage.layer.masksToBounds = true
    }
    
  
}
