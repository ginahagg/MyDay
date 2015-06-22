//
//  LocationDataController.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/18/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreData

class LocationDataController {
    
    var delegate : NSFetchedResultsControllerDelegate?
    
    private var managedObjectContext: NSManagedObjectContext
    private lazy var locationDataController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Location")
        //fetchRequest.relationshipKeyPathsForPrefetching = ["toDo"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "section", cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch _ {
        }
        controller.delegate = self
        
        return controller
        }()
    
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func fetchLocationsBySection(){
        let fetchRequest = NSFetchRequest(entityName: "Location")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let nsC  = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "section", cacheName: nil)
        do {
            try nsC.performFetch()
        } catch _ {
        }
    }
    
    func fetchLocationsByAddr() -> [NSDictionary]{
            /*let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext!)*/
            let fetchRequest = NSFetchRequest(entityName: "Location")
            fetchRequest.sortDescriptors = nil
            fetchRequest.propertiesToGroupBy = ["addr","latitude", "longitude", "date", "info", "pin", "photo"]
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            //fetchRequest.propertiesToFetch = ["latitude", "longitude"]
            //fetchRequest.returnsDistinctResults = true
            let results = self.managedObjectContext.executeFetchRequest(fetchRequest) as! [NSDictionary]
            return results
    }
    
    func updateLocation(waypoint : EditableWaypoint) {
        //let entitydesc = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        //var loc = Location(entity: entitydesc!, insertIntoManagedObjectContext: self.managedObjectContext)
        var error : NSError?
        let loc = self.managedObjectContext.existingObjectWithID(waypoint.storeId! as NSManagedObjectID) as! Location
        loc.info = "\(waypoint.name) : \(waypoint.info)"
        let url = waypoint.imageURL
        if (url != nil){
            let path = url!.path
            loc.photo = path != nil ? path! : ""
        }
        do {
            try self.managedObjectContext.save()
        } catch var error1 as NSError {
            error = error1
        }
    }
    
    func addLocation(waypoint: EditableWaypoint) {
        print("adding location")
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        let loc = Location(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        loc.latitude = waypoint.coordinate.latitude
        loc.longitude = waypoint.coordinate.longitude
        loc.info = "\(waypoint.description) -dropped"
        if (waypoint.addr == ""){
            EditableWaypoint.getAddressForSave(waypoint)
        }
        loc.addr = waypoint.addr
        loc.date = NSDate()
        var error: NSError?
        do {
            try self.managedObjectContext.save()
        } catch var error1 as NSError {
            error = error1
        }
        
        if let err = error {
            print(err.localizedFailureReason)
        } else {
            print ("saved succesfully \(NSDate()),\(loc.longitude),\(loc.latitude)")
            waypoint.storeId = loc.objectID
        }
        
    }

   
}

extension LocationDataController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)  {
        delegate?.controllerWillChangeContent?(controller)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)  {
        
       
            delegate?.controller?(controller, didChangeSection: sectionInfo, atIndex: sectionIndex, forChangeType: type)
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)  {
        
        
        delegate?.controller?(controller, didChangeObject: anObject as! NSManagedObject, atIndexPath: indexPath, forChangeType: type, newIndexPath: newIndexPath)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)  {
        delegate?.controllerDidChangeContent?(controller)
    }
}
