//
//  ContinuousKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

protocol KnobDelegate {
    func handleRotationforKnob(knob: KnobView, sender: AnyObject)
}

enum angleSections: CGFloat {
    case Quarter = 1.0
    case Half = 2.0
    case ThreeQuarters = 3.0
    case Full = 4.0
}

@IBDesignable class KnobView: UIView {

    let π = Constants.sharedValues.π
    let padding = Constants.sharedValues.padding
    
    var delegate:KnobDelegate?
    
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    @IBInspectable var knobStrokeDimension: CGFloat = Constants.sharedValues.knobDimension
    @IBInspectable var minValue: Double = 0.0
    @IBInspectable var maxValue: Double = 10.0
    var range: Double {
        get {
            return maxValue - minValue
        }
    }
    
    
    @IBInspectable var isKnobStepped: Bool = false
    
    var startAngle: angleSections = .ThreeQuarters
    var endAngle: angleSections = .Quarter
    
    var knobStartAngle: CGFloat {
        get {
            return startAngle.rawValue * π / 4
        }
    }
    
    var knobEndAngle: CGFloat {
        get {
            return endAngle.rawValue * π / 4
        }
    }
    
    
    
    @IBInspectable var touchPositionInRange: Double = 0.0 {
        didSet {
            if touchPositionInRange <= range {
                setNeedsDisplay()
            }
        }
    }
    
    
    var rotationGestureRecognizer: RotationGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rotationGestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(KnobView.didReceiveTouch(_:)))
          self.addGestureRecognizer(rotationGestureRecognizer!)
        if isKnobStepped == false {
            let model = ContinuousKnobModel()
            self.delegate = model
        }
    }
    
    
    //MARK: Draw functions
    
    override func drawRect(rect: CGRect) {
        
        drawTheInLine()
        drawTheOutLine(range, touchPositionInRange: touchPositionInRange)
    }
    
    
    private func drawRunPath () -> UIBezierPath {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)/2 - padding //Radius = max width of the view / 2
        
        let arcWidth: CGFloat = knobStrokeDimension // This is the tickness of the stroke. See point 6
        
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - arcWidth/2,
                                startAngle: knobStartAngle,
                                endAngle: knobEndAngle,
                                clockwise: true)
        
        path.lineWidth = arcWidth
        
        return path
        
    }
    
    private func drawTheInLine () {
        
        let path = drawRunPath()
        counterColor.setStroke()
        path.stroke()
        
    }
    
    private func drawTheOutLine (range: Double, touchPositionInRange: Double) {
        
        let arcWidth: CGFloat = knobStrokeDimension
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        
        let angleDifference: CGFloat = 2 * π - knobStartAngle + knobEndAngle
        
        //Calculate the arc for each single interval
        
        let arcLengthPerDegree = angleDifference / CGFloat(range)
        
        //Multiply out by the actual touchPositionInRange position (touchPositionInRange)
        let outlineEndAngle = arcLengthPerDegree * CGFloat(touchPositionInRange) + knobStartAngle
        
        //draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - padding,
                                       startAngle: knobStartAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //draw the inner arc
        outlinePath.addArcWithCenter(center,
                                     radius: bounds.width/2 - arcWidth - padding,
                                     startAngle: outlineEndAngle,
                                     endAngle: knobStartAngle,
                                     clockwise: false)
        
        //close the path
        outlinePath.closePath()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
    }
    
    //MARK: Action functions

    
    func didReceiveTouch (sender: AnyObject) {
        
        if let knobDelegate = delegate {
        knobDelegate.handleRotationforKnob(self, sender: rotationGestureRecognizer!)
            print (touchPositionInRange)
            setNeedsDisplay()
            
        }
    
    }

    
}
