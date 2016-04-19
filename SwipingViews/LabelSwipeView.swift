//
//  LabelSwipeView.swift
//  SwipingViews
//
//  Created by Ariel Pollack on 19/04/2016.
//  Copyright © 2016 Ariel Pollack. All rights reserved.
//

import UIKit

class LabelSwipeView: SwipeView {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(30)
        label.textAlignment = .Center
        label.backgroundColor = UIColor.blackColor()
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    convenience init(text: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        setupLabel()
        object = text
        label.text = text
    }
    
    func setupLabel() {
        contentView.addSubview(label)
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: ["label": label])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: nil, views: ["label": label])
        contentView.addConstraints(constraints)
    }
}