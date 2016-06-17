//
//  Continuous Knob.swift
//  Flo
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


class ContinuousKnobCalculator: KnobDelegate {
    
    var managedKnob: KnobProtocol?
    
    private var deltaOldValue: Double = 0.0
    
    var delta: Double = 0.0
    
    
    func handleRotationforKnob<T:KnobProtocol>(knob: T, sender: AnyObject) {
        
         managedKnob = knob
        
        let gr = sender as! RotationGestureRecognizer
        
        let selectedAngle = gr.rotation
        
        let selectedAngleDegr = RadiansToDegrees(Double (selectedAngle))
        
        let delta = calculateDelta(selectedAngleDegr)
    
        //Update the knob
        managedKnob!.touchValueInDegrees = delta
        
    }
    
    func updateKnobWithNewValue<T:KnobProtocol>(knob: T, value:Double) {
        
        var managedKnob = knob
        let angleRange = Double (managedKnob.knobEndAngle - managedKnob.knobStartAngle)
        let angleRangeDegr = RadiansToDegrees(angleRange)
        let startAngleDegr = RadiansToDegrees(Double (managedKnob.knobStartAngle))
        let selectedAngleDegr = ((angleRangeDegr / Double (managedKnob.maxValue)) * value) + startAngleDegr
        let delta = calculateDelta(selectedAngleDegr)
        managedKnob.touchValueInDegrees = delta
    }
    
    
    
    func calculateDelta(selectedAngleDegr:Double) -> Double {
        
        guard let knob = managedKnob else { return 0.0 }
        let startAngleDegr = RadiansToDegrees(Double (knob.knobStartAngle))
        let endAngleDegr = RadiansToDegrees(Double (knob.knobEndAngle))
        let angleRange = knob.knobEndAngle - knob.knobStartAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleRange))
        
         delta = (selectedAngleDegr - startAngleDegr)
        
        if selectedAngleDegr < startAngleDegr {
            delta = selectedAngleDegr + (360 - startAngleDegr)
        }
        
        //Apply top and bottom scale for delta. When SelectedAngleDegree is out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
        
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
    
    func calculateOutputValue <T:KnobProtocol> (knob: T, sender: AnyObject) -> CGFloat {
        let angleRangeDegr = RadiansToDegrees(Double (knob.knobEndAngle - knob.knobStartAngle))
        return CGFloat (delta/angleRangeDegr) * CGFloat (knob.maxValue)
    }
    
    
    
    func RadiansToDegrees (value:Double) -> Double {
        var result = value * (180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
    
    
}
