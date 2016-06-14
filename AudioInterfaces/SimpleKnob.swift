//
//  ContinuousKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit



enum angleSections: CGFloat {
    case Quarter = 1.0
    case Half = 2.0
    case ThreeQuarters = 3.0
    case Full = 4.0
}

@IBDesignable class SimpleKnob: UIView, KnobProtocol {
    
    let π = Constants.sharedValues.π
    let padding = Constants.sharedValues.padding
    
    var delegate:KnobDelegate?
    
    let valueLabel = UILabel()
    
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    @IBInspectable var knobStrokeDimension: CGFloat = Constants.sharedValues.knobDimension
    @IBInspectable var minValue: Double = 0.0
    @IBInspectable var maxValue: Double = 10.0
    
    var valueRange: Double {
        get {
            return maxValue - minValue
        }
    }
    
    
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
    
    
    @IBInspectable var touchValueInDegrees: Double = 0.0
    
    var rotationGestureRecognizer: RotationGestureRecognizer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rotationGestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(SimpleKnob.didReceiveTouch(_:)))
        self.addGestureRecognizer(rotationGestureRecognizer!)
        let model = ContinuousKnobModel()
        self.delegate = model
        valueLabelSetUp()
        self.addSubview(valueLabel)
    }
    
    
    func valueLabelSetUp() {
        let dimension: CGFloat = 86.0
        let xPosition = (self.bounds.size.width/2) - (dimension/2)
        let yPosition = (self.bounds.size.height/2) - (dimension/2)
        valueLabel.frame = CGRectMake(xPosition, yPosition, 86, 86)
        valueLabel.contentMode = .Center
        valueLabel.textAlignment = .Center
        valueLabel.font = UIFont(name: "HelveticaNeue-Bold",
                                 size: 20.0)
        
    }
    
    
    //MARK: Draw functions
    
    override func drawRect(rect: CGRect) {
        
        drawTheInLine()
        drawTheOutLine(valueRange, touchPositionInRange: touchValueInDegrees)
        updateValueLabel()
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
        let angleRangeDegr = RadiansToDegrees(Double (angleDifference))
        
        //Calculate the arc for each single interval
        
        let arcLengthPerDegree = angleDifference / CGFloat(angleRangeDegr)
        
        //Multiply out by the actual touchPositionInRange (touchPositionInRange = delta in degrees between the startAngle (0.0) and the touch (0..angleRangeDegr)
        
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
        //Stroke the path
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
    }
    
    //MARK: Action functions
    
    
    func updateValueLabel () {

    let angleRangeDegr = RadiansToDegrees(Double (knobEndAngle - knobStartAngle))
    let angleToValue = CGFloat (touchValueInDegrees/angleRangeDegr) * CGFloat (maxValue)
     valueLabel.text = NSString(format:"%.1f", angleToValue) as String
    valueLabel.layoutIfNeeded()
    }
    
    func didReceiveTouch (sender: AnyObject) {
        
        if let knobDelegate = delegate {
            knobDelegate.handleRotationforKnob(self, sender: rotationGestureRecognizer!)
            setNeedsDisplay()
        }
    }
    
    
    func RadiansToDegrees (value:Double) -> Double {
        var result = value * (180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
}
