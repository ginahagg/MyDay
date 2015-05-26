//
//  DayStatsViewController.swift
//  MyDay
//
//  Created by Gina Hagg on 5/25/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreData
import CorePlot

class DayStatsViewController: UIViewController, CPTPlotDataSource {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - Outlets

    @IBOutlet weak var yearsSlider: UISlider!
    
    @IBOutlet weak var monthSlider: UISlider!
    
    
    @IBOutlet weak var daySlider: UISlider!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var yearLable: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var graphView: UIView!
    
    
    // MARK: - Actions

    @IBAction func yearSlider(sender: UISlider) {
        var currentValue = Int(sender.value)
        yearLable.text = "\(currentValue) Year"
    }
    
    @IBAction func monthSlider(sender: UISlider) {
        var currentValue = Int(sender.value)
        monthLabel.text = "\(currentValue) Month"
    }    
    
    @IBAction func daySlider(sender: UISlider) {
        var currentValue = Int(sender.value)
        dayLabel.text = "\(currentValue) Day"
    }
    
    private struct Constants {
        static let MyDayEntity = "MyDay"
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: Constants.MyDayEntity)
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MyDay] {
            println("\(fetchResults.count) records")
            for rec in fetchResults{
                var moodInt:Int = rec.mood as Int
                if let mood = MoodIndex(rawValue: moodInt){
                    println("Mood on \(rec.date) is \(mood.toString())")
                }
                else{
                    println("nil value on \(moodInt)")
                }
            }

        }
        createGraph()
        
    }
    
    func createGraph(){
        var graph = CPTXYGraph(frame: CGRectZero)
        graph.title = "Hello Graph"
        graph.paddingLeft = 0
        graph.paddingTop = 0
        graph.paddingRight = 0
        graph.paddingBottom = 0
        // hide the axes
        var axes = graph.axisSet as CPTXYAxisSet
        var lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 0
        axes.xAxis.axisLineStyle = lineStyle
        axes.yAxis.axisLineStyle = lineStyle
        
        // add a pie plot
        var pie = CPTPieChart()
        pie.dataSource = self
        pie.pieRadius = (self.view.frame.size.width * 0.9)/2
        graph.addPlot(pie)
        
        self.graphView.hostedGraph = graph

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
