//
//  Location.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/17/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var addr: String
    @NSManaged var date: NSDate
    @NSManaged var info: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var photo: String
    @NSManaged var pin: String
    @NSManaged var section: String

}

