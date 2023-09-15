//
//  CarePlanPopupChartManager.swift
//  MyTatva
//
//  Created by Darshan Joshi on 04/10/21.
//

import Foundation
import Charts
import UIKit


class ChartLimitLineModel {
    
    var title: String = ""
    var value: Double!
    
    init(){}
}

class CarePlanPopupChartManager {
    
    static let shared                       = CarePlanPopupChartManager()
    var readingChartDetailModel             = ReadingChartDetailModel()
    var readingListModel                    = ReadingListModel()
    var selectedFibroScanType: FibroScanType    = .LSM
    
    init(){
        
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self)
        self.readingChartDetailModel    = ReadingChartDetailModel()
        self.readingListModel           = ReadingListModel()
    }
}

//MARK: ------------------- set bar chart Method -------------------
extension CarePlanPopupChartManager {
    
    func setBarChart(vwBarChart: BarChartView,
                     xValues : [String],
                     yValues : [String],
                     color: UIColor,
                     xCount: Int) {
        
        vwBarChart.isHidden  = false
        
        vwBarChart.clear()
        vwBarChart.isUserInteractionEnabled         = true
        vwBarChart.noDataText                       = ""//"You need to provide data for the chart."
        
        vwBarChart.highlightFullBarEnabled          = true
        vwBarChart.pinchZoomEnabled                 = false
        vwBarChart.drawMarkers                      = true
        vwBarChart.doubleTapToZoomEnabled           = false
        vwBarChart.highlightPerTapEnabled           = true
        vwBarChart.highlightPerDragEnabled          = true
        vwBarChart.scaleYEnabled                    = false
        vwBarChart.scaleXEnabled                    = false
        vwBarChart.chartDescription.enabled         = false
        vwBarChart.minOffset                        = 0
        vwBarChart.legend.enabled                   = false
        vwBarChart.drawValueAboveBarEnabled         = true
        
        vwBarChart.xAxis.drawGridLinesEnabled       = false
        vwBarChart.xAxis.drawAxisLineEnabled        = false
        vwBarChart.xAxis.drawGridLinesEnabled       = false
        
        vwBarChart.leftAxis.drawGridLinesEnabled    = true
        vwBarChart.leftAxis.gridColor               = UIColor.themeLightGray
        vwBarChart.leftAxis.drawLabelsEnabled       = true
        vwBarChart.leftAxis.drawAxisLineEnabled     = false
        vwBarChart.leftAxis.granularity             = 0.0
        
        vwBarChart.rightAxis.drawGridLinesEnabled   = false
        vwBarChart.rightAxis.drawLabelsEnabled      = false
        vwBarChart.rightAxis.drawAxisLineEnabled    = false
        vwBarChart.legend.enabled                   = false
        
        vwBarChart.dragEnabled                      = true
        vwBarChart.setScaleEnabled(false)
        vwBarChart.extraTopOffset                   = 10
        vwBarChart.extraBottomOffset                = 7
        vwBarChart.extraRightOffset                 = 7
        vwBarChart.viewPortHandler.setMaximumScaleX(3)
        //        vwBarChart.setViewPortOffsets(left: 45, top: 25, right: 25, bottom: 25)
        
        //        let dataPoints  = ["T", "W", "T", "F", "S", "S", "M"]
        //        let values      = ["15","20","10","14","18","17","5"]
        
        self.setBarchartData(vwBarChart: vwBarChart,
                             xValues: xValues,
                             yValues: yValues,
                             color: color,
                             xCount: xCount)
    }
    
