//
//  Mocks.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 27/11/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit
@testable import AudioInterfaces

class mockCalculator: KnobCalculator {
    
    func handleRotationforMockKnob<T: KnobProtocol>(_ knob: T, selectedAngleDegr: CGFloat) {
        managedKnob = knob
        //Update the knob
        self.selectedAngleDegr = selectedAngleDegr
        managedKnob?.touchValueInDegrees = delta
    }

    func handleRotationforSteppedKnob<T: SteppedKnobProtocol>(_ knob: T, selectedAngleDegr: CGFloat) {
    managedKnob = knob
    self.selectedAngleDegr = selectedAngleDegr
    //Update the knob
    managedKnob!.touchValueInDegrees = self.step(delta: delta, primaryMarksMultiplier: knob.primaryMarksMultiplier, secondaryMarksMultiplier: knob.secondaryMarksMultiplier)
}
}

