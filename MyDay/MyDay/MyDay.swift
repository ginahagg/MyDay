//
//  MyDay.swift
//  MyDay
//
//  Created by Gina Hagg on 5/25/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import Foundation
import CoreData

class MyDay: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var health: NSNumber
    @NSManaged var mood: NSNumber
    @NSManaged var food: NSNumber
    @NSManaged var love: NSNumber
    @NSManaged var socialness: NSNumber
    @NSManaged var exercise: NSNumber
    @NSManaged var hair: NSNumber

}
