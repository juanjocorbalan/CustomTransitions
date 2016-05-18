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
    case Stack
}

var EyePosition : CGFloat = -1.0/900

class JCCTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var animationType: AnimationType = AnimationType.SlideLeft
    var duration : NSTimeInterval = 0.5
    var presenting : Bool = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        containerView.addSubview(toView)
        
        switch(self.animationType) {
        case .Scale:
            performScaleAnimationFromView(fromView, toView: toView, containerView: containerView, transitionContext: transitionContext)
        case .Stack:
            performStackAnimationFromView(fromView, toView: toView, containerView: containerView, transitionContext: transitionContext)
        default:
            performSimpleAnimationFromView(fromView, toView: toView, containerView: containerView, transitionContext: transitionContext)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
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
        var offsetScreenStart: CGAffineTransform
        var offsetScreenEnd: CGAffineTransform
        
        self.resetViewsToContainerFrame(containerView, fromView: fromView, toView: toView)

        switch(self.animationType) {
        case .SlideTop:
            offsetScreenStart = CGAffineTransformMakeTranslation(0,containerView.frame.height)
            offsetScreenEnd = CGAffineTransformMakeTranslation(0,-containerView.frame.height)
        case .Rotate:
            let π  = CGFloat(M_PI)
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
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            fromView.transform = self.presenting ? offsetScreenEnd : offsetScreenStart
            toView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }

    private func performScaleAnimationFromView(fromView: UIView, toView: UIView, containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let offsetScreenStart = CGAffineTransformMakeScale(0.0, 0.0)
        
        toView.transform = offsetScreenStart

        let duration = self.transitionDuration(transitionContext) / 2.0
        
        self.resetViewsToContainerFrame(containerView, fromView: fromView, toView: toView)
        
        UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: [], animations: {

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
    
    private func performStackAnimationFromView(fromView: UIView, toView: UIView, containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let offsetScreenStart = CGAffineTransformMakeTranslation(0,containerView.frame.height)
        _ = CGAffineTransformMakeTranslation(0,-containerView.frame.height)
        
        let t1 : CATransform3D = self.firstTransform()
        let t2 : CATransform3D = self.secondTransform()

        let duration = self.transitionDuration(transitionContext) / 2.0

        self.resetViewsToContainerFrame(containerView, fromView: fromView, toView: toView)

        if(self.presenting) {
            toView.transform = offsetScreenStart

            UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: [], animations: {
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration:0.5, animations: {
                    fromView.layer.transform = t1
                    fromView.alpha = 0.6;
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration:0.5, animations: {
                    fromView.layer.transform = t2
                })
                
                }, completion: nil)
        }
        else {
            toView.layer.transform = t2
            toView.alpha = 0.6;
            
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
                fromView.transform = offsetScreenStart
                }, completion: nil)
        }
        
        UIView.animateWithDuration(duration, delay: duration-(0.3*duration), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            toView.transform = CGAffineTransformIdentity
            toView.alpha = 1;
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
    
    
    private func firstTransform() -> CATransform3D {
        var t1 : CATransform3D = CATransform3DIdentity
        t1.m34 = EyePosition
        t1 = CATransform3DScale(t1, 0.9, 0.9, 1)
        t1 = CATransform3DRotate(t1, 15.0*CGFloat(M_PI)/180.0, 1, 0, 0)
        
        return t1
    }
    
    private func secondTransform() -> CATransform3D {
        var t2 : CATransform3D = CATransform3DIdentity
        t2.m34 = EyePosition
        t2 = CATransform3DScale(t2, 0.9, 0.9, 1)
        
        return t2
    }
    
    // MARK: Utils

    private func resetViewsToContainerFrame(containerView: UIView, fromView: UIView, toView: UIView) {
        fromView.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        fromView.layer.position = CGPoint(x:containerView.frame.width / 2.0, y:containerView.frame.height / 2.0)
        toView.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        toView.layer.position = CGPoint(x:containerView.frame.width / 2.0, y:containerView.frame.height / 2.0)
    }

}
