//
//  JCCTransitionManager.swift
//  CustomTransitions
//
//  Created by Juanjo Corbalán on 24/11/14.
//  Copyright (c) 2014 Juanjo Corbalan Cerezuela. All rights reserved.
//

import UIKit

enum AnimationType {
    case SlideLeft
    case SlideTop
}

class JCCTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var animationType: AnimationType = AnimationType.SlideLeft
    var duration : NSTimeInterval = 0.5
    var presenting : Bool = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        var offsetScreenStart: CGAffineTransform
        var offsetScreenEnd: CGAffineTransform

        switch(self.animationType) {
        case .SlideTop:
            offsetScreenStart = CGAffineTransformMakeTranslation(0,containerView.frame.height)
            offsetScreenEnd = CGAffineTransformMakeTranslation(0,-containerView.frame.height)
        default:
            offsetScreenStart = CGAffineTransformMakeTranslation(containerView.frame.width, 0)
            offsetScreenEnd = CGAffineTransformMakeTranslation(-containerView.frame.width, 0)
        }
        
        if(self.presenting) {
            toView.transform = offsetScreenStart
        }
        else {
            toView.transform = offsetScreenEnd
        }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: {
            if(self.presenting) {
                fromView.transform = offsetScreenEnd
            }
            else {
                fromView.transform = offsetScreenStart
            }
            toView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.duration
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}