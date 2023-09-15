
import UIKit
import Charts


class GoalSummaryChartCell: UICollectionViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblNoData            : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var lblDailyGoal         : UILabel!
    @IBOutlet weak var lblDailyGoalValue    : UILabel!
    @IBOutlet weak var btnUpdate            : UIButton!
    
    @IBOutlet weak var vwBarChart           : BarChartView!
    @IBOutlet weak var vwLineChart          : LineChartView!
    
    @IBOutlet weak var lblAutoInsight       : UILabel!
    @IBOutlet weak var indicatorView        : UIActivityIndicatorView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var set1 : BarChartDataSet?     =  nil
    var set2 : LineChartDataSet?    =  nil
    let valueArray : [String]       = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let arrValue : [String]         = ["$10", "$70", "$30", "$20", "$50", "$90", "$70"]
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Basic style setup
        self.applyStyle()
        //self.setBarChart()
        
//        self.vwBarChart.addGestureRecognizer(UIPanGestureRecognizer())
//        self.vwLineChart.addGestureRecognizer(UIPanGestureRecognizer())

        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
           
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func applyStyle(){
//        self.lblTitle.font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblDesc.font(name: .semibold, size: 13).textColor(color: .themeBlack)
        self.lblNoData.font(name: .semibold, size: 14).textColor(color: .themePurple)
        self.lblDailyGoal.font(name: .medium, size: 9).textColor(color: .themeBlack)
        self.lblDailyGoalValue.font(name: .medium, size: 14).textColor(color: .themeBlack)
        self.btnUpdate.font(name: .medium, size: 9)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 4)
        self.lblAutoInsight.font(name: .medium, size: 9)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        
        self.indicatorView.style = .medium
    }
    //------------------------------------------------------
    
    //MARK:- Override Method
    
}

//MARK: ------------------- set bar chart Method -------------------
extension GoalSummaryChartCell {
    
    func setBarChart(vwBarChart: BarChartView,
                     xValues : [String],
                     yValues : [String],
                     color: UIColor) {
        
        vwBarChart.isHidden  = false
        
        vwBarChart.clear()
        vwBarChart.isUserInteractionEnabled        = false
        vwBarChart.noDataText                      = "You need to provide data for the chart."
        
        vwBarChart.highlightFullBarEnabled         = true
        vwBarChart.pinchZoomEnabled                = false
        vwBarChart.drawMarkers                     = true
        vwBarChart.doubleTapToZoomEnabled          = false
        vwBarChart.highlightPerTapEnabled          = true
        vwBarChart.highlightPerDragEnabled         = true
        vwBarChart.scaleYEnabled                   = false
        vwBarChart.scaleXEnabled                   = false
        vwBarChart.chartDescription.enabled       = false
        vwBarChart.minOffset                       = 0
        vwBarChart.legend.enabled                  = false
        
        vwBarChart.drawValueAboveBarEnabled        = true
        vwBarChart.xAxis.drawGridLinesEnabled      = false
        vwBarChart.xAxis.drawAxisLineEnabled       = false
        vwBarChart.xAxis.drawGridLinesEnabled      = false
        vwBarChart.xAxis.granularityEnabled        = false
        vwBarChart.xAxis.granularity               = 1.0
        
        vwBarChart.leftAxis.drawGridLinesEnabled   = true
        vwBarChart.leftAxis.gridColor              = UIColor.themeLightGray
        vwBarChart.leftAxis.drawLabelsEnabled      = true
        vwBarChart.leftAxis.drawAxisLineEnabled    = false
        vwBarChart.leftAxis.granularity            = 0.0
        
        vwBarChart.rightAxis.drawGridLinesEnabled  = false
        vwBarChart.rightAxis.drawLabelsEnabled     = false
        vwBarChart.rightAxis.drawAxisLineEnabled   = false
        vwBarChart.legend.enabled                  = false
        
        vwBarChart.dragEnabled                     = false
        vwBarChart.setScaleEnabled(true)
        vwBarChart.extraTopOffset                  = 20
        vwBarChart.extraLeftOffset                 = 10
        vwBarChart.extraRightOffset                = 10
        vwBarChart.viewPortHandler.setMaximumScaleX(3)
        
//        let dataPoints  = ["T", "W", "T", "F", "S", "S", "M"]
//        let values      = ["15","20","10","14","18","17","5"]

        self.setBarchartData(vwBarChart: vwBarChart,
                             xValues: xValues,
                             yValues: yValues,
                             color: color)
    }
    
