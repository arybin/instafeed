 //
//  PresentDetailTransition.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/16/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit
 
 class PresentDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let detail = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let containerView = transitionContext.containerView()!
        
        detail.view.alpha = 0.0
        
        var frame = containerView.bounds
        frame.origin.y += 20
        frame.size.height -= 20
        detail.view.frame = frame
        containerView.addSubview(detail.view)
        
        UIView.animateWithDuration( 0.5, animations: { () -> Void in
            detail.view.alpha  = 1
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25 //half a second
    }
    
 }
