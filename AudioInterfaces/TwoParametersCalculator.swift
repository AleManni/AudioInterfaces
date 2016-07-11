//
//  TwoParametersCalculator.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 08/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class TwoParametersCalculator {
    
    var padObj: PadProtocol?
    
    func pointerPositionForValues(values: (value1: CGFloat, value2: CGFloat)) -> CGPoint {
        guard let pad = padObj else {return CGPoint(x: 0.0, y: 0.0)}
        let xPosition = pad.frame.size.width * (CGFloat(pad.maximumValuePar1)/values.value1)
        let yPosition = pad.frame.size.height * (CGFloat(pad.maximumValuePar2)/values.value2)
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    func valuesForNewPosition(point: CGPoint)->(value1: CGFloat, value2:CGFloat) {
        guard let pad = padObj else {return (0,0)}
        
        var outputValue1 = (point.x/pad.frame.size.width) * CGFloat(pad.maximumValuePar1)
        var outputValue2 = CGFloat(pad.maximumValuePar2) - (point.y/pad.frame.size.height) * CGFloat(pad.maximumValuePar2)
        
        if Double (outputValue1) > pad.maximumValuePar1 {
            outputValue1 = CGFloat(pad.maximumValuePar1)
        }
        if Double (outputValue1) < 0.0 {
            outputValue1 = 0.0
        }
        if Double (outputValue2) > pad.maximumValuePar2 {
            outputValue2 = CGFloat(pad.maximumValuePar2)
        }
        if Double (outputValue2) < 0.0 {
            outputValue2 = 0.0
        }
        
        return (outputValue1, outputValue2)
    }

}