    func setBarchartData(vwBarChart: BarChartView,
                         xValues : [String],
                         yValues : [String],
                         color: UIColor,
                         xCount: Int) {
        
        //        let dataPoints: [String] = self.arrMonth
        var dataEntries: [BarChartDataEntry] = []
        for index in 0..<xValues.count {
            
            //                  let bar = BarChartDataEntry(x: Double(index), yValues: [earning,earning])
            let bar = BarChartDataEntry.init(x: Double(index), yValues: [Double(                          yValues[index]) ?? 0])
            //            String(format: "%.3f", Double(self.arrUserData["wallet_amount"].stringValue)!)
            //            let bar = BarChartDataEntry.init(x: Double(index), yValues: [self.chartData[index]["deal_earning"].doubleValue,20.0])
            dataEntries.append(bar)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Earning")
        let chartData = BarChartData()
        //chartData.addDataSet(chartDataSet)
        chartData.append(chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth                      = Double(0.6)
        chartDataSet.colors                     = [color]
        chartDataSet.highlightColor             = color
        chartDataSet.highlightAlpha             = 1
        chartDataSet.drawValuesEnabled          = false
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
        xAxis.labelTextColor            = UIColor.themeBlack.withAlphaComponent(1)
        xAxis.labelPosition             = .bottom
        xAxis.granularityEnabled        = true
        xAxis.granularity               = 1
        
        switch xCount {
        case 7:
            xAxis.labelCount = 6
            xAxis.centerAxisLabelsEnabled = false
            break
        case 15:
            xAxis.labelCount = 15
            xAxis.centerAxisLabelsEnabled = false
            break
        case 30:
            xAxis.labelCount = 10
            xAxis.centerAxisLabelsEnabled = false
            break
        case 90:
            xAxis.labelCount = 3
            xAxis.centerAxisLabelsEnabled = true
            break
        case 1:
            xAxis.labelCount = 12
            xAxis.centerAxisLabelsEnabled = false
            break
        default:break
        }
        
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
        //        leftAxis.valueFormatter                 = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.spaceTop                       = 0.1
        leftAxis.spaceBottom                    = 0.1
        leftAxis.granularity                    = 0
        leftAxis.axisMinimum                    = 0
        
        //leftAxis.labelCount                     = 5
        leftAxis.forceLabelsEnabled             = true
        leftAxis.labelFont                      = UIFont.customFont(ofType: .medium, withSize: 8)
        leftAxis.labelTextColor                 = UIColor.themeBlack.withAlphaComponent(1)
        leftAxis.labelPosition                  = .outsideChart
        
        //leftAxis.axisMaximum = 200
        //leftAxis.axisMinimum = 0
        
        //        self.marker.chartView = self.chartView
        //        self.chartView.marker = self.marker
        
        vwBarChart.animate(xAxisDuration: 0, yAxisDuration: 0)
        //        vwBarChart.delegate = self
        vwBarChart.fitScreen()
        
        let marker = AppChartMarker.init(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        //        marker.strTitle = self.readingChartDetailModel.xva
        marker.color1           = color
        marker.color2           = color
        marker.chartView        = vwBarChart
        marker.readingType      = ReadingType.init(rawValue: self.readingListModel.keys ?? "")
        marker.selectedFibroScanType = self.selectedFibroScanType
        marker.offset           = CGPoint.init(x: 0, y: 0)
        vwBarChart.marker       = marker
    }
}

//MARK: ------------------- set line chart Method -------------------
extension CarePlanPopupChartManager {
    
    func setLineChart(vwLineChart: LineChartView,
                      xValues : [String],
                      yValues : [String],
                      yValues2 : [String],
                      color1: UIColor,
                      color2: UIColor,
                      isMultiLineChart: Bool,
                      isShowLimit: Bool,
                      arrLimitLine: [ChartLimitLineModel],
                      xCount: Int) {
        
        vwLineChart.isHidden = false
        
        vwLineChart.clear()
        vwLineChart.isUserInteractionEnabled        = true
        vwLineChart.noDataText                      = ""//"You need to provide data for the chart."
        
        vwLineChart.pinchZoomEnabled                = false
        vwLineChart.doubleTapToZoomEnabled          = false
        vwLineChart.scaleYEnabled                   = false
        vwLineChart.scaleXEnabled                   = false
        vwLineChart.chartDescription.enabled        = false
        vwLineChart.minOffset                       = 0
        vwLineChart.legend.enabled                  = true
        
        vwLineChart.drawMarkers                     = true
        vwLineChart.highlightPerTapEnabled          = true
        vwLineChart.highlightPerDragEnabled         = true
        //vwLineChart.isHighlightFullBarEnabled       = true
        
        //self.vwLineChart.drawValueAboveBarEnabled        = false
        vwLineChart.xAxis.drawGridLinesEnabled      = false
        vwLineChart.xAxis.gridColor                 = UIColor.themeGray
        vwLineChart.xAxis.drawAxisLineEnabled       = false
        vwLineChart.xAxis.drawGridLinesEnabled      = false
        
        vwLineChart.leftAxis.drawGridLinesEnabled   = true
        vwLineChart.leftAxis.gridColor              = UIColor.themeLightGray
        vwLineChart.leftAxis.drawLabelsEnabled      = true
        vwLineChart.leftAxis.drawAxisLineEnabled    = false
        vwLineChart.leftAxis.granularity            = 0.0
        
        vwLineChart.rightAxis.drawGridLinesEnabled  = false
        vwLineChart.rightAxis.drawLabelsEnabled     = false
        vwLineChart.rightAxis.drawAxisLineEnabled   = false
        vwLineChart.legend.enabled                  = false
        
        vwLineChart.dragEnabled                     = true
        vwLineChart.setScaleEnabled(false)
        vwLineChart.extraTopOffset                  = 10
        vwLineChart.extraBottomOffset               = 7
        vwLineChart.extraRightOffset                = 7
        vwLineChart.viewPortHandler.setMaximumScaleX(3)
        //        vwLineChart.setViewPortOffsets(left: 45, top: 25, right: 25, bottom: 25)
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        vwLineChart.xAxis.gridLineDashLengths = [10, 10]
        vwLineChart.xAxis.gridLineDashPhase = 0
        
        let leftAxis = vwLineChart.leftAxis
        leftAxis.removeAllLimitLines()
        if isShowLimit {
            for item in arrLimitLine {
                //                if item.value > 0 {
                let ll1                 = ChartLimitLine(limit: item.value, label: item.title)
                ll1.lineWidth           = 1
                ll1.lineDashLengths     = [5,0]
                ll1.lineColor           = UIColor.themeRed
                ll1.labelPosition       = .leftTop
                ll1.valueFont           = UIFont.customFont(ofType: .bold, withSize: 9)
                ll1.valueTextColor      = UIColor.themeBlack
                ll1.yOffset             = 0
                leftAxis.addLimitLine(ll1)
                //                }
            }
        }
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
                              isMultiLineChart: isMultiLineChart,
                              xCount: xCount)
    }
    
    func setLineChartData(vwLineChart: LineChartView,
                          xValues : [String],
                          yValues : [String],
                          yValues2 : [String],
                          color1: UIColor,
                          color2: UIColor,
                          isMultiLineChart: Bool,
                          xCount: Int) {
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For x axis
        let xAxis                       = vwLineChart.xAxis
        xAxis.enabled                   = true
        xAxis.drawAxisLineEnabled       = false
        //xAxis.labelCount                = 7//dataPoints.count
        xAxis.labelFont                 = UIFont.customFont(ofType: .medium, withSize: 8)
        xAxis.labelTextColor            = UIColor.themeBlack.withAlphaComponent(1)
        xAxis.labelPosition             = .bottom
        xAxis.granularityEnabled        = true
        xAxis.granularity               = 1
        
        switch xCount {
        case 7:
            xAxis.labelCount = 6
            xAxis.centerAxisLabelsEnabled = false
            break
        case 15:
            xAxis.labelCount = 15
            xAxis.centerAxisLabelsEnabled = false
            break
        case 30:
            xAxis.labelCount = 10
            xAxis.centerAxisLabelsEnabled = false
            break
        case 90:
            xAxis.labelCount = 3
            xAxis.centerAxisLabelsEnabled = true
            break
        case 1:
            xAxis.labelCount = 12
            xAxis.centerAxisLabelsEnabled = false
            break
        default:break
        }
        
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
        //                leftAxis.valueFormatter                 = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        if let type =  ReadingType.init(rawValue: self.readingListModel.keys) {
            if type == .fatty_liver_ugs_grade {
                vwLineChart.leftAxis.granularityEnabled = true
                vwLineChart.leftAxis.granularity        = 1
                vwLineChart.leftAxis.axisMinimum        = 0
                vwLineChart.leftAxis.axisMaximum        = 3.01
                vwLineChart.leftAxis.labelCount         = 4
                vwLineChart.leftAxis.valueFormatter     = customValueFormatter()
            }
        }
        leftAxis.spaceTop                       = 0.1
        leftAxis.spaceBottom                    = 0.1
        leftAxis.axisMinimum                    = 0
        
        //leftAxis.labelCount                     = 5
        leftAxis.forceLabelsEnabled             = true
        leftAxis.labelFont                      = UIFont.customFont(ofType: .medium, withSize: 8)
        leftAxis.labelTextColor                 = UIColor.themeBlack.withAlphaComponent(1)
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
                //values1.add(ChartDataEntry(x: Double(index), y: Double(yValues2[index]) ?? 0))
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
        
        vwLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        
        vwLineChart.rightAxis.enabled      = false      //Change Here
        vwLineChart.leftAxis.enabled       = true      //Change Here
        vwLineChart.xAxis.labelTextColor   = UIColor.themeBlack.withAlphaComponent(1) //Change Here
        
        //--------For set 1 of Y values
        let set1 = LineChartDataSet.init(entries: (values1) as! [ChartDataEntry], label: "")
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
        let gradientColors  = [color1.withAlphaComponent(0).cgColor, color1.withAlphaComponent(0.5).cgColor]
        let gradient : CGGradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: [0, 0.8])!
        set1.fillAlpha = 1.0
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set1.drawFilledEnabled  = true
        set1.drawValuesEnabled  = false
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
            set2.drawValuesEnabled  = false
            set2.valueTextColor     = color2
            
            dataSets.add(set2)
        }
        
