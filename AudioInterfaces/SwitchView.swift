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
    var state: patch = .parameterControl {
        didSet {
            switchToState(state)
        }
    }
    
    override func awakeFromNib() {
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(SwitchView.didSwipe))
        swipe!.direction = .right
        overLayView.addGestureRecognizer(swipe!)
        parametersLabel.font = Constants.Fonts().regularFont
        tapLabel.font = Constants.Fonts().regularFont
    }
    
    func switchToState(_ newState:patch){
        if let delegate = switchDelegate {
            delegate.switchDidChangeToState(newState)
        }
        switch newState {
        case .tapTempo:
            animateToTapTempo()
        case .parameterControl:
            animateToParametersControl()
        }
    }
    
    func didSwipe() {
        switch swipe!.direction {
            
        case UISwipeGestureRecognizerDirection.left:
            if state == .parameterControl {return}
            state = .parameterControl
            swipe?.direction = .right
            return
            
        case UISwipeGestureRecognizerDirection.right:
            if state == .tapTempo {return}
            state = .tapTempo
            swipe?.direction = .left
            return
            
        default:
            return
        }
        
    }
    
    func animateToTapTempo() {
        UIView.animate(withDuration: 0.1, animations: {
            self.tapLabel.backgroundColor = UIColor.black
            self.tapLabel.textColor = UIColor.white
            self.overlayLead.constant = self.parametersLabel.frame.size.width
            self.parametersLabel.backgroundColor = UIColor.lightGray
            self.parametersLabel.textColor = UIColor.black
            self.layoutIfNeeded()
        })
    }
    
    
    func animateToParametersControl() {
        UIView.animate(withDuration: 0.1, animations: {
            self.parametersLabel.backgroundColor = UIColor.black
            self.parametersLabel.textColor = UIColor.white
            self.overlayLead.constant = 0
            self.tapLabel.backgroundColor = UIColor.lightGray
            self.tapLabel.textColor = UIColor.black
            self.layoutIfNeeded()
        })
    }
    
}
