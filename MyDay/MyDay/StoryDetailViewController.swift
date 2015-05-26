//
//  ViewController.swift
//  MyDay
//
//  Created by Gina Hagg on 5/13/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreData

class StoryDetailViewController: UIViewController {

    var subject = "Mood"
    var rownum = 0
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    struct colorcircle {
        var id = 0
        var pt:CGPoint
        var color:UIColor = UIColor.whiteColor()
        var text:String = "hello"
        
    }
    
    let points = [CGPoint(x: 20, y: 100), CGPoint(x:52, y:23), CGPoint(x:135, y:59), CGPoint(x:0, y:70),
        CGPoint(x:100, y:100), CGPoint(x: 200, y:200), CGPoint(x: 300, y: 150)]
    //rgb(255,174,174) lovely pink
    //rgb(255,236,148) lovely yellow
    //rgb(180,216,231) pale blue
    //rgb(255,240,170) pale yellow
    //rgb(255,98,98)
    //255, 47, 47  red angry
    //174, 174, 255 blues
    //190, 123, 255 spiritual

    
    var selected : selectedMood?
    
    let colorcircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"so-so"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"blues"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"sad"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"pms"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"love"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"happy"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"angry"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"spiritual"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"emptiness"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"joyous"),
    colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"hopeless"),
    colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"depressed"),
    colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"In hell"),
    colorcircle(id:13,pt:CGPoint(x:250, y:200),color:CircleItem.CircleColor.helpless.toColor(), text:"helpless")]
    
    let haircircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"so-so"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"not a good day"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"awful"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"disaster"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"lovely"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"good hair day"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"yikes"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"don't care"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"i gave up"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"fabulous hair"),
        colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"hopeless hair"),
        colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"my hair depresses me"),
        colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"In hell"),
        colorcircle(id:13,pt:CGPoint(x:250, y:200),color:CircleItem.CircleColor.helpless.toColor(), text:"helpless hair")]
    
    let healthcircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"so-so"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"not a good day"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"awful"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"disaster"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"feel awesome"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"energetic"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"not so good"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"tired"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"i feel great"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"fabulously healthy"),
        colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"aches and pains"),
        colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"sick"),
        colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"In hell sick"),
        colorcircle(id:13,pt:CGPoint(x:250, y:200),color:CircleItem.CircleColor.helpless.toColor(), text:"very sick")]
    
    let lovecircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"so-so"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"lonely"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"awful"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"desperate"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"want to fall in love"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"very much in love"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"had a quarrel"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"tired of love"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"i am so in love"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"fabulously in love"),
        colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"love hurts"),
        colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"sick of love"),
        colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"In hell love hurts"),
        colorcircle(id:13,pt:CGPoint(x:250, y:200),color:CircleItem.CircleColor.helpless.toColor(), text:"when will this end")]
    
    let foodcircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"so-so"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"no appetite"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"ate fast food"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"ate junk"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"ate healthy"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"ate delicious and healthy"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"diet food"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"tired of food"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"best food ever"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"Yummy Food!!"),
        colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"bad food-indigestion"),
        colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"sick of love"),
        colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"In hell tummy hurts"),
        colorcircle(id:13,pt:CGPoint(x:250, y:200),color:CircleItem.CircleColor.helpless.toColor(), text:"fasted")]
    
    let exercisecircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"walked a little"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"no exercise"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"couch potato"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"not moved an inch"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"gym"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"long walk"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"jogged"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"hiked"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"yoga"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"danced"),
        colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"pilates"),
        colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"outdoors"),
        colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"weights"),
        colorcircle(id:13,pt:CGPoint(x:250, y:200),color:CircleItem.CircleColor.helpless.toColor(), text:"ran")]
    
    let socialcircles = [
        colorcircle(id:0,pt:CGPoint(x:52, y:23),color:CircleItem.CircleColor.so.toColor(),text:"isolated"),
        colorcircle(id:1,pt:CGPoint(x:135, y:59), color:CircleItem.CircleColor.blues.toColor(),text:"alone"),
        colorcircle(id:2,pt:CGPoint(x:0, y:70), color:CircleItem.CircleColor.sad.toColor(),text:"chat online"),
        colorcircle(id:3,pt:CGPoint(x:100, y:100), color:CircleItem.CircleColor.pms.toColor(),text:"facebooked"),
        colorcircle(id:4,pt:CGPoint(x: 50, y: 100), color:CircleItem.CircleColor.love.toColor(), text:"lovely party"),
        colorcircle(id:5,pt:CGPoint(x: 120, y: 280), color:CircleItem.CircleColor.happy.toColor(), text:"with family"),
        colorcircle(id:6,pt:CGPoint(x: 150, y: 150), color:CircleItem.CircleColor.angry.toColor(), text:"jogged"),
        colorcircle(id:7,pt:CGPoint(x: 200, y:200), color:CircleItem.CircleColor.spiritual.toColor(), text:"hiked"),
        colorcircle(id:8,pt:CGPoint(x:450, y:200),color:CircleItem.CircleColor.emptiness.toColor(), text:"yoga"),
        colorcircle(id:9,pt:CGPoint(x:300, y:150),color:CircleItem.CircleColor.joyous.toColor(), text:"with friends"),
        colorcircle(id:10,pt:CGPoint(x:80, y:85),color:CircleItem.CircleColor.hopeless.toColor(), text:"no contact"),
        colorcircle(id:11,pt:CGPoint(x:400, y:180),color:CircleItem.CircleColor.depressed.toColor(), text:"lonely"),
        colorcircle(id:12,pt:CGPoint(x:300, y:50),color:CircleItem.CircleColor.hell.toColor(), text:"desperately alone")]
        

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        println(self.subject)
        drawCircles()
    }
    
    
    func drawCircles() {
        var circles = [colorcircle]()
        // loop through the points
        if( self.subject == "Mood"){
                circles = colorcircles
        }
        else if self.subject == "HairDay"{
            circles = haircircles
        }
        else if self.subject == "Health"{
            circles = healthcircles
        }
        else if self.subject == "Love"{
            circles = lovecircles
        }
        else if self.subject == "Food"{
            circles = foodcircles
        }
        else if self.subject == "Exercise"{
            circles = exercisecircles
        }
        else if self.subject == "Socialness"{
            circles = socialcircles
        }

        
        for colcircle in circles {
            
            
            // Set a random Circle Radius
            // 2
            var circleWidth = CGFloat(30 + (arc4random() % 50))
            var circleHeight = circleWidth
            
            // Create a new CircleView
            // 3
            var circleView = CircleView(frame: CGRectMake(colcircle.pt.x, colcircle.pt.y, circleWidth, circleHeight), color:colcircle.color, txt:colcircle.text)
            view.addSubview(circleView)
        }
    }
    
    
    func SaveTheDay(story: String) {
        
        let entityDescription =
        NSEntityDescription.entityForName("MyDay",
            inManagedObjectContext: managedObjectContext!)
        
        let day = MyDay(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext)
        var selection = getAtomIndex(story)
        switch self.subject {
        case "Mood": day.mood = selection
        case "Love": day.love = selection
            case "Exercise": day.exercise = selection
            case "Food": day.food = selection
            case "HairDay": day.hair = selection
            case "Socialness": day.socialness = selection
        default: day.mood = selection
        }
        
        day.date = NSDate()
        
        var error: NSError?
        
        managedObjectContext?.save(&error)
        
        if let err = error {
            println(err.localizedFailureReason)
        } else {
            println ("all is saved")
        }

    }
    
}

