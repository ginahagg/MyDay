//
//  DayStatsViewController.swift
//  MyDay
//
//  Created by Gina Hagg on 5/25/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit
import CoreData
import Charts


class DayStatsViewController: UIViewController, ChartViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var dataForPlot : NSMutableArray = []
    
    var dataCount = 0
    
    // MARK: - Outlets

    @IBOutlet weak var yearsSlider: UISlider!
    
    @IBOutlet weak var monthSlider: UISlider!
    
    
    @IBOutlet weak var daySlider: UISlider!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var yearLable: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    //@IBOutlet weak var graphView: CPTGraphHostingView!
    
    @IBOutlet weak var _chartView: ScatterChartView!
    
    @IBAction func updateGraph(sender: UIButton) {
    }
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
    
    func getDateDiff(fromDate : NSDate, toDate : NSDate) -> Int{
        
        let cal = NSCalendar.currentCalendar()
        
        
        let unit:NSCalendarUnit = .CalendarUnitDay
        
        let components = cal.components(unit, fromDate: fromDate, toDate: toDate, options: nil)
        
        return components.day
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _chartView.delegate = self;
        
        _chartView.descriptionText = ""
        _chartView.noDataTextDescription = "You need to provide data for the chart."
        
        _chartView.drawGridBackgroundEnabled = false
        _chartView.highlightEnabled = true
        _chartView.dragEnabled = true
        _chartView.setScaleEnabled(true)
        _chartView.maxVisibleValueCount = 200
        _chartView.pinchZoomEnabled = true
        
        var l = _chartView.legend
        l.position = ChartLegend.ChartLegendPosition.RightOfChart
        l.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
        
        var yl : ChartYAxis = _chartView.leftAxis
        yl.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
        
        _chartView.rightAxis.enabled = false
        
        var xl : ChartXAxis = _chartView.xAxis
        xl.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
        xl.drawGridLinesEnabled = false
        var dataArray = fetchData()
        setDataCountWithFetch(dataArray)
    }
    
    func setDataCount(count : Int , range : UInt32)
    {
        var xVals = [String]()
        
        for  i in 0...count
        {
            xVals.append("\(i)")
        }
        
        var yVals1 = [ChartDataEntry]()
        var yVals2 = [ChartDataEntry]()
        var yVals3 = [ChartDataEntry]()
        
        for  i in 0...count
        {
            var val : Float =  Float(arc4random_uniform(range) + 3)
            yVals1.append(ChartDataEntry(value: val, xIndex: i))
            
            val = Float(arc4random_uniform(range) + 3)
            yVals2.append(ChartDataEntry(value: val, xIndex: i))
            
            val = Float(arc4random_uniform(range) + 3)
            yVals3.append(ChartDataEntry(value: val, xIndex: i))
        }
        
        
        var set1 : ScatterChartDataSet = ScatterChartDataSet(yVals: yVals1,label: "Joyful")
        println("xVals: \(xVals), yVals1:\(yVals1), yVals2\(yVals2), yVals3:\(yVals3)")
        //set1.scatterShape = 3 //ScatterShape.Square
        set1.setColor(ChartColorTemplates.colorful()[0])
        var set2 = ScatterChartDataSet(yVals: yVals2,label: "Happy")
        //set2.scatterShape = ScatterShape.Circle
        set2.setColor(ChartColorTemplates.colorful()[1])
        var set3 = ScatterChartDataSet(yVals: yVals3,label: "So-so")
        //set3.scatterShape = ScatterShapeCross;
        set3.setColor(ChartColorTemplates.colorful()[2])
        
        set1.scatterShapeSize = 8
        set2.scatterShapeSize = 8
        set3.scatterShapeSize = 8
        
        var dataSets = [ScatterChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        
        var data = ScatterChartData(xVals: xVals, dataSets: dataSets)
        
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 7.0))
        
        _chartView.data = data
        //println("chartview data: \(_chartView.data!.contains(dataSet: set1))")
    }

    func setDataCountWithFetch(dataArray: [MyDay])
    {
        var xVals = [String]()
        let count = dataArray.count
        let range : UInt32 = 14
        for  i in 0...count-1
        {
            xVals.append("\(i)")
        }
        
        var yVals1 = [ChartDataEntry]()
        var yVals2 = [ChartDataEntry]()
        var yVals3 = [ChartDataEntry]()
        var yVals4 = [ChartDataEntry]()
        var yVals5 = [ChartDataEntry]()
        var yVals6 = [ChartDataEntry]()
        
        for  i in 0...count-1
        {
            //var val : Float =  Float(arc4random_uniform(range) + 3)
            var rec = dataArray[i]
            var val = rec.mood
            switch val {
            case 1,2,10,11:
                yVals1.append(ChartDataEntry(value: Float(val), xIndex: i))
            case 0,7:
                yVals2.append(ChartDataEntry(value: Float(val), xIndex: i))
            case 3,6:
                yVals3.append(ChartDataEntry(value: Float(val), xIndex: i))
            case 4,5,9:
                yVals4.append(ChartDataEntry(value: Float(val), xIndex: i))
            case 8,10:
                yVals5.append(ChartDataEntry(value: Float(val), xIndex: i))
            case 12,13:
                yVals6.append(ChartDataEntry(value: Float(val), xIndex: i))
            default:
                yVals1.append(ChartDataEntry(value: Float(val), xIndex: i))
            }
            
        }
        //so = 0,blues,sad,pms,love,happy,angry,spiritual,emptiness,joyous,helpless,hopeless,depressed,hell
        var label = ""
        if (MoodIndex(rawValue: 1) != nil){
            label = MoodIndex(rawValue: 1)!.toString()
        }
        
        var set1 : ScatterChartDataSet = ScatterChartDataSet(yVals: yVals1,label: label)
        println("xVals: \(xVals), yVals1:\(yVals1), yVals2\(yVals2), yVals3:\(yVals3)")
        set1.setColor(ChartColorTemplates.pastel()[0])
        if (MoodIndex(rawValue: 0) != nil){
            label = MoodIndex(rawValue: 0)!.toString()
        }
        var set2 = ScatterChartDataSet(yVals: yVals2,label: label)
        set2.setColor(ChartColorTemplates.colorful()[1])
        if (MoodIndex(rawValue: 6) != nil){
            label = MoodIndex(rawValue: 6)!.toString()
        }
        var set3 = ScatterChartDataSet(yVals: yVals3,label: label)
        set3.setColor(ChartColorTemplates.colorful()[2])
        if (MoodIndex(rawValue: 5) != nil){
            label = MoodIndex(rawValue: 5)!.toString()
        }
        var set4 = ScatterChartDataSet(yVals: yVals4,label: label)
        set4.setColor(ChartColorTemplates.joyful()[1])
        if (MoodIndex(rawValue: 10) != nil){
            label = MoodIndex(rawValue: 10)!.toString()
        }
        var set5 = ScatterChartDataSet(yVals: yVals5,label: label)
        set5.setColor(ChartColorTemplates.colorful()[3])
        if (MoodIndex(rawValue: 12) != nil){
            label = MoodIndex(rawValue: 12)!.toString()
        }
        var set6 = ScatterChartDataSet(yVals: yVals6,label: label)
        set6.setColor(ChartColorTemplates.pastel()[1])
        
        set1.scatterShapeSize = 8
        set2.scatterShapeSize = 8
        set3.scatterShapeSize = 8
        set4.scatterShapeSize = 8
        set5.scatterShapeSize = 8
        set6.scatterShapeSize = 8
        
        var dataSets = [ScatterChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        dataSets.append(set4)
        dataSets.append(set5)
        dataSets.append(set6)
        
        var data = ScatterChartData(xVals: xVals, dataSets: dataSets)
        
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 7.0))
        
        _chartView.data = data
        //println("chartview data: \(_chartView.data!.contains(dataSet: set1))")
    }

    func fetchData()-> [MyDay]{
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: Constants.MyDayEntity)
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MyDay] {
            println("\(fetchResults.count) records")
            self.dataCount = fetchResults.count
            
            //let firstDate = fetchResults.first?.date
            
            /*for rec in fetchResults{
                var moodInt:Int = rec.mood as Int
                var Dt : NSDate = rec.date
                let formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .MediumStyle
                var date = formatter.stringFromDate(Dt)*/
                
                /*if let mood = MoodIndex(rawValue: moodInt){
                println("Mood on \(rec.date) is \(mood.toString())")
                }
                else{
                println("nil value on \(moodInt)")
                }}*/
            
            return fetchResults
        }
        return []
    }
    
    
    /*func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return UInt(dataForPlot.count)
    }
    
    

    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
   
        var rec = self.dataForPlot[Int(idx)] as! NSArray
        var num = NSNumber()
        // This method is actually called twice per point in the plot, one for the X and one for the Y value
        var match : UInt = UInt(CPTScatterPlotField.X.rawValue)
        if (fieldEnum == match)
        {
           
            return rec[0]
        } else {
           
            return rec[1]
        }
    }*/
    
    /*func createPieGraph(){
        var graph = CPTXYGraph(frame: CGRectZero)
        var whiteText : CPTMutableTextStyle = CPTMutableTextStyle()
        whiteText.color = CPTColor.whiteColor()
        
        graph.titleTextStyle = whiteText
        graph.title = "Hello User"
        graph.titleDisplacement = CGPointMake(0.0, -5.0)
        //graph.paddingLeft   = 10.0
        //graph.paddingTop    = 5.0
        //graph.paddingRight = 5.0
        //graph.paddingBottom = 50.0
        graph.plotAreaFrame.paddingBottom = 50.0
        graph.plotAreaFrame.paddingLeft = 50.0
        graph.plotAreaFrame.paddingTop    = 5.0
        graph.plotAreaFrame.paddingRight = 5.0
        // hide the axes
        var axes = graph.axisSet as! CPTXYAxisSet
        var lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 0
        axes.xAxis.axisLineStyle = lineStyle
        axes.yAxis.axisLineStyle = lineStyle
        
        // add a pie plot
        var pie = CPTPieChart(frame: CGRectZero)
        pie.dataSource = self
        pie.pieRadius = (self.view.frame.size.width * 0.8)/2
        graph.addPlot(pie)
        
        self.graphView.hostedGraph = graph

    }*/
    
    /*func createSimpleScatterGraph(){
        //let oneDay : Int  = 86400 //24 * 60 * 60
        let oneDay = NSDecimalNumber(string: "86400").decimalValue
        var graph = CPTXYGraph(frame: CGRectZero)
        graph.backgroundColor = UIColor.whiteColor().CGColor
        graph.title = "Hello User"
        graph.titleDisplacement = CGPointMake(0.0, -5.0)
        /*graph.paddingLeft   = 40.0
        graph.paddingTop    = 10.0
        graph.paddingRight = 10.0
        graph.paddingBottom = 40.0*/
        graph.plotAreaFrame.paddingBottom = 50.0
        graph.plotAreaFrame.paddingLeft = 50.0
        graph.plotAreaFrame.paddingTop    = 5.0
        graph.plotAreaFrame.paddingRight = 5.0
        
        // We need a hostview, you can create one in IB (and create an outlet) or just do this:
        self.graphView.hostedGraph = graph
        
        // Get the (default) plotspace from the graph so we can set its x/y ranges
        var plotSpace : CPTXYPlotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        
        plotSpace.yRange = CPTPlotRange(location: CPTDecimalFromInt(0), length: CPTDecimalFromInteger(9))
        plotSpace.xRange = CPTPlotRange (location: CPTDecimalFromInt(0), length: CPTDecimalFromInteger(9))
        
        // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
        var plot = CPTScatterPlot(frame: CGRectZero)
        var lineStyle = CPTMutableLineStyle()
        lineStyle.miterLimit        = 1.0
        lineStyle.lineWidth         = 1.0
        lineStyle.lineColor         = CPTColor.redColor()
        plot.dataLineStyle = lineStyle
        
       
        var axisSet = graph.axisSet as! CPTXYAxisSet
        var xAxis = axisSet.xAxis
        xAxis.title = "Days"
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 1.0
        axisLineStyle.lineColor = CPTColor.blackColor()
        xAxis.axisLineStyle = axisLineStyle
        var axisFormatter = NSNumberFormatter()
        axisFormatter.maximumIntegerDigits = 1
        axisFormatter.maximumFractionDigits = 0
        var axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.blackColor()
        axisTextStyle.fontName = "Helvetica-Bold"
        axisTextStyle.fontSize = 10.0
        
        xAxis.labelFormatter = axisFormatter
        xAxis.minorTickLineStyle = nil
        xAxis.labelTextStyle = axisTextStyle
        xAxis.majorIntervalLength =  CPTDecimalFromInt(1)
        xAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        //xAxis.orthogonalCoordinateDecimal = CPTDecimalFromInt(1)
      
        
        var yAxis = axisSet.yAxis
        yAxis.title = "Mood"
        yAxis.majorIntervalLength = CPTDecimalFromInt(1)
        yAxis.labelFormatter = axisFormatter
        yAxis.axisLineStyle = axisLineStyle
        yAxis.minorTickLineStyle = nil
        yAxis.labelTextStyle = axisTextStyle
        yAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        //yAxis.orthogonalCoordinateDecimal = CPTDecimalFromDouble(1.0)
        
        plot.dataSource = self
        
        // Finally, add the created plot to the default plot space of the CPTGraph object we created before
        graph.addPlot(plot, toPlotSpace: plotSpace)
        
        
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
