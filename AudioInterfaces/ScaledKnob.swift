//
//  ScaledKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class ScaledKnob: SimpleKnob, SteppedKnobProtocol {
    
    //Note: Primary marks multiplier sets the multiplier applied to the valuerange unit in order to draw the primary marks of the rotary scale. E.g. for a value scale of min Value 1.0 to maxValue 10.0 the result will be 10 marks being drawn when the mutiplier is = 1.0 (default value). For a value of 2 the marks will be 20, etc.. Similarly, the secondary marks multipier defines the multiplier for the secondary (shorter) marks, still applied to the valuerange.
    
    
    @IBInspectable var primaryMarksMultiplier: UInt = 1
    @IBInspectable var secondaryMarksMultiplier: UInt = 0
    let primaryMarkerWidth: CGFloat = 5.0
    let primaryMarkerSize: CGFloat = 10.0
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
        let calculator = KnobCalculator()
        self.delegate = calculator
        valueLabelSetUp()
        self.addSubview(valueLabel)
    }

    
    //MARK: Draw functions
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        
        drawMarks(primaryMarkerWidth, markerSize: primaryMarkerSize, multiplier: primaryMarksMultiplier)
        drawMarks(secondaryMarkerWidth, markerSize: secondaryMarkerSize, multiplier: secondaryMarksMultiplier)
        
    }
    
    func drawMarks(_ markerWidth: CGFloat, markerSize: CGFloat, multiplier: UInt) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        
        outlineColor.setFill()
        
        
        let markerPath = UIBezierPath(rect:
            CGRect(x: -markerWidth/2,
                y: 0,
                width: markerWidth,
                height: markerSize))
        
        
        context?.translateBy(x: self.bounds.size.width/2,
                              y: self.bounds.size.height/2)
        
        let valueRange = self.maxValue - self.minValue
        
        if multiplier >= 1 {
        
        for i in 1...valueRange * Int(multiplier) {
            
            context?.saveGState()
            
            let arcLenghtPerSubUnit = arcLengthPerUnitValue/CGFloat(multiplier)
            
            let angle = (arcLenghtPerSubUnit * CGFloat(i)) + knobStartAngle - π/2
        
            
            context?.rotate(by: angle)
            context?.translateBy(x: 0,
                                  y: self.bounds.size.height/2 - markerSize)
            
            markerPath.fill()
            
            context?.restoreGState()
        }
        }
        
        context?.restoreGState()
    }
    
    
    //MARK: Actions
    
    override func didReceiveTouch (_ sender: AnyObject) {
        
        if let knobDelegate = delegate as? KnobCalculator {
            knobDelegate.handleRotationforSteppedKnob(self, sender: rotationGestureRecognizer!)
            let outputValue = knobDelegate.calculateOutputValue(self, sender: self)
            valueLabel.text = NSString(format:"%.1f", outputValue) as String
            valueLabel.layoutIfNeeded()
            setNeedsDisplay()
        }
    }
    
    override func updateValueLabel () {
        if let knobDelegate = delegate as? KnobCalculator {
            let outputValue = knobDelegate.calculateOutputValue(self, sender: self)
            valueLabel.text = NSString(format:"%.1f", outputValue) as String
            valueLabel.layoutIfNeeded()
        }
    }
    
    
}