        //let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        let data : LineChartData = LineChartData(dataSets: dataSets as! [ChartDataSetProtocol])
        vwLineChart.data = data
        
        vwLineChart.animate(xAxisDuration: 0, yAxisDuration: 0)
        //        vwLineChart.delegate = self
        vwLineChart.fitScreen()
        
        ///Set marker
        //        let marker = BalloonMarker(color: color1,
        //                                   font: UIFont.customFont(ofType: .medium, withSize: 9),
        //                                   textColor: .white,
        //                                   insets: UIEdgeInsets(top: 3, left: 5, bottom: 5, right: 5))
        //
        //        marker.chartView = vwLineChart
        //        marker.minimumSize = CGSize(width: 40, height: 30)
        //        marker.offset = CGPoint.init(x: 0, y: 0)
        //        vwLineChart.marker = marker
        
        let marker = AppChartMarker.init(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        marker.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //        marker.strTitle = self.readingChartDetailModel.xva
        marker.color1           = color1
        marker.color2           = color2
        marker.chartView        = vwLineChart
        marker.readingType      = ReadingType.init(rawValue: self.readingListModel.keys ?? "")
        marker.selectedFibroScanType = self.selectedFibroScanType
        //        marker.minimumSize = CGSize(width: 40, height: 30)
        marker.offset           = CGPoint.init(x: 0, y: 0)
        vwLineChart.marker      = marker
        
    }
}

