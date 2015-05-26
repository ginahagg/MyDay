//
//  CircleView.swift
//  Circles
//
//  Created by Gina Hagg on 5/13/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var colorr = UIColor.grayColor()
    var text = "Hello"
    
    var count:Int = 7
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    init(frame: CGRect, color: UIColor, txt:String){
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.colorr = color
        self.text = txt
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Get the Graphics Context
        var context = UIGraphicsGetCurrentContext();
        
        // Set the circle outerline-width
        CGContextSetLineWidth(context, 5.0);
        CGContextSetFillColorWithColor(context,  UIColor.magentaColor().CGColor )        
        // Set the circle outerline-colour
        //UIColor.redColor().set()
        //(colorcircles[self.count].color).set()
        self.colorr.set()
        
        // Create Circle
        CGContextAddArc(context, (frame.size.width)/2, frame.size.height/2, (frame.size.width - 10)/2, 0.0, CGFloat(M_PI * 2.0), 1)
  
        // Draw
        //CGContextStrokePath(context);
        CGContextDrawPath(context, kCGPathFillStroke)
        drawText(rect, ctx:context,x:CGRectGetMidX(rect), y:CGRectGetMidY(rect), radius: CGRectGetWidth(rect)/2, sides: 1, color: UIColor.whiteColor(),
            txt:self.text)
    }
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i--;
        }
        return points
    }
    
    

    
    func drawText(rect:CGRect, ctx:CGContextRef, x:CGFloat, y:CGFloat,radius:CGFloat, sides:Int, color:UIColor, txt:String) {
        
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
        CGContextScaleCTM(ctx, 1.0, -1.0)
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/2
        // An adjustment of 270 degrees to position numbers correctly
        var cpoints = circleCircumferencePoints(1,x:x,y:y,radius:radius-inset,adjustment:90)
        
        
        let path = CGPathCreateMutable()
        // see
        for p in enumerate(cpoints) {
            if p.index > 0 {
                // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
                
                let aFont = UIFont(name: "Helvetica", size: radius/3)
                // create a dictionary of attributes to be applied to the string
                let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor.whiteColor()]
                // create the attributed string
                let text = CFAttributedStringCreate(nil, txt, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
                // set the line width to stroke the text with
                CGContextSetLineWidth(ctx, 1.5)
                // set the drawing mode to stroke
                //kCGTextStroke
                CGContextSetTextDrawingMode(ctx, kCGTextFill )
               
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                CGContextSetTextPosition(ctx, xn, yn)
                //println("Drawing text:xn: \(aFont!.description)")
                // draw the line of text
                CTLineDraw(line, ctx)
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        var radius = CGRectGetWidth(self.frame)/2
        var myRect=CGRectMake(self.frame.origin.x, self.frame.origin.y, 2*self.frame.width, 2*self.frame.height)
        println("myrect: \(myRect.origin.x), \(myRect.origin.y), \(myRect.width), \(myRect.height)")
        for tch in touches
        { // Get location of Touch
            var touch = tch as! UITouch
            var circleCenter = touch.locationInView(self.superview)
            println("i am touched at \(circleCenter.x) and \(circleCenter.y)")
            if(CGRectContainsPoint(myRect,circleCenter ))
            {
                println("you touched my circle at \(self.frame.origin.x), color: \(self.colorr), text:\(self.text)")
                var vController = self.superview?.nextResponder() as! StoryDetailViewController
                var selectedItem = selectedMood(text:self.text, color:self.colorr)
                vController.selected = selectedItem
                vController.SaveTheDay(self.text)
                println("nextresponder_id: \(vController)")
                
            }
        }

    }
    
}
