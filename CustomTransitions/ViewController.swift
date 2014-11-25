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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        self.transitionManager.duration = 1.0

        if let text = sender.titleLabel?.text {
            switch text {
            case "Vertical Sliding":
                self.transitionManager.animationType = AnimationType.SlideTop
            case "Rotation":
                self.transitionManager.animationType = AnimationType.Rotate
            default:
                self.transitionManager.animationType = AnimationType.SlideLeft
            }
        }
        performSegueWithIdentifier("customTransitionSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
    }
}

