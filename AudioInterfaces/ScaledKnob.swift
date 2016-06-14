//
//  ScaledKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 13/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class ScaledKnob: SimpleKnob {

    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        
        let angleDifference: CGFloat = 2 * π - knobStartAngle + knobEndAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleDifference))
        
        //Calculate the arc for each single interval
        
        let arcLengthPerUnitValue = angleRangeDegr / maxValue

        
        
        //1 - save original state
        CGContextSaveGState(context)
        outlineColor.setFill()
        
        let markerWidth:CGFloat = 5.0
        let markerSize:CGFloat = 10.0
        
        //2 - the marker rectangle positioned at the top left
        let markerPath = UIBezierPath(rect:
            CGRect(x: -markerWidth/2,
                y: 0,
                width: markerWidth,
                height: markerSize))
        
        //3 - move top left of context to the previous center position
        CGContextTranslateCTM(context,
                              rect.width/2,
                              rect.height/2)
        
        for i in 1...Int(self.maxValue) {
            //4 - save the centred context
            CGContextSaveGState(context)
            
            //5 - calculate the rotation angle
            let angle = CGFloat(arcLengthPerUnitValue) * CGFloat(i) + startAngle.rawValue - π/2
            
            //rotate and translate
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context,
                                  0,
                                  rect.height/2 - markerSize)
            
            //6 - fill the marker rectangle
            markerPath.fill()
            
            //7 - restore the centred context for the next rotate
            CGContextRestoreGState(context)
        }
        
        //8 - restore the original state in case of more painting
        CGContextRestoreGState(context)

    }
    
    
}