    func setBarchartData(vwBarChart: BarChartView,
                         xValues : [String],
                         yValues : [String],
                         color: UIColor) {
        
        //        let dataPoints: [String] = self.arrMonth
        var dataEntries: [BarChartDataEntry] = []
        for index in 0..<xValues.count {
            
            //                  let bar = BarChartDataEntry(x: Double(index), yValues: [earning,earning])
            let bar = BarChartDataEntry.init(x: Double(index), yValues: [Double(                          yValues[index]) ?? 0])
            //            String(format: "%.3f", Double(self.arrUserData["wallet_amount"].stringValue)!)
            //            let bar = BarChartDataEntry.init(x: Double(index), yValues: [self.chartData[index]["deal_earning"].doubleValue,20.0])
            dataEntries.append(bar)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        let chartData = BarChartData()
//        chartData.addDataSet(chartDataSet)
        chartData.append(chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth                      = Double(0.6)
        chartDataSet.colors                     = [color]
        chartDataSet.highlightColor             = color
        chartDataSet.highlightAlpha             = 1
        chartDataSet.drawValuesEnabled          = true
        chartDataSet.valueTextColor             = color
        vwBarChart.data                         = chartData
        vwBarChart.xAxis.valueFormatter         = IndexAxisValueFormatter(values:                          xValues)
        
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For x axis
        let xAxis                       = vwBarChart.xAxis
        xAxis.enabled                   = true
        xAxis.drawAxisLineEnabled       = false
        //xAxis.labelCount                = 7//dataPoints.count
        xAxis.labelFont                 = UIFont.customFont(ofType: .medium, withSize: 8)
        xAxis.labelTextColor            = UIColor.themeBlack.withAlphaComponent(0.35)
        xAxis.labelPosition             = .bottom
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 1
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.numberStyle           = .decimal
        leftAxisFormatter.maximumFractionDigits = 0
        leftAxisFormatter.negativeSuffix        = ""
        leftAxisFormatter.positiveSuffix        = ""
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For left y axis
        let leftAxis                            = vwBarChart.leftAxis
        leftAxis.enabled                        = true
        leftAxis.valueFormatter                 = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.spaceTop                       = 0//0.15
        leftAxis.granularity                    = 0
        leftAxis.axisMinimum                    = 0
        
        //leftAxis.labelCount                     = 5
        leftAxis.forceLabelsEnabled             = true
        leftAxis.labelFont                      = UIFont.customFont(ofType: .medium, withSize: 8)
        leftAxis.labelTextColor                 = UIColor.themeBlack.withAlphaComponent(0.35)
        leftAxis.labelPosition                  = .outsideChart
        
        //leftAxis.axisMaximum = 200
        //leftAxis.axisMinimum = 0
        
//        self.marker.chartView = self.chartView
//        self.chartView.marker = self.marker
        
        vwBarChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        vwBarChart.delegate = self
        vwBarChart.fitScreen()
        vwBarChart.extraRightOffset = 20
        vwBarChart.extraTopOffset = 20

    }
    
}

//MARK: ------------------- set line chart Method -------------------
///Not in use after CR 4 of grapgh UI changes
extension GoalSummaryChartCell {
    
    fileprivate func setLineChart(vwLineChart: LineChartView,
                      xValues : [String],
                      yValues : [String],
                      yValues2 : [String],
                      color1: UIColor,
                      color2: UIColor,
                      isMultiLineChart: Bool) {
        
        vwLineChart.isHidden = false
        
        vwLineChart.clear()
        vwLineChart.isUserInteractionEnabled       = false
        vwLineChart.noDataText                     = "You need to provide data for the chart."
        
        vwLineChart.pinchZoomEnabled                = false
        vwLineChart.drawMarkers                     = true
        vwLineChart.doubleTapToZoomEnabled          = false
        vwLineChart.highlightPerTapEnabled          = false
        vwLineChart.highlightPerDragEnabled         = false
        vwLineChart.scaleYEnabled                   = false
        vwLineChart.scaleXEnabled                   = false
        vwLineChart.chartDescription.enabled       = false
        vwLineChart.minOffset                       = 0
        vwLineChart.legend.enabled                  = false
        
        //self.vwLineChart.drawValueAboveBarEnabled        = false
        vwLineChart.xAxis.drawGridLinesEnabled      = false
        vwLineChart.xAxis.gridColor                 = UIColor.themeGray
        vwLineChart.xAxis.drawAxisLineEnabled       = false
        vwLineChart.xAxis.drawGridLinesEnabled      = false
        vwLineChart.xAxis.granularityEnabled        = false
        vwLineChart.xAxis.granularity               = 0.0
        
        vwLineChart.leftAxis.drawGridLinesEnabled   = true
        vwLineChart.leftAxis.gridColor              = UIColor.themeLightGray
        vwLineChart.leftAxis.drawLabelsEnabled      = true
        vwLineChart.leftAxis.drawAxisLineEnabled    = false
        vwLineChart.leftAxis.granularity            = 0.0
        
        vwLineChart.rightAxis.drawGridLinesEnabled  = false
        vwLineChart.rightAxis.drawLabelsEnabled     = false
        vwLineChart.rightAxis.drawAxisLineEnabled   = false
        vwLineChart.legend.enabled                  = false
        
        vwLineChart.dragEnabled                     = false
        vwLineChart.setScaleEnabled(true)
        vwLineChart.extraTopOffset                  = 20
        vwLineChart.extraLeftOffset                 = 10
        vwLineChart.extraRightOffset                = 10
        vwLineChart.viewPortHandler.setMaximumScaleX(3)
        
        let marker = BalloonMarker(color: UIColor.themeFb,
                                   font: .systemFont(ofSize: 18),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        
        marker.chartView = vwLineChart
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.offset = CGPoint.init(x: 0, y: -10)
        vwLineChart.marker = marker
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)

        vwLineChart.xAxis.gridLineDashLengths = [10, 10]
        vwLineChart.xAxis.gridLineDashPhase = 0

        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)

        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)

        let leftAxis = vwLineChart.leftAxis
        leftAxis.removeAllLimitLines()
//        leftAxis.addLimitLine(ll1)
//        leftAxis.addLimitLine(ll2)
        //leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [0, 0]
        leftAxis.drawLimitLinesBehindDataEnabled = true

        vwLineChart.rightAxis.enabled = false
        
        
//        let dataPoints  = ["Day1", "Day8", "Day15", "Da22", "Day29"]
//        let values      = ["15","20","10","14","18","17","5"]
        
        self.setLineChartData(vwLineChart: vwLineChart,
                          xValues : xValues,
                          yValues : yValues,
                          yValues2 : yValues2,
                          color1: color1,
                          color2: color2,
                          isMultiLineChart: isMultiLineChart)
    }
    
