//
//  LocationViewController.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/8/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationViewController: UITableViewController,CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate {
    /* colorhexa site colors
#E43451 reddish
    #EB774C orange
    #F4BA44 yellowish
    #C20826 darker red
*/
    var fetchedResultsController = NSFetchedResultsController()
    
    private lazy var locationDataController: LocationDataController = {
        
        let controller = LocationDataController(managedObjectContext: self.managedObjectContext)
        //controller.delegate = self
        
        return controller
        }()

    let locationManager = CLLocationManager()
    
    struct colorst {
        let Reddish = UIColor(rgba: "#E43451")
        let Yellowish = UIColor(rgba: "#F4BA44")
        let orangish = UIColor(rgba: "#EB774C")
        let pinkish = UIColor(rgba: "#fbe1e5")
        let CELLID = "LocCell"
        let firstPink = UIColor(rgba: "#CE6164")
        let secondPink = UIColor(rgba: "#F19B93")
        let thirdPink = UIColor(rgba: "#F5B89C")
        let fourthColor = UIColor(rgba: "#C8C597" )
    }
    
    let colors = colorst()
    
    var isByDate = true
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    @IBOutlet var UtilView: UIView!
    
    
    @IBAction func ToggleList(sender: UIBarButtonItem) {
        isByDate = isByDate ? false : true
        tableView.reloadData()

    }
    
    
    @IBAction func SaveLoc(sender: UIButton) {
        print("savinglocation")
        self.locationManager.startUpdatingLocation()
    }
    
   
    
    func addLocation(location : CLLocation) {
        print("adding location")
        let entityDescription =
        NSEntityDescription.entityForName("Location",
            inManagedObjectContext: managedObjectContext)
        let loc = Location(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        loc.date = NSDate()
        loc.longitude = NSNumber(double: lng)
        loc.latitude = NSNumber(double: lat)
        getAddressForSave(lng, lat: lat, loc: loc)
        var error: NSError?
        
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
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
        
        let location = CLLocation(latitude: lat, longitude: lng) //changed!!!
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
                loc.addr = pms
                
            }
            else {
                loc.addr = "unknown location"
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
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
    
    override func viewDidLoad() {
        /*var title = self.navigationItem.title
        self.navigationItem.title = nil
        self.navigationItem.title = "Show Locations by Address"
        let backbutton = UIBarButtonItem()
        backbutton.title = "Back"
        self.navigationItem.setLeftBarButtonItem(backbutton, animated: true)
        let barbutton = UIBarButtonItem()
        barbutton.title = "Toggle"
        self.navigationItem.setRightBarButtonItem(barbutton, animated: true)*/
        splitViewController?.delegate = self
        self.fetchedResultsController.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.tableView.layer.zPosition++
        //locationDataController.fetchLocationsBySection()
        fetchLocations()
        print("viewdidload: isByDate: \(isByDate)")
        
    }
    
    func fetchLocations(){
        let fetchRequest = NSFetchRequest(entityName: "Location")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "section", cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo = fetchedResultsController.sections as [NSFetchedResultsSectionInfo]?
        return sectionInfo![section].name
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMap" {
            print("showing map")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destinationViewController as! GPXViewController
                //controller.navigationItem.title = "\(cell!.textLabel!.text!):\(cell!.detailTextLabel!.text!)"
                //controller.rownum = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                print("allVals:")
                let allVals = fetchedResultsController.fetchedObjects as! [Location]
                controller.storedWayPoints = allVals
                let secInfo = fetchedResultsController.sections?[indexPath.section] as NSFetchedResultsSectionInfo?
                //let row = secInfo[indexPath.section] as NSFetchedResultsSectionInfo
                let locs = secInfo!.objects as! [Location]
                let loc = locs[indexPath.row]
                controller.centerCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(loc.latitude), CLLocationDegrees(loc.longitude))
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocCell") as UITableViewCell?
        cell!.layer.borderWidth = 0.5
        cell!.layer.borderColor = colors.firstPink.CGColor
        cell!.backgroundColor = colors.secondPink
        let loc = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Location
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .NoStyle
        cell!.textLabel!.text = formatter.stringFromDate(loc.date)
        cell!.detailTextLabel!.text = loc.addr
        return cell!
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            break
        case NSFetchedResultsChangeType.Update:
            break
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        }
        
        switch editingStyle {
        case .Delete:
            managedObjectContext.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as! Location)
            do {
                try managedObjectContext.save()
            } catch _ {
            }
        case .Insert:
            break
        case .None:
            break
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Update:
            tableView.cellForRowAtIndexPath(indexPath!)
            break
        }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    
    
   /* override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.lightGrayColor()
        
        return footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }*/
    
    
    
    @IBAction func goback (segue: UIStoryboardSegue){
        print("I have been unwound from \(segue.sourceViewController)")
        if let _ = segue.sourceViewController as? GPXViewController{
            print("good")
            /*if !sourceController.subject.isEmpty{
                let selectedMood = sourceController.selected
                var rownum = sourceController.rownum
                var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rownum, inSection: 0)) as! SelectionViewCell
                
                cell.selectionTitle.text = "\(selectedMood!.text!)."
                cell.selectionSubTitle.text = "My \(selectedMood!.subject!) today"
                cell.backgroundColor = selectedMood!.color
            }*/
        }
        
    }
    

}
