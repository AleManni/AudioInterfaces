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
        return differenceDegrees(angle1: endAngleDegr, angle2: startAngleDegr)
    }
    
    var selectedAngleDegr: CGFloat?
    
    var delta: CGFloat {
        guard let selectedAngleDegr = selectedAngleDegr else { return 0.0 }
        var deltaValue = differenceDegrees(angle1: selectedAngleDegr, angle2: startAngleDegr)
        
        //Apply top and bottom scale for delta. When SelectedAngleDegree is out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
        
        if deltaValue > angleRangeDegr {
            if (deltaOldValue - startAngleDegr) > (endAngleDegr - deltaOldValue) {
                deltaOldValue = angleRangeDegr
                deltaValue = deltaOldValue
            } else {
                deltaOldValue = 0
                deltaValue = deltaOldValue
            }
        }
        deltaOldValue = deltaValue
        return deltaValue
    }
    
    func handleRotationforKnob<T:KnobProtocol>(_ knob: T, sender: AnyObject) {
        managedKnob = knob
        let gr = sender as! RotationGestureRecognizer
        selectedAngleDegr = gr.rotation.radiansToDegrees()
        print ("selectedAngleDegr = \(selectedAngleDegr!)" )
        print("start angle degree = \(startAngleDegr)")
        //Update the knob
        managedKnob!.touchValueInDegrees = delta
        print(managedKnob!.touchValueInDegrees)
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
