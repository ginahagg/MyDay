//
//  GPXViewController.swift
//  Trax
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate
{
    // MARK: - Outlets

    var wayPoints = NSArray()
    
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
        if mapView?.annotations != nil { mapView.removeAnnotations(mapView.annotations as! [MKAnnotation]) }
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) {
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
    private func addWayPoints(){
        
        if (self.wayPoints.count > 0){
            var last1: AnyObject? = wayPoints.lastObject
            if let last = last1 as? Location {
                self.centerCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(last.latitude), CLLocationDegrees(last.longitude))
            }
            for (locc)  in self.wayPoints{
                if let loc = locc[0] as? Location {
                    println("\(loc.addr),\(loc.date)")
                    let waypoint = EditableWaypoint(latitude: loc.latitude as Double, longitude: loc.longitude
                        as Double)
                    waypoint.name = loc.addr
                    mapView.addAnnotation(waypoint)
                }
            }
        }
    }
    
    @IBAction func addWaypoint(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            println("i recognize press")
            let coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            let waypoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            waypoint.name = "Dropped"
            mapView.addAnnotation(waypoint)
            //saveWaypoint(waypoint)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        view.draggable = annotation is EditableWaypoint
        
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
            if annotation is EditableWaypoint {
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
        }
        
        return view
    }
    
    // this had to be adjusted slightly when we added editable waypoints
    // we can no longer depend on the thumbnailURL being set at "annotation view creation time"
    // so here we just check to see if there's a thumbnail URL
    // and, if so, we can lazily create the leftCalloutAccessoryView if needed
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
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
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("GPXViewController entered")
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
            return navcon.visibleViewController
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