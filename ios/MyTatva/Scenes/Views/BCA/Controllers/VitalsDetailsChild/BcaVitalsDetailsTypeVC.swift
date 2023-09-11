//
//  BcaVitalsDetailsTypeVC.swift
//  MyTatva
//
//  Created by Hyperlink on 10/05/23.
//  Copyright © 2023. All rights reserved.

import UIKit
import Charts

class BcaVitalsDetailsTypeVC: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var vwBG                 : UIView!
    @IBOutlet weak var lblOverAllTitle      : UILabel!
    
    @IBOutlet weak var vwDropDown           : UIView!
    @IBOutlet weak var btnDays              : UIButton!
    @IBOutlet weak var vwOverAllDetail      : UIView!
    @IBOutlet weak var lblValOne            : UILabel!
    @IBOutlet weak var lblLastReading       : UILabel!
    @IBOutlet weak var lblValTwo            : UILabel!
    @IBOutlet weak var lblAverage           : UILabel!
    @IBOutlet weak var lblBy                : UILabel!
    @IBOutlet weak var vwMainSlider         : UIView!
    @IBOutlet weak var svMainSlider         : UIStackView!
    @IBOutlet weak var slider               : UISlider!
    @IBOutlet weak var lblRangeValue        : UILabel!
    @IBOutlet weak var vwMultiColor         : MultiColorView!
    
    @IBOutlet weak var vwAnalysisChart      : UIView!
    @IBOutlet weak var vwLineChart          : LineChartView!
    @IBOutlet weak var lblAnalysisTitle     : UILabel!
    @IBOutlet weak var lblNoDataFound       : UILabel!
    @IBOutlet weak var lblAnalysis          : UILabel!
    @IBOutlet weak var lblAnalysisSubTitle  : UILabel!
    
    
    @IBOutlet weak var lblQuestion          : UILabel!
    @IBOutlet weak var vwAnswer             : UIView!
    @IBOutlet weak var lblAnswer            : UILabel!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var chartObject: ReadingChartDetailModel!
    
    var selectedDay = -1 {
        didSet {
            self.btnDays.setTitle(self.arrSelectionType[self.selectedDay]["name"].stringValue, for: UIControl.State())
        }
    }
    var viewModel: BcaVitalsDetailsTypeViewModel!
    
    var arrSelectionType: [JSON] = [
        [
            "name": "7 Days",
            "type": SelectionType.sevenDays.rawValue,
        ],
        [
            "name": "15 Days",
            "type": SelectionType.fifteenDays.rawValue,
        ],
        [
            "name": "30 Days",
            "type": SelectionType.thirtyDays.rawValue,
        ],
        [
            "name": "90 Days",
            "type": SelectionType.nintyDays.rawValue,
        ],
        [
            "name": "1 Year",
            "type": SelectionType.oneYear.rawValue
        ]
    ]
	
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(BcaVitalsDetailsTypeVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.configureUI()
//        self.setChart()
        self.sliderUI()
        self.manageActionMethods()
        self.setMultiColorView()
    }
    
    private func applyStyle() {
        self.lblOverAllTitle
            .font(name: .bold, size: 17)
            .textColor(color: .themeBlack).text = "Trend Monitor"
        self.lblValOne
            .font(name: .bold, size: 17)
            .textColor(color: .themeBlack).text = nil
        self.lblValTwo
            .font(name: .bold, size: 17)
            .textColor(color: .themeBlack).text = nil
        self.lblLastReading
            .font(name: .light, size: 13)
            .textColor(color: .themeBlack.withAlphaComponent(0.7)).text = "Last Reading"
        self.lblAverage
            .font(name: .light, size: 13)
            .textColor(color: .themeBlack.withAlphaComponent(0.7)).text = "Average Trend"
        self.lblBy
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeGreen).text = nil
        self.lblRangeValue
            .font(name: .light, size: 13)
            .textColor(color: .themeBlack.withAlphaComponent(0.7)).text = nil
        
        self.lblAnalysisTitle
            .font(name: .bold, size: 17)
            .textColor(color: .themeBlack).text = "\(self.viewModel.readingModel.readingName ?? "") Analysis"
        self.lblNoDataFound
            .font(name: .semibold, size: 13)
            .textColor(color: .themePurple).text = "No chart data available."
        self.lblNoDataFound.isHidden = true
        self.lblAnalysis
            .font(name: .semibold, size: 13)
            .textColor(color: .themeBlack).text = "Analysis"
        self.lblAnalysisSubTitle
            .font(name: .regular, size: 11)
            .textColor(color: .themeBlack.withAlphaComponent(0.7)).text = nil
        self.lblQuestion
            .font(name: .bold, size: 17)
            .textColor(color: .themeBlack).text = "What is \(self.viewModel.readingModel.readingName ?? "")?"
        self.lblAnswer
            .font(name: .regular, size: 11)
            .textColor(color: .themeBlack.withAlphaComponent(0.7)).text = nil
        self.btnDays
            .font(name: .medium, size: 11)
            .textColor(color: .themeGray)
    }
    
    func configureUI(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwAnswer
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.ThemeLightGray2, borderWidth: 1)
            self.vwDropDown
                .cornerRadius(cornerRadius: 8)
                .borderColor(color: UIColor.themeGray3.withAlphaComponent(0.5), borderWidth: 1)
            self.vwAnalysisChart
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.ThemeLightGray2, borderWidth: 1)
            self.vwOverAllDetail
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.ThemeLightGray2, borderWidth: 1)
        }
    }
    
    func sliderUI() {
//        self.slider.thumbTintColor = UIColor.themeNormal
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwMainSlider.cornerRadius(cornerRadius: self.vwMainSlider.frame.height / 2).backgroundColor = UIColor.ThemeLightGray2
            self.svMainSlider.cornerRadius(cornerRadius: self.vwMainSlider.frame.height / 2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if #available(iOS 14.0, *) {
                self.slider.subviews.first?.subviews[2].borderColor(color: .white, borderWidth: 3)
                self.slider.subviews.first?.subviews[2].cornerRadius(cornerRadius: (self.slider.subviews.first?.subviews[2].frame.height ?? 30) / 2, clips: false)
            }
            else{
                self.slider.subviews[2].borderColor(color: .white, borderWidth: 3)
                self.slider.subviews[2].cornerRadius(cornerRadius: self.slider.subviews[2].frame.height / 2, clips: false)
            }
        }
        
    }
    
    func setMultiColorView() {
        self.vwMultiColor.colors = [.themeLow, .themeNormal, .themeDanger, .themeBlack]
        self.vwMultiColor.values = [ 0.20, 0.30, 0.30, 0.20]
    }
    
    func setChart() {
//
//        CarePlanPopupChartManager.shared.readingChartDetailModel    =
        CarePlanPopupChartManager.shared.readingListModel.keys           =  self.viewModel.readingModel.keys
        
        let xValues = self.chartObject.readingsData.compactMap({ data -> String in
            return data.xValue
        })
        let yValues = self.chartObject.readingsData.compactMap({ data -> String in
            return "\(data.readingValue ?? 0.0)"
        })
        
        var xCount = 0
        switch SelectionType(rawValue: self.arrSelectionType[self.selectedDay]["type"].stringValue) {
        case .sevenDays:
            xCount = 7
            break
        case .fifteenDays:
            xCount = 15
            break
        case .thirtyDays:
            xCount = 30
            break
        case .nintyDays:
            xCount = 90
            break
        case .oneYear:
            xCount = 1
            break
        case .none:
            break
        }
        
        var arrChartLine    = [ChartLimitLineModel]()
        if let val = Double(self.chartObject.standardMax.trim()) {
            let obj1            = ChartLimitLineModel()
            obj1.title          = "Max"
            obj1.value          = val
            arrChartLine.append(obj1)
        }
        if let val = Double(self.chartObject.standardMin.trim()) {
            let obj1            = ChartLimitLineModel()
            obj1.title          = "Min"
            obj1.value          = val
            arrChartLine.append(obj1)
        }
        
        let color1 = UIColor.hexStringToUIColor(hex: self.chartObject.colorCode1)
        let color2 = UIColor.hexStringToUIColor(hex: self.chartObject.colorCode2)
        CarePlanPopupChartManager.shared.setLineChart(
            vwLineChart: self.vwLineChart,
            xValues: xValues,
            yValues: yValues,
            yValues2: [""],
            color1: color1,
            color2: color2,
            isMultiLineChart: false,
            isShowLimit: true,
            arrLimitLine: arrChartLine,
            xCount: xCount)
    }
    
    private func setupViewModelObserver() {
        
        self.viewModel.isResult.bind { [weak self] result in
            guard let self = self, let result = result else { return }
            self.lblValOne.text = result.lastReading
            
            let normalRange = result.bcaStandardValues.first(where: { $0.label == BCAVitalRange.Normal.rawValue})
            self.lblRangeValue.text = "Normal : \(String(format: "%.1f", Float((normalRange?.from ?? 0.0)))) - \(String(format: "%.1f", Float((normalRange?.to ?? 0.0)))) " + self.viewModel.readingModel.measurements
            
            let arrSortedRange = result.bcaStandardValues.sorted(by: { $0.to < $1.to })
            self.vwMultiColor.colors = result.bcaStandardValues.compactMap({ range -> UIColor in
                return range.color //(BCAVitalRange(rawValue: range.label) ?? .Low).bgColor
            })
            
            let lastReading = Float(Darwin.round(JSON(result.lastReading as Any).doubleValue * 10) / 10) //JSON(result.lastReading as Any).floatValue
            if let firstRange = arrSortedRange.first,lastReading < firstRange.from {
                self.slider.thumbTintColor = firstRange.color
                self.slider.value = 0
                self.slider.isHidden = false
                self.sliderUI()
            }else if let lastRange = arrSortedRange.last, lastReading > lastRange.to {
                self.slider.thumbTintColor = lastRange.color
                self.slider.value = 100
                self.slider.isHidden = false
                self.sliderUI()
            }
            
            var startingFrom = arrSortedRange.first?.from ?? 0.0
            let endingTo = (arrSortedRange.last?.to ?? 0.0) - startingFrom
            
            self.vwMultiColor.values = arrSortedRange.compactMap { range -> CGFloat in
                let diffrence = range.to - startingFrom
                startingFrom = range.to
                if (lastReading >= range.from) && (lastReading <= range.to) {
                    self.slider.thumbTintColor = range.color
                    self.slider.value = (((lastReading - (arrSortedRange.first?.from ?? 0.0)) * 100)/endingTo) //((lastReading * 100)/(arrSortedRange.last?.to ?? 0.0))
                    self.slider.isHidden = false
                    self.sliderUI()
                }
                
                return CGFloat((diffrence * 100)/endingTo)/100
            }
            
            self.vwMainSlider.isHidden = false
            
            if result.lastReading.isEmpty {
                self.lblValOne.text              = "-"
            }else {
                
                guard let object = self.viewModel.readingModel else { return }
                object.readingValue = result.lastReading
                object.reading = JSON(result.lastReading as Any).doubleValue
                
                GFunction.shared.setReadingData(obj: object, lblReading: self.lblValOne)
            }
            
//            self.lblValTwo.text = result.a
            let isIncreased = result.increasedBy > 0.0
            let increasedBy = String(format: "%.2f", Float((result.increasedBy ?? 0.0)))
            self.lblBy.textColor(color: isIncreased ? .themeNormal : BCAVitalRange.TooHigh.bgColor).text = (isIncreased ? "↑" : "↓") + " by \(increasedBy.replacingOccurrences(of: "-", with: ""))"
            self.lblBy.isHidden = JSON(increasedBy as Any).doubleValue == 0.0
            self.lblAnswer.text = result.information
            
            [
                self.vwMainSlider,self.lblRangeValue,self.slider
            ].forEach({ $0?.isHidden = (ReadingType(rawValue: self.viewModel.readingModel.keys) ?? .BaselMetabolicRate) == .BaselMetabolicRate })
            
            guard let trendGraph = result.trendGraph else {
                self.lblValTwo.text = "0"
                self.lblNoDataFound.isHidden = false
                self.vwLineChart.isHidden = true
                return
            }
            
            self.lblNoDataFound.isHidden = true
            self.vwLineChart.isHidden = false
            
            self.lblValTwo.text = String(format: "%.2f", Float(trendGraph.average.readingValue))
            self.chartObject = trendGraph
            self.setChart()
            
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    fileprivate func manageActionMethods(){
        self.vwDropDown.addTapGestureRecognizer {
            let dropDown = DropDown()
            DropDown.appearance().textColor = UIColor.themeBlack
            DropDown.appearance().selectedTextColor = UIColor.themeBlack
            DropDown.appearance().textFont = UIFont.customFont(ofType: .medium, withSize: 14)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.white
            DropDown.appearance().cellHeight = 40
            
            dropDown.anchorView = self.vwDropDown
            
            let arr: [String] = self.arrSelectionType.map { (obj) -> String in
                return obj["name"].stringValue
            }
            
            dropDown.dataSource = arr
            dropDown.selectionAction = { [weak self] (index, str) in
                guard let self = self else { return }
                self.selectedDay = index
                self.vwMainSlider.isHidden = true
                self.slider.isHidden = true
                self.viewModel.getVitalTrendAnalysis(self.arrSelectionType[self.selectedDay]["type"].stringValue)
                dropDown.hide()
                
                var params = [String:Any]()
                params[AnalyticsParameters.module.rawValue] = kBCA
                params[AnalyticsParameters.date_range_value.rawValue] = self.arrSelectionType[self.selectedDay]["name"].stringValue
                FIRAnalytics.FIRLogEvent(eventName: .USER_CHANGES_DATE_RANGE,
                                         screen: .SmartScaleReadingAnalysis,
                                         parameter: params)
            }
            dropDown.show()
        }
    }
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = BcaVitalsDetailsTypeViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        self.setupViewModelObserver()
        self.selectedDay = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwMainSlider.isHidden = true
        self.slider.isHidden = true
        self.viewModel.getVitalTrendAnalysis(self.arrSelectionType[self.selectedDay]["type"].stringValue)
        WebengageManager.shared.navigateScreenEvent(screen: .SmartScaleReadingAnalysis)
    }

}
