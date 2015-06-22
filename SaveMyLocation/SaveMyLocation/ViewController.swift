//
//  ViewController.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 5/29/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    //@IBOutlet var locationLbl: UILabel!
    
    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.mapView.frame.size.width/256) / self.mapView.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel){
            setCenterCoordinate(self.mapView.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }
    
    var centerCoordinate : CLLocationCoordinate2D?
    
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool){
        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.mapView.frame.size.width) / 256)
        self.mapView.setRegion(MKCoordinateRegionMake(centerCoordinate!, span), animated: animated)
    }
    
    @IBAction func getLocation(sender: AnyObject) {
         self.locationManager.startUpdatingLocation()
    }    
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mapView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = self.navigationItem.title!
        self.navigationItem.title = nil
        self.navigationItem.title = title
        self.title = title
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        var centerLat : NSNumber = 37.33233141
        var centerLng : NSNumber = -122.0312186
        let fetchRequest = NSFetchRequest(entityName: "Location")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest) as? [Location] {
            var results = fetchResults
            results.sortInPlace({$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
            
            if (results.count > 0){
               let last = results.last!
                centerLat = last.latitude
                centerLng = last.longitude
            }
            print("\(fetchResults.count) records\n")
            for rec in results{
                //var moodInt:Int = rec.mood as Int
                let Dt : NSDate = rec.date
                let formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .MediumStyle
                var date = formatter.stringFromDate(Dt)
                print("location: \(rec.addr),\(rec.latitude), \(rec.longitude)")
                //println("lat: \(date) for \(rec.latitude), \(rec.longitude)")
                addAnnotation(CLLocationDegrees(rec.latitude), lng: CLLocationDegrees(rec.longitude))
            }
            
        }
        else {
            print("no records")
        }
        self.centerCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(centerLat), CLLocationDegrees(centerLng))
        self.zoomLevel = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        if let location = locationManager.location{
            locationManager.stopUpdatingLocation()
            print("lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
            self.title = "Location saved May 29, 2015"
            addAnnotation(location.coordinate.latitude, lng: location.coordinate.longitude)
            saveLocation(location)
        }
    }
    
    func addAnnotation(lat : CLLocationDegrees, lng : CLLocationDegrees){
        let latDelta : CLLocationDegrees = 0.1
        let lngDelta : CLLocationDegrees = 0.1
        let loc = CLLocationCoordinate2DMake(lat, lng)
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        let region = MKCoordinateRegionMake(loc, span)
        self.mapView.setRegion(region, animated: true)
        let locPt = MKPointAnnotation()
        locPt.coordinate = loc
        locPt.title = "You set this location"
        locPt.subtitle = "\(NSDate())"
        self.mapView.addAnnotation(locPt)
    }
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "Show Image"
        static let EditWaypointSegue = "Edit Waypoint"
        static let EditWaypointPopoverWidth: CGFloat = 320
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
        }
        else {
            pinView!.annotation = annotation
        }
        pinView?.pinColor = MKPinAnnotationColor.Purple
        pinView!.canShowCallout = true

        pinView!.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
        
        pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        
        return pinView
    }
    
    func saveLocation(location : CLLocation) {
        
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
    
    


}

