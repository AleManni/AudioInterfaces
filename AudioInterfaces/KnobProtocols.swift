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
    var minValue: Double {set get}
    var maxValue: Double {set get}
}


protocol KnobDelegate {
    func handleRotationforKnob <T:KnobProtocol> (knob: T, sender: AnyObject)
}