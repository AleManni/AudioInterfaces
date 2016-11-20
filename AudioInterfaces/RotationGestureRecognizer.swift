//
//  RotationGestureRecognizer.swift
//  KNOBs
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//


import UIKit.UIGestureRecognizerSubclass

class RotationGestureRecognizer: UIPanGestureRecognizer {
    var rotation: CGFloat = 0.0
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        updateRotationWithTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateRotationWithTouches(touches)
    }
    
    func updateRotationWithTouches(_ touches: Set<NSObject>) {
        if let touch = touches[touches.startIndex] as? UITouch {
            self.rotation = rotationForLocation(touch.location(in: self.view))
        }
    }
    
    func rotationForLocation(_ location: CGPoint) -> CGFloat {
        let offset = CGPoint(x: location.x - view!.bounds.midX, y: location.y - view!.bounds.midY)
        return atan2(offset.y, offset.x)
    }
}