//MARK: ------------------- set Scatter chart Method -------------------
extension CarePlanPopupChartManager {
    
    func setScatterChart(vwScatterChart: ScatterChartView,
                         xValues : [String],
                         yValues : [[String]],
                         color: UIColor,
                         isShowLimit: Bool,
                         arrLimitLine: [ChartLimitLineModel],
                         xCount: Int) {
        
        vwScatterChart.isHidden  = false
        
        vwScatterChart.clear()
        vwScatterChart.isUserInteractionEnabled         = true
        vwScatterChart.noDataText                       = ""//"You need to provide data for the chart."
        
        vwScatterChart.pinchZoomEnabled                 = false
        vwScatterChart.drawMarkers                      = true
        vwScatterChart.doubleTapToZoomEnabled           = false
        vwScatterChart.highlightPerTapEnabled           = true
        vwScatterChart.highlightPerDragEnabled          = true
        vwScatterChart.scaleYEnabled                    = false
        vwScatterChart.scaleXEnabled                    = false
        vwScatterChart.chartDescription.enabled         = false
        vwScatterChart.minOffset                        = 0
        vwScatterChart.legend.enabled                   = false
        
        vwScatterChart.xAxis.drawGridLinesEnabled       = false
        vwScatterChart.xAxis.drawAxisLineEnabled        = false
        vwScatterChart.xAxis.drawGridLinesEnabled       = false
        
        vwScatterChart.leftAxis.drawGridLinesEnabled    = true
        vwScatterChart.leftAxis.gridColor               = UIColor.themeLightGray
        vwScatterChart.leftAxis.drawLabelsEnabled       = true
        vwScatterChart.leftAxis.drawAxisLineEnabled     = false
        //        vwScatterChart.leftAxis.granularity             = 0.0
        
        vwScatterChart.rightAxis.drawGridLinesEnabled   = false
        vwScatterChart.rightAxis.drawLabelsEnabled      = false
        vwScatterChart.rightAxis.drawAxisLineEnabled    = false
        vwScatterChart.legend.enabled                   = false
        
        vwScatterChart.dragEnabled                      = true
        vwScatterChart.setScaleEnabled(false)
        vwScatterChart.extraTopOffset                   = 10
        vwScatterChart.extraBottomOffset                = 7
        vwScatterChart.extraRightOffset                 = 7
        vwScatterChart.viewPortHandler.setMaximumScaleX(3)
        //        vwScatterChart.setViewPortOffsets(left: 35, top: 25, right: 25, bottom: 25)
        
        let leftAxis = vwScatterChart.leftAxis
        leftAxis.removeAllLimitLines()
        if isShowLimit {
            for item in arrLimitLine {
                let ll1                 = ChartLimitLine(limit: item.value, label: item.title)
                ll1.lineWidth           = 1
                ll1.lineDashLengths     = [5,0]
                ll1.lineColor           = UIColor.themeRed
                ll1.labelPosition       = .leftTop
                ll1.valueFont           = UIFont.customFont(ofType: .bold, withSize: 9)
                ll1.valueTextColor      = UIColor.themeBlack
                ll1.yOffset             = 0
                leftAxis.addLimitLine(ll1)
            }
        }
        
        leftAxis.gridLineDashLengths = [0, 0]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        //        let dataPoints  = ["T", "W", "T", "F", "S", "S", "M"]
        //        let values      = ["15","20","10","14","18","17","5"]
        
        self.setScatterChartData(vwScatterChart: vwScatterChart,
                                 xValues: xValues,
                                 yValues: yValues,
                                 color: color,
                                 xCount: xCount)
    }
    