    fileprivate func setLineChartData(vwLineChart: LineChartView,
                      xValues : [String],
                      yValues : [String],
                      yValues2 : [String],
                      color1: UIColor,
                      color2: UIColor,
                      isMultiLineChart: Bool) {
        
        
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For x axis
        let xAxis                       = vwLineChart.xAxis
        xAxis.enabled                   = true
        xAxis.drawAxisLineEnabled       = false
        //xAxis.labelCount                = 7//dataPoints.count
        xAxis.labelFont                 = UIFont.customFont(ofType: .medium, withSize: 8)
        xAxis.labelTextColor            = UIColor.themeBlack.withAlphaComponent(0.35)
        xAxis.labelPosition             = .bottom
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 1
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.numberStyle           = .decimal
        leftAxisFormatter.maximumFractionDigits = 0
        leftAxisFormatter.negativeSuffix        = ""
        leftAxisFormatter.positiveSuffix        = ""
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For left y axis
        let leftAxis                            = vwLineChart.leftAxis
        leftAxis.enabled                        = true
        leftAxis.valueFormatter                 = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.spaceTop                       = 0//0.15
        leftAxis.axisMinimum                    = 0
        
        //leftAxis.labelCount                     = 5
        leftAxis.forceLabelsEnabled             = true
        leftAxis.labelFont                      = UIFont.customFont(ofType: .medium, withSize: 8)
        leftAxis.labelTextColor                 = UIColor.themeBlack.withAlphaComponent(0.35)
        leftAxis.labelPosition                  = .outsideChart
        
        //leftAxis.axisMaximum = 200
        //leftAxis.axisMinimum = 0
        
        //        self.marker.chartView = self.chartView
        //        self.chartView.marker = self.marker
        
        
        let values1 : NSMutableArray = NSMutableArray()
        let values2 : NSMutableArray = NSMutableArray()
        
        
        /* for i in  0..<arrChartData.count {
         var val : Double = Double((i + 1) * 10)
         debugPrint("Value:-", val)
         if val >= 100 {
         val = val - Double((i + 5))
         }
         
         let randomVal = Int.random(in: 10..<100)
         values.add(ChartDataEntry(x: Double(i), y: Double(randomVal)))
         //  valueArray.append("\(i) \n PM")
         }
         
         
         for i in  1..<13 {
         var val : Double = Double((i + 1) * 5)
         debugPrint("Value:-", val)
         if val >= 100 {
         val = val - Double((i + 5))
         }
         //values.add(ChartDataEntry(x: Double(i), y: val))
         //            valueArray.append("\(i):00 \n Am")
         }
         for i in  1..<13 {
         var val : Double = Double((i + 1) * 5)
         debugPrint("Value:-", val)
         if val >= 100 {
         val = val - Double((i + 5))
         }
         //values.add(ChartDataEntry(x: Double(i), y: val))
         //            valueArray.append("\(i):00 \n Pm")
         } */
        
      
        for index in 0...xValues.count - 1 {
            debugPrint("Value of i:- ", index)
            
            values1.add(ChartDataEntry(x: Double(index), y: Double(yValues[index]) ?? 0))
            
            if isMultiLineChart {
                //let arr2      = ["18","5","9","20","15","11","2"]
                values2.add(ChartDataEntry(x: Double(index), y: Double(yValues2[index]) ?? 0))
            }
        }
        
//        for index in 0..<dataPoints.count {
//            debugPrint("Value of i:- ", index)
//
//            values1.add(ChartDataEntry(x: Double(index), y: Double(arr[index])!))
//
//            if isMultiLineChart {
//                let arr2      = ["18","5","9","20","15","11","2"]
//                values2.add(ChartDataEntry(x: Double(index), y: Double(arr2[index])!))
//            }
//        }
        
        //change by kushal
        vwLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        
        vwLineChart.rightAxis.enabled      = false      //Change Here
        vwLineChart.leftAxis.enabled       = true      //Change Here
        vwLineChart.xAxis.labelTextColor   = UIColor.themeBlack.withAlphaComponent(0.35) //Change Here
        
        //--------For set 1 of Y values
        let set1 = LineChartDataSet.init(entries: values1 as! [ChartDataEntry], label: "")
        //        set1?.drawIconsEnabled = false
        set1.lineDashLengths = [0.0,0.0]
        set1.highlightLineDashLengths = [0.0,0.0]
        set1.highlightLineWidth = 0.0
        set1.mode = .linear//.horizontalBezier          //Chane Here
        set1.setColor(color1) //Change Here
        set1.setCircleColor(UIColor.themeYellow)
        set1.lineWidth = 2.0
        set1.drawCircleHoleEnabled = true
        set1.circleColors = [UIColor.white]
        set1.circleHoleColor = color1
        set1.circleRadius = 4.0
        set1.circleHoleRadius = 2.0
        set1.formLineDashLengths = [0.0,0.0]
        set1.formLineWidth = 2.0
        set1.formSize = 30.0
        let gradientColors  = [color1.withAlphaComponent(0).cgColor , color1.withAlphaComponent(0.5).cgColor]
        let gradient : CGGradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: [0, 0.8])!
        set1.fillAlpha = 1.0
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set1.drawFilledEnabled  = true
        set1.drawValuesEnabled  = true
        set1.valueTextColor     = color1
        
