//
//  Constants.swift
//  Flo
//
//  Created by Carolina Gigler on 19/05/2016.
//  Copyright © 2016 Alessandro Manni - Nodes Agency. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    let π = CGFloat(M_PI)
    var knobStartAngle: CGFloat
    var knobEndAngle: CGFloat
    
    let knobWidth: CGFloat = 76.0
    
    //Set different max/min values (scale) for different purposes
    let maximumVolumeValue: Float = 10.0
    let minimumVolumeValue: Float = 0.0
    let maximumDelayValue: Float = 1500.0 //ms
    let minimumDelayValue: Float = 0.0 //ms
    
    static let sharedValues = Constants()
    
    override init () {
        knobStartAngle = 3 * π / 4
        knobEndAngle = π / 4
        super.init()
    }
    
    
}
