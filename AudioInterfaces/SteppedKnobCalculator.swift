//
//  SteppedKnobModel.swift
//  AudioInterfaces
//
//  Created by Carolina Gigler on 14/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class SteppedKnobCalculator {
    var managedKnob: SteppedKnobProtocol?
    var delta: Double = 0.0
    private var deltaOldValue: Double = 0.0
    
    
    
    func handleRotationforSteppedKnob <T:SteppedKnobProtocol> (steppedKnob: T, sender: AnyObject) {
        
        managedKnob = steppedKnob
        
        let gr = sender as! RotationGestureRecognizer
        
        let selectedAngle = gr.rotation
        
        let selectedAngleDegr = RadiansToDegrees(Double (selectedAngle))
        
        let primaryMarksMultiplier = steppedKnob.primaryMarksMultiplier
        let secondaryMarksMultiplier = steppedKnob.secondaryMarksMultiplier
        
        let steppedDelta = calculateDelta(selectedAngleDegr, valueRange: (managedKnob!.maxValue - managedKnob!.minValue), multipliers: (primaryMarksMultiplier, secondaryMarksMultiplier))
        
        //Update the knob
        managedKnob!.touchValueInDegrees = steppedDelta
        delta = steppedDelta
        
    }
    
    
    func updateKnobWithNewValue<T:SteppedKnobProtocol>(steppedKnob: T, value:Double) {
        
        var managedKnob = steppedKnob
        let angleRange = Double (managedKnob.knobEndAngle - managedKnob.knobStartAngle)
        let angleRangeDegr = RadiansToDegrees(angleRange)
        let startAngleDegr = RadiansToDegrees(Double (managedKnob.knobStartAngle))
        let selectedAngleDegr = ((angleRangeDegr / Double (managedKnob.maxValue)) * value) + startAngleDegr
        let delta = calculateDelta(selectedAngleDegr, valueRange: (managedKnob.maxValue - managedKnob.minValue), multipliers: (managedKnob.primaryMarksMultiplier, managedKnob.secondaryMarksMultiplier))
        managedKnob.touchValueInDegrees = delta
    }
    
    
    func calculateDelta(selectedAngleDegr:Double, valueRange: Int, multipliers: (primary:UInt, secondary:UInt)) -> Double {
        
        guard let knob = managedKnob else { return 0.0 }
        let startAngleDegr = RadiansToDegrees(Double (knob.knobStartAngle))
        let endAngleDegr = RadiansToDegrees(Double (knob.knobEndAngle))
        let angleRange = knob.knobEndAngle - knob.knobStartAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleRange))
        
        var delta = (selectedAngleDegr - startAngleDegr)
        
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
        
        // Step the delta on the basis of the minimum interval (step) defined for the knob scale
        
        var numberOfSteps: UInt = 0
        
        if multipliers.secondary > 0 {
            numberOfSteps = multipliers.secondary
        } else {
            guard multipliers.primary > 0 else {
                return delta
            }
            numberOfSteps = multipliers.primary
        }
        
        let stepDegrees = angleRangeDegr / Double(valueRange * Int(numberOfSteps))
        let partial = round(delta/stepDegrees)
        
        delta = partial * stepDegrees
        deltaOldValue = delta
        return delta
        
    }
    
    
    func calculateOutputValue <T:SteppedKnobProtocol> (steppedKnob: T, sender: AnyObject) -> CGFloat {
        let angleRangeDegr = RadiansToDegrees(Double (steppedKnob.knobEndAngle - steppedKnob.knobStartAngle))
        return CGFloat (delta/angleRangeDegr) * CGFloat (steppedKnob.maxValue)
    }
    
    
    //MARK: Utilities
    
    func RadiansToDegrees (value:Double) -> Double {
        var result = value * (180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
    
    
}


