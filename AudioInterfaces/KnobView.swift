//
//  ContinuousKnob.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

protocol KnobDelegate {
    func handleRotation(sender: AnyObject)
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
    @IBInspectable var startAngle: angleSections = .ThreeQuarters
    @IBInspectable var endAngle: angleSections = .Quarter
    @IBInspectable var knobStrokeDimension: CGFloat = Constants.sharedValues.knobDimension
    @IBInspectable var minValue: Double = 0.0
    @IBInspectable var maxValue: Double = 10.0
    
    private var knobStartAngle: CGFloat {
        get {
            return startAngle.rawValue * π / 4
        }
    }
    
    private var knobEndAngle: CGFloat {
        get {
            return endAngle.rawValue * π / 4
        }
    }
    
    private var range: Double {
        get {
            return maxValue - minValue
        }
    }
    
    private var touchPositionInRange: Double = 0.0 {
        didSet {
            if touchPositionInRange <= range {
                setNeedsDisplay()
            }
        }
    }

    
    var minimumValue = Constants.sharedValues.minimumVolumeValue
    var maximumValue = Constants.sharedValues.maximumVolumeValue
    
    //var delegate: continuousKnobValueDelegate?
    
    private var deltaOldValue: Double = 0.0
    
    //MARK: Draw functions
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gr = RotationGestureRecognizer(target: self, action: #selector(ContinuousKnobModel.handleRotation(_:)))
        self.addGestureRecognizer(gr)
    }
    
    override func drawRect(rect: CGRect) {
        
        drawTheInLine()
        drawTheOutLine(range, touchPositionInRange: touchPositionInRange)
    }
    
    
    private func drawRunPath () -> UIBezierPath {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)/2 - padding //Radius = max width of the view / 2
        
        let arcWidth: CGFloat = knobStrokeDimension // This is the tickness of the stroke. See point 6
        
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
    
    private func drawTheOutLine (range: Double, touchPositionInRange: Double) {
        
        
        let arcWidth: CGFloat = knobStrokeDimension
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        
        let angleDifference: CGFloat = 2 * π - startAngle.rawValue + endAngle.rawValue
        
        //Calculate the arc for each single interval
        
        let arcLengthPerDegree = angleDifference / CGFloat(range)
        
        //Multiply out by the actual touchPositionInRange postion (touchPositionInRange)
        let outlineEndAngle = arcLengthPerDegree * CGFloat(touchPositionInRange) + startAngle.rawValue
        
        //draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - padding - 2.5,
                                       startAngle: startAngle.rawValue,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //draw the inner arc
        outlinePath.addArcWithCenter(center,
                                     radius: bounds.width/2 - arcWidth - padding + 2.5,
                                     startAngle: outlineEndAngle,
                                     endAngle: startAngle.rawValue,
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
        knobDelegate.handleRotation(self)
        }
    
    }

    
}
