//
//  SwipeView.swift
//  SwipingViews
//
//  Created by Ariel Pollack on 19/04/2016.
//  Copyright © 2016 Ariel Pollack. All rights reserved.
//

import UIKit

protocol SwipeViewDelegate {
    func didSwipeRight(swipeView: SwipeView, object: AnyObject)
    func didSwipeLeft(swipeView: SwipeView, object: AnyObject)
}

class SwipeView: UIView {
    let SidePadding: CGFloat = 50
    
    var delegate: SwipeViewDelegate?
    
    var object: AnyObject!
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    
    lazy var centerXConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
    }()
    
    lazy var centerYConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.contentView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
    }()
    
    var didUpdateConstraints = false
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            var constraints = [
                NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200),
                centerXConstraint,
                centerYConstraint
            ]
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": contentView])
            self.addConstraints(constraints)
        }
        super.updateConstraints()
    }
    
    var startingOffset: CGFloat = 0
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // save the X location where the user began touching
        startingOffset = touches.first!.locationInView(self).x
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // get current location
        let location = touches.first!.locationInView(self).x
        
        // calculate offset from first touch
        let offsetFromStart = location - startingOffset
        
        // set max distance as 2/3 of view width
        let maxDistance = bounds.width/2*3
        
        // set X position the same as the offset
        centerXConstraint.constant = offsetFromStart
        
        // calculate desired rotation and resize
        let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_4) * (offsetFromStart / maxDistance))
        let resize = CGAffineTransformMakeScale(1 - fabs(offsetFromStart) / maxDistance, 1 - fabs(offsetFromStart) / maxDistance)
        
        // set transformation and opacity by swiped offset
        contentView.transform = CGAffineTransformConcat(rotate, resize)
        contentView.alpha = 1 - fabs(offsetFromStart) / maxDistance
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // get end location
        let location = touches.first!.locationInView(self).x
        
        // calculate offset from first touch
        let offsetFromStart = location - startingOffset

        if fabs(offsetFromStart) > 100 {
            // make the swipe desicion
            
            if offsetFromStart < 0 {
                self.delegate?.didSwipeLeft(self, object: object)
            } else {
                self.delegate?.didSwipeRight(self, object: object)
            }
        } else {
            // bring the view back to its original state
            
            centerXConstraint.constant = 0
            centerYConstraint.constant = 0
            UIView.animateWithDuration(0.1, animations: {
                self.layoutIfNeeded()
                self.contentView.alpha = 1
                self.contentView.transform = CGAffineTransformIdentity
            })
        }
    }
}