    func setScatterChartData(vwScatterChart: ScatterChartView,
                             xValues : [String],
                             yValues : [[String]],
                             color: UIColor,
                             xCount: Int) {
        
        //        let dataPoints: [String] = self.arrMonth
        var dataEntries: [ChartDataEntry] = []
        for index in 0...xValues.count - 1 {
            let yVals    = yValues[index]
            if yVals.count > 0 {
                for yIndex in 0...yVals.count - 1 {
                    let data1   = ChartDataEntry.init(x: Double(index), y: JSON(yVals[yIndex]).doubleValue)
                    dataEntries.append(data1)
                }
            }
            else {
                let data1   = ChartDataEntry.init(x: Double(index), y: 0)
                dataEntries.append(data1)
            }
        }
        
        let set1 = ScatterChartDataSet(entries: dataEntries, label: "Earning")
        set1.setScatterShape(.circle)
        set1.setColor(color)
        set1.scatterShapeHoleRadius             = 3
        set1.scatterShapeHoleColor              = color
        set1.scatterShapeSize                   = 7
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        //chartData.addDataSet(chartDataSet)
        set1.colors                             = [color]
        set1.highlightColor                     = color
        set1.drawValuesEnabled                  = false
        set1.valueTextColor                     = color
        let chartData                           = ScatterChartData()
        chartData.append(set1)
        chartData.setDrawValues(false)
        vwScatterChart.data                     = chartData
        vwScatterChart.xAxis.valueFormatter     = IndexAxisValueFormatter(values: xValues)
        
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For x axis
        let xAxis                       = vwScatterChart.xAxis
        xAxis.enabled                   = true
        xAxis.drawAxisLineEnabled       = false
        //xAxis.labelCount              = 7//dataPoints.count
        xAxis.labelFont                 = UIFont.customFont(ofType: .medium, withSize: 8)
        xAxis.labelTextColor            = UIColor.themeBlack.withAlphaComponent(1)
        xAxis.labelPosition             = .bottom
        xAxis.granularityEnabled        = true
        xAxis.granularity               = 1
        
        switch xCount {
        case 7:
            xAxis.labelCount = 6
            xAxis.centerAxisLabelsEnabled = false
            break
        case 15:
            xAxis.labelCount = 15
            xAxis.centerAxisLabelsEnabled = false
            break
        case 30:
            xAxis.labelCount = 10
            xAxis.centerAxisLabelsEnabled = false
            break
        case 90:
            xAxis.labelCount = 3
            xAxis.centerAxisLabelsEnabled = true
            break
        case 1:
            xAxis.labelCount = 12
            xAxis.centerAxisLabelsEnabled = false
            break
        default:break
        }
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 1
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.numberStyle           = .decimal
        leftAxisFormatter.maximumFractionDigits = 0
        leftAxisFormatter.negativeSuffix        = ""
        leftAxisFormatter.positiveSuffix        = ""
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For left y axis
        let leftAxis                            = vwScatterChart.leftAxis
        leftAxis.enabled                        = true
        //        leftAxis.valueFormatter                 = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.spaceTop                       = 0.05
        leftAxis.spaceBottom                    = 0.05
        //        leftAxis.granularity                    = 0
        //        leftAxis.axisMinimum                    = 0
        
        //leftAxis.labelCount                     = 5
        leftAxis.forceLabelsEnabled             = true
        leftAxis.labelFont                      = UIFont.customFont(ofType: .medium, withSize: 8)
        leftAxis.labelTextColor                 = UIColor.themeBlack.withAlphaComponent(1)
        leftAxis.labelPosition                  = .outsideChart
        
        //leftAxis.axisMaximum = 200
        //leftAxis.axisMinimum = 0
        
        //        self.marker.chartView = self.chartView
        //        self.chartView.marker = self.marker
        
        vwScatterChart.animate(xAxisDuration: 0, yAxisDuration: 0)
        //        vwBarChart.delegate = self
        vwScatterChart.fitScreen()
        vwScatterChart.extraRightOffset = 10
        
        
        let marker = AppChartMarker.init(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        //        marker.strTitle = self.readingChartDetailModel.xva
        marker.color1           = color
        marker.color2           = color
        marker.chartView        = vwScatterChart
        marker.readingType      = ReadingType.init(rawValue: self.readingListModel.keys ?? "")
        marker.selectedFibroScanType = self.selectedFibroScanType
        marker.offset           = CGPoint.init(x: 0, y: 0)
        vwScatterChart.marker   = marker
    }
}

//MARK: ------------------- set CandleStick chart Method -------------------
extension CarePlanPopupChartManager {
    
