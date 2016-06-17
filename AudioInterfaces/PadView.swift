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



@IBDesignable class PadView: UIView {
    
    var PadController = UIControl()
    @IBInspectable var gridColor: UIColor = UIColor.orangeColor()
    @IBInspectable var backColor: UIColor = UIColor.yellowColor()
    @IBInspectable var lineWidth:CGFloat = 2
    @IBInspectable var leadSpaceBetweenLines: Int = 20
    @IBInspectable var patchTo: patch = .TapTempo
    
    
    var delegate: AnyObject?
    var outputVaues: (value1: Int, value2: Int) = (0,0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.PadController.addTarget(self, action: #selector(PadView.didTap), forControlEvents: .TouchUpInside)
        self.PadController.addTarget(self, action: #selector(PadView.didDrag), forControlEvents: .TouchDragInside)
        setUpPadController()
        
        switch patchTo {
        case .TapTempo:
            self.delegate = TapTempoCalculator()
        case .ParameterControl:
            return // For future implementation
        }
        
    }
    
    func setUpPadController () {
        self.PadController.layer.cornerRadius = 3.0
        self.PadController.layer.borderColor = gridColor.CGColor
        self.PadController.layer.borderWidth = 2.0
        self.PadController.clipsToBounds = true
    }
    
    
    func didDrag() {
        //For future implmentation
    }
    
    
    func didTap() {
        if let delegate = self.delegate as? TapTempoCalculator {
            delegate.didTapTempo()
            outputVaues.value1 = delegate.averageMs
            outputVaues.value2 = delegate.BPM
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawPadController()
            }
    
    
    func drawPadController() {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, backColor.CGColor)
        
        CGContextFillRect(context, PadController.bounds)
        
        let leadDimension = max(self.bounds.size.width, self.bounds.size.height)
        let secondaryDimension = min(self.bounds.size.width, self.bounds.size.height)
        
        let secondarySpaceBetweenLines: CGFloat = (secondaryDimension / (leadDimension/CGFloat(leadSpaceBetweenLines)))
        
        var leadStart = CGPoint(x: 0.0, y: 0.0)
        var endPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        if self.frame.size.width == leadDimension {
            
            for i in 0...(Int (leadDimension) / leadSpaceBetweenLines) {
                
                
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
                endPoint =  CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                //1
                CGContextMoveToPoint(context, leadStart.x + CGFloat(leadSpaceBetweenLines * i),
                                     leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y + secondarySpaceBetweenLines * CGFloat(i))
                
                //2
                CGContextMoveToPoint(context, leadStart.x + CGFloat(leadSpaceBetweenLines * i),
                                     leadStart.y)
                
                CGContextAddLineToPoint(context, leadStart.x, leadStart.y - secondarySpaceBetweenLines * CGFloat(i))
            }
            
            
            for i in 0...(Int (leadDimension) / leadSpaceBetweenLines) {
                
                leadStart = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                endPoint = CGPoint (x: self.bounds.minX, y: self.bounds.maxY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                
                //3
                CGContextMoveToPoint(context, leadStart.x - CGFloat(leadSpaceBetweenLines * i),
                                     leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y - secondarySpaceBetweenLines * CGFloat(i))
                
                //4
                CGContextMoveToPoint(context, endPoint.x + CGFloat(leadSpaceBetweenLines * i),
                                     leadStart.y)
                CGContextAddLineToPoint(context, leadStart.x, endPoint.y - secondarySpaceBetweenLines * CGFloat(i))
            }
        }
        
        
        if self.frame.size.height == leadDimension {
            
            for i in 0...(Int (leadDimension) / leadSpaceBetweenLines) {
                
                
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
                endPoint =  CGPoint (x: self.bounds.maxX, y: self.bounds.maxY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                //1
                CGContextMoveToPoint(context, leadStart.x - CGFloat(leadSpaceBetweenLines * i),
                                     leadStart.y)
                CGContextAddLineToPoint(context, endPoint.x - secondarySpaceBetweenLines * CGFloat(i)
                    , endPoint.y)
                //2
                CGContextMoveToPoint(context, endPoint.x, endPoint.y - CGFloat(leadSpaceBetweenLines * i))
                
                CGContextAddLineToPoint(context, leadStart.x + secondarySpaceBetweenLines * CGFloat(i)
                    , leadStart.y)
            }
            
            
            for i in 0...(Int (leadDimension) / leadSpaceBetweenLines) {
                
                leadStart = CGPoint (x: self.bounds.minX, y: self.bounds.maxY)
                endPoint = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                CGContextSetLineWidth(context, lineWidth)
                
                //3
                CGContextMoveToPoint(context, leadStart.x, leadStart.y - CGFloat(leadSpaceBetweenLines * i))
                CGContextAddLineToPoint(context, endPoint.x - secondarySpaceBetweenLines * CGFloat(i) , endPoint.y)
                //4
                CGContextMoveToPoint(context, endPoint.x, endPoint.y + CGFloat(leadSpaceBetweenLines * i))
                CGContextAddLineToPoint(context, leadStart.x, leadStart.y + secondarySpaceBetweenLines * CGFloat(i))
                
            }
        }
        
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextStrokePath(context)
        

    }
    
    
}




