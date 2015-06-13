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

class LocationViewController: UITableViewController,CLLocationManagerDelegate {
    /* colorhexa site colors
#E43451 reddish
    #EB774C orange
    #F4BA44 yellowish
    #C20826 darker red
*/
    let locationManager = CLLocationManager()
    
    struct colorst {
        let Reddish = UIColor(rgba: "#E43451")
        let Yellowish = UIColor(rgba: "#F4BA44")
        let orangish = UIColor(rgba: "#EB774C")
        let pinkish = UIColor(rgba: "#fbe1e5")
        let CELLID = "LocCell"
        let MapSegueId = "ShowMap"
        let firstPink = UIColor(rgba: "#CE6164")
        let secondPink = UIColor(rgba: "#F19B93")
        let thirdPink = UIColor(rgba: "#F5B89C")
        let fourthColor = UIColor(rgba: "#C8C597" )
    }
    
    let colors = colorst()
    
    var isByDate = true
    
    var locDict = NSMutableDictionary()
    var locDictByAddr = NSMutableDictionary()
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    @IBAction func showButton(sender: UIBarButtonItem) {
        isByDate = isByDate ? false : true
        sender.title! = isByDate ? "Show By Address" : "Show By Date"
        tableView.reloadData()
    }
    
    
    @IBAction func SaveLocation(sender: AnyObject) {
        println("savinglocation")
        self.locationManager.startUpdatingLocation()
    }
    
    func addLocation(location : CLLocation) {
        println("adding location")
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
        
        managedObjectContext?.save(&error)
        
        if let err = error {
            println(err.localizedFailureReason)
        } else {
            println ("saved succesfully \(NSDate()),\(location.coordinate.longitude),\(location.coordinate.latitude)")
        }
        
        if(isByDate){
            populateByDate(loc)
        }
        else{
            populateByAddr(loc)
        }
        self.tableView.reloadData()
    }
    
    func getAddressForSave(lng:CLLocationDegrees, lat:CLLocationDegrees, loc : Location){
        //var longitude :CLLocationDegrees = -122.0312186
        //var latitude :CLLocationDegrees = 37.33233141
        
        var location = CLLocation(latitude: lat, longitude: lng) //changed!!!
        //println(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //println(location)
            
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                var pms = "\(pm.thoroughfare) \(pm.subLocality), \(pm.locality)"
                loc.addr = pms
                
            }
            else {
                loc.addr = "unknown location"
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("old:\(oldLocation.description), new:\(newLocation.description)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error.description)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locationManager.location{
            locationManager.stopUpdatingLocation()
            println("locationViewController: lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
            addLocation(location)
        }
    }
    
    override func viewDidLoad() {
        /*var title = self.navigationItem.title
        self.navigationItem.title = nil
        self.navigationItem.title = "Show Locations by Address"*/
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        fetchLocationsByCriteria("Date")
        println("viewdidload: isByDate: \(isByDate)")
        
    }
    
    func fetchLocationsByCriteria(crit : String){
            let fetchRequest = NSFetchRequest(entityName: "Location")
            var locs = [Location]()

            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Location]
            {
                var locations = fetchResults
                locations.sort({$0.date.timeIntervalSinceNow < $1.date.timeIntervalSinceNow})
                var locs = NSMutableArray()
                var ct = 0
                for loc in locations {
                    var dt = loc.date
                    populateByDate(loc)
                    populateByAddr(loc)                    
                }

            }
            else {
                println("no records")
            }
    }
    
    func populateByAddr(loc: Location){
        var locs = NSMutableArray()
        var addr = loc.addr
         var dt = loc.date
        var keys = locDictByAddr.allKeys as! [String]
        /*let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        var date = formatter.stringFromDate(dt)*/
        
        if find(keys, addr) == nil{
            locs = NSMutableArray()
        }
        else{
            locs = locDictByAddr.valueForKey(addr) as! NSMutableArray
        }
        var index = locs.count > 0 ? locs.count : 0
        locs.insertObject(loc, atIndex: index)
        locDictByAddr[addr] = locs

    }
    
