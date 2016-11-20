//
//  ContinuousKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit



enum angleSections: CGFloat {
    case quarter = 1.0
    case half = 2.0
    case threeQuarters = 3.0
    case full = 4.0
}

@IBDesignable class SimpleKnob: UIView, KnobProtocol {
    
    let π = Constants.sharedValues.π
    let padding = Constants.sharedValues.padding
    
    var delegate:AnyObject?
    
    let valueLabel = UILabel()
    
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    @IBInspectable var knobStrokeDimension: CGFloat = Constants.sharedValues.knobDimension
    @IBInspectable var minValue: Int = 0
    @IBInspectable var maxValue: Int = 10
    
    var valueRange: Int {
        get {
            return maxValue - minValue
        }
    }
    
    
    var startAngle: angleSections = .threeQuarters
    var endAngle: angleSections = .quarter
    
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
    
    
    
    
    @IBInspectable var touchValueInDegrees: CGFloat = 0.0
    
    var rotationGestureRecognizer: RotationGestureRecognizer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rotationGestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(SimpleKnob.didReceiveTouch(_:)))
        self.addGestureRecognizer(rotationGestureRecognizer!)
        let calculator = ContinuousKnobCalculator()
        self.delegate = calculator
        valueLabelSetUp()
        self.addSubview(valueLabel)
    }
    
    
    func valueLabelSetUp() {
        let dimension: CGFloat = 86.0
        let xPosition = (self.bounds.size.width/2) - (dimension/2)
        let yPosition = (self.bounds.size.height/2) - (dimension/2)
        valueLabel.frame = CGRect(x: xPosition, y: yPosition, width: 86, height: 86)
        valueLabel.contentMode = .center
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont(name: "HelveticaNeue-Bold",
                                 size: 20.0)
        
    }
    
    
    //MARK: Draw functions
    
    override func draw(_ rect: CGRect) {
        
        drawTheInLine()
        drawTheOutLine(valueRange, touchPositionInRange: touchValueInDegrees)
        updateValueLabel()
    }
    
    
    fileprivate func drawRunPath () -> UIBezierPath {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)/2 - padding // Radius = max width of the view / 2
        
        let arcWidth: CGFloat = knobStrokeDimension // This is the tickness of the stroke.
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - arcWidth/2,
                                startAngle: knobStartAngle,
                                endAngle: knobEndAngle,
                                clockwise: true)
        
        path.lineWidth = arcWidth
        
        return path
        
    }
    
    fileprivate func drawTheInLine () {
        
        let path = drawRunPath()
        counterColor.setStroke()
        path.stroke()
        
    }
    
    fileprivate func drawTheOutLine (_ range: Int, touchPositionInRange: CGFloat) {
        
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
        outlinePath.addArc(withCenter: center,
                                     radius: bounds.width/2 - arcWidth - padding,
                                     startAngle: outlineEndAngle,
                                     endAngle: knobStartAngle,
                                     clockwise: false)
        
        //close the path
        outlinePath.close()
        //Stroke the path
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
    }
    
    //MARK: Actions
    
    
    
    
    func updateValueLabel () {
        if let knobDelegate = delegate as? ContinuousKnobCalculator {
        let outputValue = knobDelegate.calculateOutputValue(self, sender: self)
        valueLabel.text = NSString(format:"%.1f", outputValue) as String
        valueLabel.layoutIfNeeded()
        }
    }
    
    func didReceiveTouch (_ sender: AnyObject) {
        
        if let knobDelegate = delegate as? ContinuousKnobCalculator {
            knobDelegate.handleRotationforKnob(self, sender: rotationGestureRecognizer!)
            updateValueLabel()
            setNeedsDisplay()
        }
    }
    
    //MARK: Utilities
    
    func RadiansToDegrees (_ value:Double) -> Double {
        var result = value * (180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
}
