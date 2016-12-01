//
//  PublicFunctions.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 01/12/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

public func differenceDegrees(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    return (360 + (angle1 - angle2)).truncatingRemainder(dividingBy: 360)
}
