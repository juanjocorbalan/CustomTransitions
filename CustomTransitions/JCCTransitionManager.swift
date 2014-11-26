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
    case Rotate
    case Scale
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
        
        containerView.addSubview(toView)
        
        switch(self.animationType) {
        case .Scale:
            performScaleAnimationFromView(fromView, toView: toView, containerView: containerView, transitionContext: transitionContext)
        default:
            performSimpleAnimationFromView(fromView, toView: toView, containerView: containerView, transitionContext: transitionContext)
        }
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
    
    // MARK: Animations
    
    private func performSimpleAnimationFromView(fromView: UIView, toView: UIView, containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let π : CGFloat = 3.14159265359
        
        var offsetScreenStart: CGAffineTransform
        var offsetScreenEnd: CGAffineTransform
        
        switch(self.animationType) {
        case .SlideTop:
            offsetScreenStart = CGAffineTransformMakeTranslation(0,containerView.frame.height)
            offsetScreenEnd = CGAffineTransformMakeTranslation(0,-containerView.frame.height)
        case .Rotate:
            offsetScreenStart = CGAffineTransformMakeRotation(-π/2)
            offsetScreenEnd = CGAffineTransformMakeRotation(π/2)
            fromView.layer.anchorPoint = CGPoint(x:0, y:0)
            fromView.layer.position = CGPoint(x:0, y:0)
            toView.layer.anchorPoint = CGPoint(x:0, y:0)
            toView.layer.position = CGPoint(x:0, y:0)
        default:
            offsetScreenStart = CGAffineTransformMakeTranslation(containerView.frame.width, 0)
            offsetScreenEnd = CGAffineTransformMakeTranslation(-containerView.frame.width, 0)
        }
        
        toView.transform = self.presenting ? offsetScreenStart : offsetScreenEnd
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: {
            fromView.transform = self.presenting ? offsetScreenEnd : offsetScreenStart
            toView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }

    private func performScaleAnimationFromView(fromView: UIView, toView: UIView, containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        var offsetScreenStart = CGAffineTransformMakeScale(0.0, 0.0)
        
        toView.transform = offsetScreenStart

        let duration = self.transitionDuration(transitionContext) / 2.0
        
        fromView.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        fromView.layer.position = CGPoint(x:containerView.frame.width / 2.0, y:containerView.frame.height / 2.0)
        toView.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        toView.layer.position = CGPoint(x:containerView.frame.width / 2.0, y:containerView.frame.height / 2.0)
        
        UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: nil, animations: {

            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration:duration, animations: {
                fromView.transform = offsetScreenStart
                })

            UIView.addKeyframeWithRelativeStartTime(duration, relativeDuration:duration, animations: {
                toView.transform = CGAffineTransformIdentity
                })

            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
}