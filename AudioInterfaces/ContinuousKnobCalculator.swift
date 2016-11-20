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
    
    fileprivate var deltaOldValue: CGFloat = 0.0
    
    fileprivate var startAngleDegr: CGFloat {
        guard let knob = managedKnob else { return 0 }
        return knob.knobStartAngle.radiansToDegrees()
    }
    
    fileprivate var endAngleDegr: CGFloat {
        guard let knob = managedKnob else { return 0 }
        return knob.knobEndAngle.radiansToDegrees()
    }
    
    fileprivate var angleRangeDegr: CGFloat {
        guard let knob = managedKnob else { return 0 }
        return (knob.knobEndAngle - knob.knobStartAngle).radiansToDegrees()
    }
    
    var selectedAngleDegr: CGFloat?
    
    var delta: CGFloat {
            guard let selectedAngleDegr = selectedAngleDegr else { return 0.0 }
            var deltaRaw = (selectedAngleDegr - startAngleDegr)
            if selectedAngleDegr < startAngleDegr  && selectedAngleDegr < endAngleDegr {
                return selectedAngleDegr + (360 - startAngleDegr)
            }
            
            //Apply top and bottom scale for delta. When SelectedAngleDegree is out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
            
            if selectedAngleDegr > endAngleDegr && selectedAngleDegr < startAngleDegr {
                if (deltaOldValue - startAngleDegr) > (endAngleDegr - deltaOldValue) {
                    deltaOldValue = angleRangeDegr
                    deltaRaw = deltaOldValue
                } else {
                    deltaOldValue = 0
                    deltaRaw = deltaOldValue
                }
            }
            deltaOldValue = deltaRaw
            return deltaRaw
    }
    
    func handleRotationforKnob<T:KnobProtocol>(_ knob: T, sender: AnyObject) {
        managedKnob = knob
        let gr = sender as! RotationGestureRecognizer
        selectedAngleDegr = gr.rotation.radiansToDegrees()
        //Update the knob
        managedKnob!.touchValueInDegrees = delta
    }
    
    func updateKnobWithNewValue<T:KnobProtocol>(_ knob: T, value: CGFloat) {
        var managedKnob = knob
        selectedAngleDegr = ((angleRangeDegr / CGFloat(managedKnob.maxValue)) * value) + startAngleDegr
        managedKnob.touchValueInDegrees = delta
    }
    
    func calculateOutputValue <T:KnobProtocol> (_ knob: T, sender: AnyObject) -> CGFloat {
        return CGFloat (delta/angleRangeDegr) * CGFloat (knob.maxValue)
    }
    
}
