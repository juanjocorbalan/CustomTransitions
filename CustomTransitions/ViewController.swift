//
//  ViewController.swift
//  CustomTransitions
//
//  Created by Juanjo Corbalán on 24/11/14.
//  Copyright (c) 2014 Juanjo Corbalan Cerezuela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transitionManager = JCCTransitionManager()
    
    var animationTypes : Dictionary<String, AnimationType>= ["Vertical Sliding" : .SlideTop,
                                                             "Horizontal Sliding" : .SlideLeft,
                                                             "Rotation" : .Rotate,
                                                             "Scale" : .Scale,
                                                             "Stack" : .Stack]

    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {
   
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        self.transitionManager.duration = 1.0

        self.transitionManager.animationType = animationTypes[sender.currentTitle!] ?? .SlideLeft

        performSegueWithIdentifier("customTransitionSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
    }
}