        let dataSets : NSMutableArray = NSMutableArray()
        dataSets.add(set1)
        
        //--------For set 2 of Y values
        if isMultiLineChart {
            let set2 = LineChartDataSet.init(entries: values2 as! [ChartDataEntry], label: "")
            //        set1?.drawIconsEnabled = false
            set2.lineDashLengths = [0.0,0.0]
            set2.highlightLineDashLengths = [0.0,0.0]
            set2.highlightLineWidth = 0.0
            set2.mode = .linear//.horizontalBezier          //Chane Here
            set2.setColor(color2) //Change Here
            set2.setCircleColor(UIColor.themeYellow)
            set2.lineWidth = 2.0
            set2.drawCircleHoleEnabled = true
            set2.circleColors = [UIColor.white]
            set2.circleHoleColor = color2
            set2.circleRadius = 4.0
            set2.circleHoleRadius = 2.0
            set2.formLineDashLengths = [0.0,0.0]
            set2.formLineWidth = 2.0
            set2.formSize = 30.0
            let gradientColors2  = [color2.withAlphaComponent(0).cgColor , color2.withAlphaComponent(0.5).cgColor]
            let gradient2 : CGGradient = CGGradient(colorsSpace: nil, colors: gradientColors2 as CFArray, locations: [0, 0.8])!
            set2.fillAlpha = 1.0
            set2.fill = LinearGradientFill(gradient: gradient2, angle: 90)
            set2.drawFilledEnabled  = true
            set2.drawValuesEnabled  = true
            set2.valueTextColor     = color2
            
            dataSets.add(set2)
        }
        
        let data : LineChartData = LineChartData(dataSets: dataSets as! [ChartDataSetProtocol])
        vwLineChart.data = data
        
        vwLineChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        vwLineChart.delegate = self
        vwLineChart.fitScreen()
        vwLineChart.extraRightOffset = 20
        
    }
}

extension GoalSummaryChartCell : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    
    chartView.highlightValue(Highlight(x: entry.x, y: entry.y, dataSetIndex: 0))
    }
}