    func setCandleStickChart(vwCandleStickChart: CandleStickChartView,
                             xValues : [String],
                             minValues : [String],
                             maxValues : [String],
                             color1: UIColor,
                             color2: UIColor,
                             xCount: Int) {
        
        vwCandleStickChart.isHidden  = false
        
        vwCandleStickChart.clear()
        vwCandleStickChart.isUserInteractionEnabled         = true
        vwCandleStickChart.noDataText                       = ""//"You need to provide data for the chart."
        vwCandleStickChart.pinchZoomEnabled                 = false
        vwCandleStickChart.drawMarkers                      = true
        vwCandleStickChart.doubleTapToZoomEnabled           = false
        vwCandleStickChart.highlightPerTapEnabled           = true
        vwCandleStickChart.highlightPerDragEnabled          = true
        vwCandleStickChart.scaleYEnabled                    = false
        vwCandleStickChart.scaleXEnabled                    = false
        vwCandleStickChart.chartDescription.enabled         = false
        vwCandleStickChart.minOffset                        = 0
        vwCandleStickChart.legend.enabled                   = false
        
        vwCandleStickChart.xAxis.drawGridLinesEnabled       = false
        vwCandleStickChart.xAxis.drawAxisLineEnabled        = false
        vwCandleStickChart.xAxis.drawGridLinesEnabled       = false
        
        vwCandleStickChart.leftAxis.drawGridLinesEnabled    = false
        vwCandleStickChart.leftAxis.drawLabelsEnabled       = true
        vwCandleStickChart.leftAxis.drawAxisLineEnabled     = false
        
        vwCandleStickChart.rightAxis.drawGridLinesEnabled   = false
        vwCandleStickChart.rightAxis.drawLabelsEnabled      = false
        vwCandleStickChart.rightAxis.drawAxisLineEnabled    = false
        vwCandleStickChart.legend.enabled                   = false
        
        vwCandleStickChart.dragEnabled                      = true
        vwCandleStickChart.setScaleEnabled(false)
        vwCandleStickChart.extraTopOffset                   = 10
        vwCandleStickChart.extraBottomOffset                = 7
        vwCandleStickChart.extraRightOffset                 = 7
        vwCandleStickChart.viewPortHandler.setMaximumScaleX(3)
        //        vwCandleStickChart.setViewPortOffsets(left: 35, top: 25, right: 25, bottom: 25)
        
        //        let dataPoints  = ["T", "W", "T", "F", "S", "S", "M"]
        //        let values      = ["15","20","10","14","18","17","5"]
        
        self.setCandleStickData(vwCandleStickChart: vwCandleStickChart,
                                xValues : xValues,
                                minValues : minValues,
                                maxValues : maxValues,
                                color1: color1,
                                color2: color2,
                                xCount: xCount)
    }
    
