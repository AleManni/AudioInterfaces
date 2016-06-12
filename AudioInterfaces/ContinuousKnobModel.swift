//
//  Continuous Knob.swift
//  Flo
//
//  Created by Alessandro Manni on 19/05/2016.
//  Copyright © 2016 Alessandro Manni - Nodes Agency. All rights reserved.
//

import UIKit


protocol continuousKnobValueDelegate {
    func continuousKnobValueupdated (value: Float)
}


@IBDesignable class ContinuousKnobModel: UIView {
    
    var range: Double = 10.0
    var finger: Double = 0.0 {
        didSet {
            if finger <= range {
                setNeedsDisplay()
            }
        }
    }
    
    
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    
    let π = Constants.sharedValues.π
    
    
    
    var minimumValue = Constants.sharedValues.minimumVolumeValue
    var maximumValue = Constants.sharedValues.maximumVolumeValue
    
    var padding: CGFloat = 4.0 // This is set in order to prevent image cuts in the presentation of the view when it is tangential to the view.bounds
    
    var delegate: continuousKnobValueDelegate?
    
    private var deltaOldValue: Double = 0.0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gr = RotationGestureRecognizer(target: self, action: #selector(ContinuousKnobModel.handleRotation(_:)))
        self.addGestureRecognizer(gr)
    }
    
    
    
    override func drawRect(rect: CGRect) {
        
        drawTheInLine()
        drawTheOutLine(range, finger: finger)
    }
    
    
    private func drawRunPath () -> UIBezierPath {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)/2 - padding //Radius = max width of the view / 2
        
        let arcWidth: CGFloat = knobWidth // This is the tickness of the stroke. See point 6
        
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineWidth = arcWidth
        
        return path
        
    }
    
    private func drawTheInLine () {
        
        let path = drawRunPath()
        counterColor.setStroke()
        path.stroke()
        
    }
    
    
    func handleRotation(sender: AnyObject) {
        
        let gr = sender as! RotationGestureRecognizer
        
        let selectedAngle = gr.rotation
        
        let selectedAngleDegr = RadiansToDegrees(Double (selectedAngle))
        
        let angleRange = endAngle - startAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleRange))
        let endAngleDegr = RadiansToDegrees(Double (endAngle))
        
        //Convert the angle to a value on the given knob scale
        
        let startAngleDegr = RadiansToDegrees(Double (startAngle))
        
        
        
        let delta = calculateDelta(selectedAngleDegr)
        
        
        //Update the knob
        
        self.range = angleRangeDegr
        self.finger = delta
        
        
        // Update the knob value on the basis of the given scale (maximum value)
        
        let angleToValue = CGFloat (delta/angleRangeDegr) * CGFloat (maximumValue)
        self.delegate?.continuousKnobValueupdated(Float (angleToValue))
        
    }
    
    func updateWithNewTime(time:Double) {
        
        let angleRange = Double (endAngle - startAngle)
        let angleRangeDegr = RadiansToDegrees(angleRange)
        let startAngleDegr = RadiansToDegrees(Double (startAngle))
        let selectedAngleDegr = ((angleRangeDegr / Double (maximumValue)) * time) + startAngleDegr
        let delta = calculateDelta(selectedAngleDegr)
        self.finger = delta
        
        // drawTheOutLine(angleRange, delta: valueToAngle)
        setNeedsDisplay()
    }

    
    
    func calculateDelta(selectedAngleDegr:Double) -> Double {
        let startAngleDegr = RadiansToDegrees(Double (startAngle))
        let endAngleDegr = RadiansToDegrees(Double (endAngle))
        let angleRange = endAngle - startAngle
        let angleRangeDegr = RadiansToDegrees(Double (angleRange))
        
        var delta = (selectedAngleDegr - startAngleDegr)
        
        if selectedAngleDegr < startAngleDegr {
            delta = selectedAngleDegr + (360 - startAngleDegr)
        }
        
        
        //Apply top and bottom scale for delta. When out of scale, delta will retain either the max or min value depending on the value of the the previous touch - rendering the area between the start and end of pot "insensitive"
        
        if selectedAngleDegr > endAngleDegr && selectedAngleDegr < startAngleDegr {
            if (deltaOldValue - startAngleDegr) > (endAngleDegr - deltaOldValue) {
                deltaOldValue = angleRangeDegr
                delta = deltaOldValue
            } else {
                deltaOldValue = 0
                delta = deltaOldValue
            }
        }
        
        
        deltaOldValue = delta
        return delta
    }
    
    
    
    private func drawTheOutLine (range: Double, finger: Double) {
        
        
        let arcWidth: CGFloat = knobWidth
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        
        //Calculate the arc for each single interval
        
        let arcLengthPerDegree = angleDifference / CGFloat(range)
        
        //Multiply out by the actual finger postion (finger)
        let outlineEndAngle = arcLengthPerDegree * CGFloat(finger) + startAngle
        
        //draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - padding - 2.5,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //draw the inner arc
        outlinePath.addArcWithCenter(center,
                                     radius: bounds.width/2 - arcWidth - padding + 2.5,
                                     startAngle: outlineEndAngle,
                                     endAngle: startAngle,
                                     clockwise: false)
        
        //close the path
        outlinePath.closePath()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
    }
    
    
    func RadiansToDegrees (value:Double) -> Double {
        var result = value * (180.0 / M_PI)
        if result < 0 {
            result += 360
        }
        return result
    }
    
    
}
