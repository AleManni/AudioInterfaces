//
//  KnobProtocol.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 13/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


protocol KnobProtocol {
    var knobStartAngle: CGFloat { get }
    var knobEndAngle: CGFloat { get }
    var touchValueInDegrees: Double {set get}
    var minValue: Int {set get}
    var maxValue: Int {set get}
}

protocol SteppedKnobProtocol {
    var knobStartAngle: CGFloat { get }
    var knobEndAngle: CGFloat { get }
    var touchValueInDegrees: Double {set get}
    var minValue: Int {set get}
    var maxValue: Int {set get}
    var primaryMarksMultiplier: Int {set get}
    var secondaryMarksMultiplier: Int {set get}
}


protocol KnobDelegate {
    func handleRotationforKnob <T:KnobProtocol> (knob: T, sender: AnyObject)
    func calculateOutputValue <T:KnobProtocol> (knob: T, sender: AnyObject) -> CGFloat
}

protocol SteppedKnobDelegate {
    func handleRotationforSteppedKnob <T:SteppedKnobProtocol> (steppedKnob: T, sender: AnyObject)
    func calculateOutputValue <T:SteppedKnobProtocol> (steppedKnob: T, sender: AnyObject) -> CGFloat
}

protocol PadDelegate {
    func didUpdateValues(value1: Int, value2: Int)
}