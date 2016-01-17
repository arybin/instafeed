//
//  DismissDetailTransition.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/16/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class DismissDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let detail = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            detail.view.alpha = 0.0
            }) { (finished: Bool) -> Void in
                detail.view.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
}
