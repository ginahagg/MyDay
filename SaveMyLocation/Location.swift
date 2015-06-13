//
//  Location.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 5/29/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var addr: String
    @NSManaged var date: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var info: String
    @NSManaged var photo: String
    @NSManaged var pin: String
    

}
