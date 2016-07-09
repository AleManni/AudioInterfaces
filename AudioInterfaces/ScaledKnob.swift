//
//  ScaledKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 13/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class ScaledKnob: SimpleKnob, SteppedKnobProtocol {
    
    //Note: Primary marks multiplier sets the multiplier applied to the valuerange unit in order to draw the primary marks of the rotary scale. E.g. for a value scale of min Value 1.0 to maxValue 10.0 the result will be 10 marks being drawn when the mutiplier is = 1.0 (default value). For a value of 2 the marks will be 20, etc.. Similarly, the secondary marks multipier defines the multiplier for the secondary (shorter) marks, still applied to the valuerange.
    
    
    @IBInspectable var primaryMarksMultiplier: UInt = 1
    @IBInspectable var secondaryMarksMultiplier: UInt = 0
    let primaryMarkerWidth:CGFloat = 5.0
    let primaryMarkerSize:CGFloat = 10.0
    let secondaryMarkerWidth: CGFloat = 2.5
    let secondaryMarkerSize: CGFloat = 5.0
    
    var  arcLengthPerUnitValue: CGFloat {
        get {
            let angleDifference: CGFloat = 2 * π - knobStartAngle + knobEndAngle
            return angleDifference / CGFloat(maxValue-minValue)
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        rotationGestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(SimpleKnob.didReceiveTouch(_:)))
        self.addGestureRecognizer(rotationGestureRecognizer!)
        let calculator = SteppedKnobCalculator()
        self.delegate = calculator
        valueLabelSetUp()
        self.addSubview(valueLabel)
    }

    
    //MARK: Draw functions
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        
        
        drawMarks(primaryMarkerWidth, markerSize: primaryMarkerSize, multiplier: primaryMarksMultiplier)
        drawMarks(secondaryMarkerWidth, markerSize: secondaryMarkerSize, multiplier: secondaryMarksMultiplier)
        
    }
    
    func drawMarks(markerWidth: CGFloat, markerSize: CGFloat, multiplier: UInt) {
        
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
        
        let valueRange = self.maxValue - self.minValue
        
        if multiplier >= 1 {
        
        for i in 1...valueRange * Int(multiplier) {
            
            CGContextSaveGState(context)
            
            let arcLenghtPerSubUnit = arcLengthPerUnitValue/CGFloat(multiplier)
            
            let angle = (arcLenghtPerSubUnit * CGFloat(i)) + knobStartAngle - π/2
        
            
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context,
                                  0,
                                  self.bounds.size.height/2 - markerSize)
            
            markerPath.fill()
            
            CGContextRestoreGState(context)
        }
        }
        
        CGContextRestoreGState(context)
    }
    
    
    //MARK: Actions
    
    override func didReceiveTouch (sender: AnyObject) {
        
        if let knobDelegate = delegate as? SteppedKnobCalculator {
            knobDelegate.handleRotationforSteppedKnob(self, sender: rotationGestureRecognizer!)
            let outputValue = knobDelegate.calculateOutputValue(self, sender: self)
            valueLabel.text = NSString(format:"%.1f", outputValue) as String
            valueLabel.layoutIfNeeded()
            setNeedsDisplay()
        }
    }
    
    override func updateValueLabel () {
        if let knobDelegate = delegate as? SteppedKnobCalculator {
            let outputValue = knobDelegate.calculateOutputValue(self, sender: self)
            valueLabel.text = NSString(format:"%.1f", outputValue) as String
            valueLabel.layoutIfNeeded()
        }
    }
    
    
}
