//
//  PadAssembly.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 16/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

@IBDesignable class PadAssembly: UIView {
    
    
    @IBOutlet weak var pad: Pad!
    
    @IBOutlet weak var value1Label: UILabel!
    @IBOutlet weak var value2Label: UILabel!
    @IBOutlet weak var value1Title: UILabel!
    @IBOutlet weak var value2Title: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        NSBundle.mainBundle().loadNibNamed("PadAssembly", owner: self, options: nil)
        setUpView()
    }
    
    func setUpView() {
    value1Label.backgroundColor = pad.gridColor
    value2Label.backgroundColor = pad.gridColor
    
    }

    override func drawRect(rect: CGRect) {
        
    }
    
    }