    func setCandleStickData(vwCandleStickChart: CandleStickChartView,
                            xValues : [String],
                            minValues : [String],
                            maxValues : [String],
                            color1: UIColor,
                            color2: UIColor,
                            xCount: Int){
        
        /*
         let yVals1 = (0..<dataPoints.count).map { (i) -> CandleChartDataEntry in
         let range: Double = 1
         let mult = range + 1
         let val = Double(Double(arc4random_uniform(40)) + mult)
         let high = Double(arc4random_uniform(9) + 8)
         let low = Double(arc4random_uniform(9) + 8)
         let open = Double(arc4random_uniform(6) + 1)
         let close = Double(arc4random_uniform(6) + 1)
         let even = i % 2 == 0
         
         return CandleChartDataEntry(x: Double(i),
         shadowH: val + high,
         shadowL: val - low,
         open: even ? val + open : val - open,
         close: even ? val - close : val + close,
         icon: UIImage(named: "chart_dot")!)
         }
         */
        
        var arrCandleChartDataEntry =  [CandleChartDataEntry]()
        for index in 0...xValues.count - 1 {
            
            let minimumValue    = Double(minValues[index]) ?? 0
            var maximumValue    = Double(maxValues[index]) ?? 0
            
            if minimumValue == maximumValue {
                maximumValue += 1
            }
            
            let obj: CandleChartDataEntry = CandleChartDataEntry(x: Double(index),
                                                                 shadowH: maximumValue,
                                                                 shadowL:minimumValue,
                                                                 open:minimumValue,
                                                                 close:                        maximumValue,
                                                                 icon:UIImage(named: "chart_dot")!)
            
            arrCandleChartDataEntry.append(obj)
        }
        
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For x axis
        let xAxis                       = vwCandleStickChart.xAxis
        xAxis.valueFormatter            = IndexAxisValueFormatter(values: xValues)
        xAxis.enabled                   = true
        xAxis.drawAxisLineEnabled       = false
        //xAxis.labelCount                = 7//dataPoints.count
        xAxis.labelFont                 = UIFont.customFont(ofType: .medium, withSize: 8)
        xAxis.labelTextColor            = UIColor.themeBlack.withAlphaComponent(1)
        xAxis.labelPosition             = .bottom
        xAxis.granularityEnabled        = true
        xAxis.granularity               = 1
        
        switch xCount {
        case 7:
            xAxis.labelCount = 6
            xAxis.centerAxisLabelsEnabled = false
            break
        case 15:
            xAxis.labelCount = 15
            xAxis.centerAxisLabelsEnabled = false
            break
        case 30:
            xAxis.labelCount = 10
            xAxis.centerAxisLabelsEnabled = false
            break
        case 90:
            xAxis.labelCount = 3
            xAxis.centerAxisLabelsEnabled = true
            break
        case 1:
            xAxis.labelCount = 12
            xAxis.centerAxisLabelsEnabled = false
            break
        default:break
        }
        
        let leftAxisFormatter                       = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits     = 1
        leftAxisFormatter.maximumFractionDigits     = 1
        leftAxisFormatter.numberStyle               = .decimal
        leftAxisFormatter.maximumFractionDigits     = 0
        leftAxisFormatter.negativeSuffix            = ""
        leftAxisFormatter.positiveSuffix            = ""
        
        let set1 = CandleChartDataSet(entries: arrCandleChartDataEntry, label: "Data Set")
        set1.axisDependency         = .left
        set1.setColor(UIColor.themePurple)
        set1.drawIconsEnabled       = false
        set1.iconsOffset            = CGPoint.init(x: 0, y: 5)
        set1.shadowColor            = .darkGray
        set1.shadowWidth            = 0
        set1.decreasingColor        = .red
        set1.decreasingFilled       = true
        set1.increasingColor        = color1
        set1.increasingFilled       = true
        set1.neutralColor           = color1
        set1.drawValuesEnabled      = false
        set1.formLineWidth          = CGFloat(0)
        set1.barSpace               = 0.35
        // set1.barCornerRadius        = 3
        set1.drawVerticalHighlightIndicatorEnabled   = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.valueTextColor         = color1
        set1.valueFormatter         = CandleChartValueFormatter(numberFormatter: leftAxisFormatter,
                                                                dataSet: set1,
                                                                dataEntry: arrCandleChartDataEntry)
        
        let data = CandleChartData(dataSet: set1)
        vwCandleStickChart.data = data
        
        
        //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        //----------- For left y axis
        let leftAxis                            = vwCandleStickChart.leftAxis
        leftAxis.enabled                        = true
        //        leftAxis.valueFormatter                 = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.spaceTop                       = 0.1
        leftAxis.spaceBottom                    = 0.1
        leftAxis.granularity                    = 1
        leftAxis.axisMinimum                    = 0
        
        //leftAxis.labelCount                     = 5
        leftAxis.forceLabelsEnabled             = true
        leftAxis.labelFont                      = UIFont.customFont(ofType: .medium, withSize: 8)
        leftAxis.labelTextColor                 = UIColor.themeBlack.withAlphaComponent(1)
        leftAxis.labelPosition                  = .outsideChart
        
        //leftAxis.axisMaximum = 200
        //leftAxis.axisMinimum = 0
        
        //        self.marker.chartView = self.chartView
        //        self.chartView.marker = self.marker
        
        vwCandleStickChart.animate(xAxisDuration: 0, yAxisDuration: 0)
        //vwCandleStickChart.delegate = self
        vwCandleStickChart.fitScreen()
        
        let marker = AppChartMarker.init(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
        //        marker.strTitle = self.readingChartDetailModel.xva
        marker.color1               = color1
        marker.color2               = color1
        marker.chartView            = vwCandleStickChart
        marker.readingType          = ReadingType.init(rawValue: self.readingListModel.keys ?? "")
        marker.selectedFibroScanType = self.selectedFibroScanType
        marker.offset               = CGPoint.init(x: 0, y: 0)
        vwCandleStickChart.marker   = marker
    }
}

extension CarePlanPopupChartManager : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        //        super.chartValueSelected(chartView, entry: entry, highlight: highlight)
        //
        //        chartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
        //                                            axis: chartView.data![highlight.dataSetIndex].axisDependency,
        //                                            duration: 1)
        
