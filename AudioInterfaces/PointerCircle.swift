//
//  PointerCircle.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 08/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable class PointerCircle: UIView {
    
    var color: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect)
        print(rect)
        color.setFill()
        circlePath.fill()
    }
    
}
