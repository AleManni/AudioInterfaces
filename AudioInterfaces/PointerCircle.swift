//
//  PointerCircle.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 08/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable class PointerCircle: UIView {
    
    var color: UIColor = UIColor.blackColor()
    
    override func drawRect(rect: CGRect) {
        
            let center = CGPoint(x:5, y: 5)
            
            let radius: CGFloat = 5.0
        
            let circlePath = UIBezierPath(arcCenter: center,
                                    radius: radius,
                                    startAngle: CGFloat(0),
                                    endAngle:CGFloat(M_PI * 2),
                                    clockwise: true)
        
//            let circleLayer = CAShapeLayer()
//        circleLayer.path = circlePath.CGPath
//        circleLayer.fillColor = color.CGColor
        
        color.setFill()
        circlePath.fill()
        
        }
}
