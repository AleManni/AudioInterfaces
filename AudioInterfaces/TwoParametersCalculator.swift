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
    
    
    func valuesForNewPosition(point: CGPoint)->(value1: Double, value2:Double) {
        guard let pad = padObj else {return (0,0)}
        
        var outputValue1 = Double(point.x/pad.frame.size.width) * (pad.maximumValuePar1)
        var outputValue2 = pad.maximumValuePar2 - (Double(point.y/pad.frame.size.height) * pad.maximumValuePar2)
        print ("pointY \(point.y)")
        print ("unconverted \(Double(point.y/pad.frame.size.height) * pad.maximumValuePar2)")
        if Double (outputValue1) > pad.maximumValuePar1 {
            outputValue1 = pad.maximumValuePar1
        }
        if Double (outputValue1) < 0.0 {
            outputValue1 = 0.0
        }
        if Double (outputValue2) > pad.maximumValuePar2 {
            outputValue2 = pad.maximumValuePar2
        }
        if Double (outputValue2) < 0.0 {
            outputValue2 = 0.0
        }
        print (outputValue1, outputValue2)
        return (Double (outputValue1), Double (outputValue2))
    }
}
