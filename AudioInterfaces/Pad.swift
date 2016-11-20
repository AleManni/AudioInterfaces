//
//  Pad.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


@IBDesignable class Pad: UIControl, UIGestureRecognizerDelegate, PadProtocol {
    
    @IBInspectable var gridColor: UIColor = UIColor.orangeColor()
    @IBInspectable var backColor: UIColor = UIColor.yellowColor()
    @IBInspectable var lineWidth:CGFloat = 2
    @IBInspectable var leadSpaceBetweenLines: CGFloat = 20
    var patchType: patch = .ParameterControl {
        didSet {
            setNeedsDisplay()
            setUpView()
        }
    }
    @IBInspectable var maximumValuePar1: Double = 0.0
    @IBInspectable var maximumValuePar2: Double = 0.0
    
    var panGesture: UIPanGestureRecognizer?
    var tapGesture: UITapGestureRecognizer?
    var touchPosition: CGPoint?
    var delegate: AnyObject?
    var viewDelegate: PadDelegate?
    var outputValues: (value1: CGFloat, value2: CGFloat) = (0,0)
    
    let pointer = PointerCircle()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView () {
        
        switch patchType {
            
        case .TapTempo:
            self.gestureRecognizers = []
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(Pad.didTap))
            self.addGestureRecognizer(tapGesture!)
            tapGesture!.delegate = self
            self.delegate = TapTempoCalculator()
            if subviews.contains(pointer) {
                pointer.removeFromSuperview()
            }
            
        case .ParameterControl:
            self.gestureRecognizers = []
            panGesture = UIPanGestureRecognizer(target: self, action: #selector (Pad.handlePan))
            self.addGestureRecognizer(panGesture!)
            panGesture!.delegate = self
            let calculator = TwoParametersCalculator()
            self.delegate = calculator
            calculator.padObj = self
            self.addSubview(pointer)
            pointer.frame = CGRectMake(0, 0, 12, 12)
            pointer.opaque = false
            pointer.color = gridColor
            pointer.center = CGPoint(x: (self.bounds.minX + pointer.frame.size.width), y: (self.bounds.maxY-pointer.frame.size.height))
        }
        
        setNeedsLayout()
    }
    
    
    
    func handlePan() {
        guard let pan = panGesture else {return}
        switch pan.state {
        case .Began, .Changed:
            touchPosition = pan.locationInView(self)
            guard let del = delegate as! TwoParametersCalculator? else {return}
            let outValues: (value1: CGFloat, value2:CGFloat) = del.valuesForNewPosition(touchPosition!)
            outputValues.value1 = outValues.value1
            outputValues.value2 = outValues.value2
            self.viewDelegate?.didUpdateValues(outputValues.value1, value2: outputValues.value2)
            repositionPointer((outputValues.value1, outputValues.value2))
        default:
            break
        }
    }
    
