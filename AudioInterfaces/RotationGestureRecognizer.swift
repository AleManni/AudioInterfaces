//
//  RotationGestureRecognizer.swift
//  KNOBs
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni - Nodes Agency. All rights reserved.
//


import UIKit.UIGestureRecognizerSubclass

class RotationGestureRecognizer: UIPanGestureRecognizer {
    var rotation: CGFloat = 0.0
    
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        updateRotationWithTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        updateRotationWithTouches(touches)
    }
    
    func updateRotationWithTouches(touches: Set<NSObject>) {
        if let touch = touches[touches.startIndex] as? UITouch {
            self.rotation = rotationForLocation(touch.locationInView(self.view))
        }
    }
    
    func rotationForLocation(location: CGPoint) -> CGFloat {
        let offset = CGPoint(x: location.x - view!.bounds.midX, y: location.y - view!.bounds.midY)
        return atan2(offset.y, offset.x)
        
    }
}

