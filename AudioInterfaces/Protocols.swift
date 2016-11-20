//
//  KnobProtocol.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 13/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


//MARK: - Private protocols

protocol KnobProtocol {
    var knobStartAngle: CGFloat {get}
    var knobEndAngle: CGFloat {get}
    var touchValueInDegrees: CGFloat {set get}
    var minValue: Int {set get}
    var maxValue: Int {set get}
}

protocol SteppedKnobProtocol {
    var knobStartAngle: CGFloat {get}
    var knobEndAngle: CGFloat {get}
    var touchValueInDegrees: CGFloat  {set get}
    var minValue: Int {set get}
    var maxValue: Int {set get}
    var primaryMarksMultiplier: UInt {set get}
    var secondaryMarksMultiplier: UInt {set get}
}

protocol PadProtocol {
    var maximumValuePar1: Double {get}
    var maximumValuePar2: Double {get}
    var frame: CGRect {set get}
}


protocol KnobDelegate {
    func handleRotationforKnob <T:KnobProtocol> (_ knob: T, sender: AnyObject)
    func calculateOutputValue <T:KnobProtocol> (_ knob: T, sender: AnyObject) -> CGFloat
}

protocol SteppedKnobDelegate {
    func handleRotationforSteppedKnob <T:SteppedKnobProtocol> (_ steppedKnob: T, sender: AnyObject)
    func calculateOutputValue <T:SteppedKnobProtocol> (_ steppedKnob: T, sender: AnyObject) -> CGFloat
}

protocol PadDelegate {
    func didUpdateValues(_ value1: CGFloat, value2: CGFloat)
}

protocol switchViewDelegate {
    func switchDidChangeToState(_ newState:patch)
}
