//
//  Indicator.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 24.12.2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit

class Indicator: UIView {
    @IBOutlet weak var firstIndicator: CircleImageView!
    @IBOutlet weak var secondIndicator: CircleImageView!
    @IBOutlet weak var thirdIndicator: CircleImageView!
    
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    func animateIndicator() {
          UIView.animate(withDuration: 0.6,
                         delay: 0,
                         options: [.repeat, .autoreverse, .curveLinear],
                         animations: {
            self.firstIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
          }) { _ in
            self.firstIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        
            UIView.animate(withDuration: 0.6,
                           delay: 0.3,
                           options: [.repeat, .autoreverse, .curveLinear],
                           animations: {
              self.secondIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
              self.secondIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
              }
        
            UIView.animate(withDuration: 0.6,
                           delay: 0.6,
                           options: [.repeat, .autoreverse, .curveLinear],
                           animations: {
              self.thirdIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
              self.thirdIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
              }
        
    }
    
    func xibSetup() {
        
        contentView = loadFromXib()
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        animateIndicator()
        
    }
    
    func loadFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return xib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
