//
//  GPXViewController.swift
//  Trax
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class GPXViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate, NSFetchedResultsControllerDelegate
{
    // MARK: - Outlets
    
    
    var wayPoints = NSMutableArray()
    var storedWayPoints = [Location]()
    
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
        if(centerCoordinate != nil){
            self.mapView.setRegion(MKCoordinateRegionMake(centerCoordinate!, span), animated: animated)
        }
    }
    
    
    // MARK: - CoreData
    
    var fetchedResultsController = NSFetchedResultsController()
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    private lazy var locationDataController: LocationDataController = {
        
        let controller = LocationDataController(managedObjectContext: self.managedObjectContext!)
        controller.delegate = self
        
        return controller
    }()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            //mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    // MARK: - Public API
    
    var gpxURL: NSURL? {
        didSet {
            clearWaypoints()
            if let url = gpxURL {
                GPX.parse(url) {
                    if let gpx = $0 {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }
    

    // MARK: - Waypoints
    
    private func clearWaypoints() {
        if mapView?.annotations != nil { mapView.removeAnnotations(mapView.annotations as [MKAnnotation]) }
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) {
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        let waypoint = annotation as? GPX.Waypoint
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let title = waypoint!.description
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: waypoint, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let rightButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
            pinView!.rightCalloutAccessoryView = rightButton
            
            if (!title.isEmpty && (title.rangeOfString("dropped") != nil)) {
                pinView!.pinColor = .Purple
            }
            else{
                pinView!.pinColor = .Green
            }
        }
        else {
            if (!title.isEmpty && (title.rangeOfString("dropped") != nil)) {
                pinView!.pinColor = .Purple
            }
            pinView!.annotation = waypoint
        }
        
        return pinView
    }
    
    private func addWayPoints(){
        if (self.storedWayPoints.count > 0){
            for (loc)  in storedWayPoints{
                let waypoint = EditableWaypoint(latitude: Double(loc.latitude), longitude: Double(loc.longitude))
                waypoint.storeId = loc.objectID
                waypoint.name = loc.addr
                waypoint.info = "\(loc.date)"
                self.wayPoints.addObject(waypoint)
                /*var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
                if pinView == nil {
                    pinView = MKPinAnnotationView(annotation: waypoint, reuseIdentifier: "pin")
                    pinView!.canShowCallout = true
                    pinView!.animatesDrop = true
                    pinView!.pinColor = .Purple
                }
                else {
                    pinView!.pinColor = MKPinAnnotationColor.Green
                    pinView!.annotation = waypoint
                }*/
               // let waypoint = wp as! EditableWaypoint
                mapView.addAnnotation(waypoint)
            }
        }
        
    }
    
    @IBAction func addWaypoint(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            print("i recognize press")
            let coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            let waypoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            EditableWaypoint.getAddressForSave(waypoint)
            waypoint.name = "dropped - \(waypoint.addr)"
            waypoint.info = "\(NSDate())"
            mapView.addAnnotation(waypoint)
            self.wayPoints.addObject(waypoint)
            locationDataController.addLocation(waypoint)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // this had to be adjusted slightly when we added editable waypoints
    // we can no longer depend on the thumbnailURL being set at "annotation view creation time"
    // so here we just check to see if there's a thumbnail URL
    // and, if so, we can lazily create the leftCalloutAccessoryView if needed
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let waypoint = view.annotation as? GPX.Waypoint {
            if let url = waypoint.thumbnailURL {
                if view.leftCalloutAccessoryView == nil {
                    // a thumbnail must have been added since the annotation view was created
                    view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
                }
                if let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton {
                    if let imageData = NSData(contentsOfURL: url) { // blocks main thread!
                        if let image = UIImage(data: imageData) {
                            thumbnailImageButton.setImage(image, forState: .Normal)
                        }
                    }
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegueWithIdentifier(Constants.EditWaypointSegue, sender: view)
        } else if let waypoint = view.annotation as? GPX.Waypoint {
            if waypoint.imageURL != nil {
                performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ShowImageSegue {
            if let waypoint = (sender as? MKAnnotationView)?.annotation as? GPX.Waypoint {
                if let wivc = segue.destinationViewController.contentViewController as? WaypointImageViewController {
                    wivc.waypoint = waypoint
                } else if let ivc = segue.destinationViewController.contentViewController as? ImageViewController {
                    ivc.imageURL = waypoint.imageURL
                    ivc.title = waypoint.name
                }
            }
        } else if segue.identifier == Constants.EditWaypointSegue {
            if let waypoint = (sender as? MKAnnotationView)?.annotation as? EditableWaypoint {
                if let ewvc = segue.destinationViewController.contentViewController as? EditWaypointViewController {
                    if let ppc = ewvc.popoverPresentationController {
                        let coordinatePoint = mapView.convertCoordinate(waypoint.coordinate, toPointToView: mapView)
                        ppc.sourceRect = (sender as! MKAnnotationView).popoverSourceRectForCoordinatePoint(coordinatePoint)
                        let minimumSize = ewvc.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                        ewvc.preferredContentSize = CGSize(width: Constants.EditWaypointPopoverWidth, height: minimumSize.height)
                        ppc.delegate = self
                    }
                    ewvc.waypointToEdit = waypoint
                }
            }
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen // full screen, but we can see what's underneath
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?
    {
        let navcon = UINavigationController(rootViewController: controller.presentedViewController)
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        visualEffectView.frame = navcon.view.bounds
        navcon.view.insertSubview(visualEffectView, atIndex: 0) // "back-most" subview
        return navcon
    }

    // MARK: - View Controller Lifecycle
    
    func fetchLocations(){
        /*let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext!)*/
        let fetchRequest = NSFetchRequest(entityName: "Location")
        fetchRequest.sortDescriptors = nil
        fetchRequest.propertiesToGroupBy = ["addr","latitude", "longitude", "date", "info", "pin", "photo"]
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        //fetchRequest.propertiesToFetch = ["latitude", "longitude"]
        //fetchRequest.returnsDistinctResults = true
        let results = self.managedObjectContext?.executeFetchRequest(fetchRequest) as! [NSDictionary]
        if (results.count>0){
            for res in results{
                let addr = res.valueForKey("addr") as! String
                let lat = res.valueForKey("latitude") as! Double
                let lng = res.valueForKey("longitude") as! Double
                let pin = res.valueForKey("pin") as! String
                let waypoint = EditableWaypoint(latitude: lat, longitude: lng)
                waypoint.name = addr
                self.wayPoints.addObject(waypoint)
            }
        }
        
    }
    
    func buildWayPoints(results: [NSDictionary]){
        if (results.count>0){
            for res in results{
                let addr = res.valueForKey("addr") as! String
                let lat = res.valueForKey("latitude") as! Double
                let lng = res.valueForKey("longitude") as! Double
                let pin = res.valueForKey("pin") as! String
                let waypoint = EditableWaypoint(latitude: lat, longitude: lng)
                waypoint.name = addr
                self.wayPoints.addObject(waypoint)
            }
        }

    }
    
    override func viewDidLoad() {
        print("gpxviewcontroller viewdidload")
        super.viewDidLoad()
        self.fetchedResultsController.delegate = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        let results = locationDataController.fetchLocationsByAddr()
        buildWayPoints(results)
        addWayPoints()
        //self.centerCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(centerLat), CLLocationDegrees(centerLng))
        self.zoomLevel = 10
        // sign up to hear about GPX files arriving
        // we never remove this observer, so we will never leave the heap
        // might make some sense to think about when to remove this observer
        
       /* let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate

        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue)  { notification in
            if let url = notification?.userInfo?[GPXURL.Key] as? NSURL {
                self.gpxURL = url
            }
        }*/
    }

    // MARK: - Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "Show Image"
        static let EditWaypointSegue = "Edit Waypoint"
        static let EditWaypointPopoverWidth: CGFloat = 320
    }
}

// MARK: - Convenience Extensions

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}

extension MKAnnotationView {
    func popoverSourceRectForCoordinatePoint(coordinatePoint: CGPoint) -> CGRect {
        var popoverSourceRectCenter = coordinatePoint
        popoverSourceRectCenter.x -= frame.width / 2 - centerOffset.x - calloutOffset.x
        popoverSourceRectCenter.y -= frame.height / 2 - centerOffset.y - calloutOffset.y
        return CGRect(origin: popoverSourceRectCenter, size: frame.size)
    }
}