    func repositionPointer(values: (value1: CGFloat, value2: CGFloat)?) {
        guard let touch = touchPosition else {
            if values != nil {
                guard let delegate = self.delegate as? TwoParametersCalculator else {return}
            let centre = delegate.pointerPositionForValues(values!)
                pointer.center = centre
                pointer.setNeedsLayout()
            }
            return
        }
        pointer.center = touch
        pointer.setNeedsLayout()
    }
    
    
    func didTap() {
        if let delegate = self.delegate as? TapTempoCalculator {
            delegate.didTapTempo()
            outputValues.value1 = CGFloat(delegate.averageMs)
            outputValues.value2 = CGFloat(delegate.BPM)
            self.viewDelegate?.didUpdateValues(outputValues.value1, value2: outputValues.value2)
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        switch patchType {
        case .TapTempo:
            drawForTap(rect)
        case .ParameterControl:
            drawForParametersControl (rect)
        }
    }
    
    func drawForTap (rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, backColor.CGColor)
        
        CGContextFillRect(context, rect)
        
        let leadDimension = max(self.bounds.size.width, self.bounds.size.height)
        let secondaryDimension = min(self.bounds.size.width, self.bounds.size.height)
        
        let secondarySpaceBetweenLines: CGFloat = (secondaryDimension / (leadDimension/CGFloat(leadSpaceBetweenLines)))
        
        var leadStart = CGPoint(x: 0.0, y: 0.0)
        var endPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        if self.frame.size.width == leadDimension {
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
                endPoint =  CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                //1
                CGContextMoveToPoint(context, leadStart.x + (leadSpaceBetweenLines * CGFloat(i)),
                                     leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y + secondarySpaceBetweenLines * CGFloat(i))
                
                //2
                CGContextMoveToPoint(context, leadStart.x + (leadSpaceBetweenLines * CGFloat (i)),
                                     leadStart.y)
                
                CGContextAddLineToPoint(context, leadStart.x, leadStart.y - secondarySpaceBetweenLines * CGFloat(i))
            }
            
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                leadStart = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                endPoint = CGPoint (x: self.bounds.minX, y: self.bounds.maxY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                
                //3
                CGContextMoveToPoint(context, leadStart.x - (leadSpaceBetweenLines * CGFloat(i)),
                                     leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y - secondarySpaceBetweenLines * CGFloat(i))
                
                //4
                CGContextMoveToPoint(context, endPoint.x + CGFloat(leadSpaceBetweenLines * CGFloat(i)),
                                     leadStart.y)
                CGContextAddLineToPoint(context, leadStart.x, endPoint.y - secondarySpaceBetweenLines * CGFloat(i))
            }
        }
        
        
        if self.frame.size.height == leadDimension {
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
                endPoint =  CGPoint (x: self.bounds.maxX, y: self.bounds.maxY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                //1
                CGContextMoveToPoint(context, leadStart.x - CGFloat(leadSpaceBetweenLines * CGFloat(i)),
                                     leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x - secondarySpaceBetweenLines * CGFloat(i)
                    , endPoint.y)
                //2
                CGContextMoveToPoint(context, endPoint.x, endPoint.y - CGFloat(leadSpaceBetweenLines * CGFloat(i)))
                
                CGContextAddLineToPoint(context, leadStart.x + secondarySpaceBetweenLines * CGFloat(i)
                    , leadStart.y)
            }
            
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                leadStart = CGPoint (x: self.bounds.minX, y: self.bounds.maxY)
                endPoint = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                
                //3
                CGContextMoveToPoint(context, leadStart.x, leadStart.y - CGFloat(leadSpaceBetweenLines * CGFloat(i)))
                CGContextAddLineToPoint(context, endPoint.x - secondarySpaceBetweenLines * CGFloat(i) , endPoint.y)
                //4
                CGContextMoveToPoint(context, endPoint.x, endPoint.y + CGFloat(leadSpaceBetweenLines * CGFloat(i)))
                CGContextAddLineToPoint(context, leadStart.x, leadStart.y + secondarySpaceBetweenLines * CGFloat(i))
                
            }
        }
        
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextStrokePath(context)
        
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = gridColor.CGColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        
    }
    
    func drawForParametersControl (rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backColor.CGColor)
        CGContextFillRect(context, rect)
        
        let leadDimension = max(self.bounds.size.width, self.bounds.size.height)
        let secondaryDimension = min(self.bounds.size.width, self.bounds.size.height)
        
        leadSpaceBetweenLines = leadDimension/CGFloat(maximumValuePar1)
        let secondarySpaceBetweenLines: CGFloat = (secondaryDimension/CGFloat(maximumValuePar2))
        
        var leadStart = CGPoint(x: 0.0, y: 0.0)
        var endPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        
            
            for i in 0...(Int (maximumValuePar1)) {
        
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
                endPoint =  CGPoint (x: self.bounds.minX, y: self.bounds.minY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                //1
                CGContextMoveToPoint(context, leadStart.x + leadSpaceBetweenLines * CGFloat(i),leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x + leadSpaceBetweenLines * CGFloat(i), endPoint.y)
                
            }
            
            
            for i in 0...(Int (maximumValuePar2)) {
                
                leadStart = CGPoint (x: self.bounds.minX, y: self.bounds.minY)
                endPoint = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                
                //3
                CGContextMoveToPoint(context, leadStart.x,
                                     leadStart.y + (secondarySpaceBetweenLines * CGFloat(i)))
                CGContextAddLineToPoint(context, endPoint.x,
                                        endPoint.y + (secondarySpaceBetweenLines * CGFloat(i)))
                }
        
               
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextStrokePath(context)
        
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = gridColor.CGColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        
}

}


