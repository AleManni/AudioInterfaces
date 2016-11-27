//
//  Pad.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


@IBDesignable class Pad: UIControl, UIGestureRecognizerDelegate, PadProtocol {
    
    @IBInspectable var gridColor: UIColor = UIColor.orange
    @IBInspectable var backColor: UIColor = UIColor.yellow
    @IBInspectable var lineWidth:CGFloat = 2
    @IBInspectable var leadSpaceBetweenLines: CGFloat = 20
    var patchType: patch = .parameterControl {
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
            
        case .tapTempo:
            self.gestureRecognizers = []
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(Pad.didTap))
            self.addGestureRecognizer(tapGesture!)
            tapGesture!.delegate = self
            self.delegate = TapTempoCalculator()
            if subviews.contains(pointer) {
                pointer.removeFromSuperview()
            }
            
        case .parameterControl:
            self.gestureRecognizers = []
            panGesture = UIPanGestureRecognizer(target: self, action: #selector (Pad.handlePan))
            self.addGestureRecognizer(panGesture!)
            panGesture!.delegate = self
            let calculator = TwoParametersCalculator()
            self.delegate = calculator
            calculator.padObj = self
            self.addSubview(pointer)
            pointer.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
            pointer.isOpaque = false
            pointer.color = gridColor
            pointer.center = CGPoint(x: (self.bounds.minX + pointer.frame.size.width), y: (self.bounds.maxY-pointer.frame.size.height))
        }
        
