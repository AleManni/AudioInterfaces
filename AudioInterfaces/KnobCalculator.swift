//
//  Continuous Knob.swift
//  Flo
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


class KnobCalculator: KnobDelegate {
    
    internal var managedKnob: KnobProtocol?
    
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
    
    internal var selectedAngleDegr: CGFloat?
    
    internal var delta: CGFloat {
        guard let selectedAngleDegr = selectedAngleDegr else { return 0.0 }
        var deltaValue = differenceDegrees(angle1: selectedAngleDegr, angle2: startAngleDegr)
        
        //Apply top and bottom scale for delta. When SelectedAngleDegree is out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
        
        if deltaValue > angleRangeDegr {
            if (deltaOldValue - startAngleDegr) > (endAngleDegr - deltaOldValue) {
                deltaValue = angleRangeDegr
            } else {
                deltaValue = 0
            }
        }
        deltaOldValue = deltaValue
        return deltaValue
    }
    
    public func handleRotationforKnob<T: KnobProtocol>(_ knob: T, sender: AnyObject) {
        managedKnob = knob
        let gr = sender as! RotationGestureRecognizer
        selectedAngleDegr = gr.rotation.radiansToDegrees()
        //Update the knob
        managedKnob!.touchValueInDegrees = delta
    }
    
    fileprivate func updateKnobWithNewValue<T:KnobProtocol>(_ knob: T, value: CGFloat) {
        managedKnob = knob
        selectedAngleDegr = ((angleRangeDegr / CGFloat((managedKnob?.maxValue)!)) * value) + startAngleDegr
        managedKnob?.touchValueInDegrees = delta
    }
    
    internal func calculateOutputValue <T:KnobProtocol> (_ knob: T, sender: AnyObject) -> CGFloat {
        return CGFloat (delta/angleRangeDegr) * CGFloat (knob.maxValue)
    }
}

//MARK: - Extension for knobs comforming to SteppedKnobProtocol
extension KnobCalculator  {
    
    private var valueRange: CGFloat {
        guard let knob = managedKnob as? SteppedKnobProtocol else { return 0 }
        return CGFloat(knob.maxValue - knob.minValue)
    }
    
    // Step the delta on the basis of the minimum interval (step) defined for the knob scale
    internal func step(delta: CGFloat, primaryMarksMultiplier: UInt, secondaryMarksMultiplier: UInt) -> CGFloat {
        let numberOfSteps = (secondaryMarksMultiplier > 0) ? secondaryMarksMultiplier : (primaryMarksMultiplier > 0) ? primaryMarksMultiplier : UInt(delta)
        let stepDegrees = angleRangeDegr / (valueRange * CGFloat(numberOfSteps))
        let partial = round(delta/stepDegrees)
        let deltaFinal = partial * stepDegrees
        deltaOldValue = deltaFinal
        return deltaFinal
    }
    
    public func handleRotationforSteppedKnob<T: SteppedKnobProtocol>(_ knob: T, sender: AnyObject) {
        managedKnob = knob
        let gr = sender as! RotationGestureRecognizer
        selectedAngleDegr = gr.rotation.radiansToDegrees()
        //Update the knob
        managedKnob!.touchValueInDegrees = self.step(delta: delta, primaryMarksMultiplier: knob.primaryMarksMultiplier, secondaryMarksMultiplier: knob.secondaryMarksMultiplier)
    }
}