    func populateByDate(loc: Location) -> (index: Int, section: String , exists: Bool){
        var dt = loc.date
        var locs = NSMutableArray()
        var keys = locDict.allKeys as! [String]
        var isNewSection = false
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        var date = formatter.stringFromDate(dt)
        if find(keys, date) == nil{
            locs = NSMutableArray()
        }
        else{
            locs = locDict.valueForKey(date) as! NSMutableArray
            isNewSection = true
        }
        var index = locs.count > 0 ? locs.count : 0
        locs.insertObject(loc, atIndex: index)
        locDict[date] = locs
        return(index,date, isNewSection)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         println("numsections: isByDate: \(isByDate)")
        if(isByDate){
            return self.locDict.count
        }
        else{
            return self.locDictByAddr.count
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         println("viewforheader: isByDate: \(isByDate)")
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! GroupCell
        var keys = NSArray()
        if(isByDate){
            keys = locDict.allKeys
        }
        else{
            keys = locDictByAddr.allKeys
        }
        
        var key = keys[section] as! String
    
        headerCell.backgroundColor = colors.fourthColor

        //headerCell.textLabel?.textColor = colors.Yellowish
        headerCell.textLabel!.text = key
        return headerCell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         println("numrowsinsection: isByDate: \(isByDate)")
        var locations = []
        var keys = NSArray()
        var key = ""
        if(isByDate){
            keys = locDict.allKeys
            key = keys[section] as! String
            locations = locDict.valueForKey(key) as! [Location]
        }
        else{
            keys = locDictByAddr.allKeys
            key = keys[section] as! String
            locations = locDictByAddr.valueForKey(key) as! [Location]

        }
        return locations.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == colors.MapSegueId {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var cell = self.tableView.cellForRowAtIndexPath(indexPath)
                let controller = segue.destinationViewController as! ViewController
                controller.navigationItem.title = "\(cell!.textLabel!.text!):\(cell!.detailTextLabel!.text!)"
                //controller.rownum = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         println("cellforrowatindex: isByDate: \(isByDate)")
        var corners : UIRectCorner = UIRectCorner(0)
        tableView.layer.cornerRadius = 10
        if (tableView.style == UITableViewStyle.Grouped) {
          
            if (tableView.numberOfRowsInSection(indexPath.section) == 1){
                corners = UIRectCorner.AllCorners
            } else if (indexPath.row == 0) {
                corners = UIRectCorner.TopLeft | UIRectCorner.TopRight;
            } else if (indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1) {
                corners = UIRectCorner.BottomLeft | UIRectCorner.BottomRight;
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("LocCell") as! UITableViewCell
       
        //cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = colors.firstPink.CGColor
        cell.backgroundColor = colors.secondPink
        let sect = indexPath.section
        var keys = NSArray()
        var locations = NSMutableArray()
        var key = ""
        var location : Location
        if (isByDate){
            keys = locDict.allKeys
            key = keys[sect] as! String
            locations = locDict[key] as! NSMutableArray
            location = locations[indexPath.row] as! Location
        }
        else{
            keys = locDictByAddr.allKeys
            key = keys[sect] as! String
            locations = locDictByAddr[key] as! NSMutableArray
            location = locations[indexPath.row] as! Location
        }
        
        //let lat = CLLocationDegrees(location.latitude)
        //let lng = CLLocationDegrees(location.longitude)
        let dt = location.date
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .NoStyle
        var date = ""
        //println(date)
        //getAddressForUI(lng, lat: lat, cell: cell)
        if isByDate {
            formatter.dateStyle = .NoStyle
            date = formatter.stringFromDate(dt)
            cell.textLabel!.text = date
            cell.detailTextLabel!.text = location.addr
        }
        else{
            formatter.dateStyle = .NoStyle
            date = formatter.stringFromDate((dt))
            cell.textLabel!.text = location.addr
            cell.detailTextLabel!.text = date
        }
        
        return cell
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
        println("I have been unwound from \(segue.sourceViewController)")
        if let sourceController = segue.sourceViewController as? ViewController{
            println("good")
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
