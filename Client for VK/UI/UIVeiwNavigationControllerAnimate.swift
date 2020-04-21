//
//  UIVeiwNavigationControllerAnimate.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 25.01.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import UIKit


final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let = transitionContext.viewController(forKey: .from)
        let = transitionContext.viewController(forKey: .to)
        transitionContext.contanerView
    }
}
