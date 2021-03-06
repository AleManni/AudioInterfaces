//
//  Constants.swift
//  Flo
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


class Constants: NSObject {
    
    
    let π = CGFloat(M_PI)
    let knobDimension: CGFloat = 76.0
    var padding: CGFloat = 7.0 // This is set in order to prevent image cuts in the presentation of the knob when it is tangential to the view.bounds
    
    //Set different max/min values (scale) for different purposes
    let maximumVolumeValue: Float = 10.0
    let minimumVolumeValue: Float = 0.0
    let maximumDelayValue: Float = 1500.0 //ms
    let minimumDelayValue: Float = 0.0 //ms
    
    static let sharedValues = Constants()
    
    struct Fonts {
        let smallFont = UIFont(name: "Zapf Dingbats", size: 9)
        let regularFont = UIFont(name: "Zapf Dingbats", size: 11)
        let largeFont = UIFont(name: "Zapf Dingbats", size: 13)
    }
    
    
}
