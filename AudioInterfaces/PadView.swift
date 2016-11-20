//
//  Pad.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni - Nodes Agency on 15/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

enum patch {
    case tapTempo
    case parameterControl
}

//Note: action for Button needs to be defined programmatically below by the end user!

@IBDesignable open class PadView: UIView, PadDelegate, switchViewDelegate {
    
    var PadController = Pad()
    @IBInspectable var gridColor: UIColor = UIColor.orange
    @IBInspectable var backColor: UIColor = UIColor.yellow
    @IBInspectable var lineWidth:CGFloat = 2
    @IBInspectable var leadSpaceBetweenLines: CGFloat = 20
    
    @IBInspectable var displayLabels: Bool = true
    @IBInspectable var displayButton: Bool = true
    @IBInspectable var buttonTitle: String?
    @IBInspectable var maximumValuePar1: Double = 0.0
    @IBInspectable var maximumValuePar2: Double = 0.0
    
    let button = UIButton()
    var buttonAction: ( ()->() )?
    
    fileprivate var buttonGesture: UITapGestureRecognizer?
    fileprivate let titleLabel1 = UILabel()
    fileprivate let titleLabel2 = UILabel()
    fileprivate let valueLabel1 = UILabel()
    fileprivate let valueLabel2 = UILabel()
    
    
    fileprivate var patchTo: patch = .parameterControl {
        didSet {
            setUpPadController ()
            setUpLabels([titleLabel1, valueLabel1, titleLabel2, valueLabel2])
            layoutIfNeeded()
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(PadController)
        setUpPadController()
        PadController.setUpView()
        setUpButton()
        setUpLabels([titleLabel1, valueLabel1, titleLabel2, valueLabel2])
        setUpSwitch()
    }
    
    
    
    
    fileprivate func setUpPadController () {
        PadController.patchType = patchTo
        PadController.gridColor = gridColor
        PadController.backColor = backColor
        PadController.lineWidth = lineWidth
        PadController.leadSpaceBetweenLines = leadSpaceBetweenLines
        PadController.maximumValuePar1 = maximumValuePar1
        PadController.maximumValuePar2 = maximumValuePar2
        
        PadController.frame = CGRect(x: 10, y: 10, width: self.bounds.size.width - 20, height: self.bounds.size.height * 0.5)
        PadController.viewDelegate = self
        PadController.translatesAutoresizingMaskIntoConstraints = false
        let padTrail = NSLayoutConstraint(item: PadController, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10)
        let padLead = NSLayoutConstraint(item: PadController, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10)
        let padWidth = NSLayoutConstraint(item: PadController, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -20)
        let padHeight = NSLayoutConstraint(item: PadController, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
        let padTop = NSLayoutConstraint(item: PadController, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -10)
        self.addConstraints([padTrail, padLead, padWidth, padHeight, padTop])
        
        layoutIfNeeded()
    }
    
    fileprivate func setUpLabels (_ labels:[UILabel]) {
        
        guard displayLabels == true else {
            for label in labels {
                label.isHidden = true
            }
            return
        }
        
        self.addSubview(titleLabel1)
        self.addSubview(valueLabel1)
        self.addSubview(titleLabel2)
        self.addSubview(valueLabel2)
        
        for label in labels {
            label.font = Constants.Fonts().smallFont 
            label.sizeToFit()
            
            if label == valueLabel1 || label == valueLabel2 {
                label.frame.size.width = PadController.frame.size.width/4
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
                label.textAlignment = .center
            } else {
                label.frame.size.width = PadController.frame.size.width/8
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor.black
                label.textAlignment = .right
            }
            
            
            label.translatesAutoresizingMaskIntoConstraints = false
            let widthContraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: PadController, attribute: .width, multiplier: 0.25, constant: 0)
            self.addConstraints([widthContraint])
            
            makeRoundedCorners(label)
        }
        
        
        let label1Allign = NSLayoutConstraint(item: titleLabel1, attribute: .centerY, relatedBy: .equal, toItem: valueLabel1, attribute: .centerY, multiplier: 1, constant: 0)
        let label1Trail = NSLayoutConstraint(item: titleLabel1, attribute: .trailing, relatedBy: .equal, toItem: valueLabel1, attribute: .leading, multiplier: 1, constant: -4)
        let label1Btm = NSLayoutConstraint(item: titleLabel1, attribute: .bottom, relatedBy: .equal, toItem: valueLabel1, attribute: .bottom, multiplier: 1, constant: 0)
        
        let value1height = NSLayoutConstraint(item: valueLabel1, attribute: .height, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 0.5, constant: -3)
        let value1Top = NSLayoutConstraint(item: valueLabel1, attribute: .top, relatedBy: .equal, toItem: PadController, attribute: .bottom, multiplier: 1, constant: 16)
        let value1Lead = NSLayoutConstraint(item: valueLabel1, attribute: .leading, relatedBy: .equal, toItem: titleLabel1, attribute: .trailing, multiplier: 1, constant: 4)
        let value1Trail = NSLayoutConstraint(item: valueLabel1, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10)
        
        let label2Allign = NSLayoutConstraint(item: titleLabel2, attribute: .centerY, relatedBy: .equal, toItem: valueLabel2, attribute: .centerY, multiplier: 1, constant: 0)
        let label2Trail = NSLayoutConstraint(item: titleLabel2, attribute: .trailing, relatedBy: .equal, toItem: valueLabel2, attribute: .leading, multiplier: 1, constant: -4)
        let label2Btm = NSLayoutConstraint(item: titleLabel2, attribute: .bottom, relatedBy: .equal, toItem: valueLabel2, attribute: .bottom, multiplier: 1, constant: 0)
        
        let value2height = NSLayoutConstraint(item: valueLabel2, attribute: .height, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 0.5, constant: -3)
        let value2Top = NSLayoutConstraint(item: valueLabel2, attribute: .top, relatedBy: .equal, toItem: valueLabel1, attribute: .bottom, multiplier: 1, constant: 6)
        let value2Lead = NSLayoutConstraint(item: valueLabel2, attribute: .leading, relatedBy: .equal, toItem: titleLabel2, attribute: .trailing, multiplier: 1, constant: 4)
        let value2Trail = NSLayoutConstraint(item: valueLabel2, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10)
        
        self.addConstraints([label1Allign, label1Trail, label1Btm, value1height, value1Top, value1Lead, value1Trail, label2Allign, label2Trail, label2Btm, value2Top, value2height, value2Lead, value2Trail])
        
        
        switch patchTo {
        case .tapTempo:
            titleLabel1.text = "Ms"
            titleLabel2.text = "BPM"
            valueLabel1.text = " "
            valueLabel2.text = " "
            
        case .parameterControl:
            titleLabel1.text = "PAR1"
            titleLabel2.text = "PAR2"
            valueLabel1.text = " "
            valueLabel2.text = " "
        }
        
        setNeedsLayout()
        
    }
    
    
    
    fileprivate func setUpButton() {
        guard displayButton == true else {
            button.isHidden = true
            return}
        self.addSubview(button)
        makeRoundedCorners(button)
        button.backgroundColor = gridColor
        if let title = buttonTitle {
            button.setTitle(title, for: UIControlState())
        }
        
        button.showsTouchWhenHighlighted = true
        button.titleLabel!.font = Constants.Fonts().smallFont
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.allowsDefaultTighteningForTruncation
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: PadController, attribute: .width, multiplier: 0.25, constant: 0)
        let buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: PadController, attribute: .bottom, multiplier: 1, constant: 16)
        let buttonLead = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: PadController, attribute: .leading, multiplier: 1, constant: 0)
        let  heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
        
        self.addConstraints([widthConstraint, buttonTop, buttonLead, heightConstraint])
        
        buttonGesture = UITapGestureRecognizer(target: self, action: #selector(performButtonAction))
        button.addGestureRecognizer(buttonGesture!)
         layoutIfNeeded()
    }
    
    func performButtonAction () {
        if let _ = buttonAction {
            buttonAction!()
        }
    }
    
    fileprivate func setUpSwitch() {
        let switchView = Bundle.main.loadNibNamed("SwitchView", owner: self, options: nil)?[0] as! SwitchView
        self.addSubview(switchView)
        switchView.switchDelegate = self
        
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: switchView, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.5, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: switchView, attribute: .height, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1, constant: 0)
        let switchTop = NSLayoutConstraint(item: switchView, attribute: .top, relatedBy: .equal, toItem: PadController, attribute: .bottom, multiplier: 1, constant: 16)
        
        let switchLead = NSLayoutConstraint(item: switchView, attribute: .leading, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 8)
        
        self.addConstraints([widthConstraint, heightConstraint, switchTop, switchLead])
    }
    
    
    //MARK - Utilities
    
    fileprivate func makeRoundedCorners(_ view: UIView) {
        view.layer.cornerRadius = 3.0
        view.clipsToBounds = true
    }
    
    
    //MARK: PadDelegate
    
    func didUpdateValues(_ value1: CGFloat, value2: CGFloat) {
        if PadController.patchType == .tapTempo {
            valueLabel1.text = "\(Int(value1))"
            valueLabel2.text = "\(Int(value2))"
        }
        if PadController.patchType == .parameterControl {
            let string1 = String(format:"%.1f", value1)
            let string2 = String(format:"%.1f", value2)
            valueLabel1.text = "\(string1)"
            valueLabel2.text = "\(string2)"
        }
    }
    
    //MARK SwitchViewDelegate
    
    func switchDidChangeToState(_ newState:patch) {
        patchTo = newState
    }
    
}




