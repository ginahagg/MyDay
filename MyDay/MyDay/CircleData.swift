//
//  CircleData.swift
//  MyDay
//
//  Created by Gina Hagg on 5/14/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import Foundation
import UIKit


struct selectedMood{
    var text:String?
    var color:UIColor?
}

enum StoryIndex: Int {
    case Mood = 0, HairDay, Health, Love, Food, Exercise, Socialness
}


enum MoodIndex: Int{
    case so = 0,blues,sad,pms,love,happy,angry,spiritual,emptiness,joyous,helpless,hopeless,depressed,hell
    
    func toString() -> String{
        
        switch self{
        case .so: return "so"
        case .blues: return "blues"
        case .sad: return "sad"
        case .pms: return "pms"
        case .love: return "love"
        case .happy: return "happy"
        case .angry: return "angry"
        case .spiritual: return "spiritual"
        case .emptiness: return "emptiness"
        case .joyous: return "joyous"
        case .helpless: return "helpless"
        case .hopeless: return "hopeless"
        case .depressed: return "depressed"
        case .helpless: return "hell"
        default: return "so-so"
        }
    }
}

enum HairDayIndex: Int {
    case lovely = 0, managable, bad, frizzy, horrible
}

enum ExerciseIndex: Int {
    case gym = 0, yoga, pilates, walk, dance, hike, stretching,couch_potato
}

enum SocialnessIndex: Int{
    case alone=1, online_chat, with_friends, with_family, with_my_love, with_date
}

enum LoveIndex: Int{
    case in_love = 0, interested, just_met, dating, have_feelings, no_love
}

func getAtomIndex(sel: String) -> Int{
    switch sel{
    case "so-so": return MoodIndex.so.rawValue
        
    case "blues": return MoodIndex.blues.rawValue
    case "sad", "alone":
        return MoodIndex.sad.rawValue
    case "pms":
        return MoodIndex.pms.rawValue
    case "love", "stretching":
        return MoodIndex.love.rawValue
    case "happy", "have_feelings", "hike":
        return MoodIndex.happy.rawValue
    case "angry", "just_met", "gym":
        return MoodIndex.angry.rawValue
    case "spiritual", "dating", "walk", "managable":
        return MoodIndex.spiritual.rawValue
    case "emptiness", "couch_potato", "frizzy":
        return MoodIndex.emptiness.rawValue
    case "joyous", "in_love", "with_my_love", "lovely", "dance":
        return MoodIndex.joyous.rawValue
    case "helpless":
        return MoodIndex.helpless.rawValue
    case "hopeless":
        return MoodIndex.hopeless.rawValue
    case "depressed", "no_love":
        return MoodIndex.depressed.rawValue
    case "hell":
        return MoodIndex.hell.rawValue
    default: return MoodIndex.so.rawValue
        
    }
    
}


struct CircleItem{
    enum CircleColor{
        case so
        case blues
        case sad, alone
        case pms
        case love,stretching
        case happy, have_feelings, hike
        case angry, just_met, gym
        case spiritual, dating, walk, managable
        case emptiness, couch_potato, frizzy
        case joyous, in_love, with_my_love, lovely, dance
        case helpless
        case hopeless
        case depressed, no_love
        case hell
        
            func toColor()-> UIColor{
                switch self{
                case .so:
                    return UIColor(red: 180/255, green: 216/255, blue: 231/255, alpha: 1)
                case .blues:
                    return UIColor(red: 174/255, green: 174/255, blue: 255/255, alpha: 1)
                case .sad, .alone:
                    return UIColor(red: 180/255, green: 216/255, blue: 231/255, alpha: 1)
                case .pms:
                    return UIColor(red: 255/255, green: 236/255, blue: 148/255, alpha: 1)
                case .love, .stretching:
                    return UIColor(red: 255/255, green: 174/255, blue: 174/255, alpha: 1)
                case .happy, .have_feelings, .hike:
                    return UIColor(red: 255/255, green: 98/255, blue: 98/255, alpha: 1)
                case .angry, .just_met, .gym:
                    return UIColor(red: 255/255, green: 47/255, blue: 47/255, alpha: 1)
                case .spiritual, .dating, .walk, .managable:
                    return UIColor(red: 190/255, green: 123/255, blue: 255/255, alpha: 1)
                case .emptiness, .couch_potato, .frizzy:
                    return UIColor.whiteColor()
                case .joyous, .in_love, .with_my_love, .lovely, .dance:
                    return UIColor.orangeColor()
                case .helpless:
                    return UIColor.grayColor()
                case .hopeless:
                    return UIColor.greenColor()
                case .depressed, .no_love:
                    return UIColor.blueColor()
                case .hell:
                    return UIColor.blackColor()
                default: return UIColor.magentaColor()
                    
                }
        
            }
        
        
        
    }
    
    
    enum CircleCategory{
        case Mood
        case Hair
        case Color
        case Food
        case Health
        case Work
        case Weather
        case Exercise
        case Love
        case Angry
        case Socialness
        case Joke
        case Word
        case InLove
        
        func toString()->String{
            switch self{
            case .Mood:
                return "My Mood"
            case .Hair:
                return "My Hairday"
            case .Color:
                return "Color of my Day"
            case .Health:
                return "My Health"
            case .Food:
                return "What did I eat?"
            case .Work:
                return "At work day"
            case .Weather:
                return "Weather today"
            case .Exercise:
                return "Exercise"
            case .Love:
                return "My lovelife"
            case .Angry:
                return "Angry At"
            case .Joke:
                return "Joke of Day"
            case .Word:
                return "Word of the Day"
            case .Socialness:
                return "Socialness"
            case .InLove:
                return "In Love or Not"
                
            }
        }
        
    }
    let category: CircleCategory
    let circleColor: CircleColor
    let summary: String

}

