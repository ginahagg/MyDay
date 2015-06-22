//
//  LocationManagedObject.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/10/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class LocationManagedObject : NSManagedObject {
    
    
    
    static func saveLocation(location : CLLocation, managedObjectContext : NSManagedObjectContext) {
        
        let entityDescription =
        NSEntityDescription.entityForName("Location",
            inManagedObjectContext: managedObjectContext)
        
        
        
        //SO STUPID! coredata model for lat/lng is double, but i need NSNumber wrapping because declaring lat/lng as double
        //in Location model class fails. i need to declare them as NSNumber. Thus the wrapping..IDIOTs
        
        let loc = Location(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        
        var location = CLLocation(latitude: lat, longitude: lng) //changed!!!
        //println(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //println(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                var pms = "\(pm.thoroughfare) \(pm.subLocality), \(pm.locality)"
                loc.addr = pms
                
            }
            else {
                loc.addr = "unknown location"
                print("Problem with the data received from geocoder")
            }
        })

        
        loc.date = NSDate()
        loc.longitude = NSNumber(double: lng)
        loc.latitude = NSNumber(double: lat)
        
        var error: NSError?
        
        do {
            try managedObjectContext.save()
        } catch var error1 as NSError {
            error = error1
        }
        
        if let err = error {
            print(err.localizedFailureReason)
        } else {
            print ("saved succesfully \(NSDate()),\(location.coordinate.longitude),\(location.coordinate.latitude)")
        }
        
    }
    
    
}
