//
//  TapTempoCalculator.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 16/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

class TapTempoCalculator {
    
    // var managedPad: SteppedKnobProtocol?
    var tapArray: [TimeInterval] = []
    
    
    var averageTime: Double = 0.0
    
    var averageMs: Int {
        get {
            return Int (self.averageTime * 1000) // Value in ms
        }
        
        set {
            
        }
    }
    
    var BPM: Int = 0

    func didTapTempo () {
        
        storeTaps(Date().timeIntervalSinceReferenceDate)
        calculateAverageTime()
        calculateBPM()
        
    }
    
    func storeTaps (_ tapTime: TimeInterval) {
        
        guard !tapArray.isEmpty else {
            tapArray.append(tapTime)
            return
        }
        
        //If more than 2 sec elapsed since the last tap, the array is emptied as we assume that the previous taps should not been taken in consideration
        if tapTime - tapArray.last! > 2.0 {
            tapArray.removeAll()
            tapArray.append(tapTime)
        }
        tapArray.append(tapTime)
    }
    
    func calculateAverageTime () {
        let numberOfTaps = tapArray.count
        guard numberOfTaps >= 3 else {
            self.averageTime = 0
            return
        }
        self.averageTime = (tapArray.last! - tapArray[1])/Double (numberOfTaps-2)
    }
    
    
    func calculateBPM () {
        if self.averageTime != 0.0 {
            let bpm = 60/self.averageTime
            self.BPM = Int(round(bpm)) }
        else {
            self.BPM = 0
        }
       
    }

    
}
