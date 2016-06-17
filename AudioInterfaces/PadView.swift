//
//  Pad.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 15/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

enum patch {
    case TapTempo
    case ParameterControl
}

//Note: action for Button needs to be defined programmatically below by the end user!

@IBDesignable class PadView: UIView, PadDelegate {
    
    var PadController = Pad()
    @IBInspectable var gridColor: UIColor = UIColor.orangeColor()
    @IBInspectable var backColor: UIColor = UIColor.yellowColor()
    @IBInspectable var lineWidth:CGFloat = 2
    @IBInspectable var leadSpaceBetweenLines: Int = 20
    @IBInspectable var patchTo: patch = .TapTempo
    @IBInspectable var displayLabels: Bool = true
    @IBInspectable var displayButton: Bool = true
    @IBInspectable var buttonTitle: String?
    
    let titleLabel1 = UILabel()
    let titleLabel2 = UILabel()
    let valueLabel1 = UILabel()
    let valueLabel2 = UILabel()
    let button = UIButton()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(PadController)
        setUpPadController ()
        PadController.setUpView()
        setUpLabels([titleLabel1, valueLabel1, titleLabel2, valueLabel2])
        setUpButton()
    }
    
    
    func setUpPadController () {
        PadController.gridColor = gridColor
        PadController.backColor = backColor
        PadController.lineWidth = lineWidth
        PadController.leadSpaceBetweenLines = leadSpaceBetweenLines
        PadController.patchTo = patchTo
        PadController.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height * 0.5)
        PadController.viewDelegate = self
        PadController.translatesAutoresizingMaskIntoConstraints = false
        let padTrail = NSLayoutConstraint(item: PadController, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -10)
        let padLead = NSLayoutConstraint(item: PadController, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 10)
        let padWidth = NSLayoutConstraint(item: PadController, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -20)
        let padHeight = NSLayoutConstraint(item: PadController, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.5, constant: 0)
        let padTop = NSLayoutConstraint(item: PadController, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: -10)
        self.addConstraints([padTrail, padLead, padWidth, padHeight, padTop])
    }
    
    func setUpLabels (labels:[UILabel]) {
        
        guard displayLabels == true else {
            for label in labels {
                label.hidden = true
            }
            return
        }
        
        self.addSubview(titleLabel1)
        self.addSubview(valueLabel1)
        self.addSubview(titleLabel2)
        self.addSubview(valueLabel2)
        
        for label in labels {
            
            label.frame.size.width = PadController.frame.size.width/4
            label.font = UIFont(name: "Zapf Dingbats", size: 12)
            label.adjustsFontSizeToFitWidth = true
            
            if label == valueLabel1 || label == valueLabel2 {
                label.backgroundColor = UIColor.blackColor()
                label.textColor = UIColor.whiteColor()
            } else {
                label.backgroundColor = UIColor.clearColor()
                label.textColor = UIColor.blackColor()
            }
            
            label.textAlignment = .Center
            label.translatesAutoresizingMaskIntoConstraints = false
            let widthContraint = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: PadController, attribute: .Width, multiplier: 0.25, constant: 0)
            self.addConstraints([widthContraint])
            
            makeRoundedCorners(label)
            
        }
        
        
        let label1Top = NSLayoutConstraint(item: titleLabel1, attribute: .Top, relatedBy: .Equal, toItem: PadController, attribute: .Bottom, multiplier: 1, constant: 16)
        let label1Trail = NSLayoutConstraint(item: titleLabel1, attribute: .Trailing, relatedBy: .Equal, toItem: valueLabel1, attribute: .Leading, multiplier: 1, constant: 0)
        let value1Top = NSLayoutConstraint(item: valueLabel1, attribute: .Top, relatedBy: .Equal, toItem: PadController, attribute: .Bottom, multiplier: 1, constant: 16)
        let value1Lead = NSLayoutConstraint(item: valueLabel1, attribute: .Leading, relatedBy: .Equal, toItem: titleLabel1, attribute: .Trailing, multiplier: 1, constant: 0)
        let value1Trail = NSLayoutConstraint(item: valueLabel1, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -10)
        
        let label2Top = NSLayoutConstraint(item: titleLabel2, attribute: .Top, relatedBy: .Equal, toItem: titleLabel1, attribute: .Bottom, multiplier: 1, constant: 8)
        let label2Trail = NSLayoutConstraint(item: titleLabel2, attribute: .Trailing, relatedBy: .Equal, toItem: valueLabel2, attribute: .Leading, multiplier: 1, constant: 0)
        let value2Top = NSLayoutConstraint(item: valueLabel2, attribute: .Top, relatedBy: .Equal, toItem: valueLabel1, attribute: .Bottom, multiplier: 1, constant: 8)
        let value2Lead = NSLayoutConstraint(item: valueLabel2, attribute: .Leading, relatedBy: .Equal, toItem: titleLabel2, attribute: .Trailing, multiplier: 1, constant: 0)
        let value2Trail = NSLayoutConstraint(item: valueLabel2, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -10)
        
        self.addConstraints([label1Top, label1Trail, value1Top, value1Lead, value1Trail, label2Top, label2Trail, value2Top, value2Lead, value2Trail])
        
        
        switch patchTo {
        case .TapTempo:
            titleLabel1.text = "Ms"
            titleLabel2.text = "BPM"
            valueLabel1.text = " "
            valueLabel2.text = " "
            
        case .ParameterControl:
            return // For future implementation
        }
        
        
        
        setNeedsLayout()

    }
    
    func setUpButton() {
        guard displayButton == true else {
            button.hidden = true
            return}
        self.addSubview(button)
        makeRoundedCorners(button)
        button.backgroundColor = gridColor
        if let title = buttonTitle {
        button.setTitle(title, forState: .Normal)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let widthContraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: PadController, attribute: .Width, multiplier: 0.5, constant: 0)
        let buttonTop = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: PadController, attribute: .Bottom, multiplier: 1, constant: 16)
        let buttonLead = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: PadController, attribute: .Leading, multiplier: 1, constant: 0)
        
        
        var conditionalContraint: NSLayoutConstraint
        
        if titleLabel2.hidden == false {
        conditionalContraint = NSLayoutConstraint(item: button, attribute: .BottomMargin, relatedBy: .Equal, toItem: titleLabel2, attribute: .BottomMargin, multiplier: 1, constant: 0)
        }
        else {
            conditionalContraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: button, attribute: .Height, multiplier: 1, constant: 32)
        }
        
        //let buttonTrail = NSLayoutConstraint(item: button, attribute: .Trailing, relatedBy: .Equal, toItem: titleLabel1, attribute: .Leading, multiplier: 1, constant: 0)
        self.addConstraints([widthContraint, buttonTop, buttonLead, conditionalContraint])
        
        button.layoutIfNeeded()
        
    }
    
    
    func makeRoundedCorners(view: UIView) {
        view.layer.cornerRadius = 3.0
        view.clipsToBounds = true
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        
    }
    
    //MARK: PadDelegate 
    
    func didUpdateValues(value1: Int, value2: Int) {
        
        valueLabel1.text = "\(value1)"
        valueLabel2.text = "\(value2)"
    }
    
}




