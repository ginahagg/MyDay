//
//  MKGPX.swift
//  Trax
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import MapKit
import CoreData

class EditableWaypoint: GPX.Waypoint
{
    // make coordinate get & set (for draggable annotations)
    override var coordinate: CLLocationCoordinate2D {
        get { return super.coordinate }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    override var thumbnailURL: NSURL? { return imageURL }
    override var imageURL: NSURL? { return links.first?.url }
    
    var storeId: NSManagedObjectID?
    
    var addr: String = ""
    
    static func getAddressForSave(waypoint: EditableWaypoint){
        //var longitude :CLLocationDegrees = -122.0312186
        //var latitude :CLLocationDegrees = 37.33233141
        
        let location = CLLocation(latitude: waypoint.coordinate.latitude, longitude: waypoint.coordinate.longitude) //changed!!!
        //println(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //println(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                let pms = "\(pm.thoroughfare) \(pm.subLocality), \(pm.locality)"
                waypoint.addr = pms
                
            }
            else {
                waypoint.addr = "unknown location"
                print("Problem with the data received from geocoder")
            }
        })
    }


}

extension GPX.Waypoint: MKAnnotation
{
    // MARK: - MKAnnotation

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? { return name }
    
    var subtitle: String? { return info }
    
    
    // MARK: - Links to Images

    var thumbnailURL: NSURL? { return getImageURLofType("thumbnail") }
    var imageURL: NSURL? { return getImageURLofType("large") }
    
    private func getImageURLofType(type: String) -> NSURL? {
        for link in links {
            if link.type == type {
                return link.url
            }
        }
        return nil
    }
    
    
}