        setNeedsLayout()
    }
    
    
    
    func handlePan() {
        guard let pan = panGesture else {return}
        switch pan.state {
        case .began, .changed:
            touchPosition = pan.location(in: self)
            guard let del = delegate as! TwoParametersCalculator? else { return }
            if pan.state == .began {
                UIView.animate(withDuration: 0.3, animations: {
                    self.pointer.frame = CGRect(x: self.pointer.frame.origin.x, y: self.pointer.frame.origin.y, width: 20, height: 20)})
            }
            let outValues: (value1: CGFloat, value2:CGFloat) = del.valuesForNewPosition(touchPosition!)
            outputValues.value1 = outValues.value1
            outputValues.value2 = outValues.value2
            self.viewDelegate?.didUpdateValues(outputValues.value1, value2: outputValues.value2)
            repositionPointer((outputValues.value1, outputValues.value2))
            
        case.ended:
            UIView.animate(withDuration: 0.3, animations: {
                self.pointer.frame = CGRect(x: self.pointer.frame.origin.x, y: self.pointer.frame.origin.y, width: 12, height: 12)})
            break
            
        default:
            break
        }
    }
    
    func repositionPointer(_ values: (value1: CGFloat, value2: CGFloat)?) {
        guard let touch = touchPosition else {
            if values != nil {
                guard let delegate = self.delegate as? TwoParametersCalculator else { return }
                let centre = delegate.pointerPositionForValues(values!)
                pointer.center = centre
                setNeedsLayout()
            }
            return
        }
        pointer.center = touch
        setNeedsLayout()
    }
    
    func didTap() {
        if let delegate = self.delegate as? TapTempoCalculator {
            delegate.didTapTempo()
            outputValues.value1 = CGFloat(delegate.averageMs)
            outputValues.value2 = CGFloat(delegate.BPM)
            self.viewDelegate?.didUpdateValues(outputValues.value1, value2: outputValues.value2)
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        switch patchType {
        case .tapTempo:
            drawForTap(rect)
        case .parameterControl:
            drawForParametersControl (rect)
        }
    }
    
    func drawForTap (_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(backColor.cgColor)
        
        context?.fill(rect)
        
        let leadDimension = max(self.bounds.size.width, self.bounds.size.height)
        let secondaryDimension = min(self.bounds.size.width, self.bounds.size.height)
        
        let secondarySpaceBetweenLines: CGFloat = (secondaryDimension / (leadDimension/CGFloat(leadSpaceBetweenLines)))
        
        var leadStart = CGPoint(x: 0.0, y: 0.0)
        var endPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        if self.frame.size.width == leadDimension {
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
                endPoint =  CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                context?.setLineWidth(lineWidth)
                //1
                context?.move(to: CGPoint(x: leadStart.x + (leadSpaceBetweenLines * CGFloat(i)), y: leadStart.y))
                context?.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y + secondarySpaceBetweenLines * CGFloat(i)))
                
                //2
                context?.move(to: CGPoint(x: leadStart.x + (leadSpaceBetweenLines * CGFloat (i)), y: leadStart.y))
                
                context?.addLine(to: CGPoint(x: leadStart.x, y: leadStart.y - secondarySpaceBetweenLines * CGFloat(i)))
            }
            
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                leadStart = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                endPoint = CGPoint (x: self.bounds.minX, y: self.bounds.maxY)
                
                
                context?.setLineWidth(lineWidth)
                
                //3
                context?.move(to: CGPoint(x: leadStart.x - (leadSpaceBetweenLines * CGFloat(i)), y: leadStart.y))
                context?.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y - secondarySpaceBetweenLines * CGFloat(i)))
                
                //4
                context?.move(to: CGPoint(x: endPoint.x + CGFloat(leadSpaceBetweenLines * CGFloat(i)), y: leadStart.y))
                context?.addLine(to: CGPoint(x: leadStart.x, y: endPoint.y - secondarySpaceBetweenLines * CGFloat(i)))
            }
        }
        
        
        if self.frame.size.height == leadDimension {
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                
                leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
                endPoint =  CGPoint (x: self.bounds.maxX, y: self.bounds.maxY)
                
                
                context?.setLineWidth(lineWidth)
                //1
                context?.move(to: CGPoint(x: leadStart.x - CGFloat(leadSpaceBetweenLines * CGFloat(i)), y: leadStart.y))
                context?.addLine(to: CGPoint(x: endPoint.x - secondarySpaceBetweenLines * CGFloat(i), y: endPoint.y))
                //2
                context?.move(to: CGPoint(x: endPoint.x, y: endPoint.y - CGFloat(leadSpaceBetweenLines * CGFloat(i))))
                
                context?.addLine(to: CGPoint(x: leadStart.x + secondarySpaceBetweenLines * CGFloat(i), y: leadStart.y))
            }
            
            
            for i in 0...(Int (leadDimension) / Int (leadSpaceBetweenLines)) {
                
                leadStart = CGPoint (x: self.bounds.minX, y: self.bounds.maxY)
                endPoint = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
                
                
                context?.setLineWidth(lineWidth)
                
                //3
                context?.move(to: CGPoint(x: leadStart.x, y: leadStart.y - CGFloat(leadSpaceBetweenLines * CGFloat(i))))
                context?.addLine(to: CGPoint(x: endPoint.x - secondarySpaceBetweenLines * CGFloat(i), y: endPoint.y))
                //4
                context?.move(to: CGPoint(x: endPoint.x, y: endPoint.y + CGFloat(leadSpaceBetweenLines * CGFloat(i))))
                context?.addLine(to: CGPoint(x: leadStart.x, y: leadStart.y + secondarySpaceBetweenLines * CGFloat(i)))
                
            }
        }
        
        context?.setStrokeColor(gridColor.cgColor)
        context?.setLineWidth(lineWidth)
        context?.strokePath()
        
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = gridColor.cgColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        
    }
    
    func drawForParametersControl (_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backColor.cgColor)
        context?.fill(rect)
        
        let leadDimension = max(self.bounds.size.width, self.bounds.size.height)
        let secondaryDimension = min(self.bounds.size.width, self.bounds.size.height)
        
        leadSpaceBetweenLines = leadDimension/CGFloat(maximumValuePar1)
        let secondarySpaceBetweenLines: CGFloat = (secondaryDimension/CGFloat(maximumValuePar2))
        
        var leadStart = CGPoint(x: 0.0, y: 0.0)
        var endPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        
        
        for i in 0...(Int (maximumValuePar1)) {
            
            leadStart = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
            endPoint =  CGPoint (x: self.bounds.minX, y: self.bounds.minY)
            
            
            context?.setLineWidth(lineWidth)
            //1
            context?.move(to: CGPoint(x: leadStart.x + leadSpaceBetweenLines * CGFloat(i), y: leadStart.y))
            context?.addLine(to: CGPoint(x: endPoint.x + leadSpaceBetweenLines * CGFloat(i), y: endPoint.y))
            
        }
        
        
        for i in 0...(Int (maximumValuePar2)) {
            
            leadStart = CGPoint (x: self.bounds.minX, y: self.bounds.minY)
            endPoint = CGPoint (x: self.bounds.maxX, y: self.bounds.minY)
            
            
            context?.setLineWidth(lineWidth)
            
            //3
            context?.move(to: CGPoint(x: leadStart.x, y: leadStart.y + (secondarySpaceBetweenLines * CGFloat(i))))
            context?.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y + (secondarySpaceBetweenLines * CGFloat(i))))
        }
        
        
        context?.setStrokeColor(gridColor.cgColor)
        context?.setLineWidth(lineWidth)
        context?.strokePath()
        
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = gridColor.cgColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        
    }
    
}


