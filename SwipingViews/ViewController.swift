//
//  ViewController.swift
//  SwipingViews
//
//  Created by Ariel Pollack on 19/04/2016.
//  Copyright © 2016 Ariel Pollack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var texts = (1...10).map({ "\($0)" })
    var results = [String: Bool]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // show first object
        showNextObject()
    }

    func showNextObject() {
        if texts.count == 0 {
            return
        }
        
        let object = texts.removeFirst()
        showObject(object)
    }
    
    func showObject(object: String) {
        // initialize with current object
        let swipeView = LabelSwipeView(text: object)
        swipeView.delegate = self
        view.addSubview(swipeView)
        
        // place in the middle horizontally
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[swipe]|", options: [], metrics: nil, views: ["swipe": swipeView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[swipe(300)]", options: [], metrics: nil, views: ["swipe": swipeView])
        view.addConstraints(constraints)
        
        // show view
        swipeView.alpha = 0;
        UIView.animateWithDuration(0.5) {
            swipeView.alpha = 1
        }
    }
}

extension ViewController: SwipeViewDelegate {
    
    func didSwipeLeft(swipeView: SwipeView, object: AnyObject) {
        dismissSwipeView(swipeView, object: object, result: false)
    }
    
    func didSwipeRight(swipeView: SwipeView, object: AnyObject) {
        dismissSwipeView(swipeView, object: object, result: true)
    }
    
    func dismissSwipeView(swipeView: SwipeView, object: AnyObject, result: Bool) {
        // save result for swiped object
        results[object as! String] = result
        
        // dismiss the view animated
        UIView.animateWithDuration(0.5, animations: {
            swipeView.alpha = 0
        }) { _ in
            swipeView.removeFromSuperview()
            self.showNextObject()
        }
    }
}

