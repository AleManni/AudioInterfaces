//
//  SwitchView.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 09/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class SwitchView: UIView {
    
    @IBOutlet weak var overlayLead: NSLayoutConstraint!
    @IBOutlet weak var parametersLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var overLayView: UIView!
    var switchDelegate: switchViewDelegate?
    var swipe: UISwipeGestureRecognizer?
    
    var state: patch = .ParameterControl {
        didSet {
            switchToState(state)
        }
    }
    
    
    
    override func awakeFromNib() {
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(SwitchView.didSwipe))
        swipe!.direction = .Right
        overLayView.addGestureRecognizer(swipe!)
    }
    
    func switchToState(newState:patch){
        if let delegate = switchDelegate {
            delegate.switchDidChangeToState(newState)
        }
        switch newState {
        case .TapTempo:
            animateToTapTempo()
        case .ParameterControl:
            animateToParametersControl()
        }
    }
    
    func didSwipe() {
        switch swipe!.direction {
            
        case UISwipeGestureRecognizerDirection.Left:
            if state == .ParameterControl {return}
            state = .ParameterControl
            swipe?.direction = .Right
            return
            
        case UISwipeGestureRecognizerDirection.Right:
            if state == .TapTempo {return}
            state = .TapTempo
            swipe?.direction = .Left
            return
            
        default:
            return
        }
        
    }
    
    func animateToTapTempo() {
        UIView.animateWithDuration(0.1, animations: {
            self.tapLabel.backgroundColor = UIColor.blackColor()
            self.tapLabel.textColor = UIColor.whiteColor()
            self.overlayLead.constant = self.parametersLabel.frame.size.width
            self.parametersLabel.backgroundColor = UIColor.lightGrayColor()
            self.parametersLabel.textColor = UIColor.blackColor()
            self.layoutIfNeeded()
        })
    }
    
    
    func animateToParametersControl() {
        UIView.animateWithDuration(0.1, animations: {
            self.parametersLabel.backgroundColor = UIColor.blackColor()
            self.parametersLabel.textColor = UIColor.whiteColor()
            self.overlayLead.constant = 0
            self.tapLabel.backgroundColor = UIColor.lightGrayColor()
            self.tapLabel.textColor = UIColor.blackColor()
            self.layoutIfNeeded()
        })
    }
    
}
