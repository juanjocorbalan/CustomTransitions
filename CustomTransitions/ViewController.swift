//
//  ViewController.swift
//  CustomTransitions
//
//  Created by Juanjo Corbalán on 24/11/14.
//  Copyright (c) 2014 Juanjo Corbalan Cerezuela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let slideAndBounceTransitionManager = SlideAndBounceTransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.slideAndBounceTransitionManager
    }
}

