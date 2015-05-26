//
//  SelectionTableViewController.swift
//  MyDay
//
//  Created by Gina Hagg on 5/13/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController {
    private var selCell:SelectionViewCell?
    private var detailViewController: StoryDetailViewController? = nil
    private let stories = ["Mood","HairDay","Health","Love","Food","Exercise","Socialness"]
    
    private struct Constants{
        static let ShowStatsSegue = "showStats"
        static let ShowDetailSegue = "showDetail"
    }
    
    override func viewDidAppear(animated: Bool) {
        let dt = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        var date = formatter.stringFromDate(dt)
        self.title = "My Day today \(date)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SelectionViewCell = (tableView.dequeueReusableCellWithIdentifier("selCell", forIndexPath:indexPath) as! SelectionViewCell)
        cell.selectionTitle.text = stories[indexPath.row]
        cell.selectionSubTitle.text = "What is yours today?"
        return cell

    }
    
    @IBAction func showDayStats(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Constants.ShowStatsSegue, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ShowDetailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var cell = self.tableView.cellForRowAtIndexPath(indexPath) as? SelectionViewCell
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! StoryDetailViewController
                controller.subject = cell!.selectionTitle.text!
                controller.rownum = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func goback (segue: UIStoryboardSegue){
        println("I have been unwound from \(segue.sourceViewController)")
        if let sourceController = segue.sourceViewController as? StoryDetailViewController{
            if !sourceController.subject.isEmpty{
                let selectedMood = sourceController.selected
                var rownum = sourceController.rownum
                var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rownum, inSection: 0)) as! SelectionViewCell
            
            cell.selectionTitle.text = "\(selectedMood!.text!)."
            cell.selectionSubTitle.text = "\(selectedMood!.text!) today"
            cell.backgroundColor = selectedMood!.color
            }
        }
        
    }
    

}
