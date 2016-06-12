//
//  Constants.swift
//  Flo
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni - Nodes Agency. All rights reserved.
//

import UIKit


class Constants: NSObject {
    
    
    let π = CGFloat(M_PI)
    let knobDimension: CGFloat = 76.0
    var padding: CGFloat = 4.0 // This is set in order to prevent image cuts in the presentation of the knob when it is tangential to the view.bounds
    
    //Set different max/min values (scale) for different purposes
    let maximumVolumeValue: Float = 10.0
    let minimumVolumeValue: Float = 0.0
    let maximumDelayValue: Float = 1500.0 //ms
    let minimumDelayValue: Float = 0.0 //ms
    
    static let sharedValues = Constants()
    
    override init () {
    super.init()
    }
    
    
}
