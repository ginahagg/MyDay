//
//  FUICellBackgroundView.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/11/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit

class FUICellBackgroundView: UIView {
    
    var cornerRadius:CGFloat = 0.5
    var separatorColor: UIColor = UIColor.yellowColor()
    var separatorHeight: CGFloat = 0.3
    var roundedCorners : UIRectCorner = UIRectCorner.AllCorners

    
    func initialize (){
        if (self == FUICellBackgroundView.self()){
            
            let appearance = FUICellBackgroundView.appearance()
            
            appearance.cornerRadius = 3.0
            appearance.separatorColor = UIColor.clearColor()
            appearance.separatorHeight = 1.0
            print("setting appearance \(appearance.cornerRadius)")
            self.opaque = false
            self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        }
    }
    
    
    override func drawRect(aRect: CGRect){
        print("drawing Rect")
        let c = UIGraphicsGetCurrentContext()
    
        let lineWidth : CGFloat = 1.0
        CGContextSetStrokeColorWithColor(c, UIColor.grayColor().CGColor)
        CGContextSetLineWidth(c, lineWidth)
        CGContextSetAllowsAntialiasing(c, true)
        CGContextSetShouldAntialias(c, true)
    
        let radii = CGSizeMake(self.cornerRadius, self.cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:self.roundedCorners , cornerRadii: radii)
        
        CGContextSaveGState(c)
        CGContextAddPath(c, bezierPath.CGPath)
        CGContextClip(c)
    
        CGContextSetFillColorWithColor(c, self.backgroundColor!.CGColor)
        CGContextFillRect(c, self.bounds)
        CGContextSetFillColorWithColor(c, self.separatorColor.CGColor)
        CGContextFillRect(c, CGRectMake(0, self.bounds.size.height - self.separatorHeight, self.bounds.size.width, self.bounds.size.height - self.separatorHeight))
    
        CGContextRestoreGState(c)
    
    }

}
