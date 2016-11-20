//
//  Extensions.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 20/11/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    public func radiansToDegrees() -> CGFloat {
        var result = self * CGFloat(180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
    
}
