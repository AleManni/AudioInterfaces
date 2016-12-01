//
//  SteppedKnobModel.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 14/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

//import UIKit
//
//class SteppedKnobCalculator: KnobCalculator, SteppedKnobDelegate {
//    
//    fileprivate var primaryMarksMultiplier: UInt {
//        guard let knob = managedKnob, let multiplier = knob.primaryMarksMultiplier  else { return 0 }
//        return multiplier
//    }
//    
//    fileprivate var  secondaryMarksMultiplier: UInt  {
//        guard let knob = managedKnob, let multiplier = knob.secondaryMarksMultiplier  else { return 0 }
//        return multiplier
//    }
//
//    
//    
//    fileprivate var valueRange: CGFloat {
//        guard let knob = managedKnob else { return 0 }
//        return CGFloat(knob.maxValue - knob.minValue)
//    }
//    
//
//    var delta: CGFloat {
//        guard let selectedAngleDegr = selectedAngleDegr, let knob = managedKnob else { return 0.0 }
//        var deltaTemp = (selectedAngleDegr - startAngleDegr)
//        
//        if selectedAngleDegr < startAngleDegr {
//            deltaTemp = selectedAngleDegr + (360 - startAngleDegr)
//        }
//        
//        //Apply top and bottom scale for delta. When SelectedAngleDegree is out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
//        
//        if selectedAngleDegr > endAngleDegr && selectedAngleDegr < startAngleDegr {
//            if (deltaOldValue - startAngleDegr) > (endAngleDegr - deltaOldValue) {
//                deltaOldValue = angleRangeDegr
//                deltaTemp = deltaOldValue
//            } else {
//                deltaOldValue = 0
//                deltaTemp = deltaOldValue
//            }
//        }
//        deltaOldValue = deltaTemp
//        
//        // Step the delta on the basis of the minimum interval (step) defined for the knob scale
//        let numberOfSteps = (secondaryMarksMultiplier > 0) ? knob.secondaryMarksMultiplier : (primaryMarksMultiplier > 0) ? knob.primaryMarksMultiplier : UInt(deltaTemp)
//        
//        let stepDegrees = angleRangeDegr / (valueRange * CGFloat(numberOfSteps))
//        let partial = round(deltaTemp/stepDegrees)
//        deltaTemp = partial * stepDegrees
//        deltaOldValue = deltaTemp
//        return deltaTemp
//    }
//
//    func handleRotationforSteppedKnob <T:SteppedKnobProtocol> (_ steppedKnob: T, sender: AnyObject) {
//        managedKnob = steppedKnob
//        let gr = sender as! RotationGestureRecognizer
//        selectedAngleDegr = gr.rotation.radiansToDegrees()
//        //Update the knob
//        managedKnob!.touchValueInDegrees = delta
//    }
//    
//    
//    func updateKnobWithNewValue<T:SteppedKnobProtocol>(_ steppedKnob: T, value: CGFloat) {
//        var managedKnob = steppedKnob
//        selectedAngleDegr = ((angleRangeDegr / CGFloat (managedKnob.maxValue)) * value) + startAngleDegr
//        managedKnob.touchValueInDegrees = delta
//    }
//    
//
//    func calculateOutputValue <T:SteppedKnobProtocol> (_ steppedKnob: T, sender: AnyObject) -> CGFloat {
//        return (delta/angleRangeDegr) * CGFloat (steppedKnob.maxValue)
//    }
//
//}
//
//
