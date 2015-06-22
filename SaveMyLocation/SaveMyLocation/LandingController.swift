//
//  LandingController.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/13/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LandingController: UIViewController, CLLocationManagerDelegate {
    
    struct Constants{
        static let ShowEditSegue = "ShowEdit"
        static let ShowMapSegue = "ShowMap"
    }

    @IBAction func SaveLocation(sender: UIButton) {
        print("save location is called")
        self.locationManager.startUpdatingLocation()
    }
    
    let locationManager = CLLocationManager()
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
    }

    
    func addLocation(location : CLLocation) {
        print("adding location")
        let entityDescription =
        NSEntityDescription.entityForName("Location",
            inManagedObjectContext: managedObjectContext!)
        
        //SO STUPID! coredata model for lat/lng is double, but i need NSNumber wrapping because declaring lat/lng as double
        //in Location model class fails. i need to declare them as NSNumber. Thus the wrapping..IDIOTs
        
        let loc = Location(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        loc.date = NSDate()
        loc.longitude = NSNumber(double: lng)
        loc.latitude = NSNumber(double: lat)
        getAddressForSave(lng, lat: lat, loc: loc)
        var error: NSError?
        
        do {
            try managedObjectContext?.save()
        } catch var error1 as NSError {
            error = error1
        }
                
        if let err = error {
            print(err.localizedFailureReason)
        } else {
            print ("saved succesfully \(NSDate()),\(location.coordinate.longitude),\(location.coordinate.latitude)")
            let alertController = UIAlertController(title: "Location saved.", message: "on \(NSDate())", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (_) in }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                print("showed Alert")
            }
        }
        
        
        
    }
    
    func getAddressForSave(lng:CLLocationDegrees, lat:CLLocationDegrees, loc : Location){
        //var longitude :CLLocationDegrees = -122.0312186
        //var latitude :CLLocationDegrees = 37.33233141
        
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
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        print("old:\(oldLocation.description), new:\(newLocation.description)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        if let location = locationManager.location{
            locationManager.stopUpdatingLocation()
            print("locationViewController: lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
            addLocation(location)
        }
    }
    
}
