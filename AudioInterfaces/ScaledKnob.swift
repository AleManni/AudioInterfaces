//
//  ScaledKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 13/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class ScaledKnob: SimpleKnob {
    
    //Note: Primary marks multiplier sets the multiplier applied to the valuerange unit in order to draw the primary marks of the rotary scale. E.g. for a value scale of min Value 1.0 to maxValue 10.0 the result will be 10 marks being drawn when the mutiplier is = 1.0 (default value). For a value of 0.5 the marks will be 20, etc.. Similarly, the secondary marks mutipier defines the multiplier for the secondaty (shorter) markss, still applied to the valuerange.
    
    
    @IBInspectable var primaryMarksMultiplier: Int = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var secondaryMarksMultiplier: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    let primaryMarkerWidth:CGFloat = 5.0
    let primaryMarkerSize:CGFloat = 10.0
    let secondaryMarkerWidth: CGFloat = 2.5
    let secondaryMarkerSize: CGFloat = 5.0
    
    var  arcLengthPerUnitValue: CGFloat {
        get {
            let angleDifference: CGFloat = 2 * π - startAngle.rawValue + endAngle.rawValue
            return angleDifference / CGFloat(maxValue)
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        drawMarks(primaryMarkerWidth, markerSize: primaryMarkerSize, multiplier: primaryMarksMultiplier)
        drawMarks(secondaryMarkerWidth, markerSize: secondaryMarkerSize, multiplier: secondaryMarksMultiplier)
        
    }
    
    func drawMarks(markerWidth: CGFloat, markerSize: CGFloat, multiplier: Int) {
        
        let arcLength = arcLengthPerUnitValue/CGFloat(multiplier)
        
        
        let context = UIGraphicsGetCurrentContext()
        
        
        
        CGContextSaveGState(context)
        outlineColor.setFill()
        
        
        
        let markerPath = UIBezierPath(rect:
            CGRect(x: -markerWidth/2,
                y: 0,
                width: markerWidth,
                height: markerSize))
        
        
        CGContextTranslateCTM(context,
                              self.bounds.size.width/2,
                              self.bounds.size.height/2)
        
        for i in 1...Int((self.maxValue + 1) * Double(multiplier)) {
            
            CGContextSaveGState(context)
            
            let angle = arcLength * CGFloat(i) + knobStartAngle - π/2
            
            
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context,
                                  0,
                                  self.bounds.size.height/2 - markerSize)
            
            
            markerPath.fill()
            
            CGContextRestoreGState(context)
        }
        
        
        CGContextRestoreGState(context)
    }
    
    
    
    
}
