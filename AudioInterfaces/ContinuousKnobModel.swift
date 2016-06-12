//
//  Continuous Knob.swift
//  Flo
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit




class ContinuousKnobModel: UIView, KnobDelegate {
    

var managedKnob = KnobView()
private var deltaOldValue: Double = 0.0
    
func handleRotationforKnob(knob: KnobView, sender: AnyObject) {
    
        let gr = sender as! RotationGestureRecognizer
        managedKnob = knob
    
        let selectedAngle = gr.rotation
        
        let selectedAngleDegr = RadiansToDegrees(Double (selectedAngle))
        
        let angleRange = managedKnob.knobEndAngle - managedKnob.knobStartAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleRange))
     //   let endAngleDegr = RadiansToDegrees(Double (managedKnob.knobEndAngle))
        
        //Convert the angle to a value on the given knob scale
        
      //  let startAngleDegr = RadiansToDegrees(Double (managedKnob.knobStartAngle))
        
        let delta = calculateDelta(selectedAngleDegr)
    
        print (delta)
        
        //Update the knob
        
        //managedKnob.range = angleRangeDegr
        managedKnob.touchPositionInRange = delta
    
        
        // Update the label value on the basis of the given scale (maximum value)
        
        let angleToValue = CGFloat (delta/angleRangeDegr) * CGFloat (managedKnob.maxValue)
    //FIXME: Once the label is done uncomment and modify method below
   // managedKnob.updateLabel(Float (angleToValue))
    
    managedKnob.layoutIfNeeded()
    }
    
    func updateKnobWithNewValue(knob: KnobView, value:Double) {
        
        managedKnob = knob
        let angleRange = Double (managedKnob.knobEndAngle - managedKnob.knobStartAngle)
        let angleRangeDegr = RadiansToDegrees(angleRange)
        let startAngleDegr = RadiansToDegrees(Double (managedKnob.knobStartAngle))
        let selectedAngleDegr = ((angleRangeDegr / Double (managedKnob.maxValue)) * value) + startAngleDegr
        let delta = calculateDelta(selectedAngleDegr)
        managedKnob.touchPositionInRange = delta
        knob.touchPositionInRange = delta
        knob.setNeedsDisplay()
    }

    
    
    func calculateDelta(selectedAngleDegr:Double) -> Double {
        let startAngleDegr = RadiansToDegrees(Double (managedKnob.knobStartAngle))
        let endAngleDegr = RadiansToDegrees(Double (managedKnob.knobEndAngle))
        let angleRange = managedKnob.knobEndAngle - managedKnob.knobStartAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleRange))
        
        var delta = (selectedAngleDegr - startAngleDegr)
        
        if selectedAngleDegr < startAngleDegr {
            delta = selectedAngleDegr + (360 - startAngleDegr)
        }
        
        
        //Apply top and bottom scale for delta. When out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
        
        if selectedAngleDegr > endAngleDegr && selectedAngleDegr < startAngleDegr {
            if (deltaOldValue - startAngleDegr) > (endAngleDegr - deltaOldValue) {
                deltaOldValue = angleRangeDegr
                delta = deltaOldValue
            } else {
                deltaOldValue = 0
                delta = deltaOldValue
            }
        }
        
        
        deltaOldValue = delta
        return delta
    }
    
    
    
    func RadiansToDegrees (value:Double) -> Double {
        var result = value * (180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
    
    
}