        chartView.highlightValues([Highlight(x: entry.x, y: entry.y, dataSetIndex: 0),
                                   Highlight(x: entry.x, y: entry.y, dataSetIndex: 1)])
        
        //        let point = gesture.location(in: chartView)
        //        let highlight = chartView.getHighlightByTouchPoint(point)
        //        chartView.highlightValue(highlight)
        
        //chartView.highlightValue(Highlight(x: highlight.x, y: highlight.y, dataSetIndex: 0))
        
        
        //        chartView.getMarkerPosition(highlight: highlight)
        
    }
}

class CandleChartValueFormatter: NSObject, ValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?
    fileprivate var dataSet: CandleChartDataSet?
    fileprivate var dataEntry: [CandleChartDataEntry]?
    
    convenience init(numberFormatter: NumberFormatter,
                     dataSet: CandleChartDataSet,
                     dataEntry: [CandleChartDataEntry]) {
        self.init()
        self.numberFormatter    = numberFormatter
        self.dataSet            = dataSet
        self.dataEntry          = dataEntry
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        //        guard let numberFormatter = numberFormatter
        //            else {
        //                return ""
        //        }
        //return numberFormatter.string(for: value)!
        
        if let entry = dataEntry?[JSON(entry.x).intValue] {
            let low = String(format:"%0.0f",entry.low)
            let high = String(format:"%0.0f",entry.high)
            
            return "\(low)-\(high)"
        }
        return ""
    }
}

class customValueFormatter: NSObject, AxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String {
        let val         = GFunction.shared.getFattyLiver(value: Int(value),
                                                         arrFattyLiverGrade: GFunction.shared.setArrFattyLiver())
        let strValue1    = val["name"].stringValue
        return strValue1
    }
    
}
