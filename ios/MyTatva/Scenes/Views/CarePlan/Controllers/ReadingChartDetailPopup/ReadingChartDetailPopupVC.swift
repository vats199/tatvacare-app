//
//  PheromonePopupVC.swift
//

//

import UIKit
import Charts

class ReadingChartDetailPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblTitleDesc         : UILabel!
    @IBOutlet weak var btnSelectGoalType    : UIButton!
    @IBOutlet weak var btnSelectFibroScanType: UIButton!
    
    @IBOutlet weak var lblNoData            : UILabel!
    
    @IBOutlet weak var vwBarChart           : BarChartView!
    @IBOutlet weak var vwLineChart          : LineChartView!
    @IBOutlet weak var vwCandleStickChart   : CandleStickChartView!
    @IBOutlet weak var vwScatterChart       : ScatterChartView!
    
    
    @IBOutlet weak var lblReading1          : UILabel!
    @IBOutlet weak var lblReadingValue1     : UILabel!
    @IBOutlet weak var lblReadingDateTime1  : UILabel!
   
    @IBOutlet weak var lblReading2          : UILabel!
    @IBOutlet weak var lblReadingValue2     : UILabel!
    @IBOutlet weak var lblReadingDateTime2  : UILabel!
    
    @IBOutlet weak var btnLog               : UIButton!
    @IBOutlet weak var btnCancelTop         : UIButton!
    
    
    //MARK:- Class Variable
    
    var goalType: GoalType              = .Exercise
    
    
    var selectedIndex : Int             = 0
    var arrReadingList                  = [ReadingListModel]()
    var readingListModel                = ReadingListModel()
    var object                          = ReadingChartDetailModel()
    var readingChartValueVw             = UIView()
    var isNext                          = false
    
    var summarySelectionType: SelectionType     = .sevenDays
    var selectedFibroScanType: FibroScanType    = .LSM
    
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
            "type": SelectionType.oneYear.rawValue,
        ],
//        [
//            "name": "All time",
//            "type": SelectionType.allTime.rawValue,
//        ]
    ]
    
    var arrFibroScanType: [JSON] = [
        [
            "name": "LSM",
            "type": FibroScanType.LSM.rawValue,
        ],
        [
            "name": "CAP",
            "type": FibroScanType.CAP.rawValue,
        ]
    ]
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
//        self.readingChartValueVw = ReadingChartValueVw.instanceFromNib()
//        self.readingChartValueVw.cornerRadius(cornerRadius: 5)
//        self.readingChartValueVw.themeShadow()
//        self.readingChartValueVw.frame = CGRect(x: self.vwLineChart.frame.origin.x, y: self.vwLineChart.frame.origin.y, width: 120, height: 50)
//        self.view.addSubview(self.readingChartValueVw)
        
        self.vwBg.animateBounce()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
        self.readingListModel = self.arrReadingList[self.selectedIndex]
        self.updateData()
        
        //self.setupHero()
    }
    
    fileprivate func configureUI(){
        self.lblTitle.font(name: .bold, size: 22)
            .textColor(color: UIColor.themeBlack)
        self.lblTitleDesc.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
     
        self.lblNoData.font(name: .semibold, size: 14).textColor(color: .themePurple)
        
        self.lblReading1.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.lblReadingValue1.font(name: .bold, size: 35)
            .textColor(color: UIColor.themeBlack)
        self.lblReadingDateTime1.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)
        
        self.lblReading2.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.lblReadingValue2.font(name: .bold, size: 35)
            .textColor(color: UIColor.themeBlack)
        self.lblReadingDateTime2.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)
            
        self.btnLog.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        self.btnSelectGoalType
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        self.btnSelectFibroScanType
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnLog.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnLog
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
    
    private func setupHero(){
        self.hero.isEnabled         = false
        self.vwBg.hero.id           = "cell"
        self.vwBg.hero.modifiers    = [.translate(y:100)]
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func updateData(){
        self.vwLineChart.isHidden           = true
        self.vwBarChart.isHidden            = true
        self.vwCandleStickChart.isHidden    = true
        self.vwScatterChart.isHidden        = true
        
        self.imgTitle.isHidden = true
        self.lblTitle.text = self.readingListModel.readingName
        self.btnLog.setTitle(AppMessages.log + " " + self.readingListModel.readingName, for: .normal)
        
        self.lblTitleDesc.text              = ""
        
        self.lblReading1.isHidden           = true
        self.lblReadingValue1.isHidden      = true
        self.lblReadingDateTime1.isHidden   = true
        
        self.lblReading2.isHidden           = true
        self.lblReadingValue2.isHidden      = true
        self.lblReadingDateTime2.isHidden   = true
        self.btnSelectFibroScanType.isHidden = true
        
        self.lblNoData.isHidden             = true
        GlobalAPI.shared.get_reading_recordsAPI(reading_id: self.readingListModel.readingsMasterId, reading_time: self.summarySelectionType) { [weak self] (isDone, obj, msg) in
            guard let self = self else {return}
            
            if isDone {
                self.lblReading1.isHidden           = false
                self.lblReadingValue1.isHidden      = false
                self.lblReadingDateTime1.isHidden   = false
                
                self.object = obj
                self.setData()
                
            }
            else {
                self.lblNoData.isHidden             = false
                self.lblNoData.text                 = msg
                //self.dismissPopUp(true, objAtIndex: nil)
            }
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = self.completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
           sendData()
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            let object = JSON()
            self.dismissPopUp(true, objAtIndex: object)
        }
        
        self.btnLog.addTapGestureRecognizer {
            
            //for reading
            self.dismiss(animated: true) {
                if self.readingListModel.notConfigured.trim() != "" {
                    Alert.shared.showSnackBar(self.readingListModel.notConfigured)
                }
                else {
                    PlanManager.shared.isAllowedByPlan(type: .reading_logs,
                                                       sub_features_id: self.readingListModel.keys,
                                                       completion: { isAllow in
                        
                        if isAllow {
                            if let type = ReadingType.init(rawValue: self.readingListModel.keys) {
                                if type == .cat {
                                    GlobalAPI.shared.get_cat_surveyAPI { [weak self] (isDone, object, id) in
                                        guard let self = self else {return}
                                        if isDone {
                                            SurveySparrowManager.shared.startSurveySparrow(token: object.surveyId)
                                            SurveySparrowManager.shared.completionHandler = { Response in
                                                print(Response as Any)
                                                
                                                GlobalAPI.shared.add_cat_surveyAPI(cat_survey_master_id: object.catSurveyMasterId,
                                                                                   survey_id: object.surveyId,
                                                                                   Score: String(Response!["score"] as? Int ?? 0), response: Response!["response"] as! [[String: Any]]) { (isDone, msg) in
                                                    
                                                    if isDone {
                                                        var params = [String: Any]()
                                                        params[AnalyticsParameters.reading_name.rawValue]   = self.readingListModel.readingName
                                                        params[AnalyticsParameters.reading_id.rawValue]     = self.readingListModel.readingsMasterId
                                                        
                                                        FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                                                                 screen: .LogReading,
                                                                                 parameter: params)
                                                    }
                                                    let object = JSON()
                                                    self.dismissPopUp(true, objAtIndex: object)
                                                }
                                            }
                                        }
                                    }
                                }
                                else {
                                    let vc = UpdateReadingParentVC.instantiate(fromAppStoryboard: .goal)
                                    vc.selectedIndex = self.selectedIndex
                                    vc.arrList = self.arrReadingList
                                    vc.modalPresentationStyle = .overFullScreen
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.completionHandler = { obj in
                                        
                                        let object = JSON()
                                        self.dismissPopUp(true, objAtIndex: object)
                                        if obj?.count > 0 {
                                            print(obj ?? "")
                                            //object
                                        }
                                    }
                                    let nav = UINavigationController(rootViewController: vc)
                                    UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
                                }
                            }
                        }
                        else {
                            PlanManager.shared.alertNoSubscription()
                        }
                    })
                }
            }
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            let object = JSON()
            self.dismissPopUp(true, objAtIndex: object)
        }
        
        self.btnSelectGoalType.addTapGestureRecognizer {
            let dropDown = DropDown()
            DropDown.appearance().textColor = UIColor.themeBlack
            DropDown.appearance().selectedTextColor = UIColor.themeBlack
            DropDown.appearance().textFont = UIFont.customFont(ofType: .medium, withSize: 14)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.white
            DropDown.appearance().cellHeight = 40
            
            dropDown.anchorView = self.btnSelectGoalType
            
            let arr: [String] = self.arrSelectionType.map { (obj) -> String in
                return obj["name"].stringValue
            }
            
            dropDown.dataSource = arr
            dropDown.selectionAction = { (index, str) in
                
                let type = SelectionType.init(rawValue: self.arrSelectionType[index]["type"].stringValue) ?? .sevenDays
                
                var params = [String:Any]()
                var screenName = ScreenName.ReadingChart.rawValue
                screenName += self.readingListModel.keys
                params[AnalyticsParameters.module.rawValue] = kCarePlan
                params[AnalyticsParameters.date_range_value.rawValue] = self.arrSelectionType[index]["name"].stringValue
                FIRAnalytics.FIRLogEvent(eventName: .USER_CHANGES_DATE_RANGE,
                                         customScreenName: screenName,
                                         parameter: params)
                
                self.summarySelectionType = type
                self.btnSelectGoalType.setTitle(str, for: .normal)
                
                self.updateData()
                
                dropDown.hide()
            }
            dropDown.show()
        }
        
        self.btnSelectFibroScanType.addTapGestureRecognizer {
            let dropDown = DropDown()
            DropDown.appearance().textColor = UIColor.themeBlack
            DropDown.appearance().selectedTextColor = UIColor.themeBlack
            DropDown.appearance().textFont = UIFont.customFont(ofType: .medium, withSize: 14)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.white
            DropDown.appearance().cellHeight = 40
            
            dropDown.anchorView = self.btnSelectFibroScanType
            
            let arr: [String] = self.arrFibroScanType.map { (obj) -> String in
                return obj["name"].stringValue
            }
            
            dropDown.dataSource = arr
            dropDown.selectionAction = { (index, str) in
                
                let type = FibroScanType.init(rawValue: self.arrFibroScanType[index]["type"].stringValue) ?? .LSM
                
                self.selectedFibroScanType = type
                self.btnSelectFibroScanType.setTitle(str, for: .normal)
                self.setData()
                
                dropDown.hide()
            }
            dropDown.show()
        }
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
//MARK: ------------------ setData Methods ------------------
extension ReadingChartDetailPopupVC {
    
    fileprivate func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .ReadingChart, postFix: self.readingListModel.keys)
        
        self.vwLineChart.isHidden           = true
//        self.vwLineChart.delegate           = self
        self.vwBarChart.isHidden            = true
        self.vwCandleStickChart.isHidden    = true
        self.vwScatterChart.isHidden        = true
        //FOR READING
        CarePlanPopupChartManager.shared.readingChartDetailModel    = self.object
        CarePlanPopupChartManager.shared.selectedFibroScanType      = self.selectedFibroScanType
        CarePlanPopupChartManager.shared.readingListModel           = self.readingListModel
        
        let type = ReadingType.init(rawValue: self.readingListModel.keys) ?? .ACR
        
        let date = GFunction.shared.convertDateFormate(dt: self.object.lastReadingDate,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        let time = GFunction.shared.convertDateFormate(dt: self.object.lastReadingDate,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                       status: .NOCONVERSION)
        
        self.lblReadingDateTime1.text   = time.0 + " " + AppMessages.on + " " + date.0
        self.lblReadingDateTime2.text   = time.0 + " " + AppMessages.on + " " + date.0
        
        ///Set last reading values
        let readingValue1: String    = "\(self.readingListModel.readingValue ?? 0)"
        var strLastReading1          = readingValue1 + " " +  self.readingListModel.measurements
        var strLastReading2          = ""
        func commonReadingValue(){
            let value       = JSON(readingValue1).intValue
            strLastReading1  = "\(value)" + " " + self.readingListModel.measurements
        }
        
        func setCommonDesc(){
            switch self.summarySelectionType {
            case .sevenDays:
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 7 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
                
                break
                
            case .fifteenDays:
                self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 15 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
                
            case .thirtyDays:
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 30 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
                
                break
            case .nintyDays:
               
                self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 90 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
                
                break
            case .oneYear:
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 1 \(AppMessages.yearIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
                
                break
//            case .allTime:
//
//                self.lblTitleDesc.text = "\(AppMessages.average) \(self.readingListModel.readingName!) \(AppMessages.readingForAllTimeIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
//
//                break
            }
        }
        
        var xValues         = [String]()
        var yValues         = [String]()
        var yValues2        = [String]()
        let color1          = UIColor.hexStringToUIColor(hex: self.object.colorCode1)
        let color2          = UIColor.hexStringToUIColor(hex: self.object.colorCode2)
        
        self.lblReadingValue1.font(name: .bold, size: 35)
            .textColor(color: color1)
        self.lblReadingValue2.font(name: .bold, size: 35)
            .textColor(color: color2)
        
        for item in self.object.readingsData {
            xValues.append(item.xValue)
            yValues.append("\(item.readingValue!)")
        }
        
        func updateLastReadingUI(text1: String,
                                 text2: String,
                                 measurements: String){
            ///This is to update UI of Font on the last reading value
            let defaultDicDesc1 : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 18),
                NSAttributedString.Key.foregroundColor : color1 as Any
            ]
            let attributeDicDesc1 : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 9),
                NSAttributedString.Key.foregroundColor : color1,
            ]
            
            self.lblReading1.text                       = text1
            self.lblReadingValue1.attributedText        = strLastReading1.getAttributedText(defaultDic: defaultDicDesc1, attributeDic: attributeDicDesc1, attributedStrings: [measurements])
            
            let defaultDicDesc2 : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 18),
                NSAttributedString.Key.foregroundColor : color2 as Any
            ]
            let attributeDicDesc2 : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 9),
                NSAttributedString.Key.foregroundColor : color2,
            ]
            
            self.lblReading2.text                       = text2
            self.lblReadingValue2.attributedText        = strLastReading2.getAttributedText(defaultDic: defaultDicDesc2, attributeDic: attributeDicDesc2, attributedStrings: [measurements])
        }
        
        //SET CHART DATA
        switch type {

        case .SPO2:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
        
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
                //                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                                  xValues: xValues,
//                                                                  yValues: yValues,
//                                                                  color: color1)
                break
            case .fifteenDays:
                xCount = 15
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
              
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .PEF:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false,
//                    isShowLimit: false,
//                    minLimit: 0,
//                    maxLimit: 0)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false,
//                    isShowLimit: false,
//                    minLimit: 0,
//                    maxLimit: 0)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .BloodPressure:
            
            //For last value
            let value1 = JSON(self.readingListModel.readingValueData.systolic ?? 0).intValue
            let value2 = JSON(self.readingListModel.readingValueData.diastolic ?? 0).intValue
            
            
            strLastReading1  = "\(value1)" + " " + self.readingListModel.measurements
            strLastReading2  = "\(value2)" + " " + self.readingListModel.measurements
            
            //FOR Avg msg
            let strAvgReadingMsg1   = AppMessages.lastReading + " "
            + AppMessages.Systolic
            + ":"
            let strAvgReadingMsg2   = AppMessages.lastReading + " "
            + AppMessages.Diastolic
            + ":"
            
            updateLastReadingUI(text1: strAvgReadingMsg1,
                                text2: strAvgReadingMsg2,
                                measurements: self.readingListModel.measurements)
            
            xValues.removeAll()
            yValues.removeAll()
            yValues2.removeAll()
            for item in self.object.readingsData {
                xValues.append(item.xValue)
                yValues.append("\(item.systolic!)")
                yValues2.append("\(item.diastolic!)")
            }
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.diastolicStandardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max Diastolic"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.diastolicStandardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min Diastolic"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.systolicStandardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min Systolic"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.systolicStandardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max Systolic"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: yValues2,
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: true)
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.Systolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.systolic))) \(AppMessages.and) \(AppMessages.Diastolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.diastolic))) \(AppMessages.inTheLast) 7 \(AppMessages.kDays)"
                
                break
            case .fifteenDays:
                xCount = 15
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.Systolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.systolic))) \(AppMessages.and) \(AppMessages.Diastolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.diastolic))) \(AppMessages.inTheLast) 15 \(AppMessages.kDays)"
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: yValues2,
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: true)
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.Systolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.systolic))) \(AppMessages.and) \(AppMessages.Diastolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.diastolic))) \(AppMessages.inTheLast) 30 \(AppMessages.kDays)"
                
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: yValues2,
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: true)
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.Systolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.systolic))) \(AppMessages.and) \(AppMessages.Diastolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.diastolic))) \(AppMessages.inTheLast) 90 \(AppMessages.kDays)"
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: yValues2,
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: true)
                
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.Systolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.systolic))) \(AppMessages.and) \(AppMessages.Diastolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.diastolic))) \(AppMessages.inTheLast) 1 \(AppMessages.year)"
                
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: yValues2,
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: true)
//
//                self.lblTitleDesc.text = "\(AppMessages.average) \(AppMessages.Diastolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.diastolic))) \(AppMessages.and) \(AppMessages.Systolic) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.systolic))) \(AppMessages.forAllTime)"
//                break
            }
            
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: yValues2,
                color1: color1,
                color2: color2,
                isMultiLineChart: true,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            self.lblReading2.isHidden           = false
            self.lblReadingValue2.isHidden      = false
            self.lblReadingDateTime2.isHidden   = false
            break
        case .HeartRate:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            xValues.removeAll()
            yValues.removeAll()
            yValues2.removeAll()
            var yVals = [[String]]()
            for item in self.object.readingsData {
                xValues.append(item.xValue)
                yValues.append("\(item.readingValueMin!)")
                yValues2.append("\(item.readingValueMax!)")
                yVals.append(item.reading_values)
            }
            
//            CarePlanPopupChartManager.shared.setCandleStickChart(vwCandleStickChart: self.vwCandleStickChart,
//                                                                 xValues: xValues,
//                                                                                              minValues: yValues,
//                                                                 maxValues: yValues2,
//                                                                 color1: color1,
//                                                                 color2: color2)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            
            var xCount = 0
            switch self.summarySelectionType {
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
//            case .allTime:
//                break
            }
            CarePlanPopupChartManager.shared.setScatterChart(vwScatterChart: self.vwScatterChart,
                                                             xValues: xValues,
                                                             yValues: yVals,
                                                             color: color1,
                                                             isShowLimit: self.object.thresholdShow == "N" ? false : true,
                                                             arrLimitLine: arrChartLine,
                                                             xCount: xCount)
            
            break
        case .BodyWeight:
            let value = JSON(readingValue1).doubleValue
            strLastReading1 = String(format: "%0.1f", value) + " " + self.readingListModel.measurements
            
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
              break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .BMI:
            let value = JSON(readingValue1).doubleValue
            strLastReading1 = String(format: "%0.1f", value) + " " + self.readingListModel.measurements
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
        
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
              break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .BloodGlucose:
            
            //For last value
            let value1 = JSON(self.readingListModel.readingValueData.fast ?? 0).intValue
            let value2 = JSON(self.readingListModel.readingValueData.pp ?? 0).intValue
            
            strLastReading1  = "\(value1)" + " " + self.readingListModel.measurements
            strLastReading2  = "\(value2)" + " " + self.readingListModel.measurements
            
            let strAvgReadingMsg1   = AppMessages.lastReading + " "
            + AppMessages.fastBloodGlucose
            + ":"
            let strAvgReadingMsg2   = AppMessages.lastReading + " "
            + AppMessages.kPPBloodGlucose
            + ":"

            updateLastReadingUI(text1: strAvgReadingMsg1,
                                text2: strAvgReadingMsg2,
                                measurements: self.readingListModel.measurements)

            xValues.removeAll()
            yValues.removeAll()
            yValues2.removeAll()
            for item in self.object.readingsData {
                xValues.append(item.xValue)
                yValues.append("\(item.fast!)")
                yValues2.append("\(item.pp!)")
            }
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.fastStandardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max Fast"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.fastStandardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min Fast"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.ppStandardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max PP"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.ppStandardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min PP"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
        
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.fastBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.fast))) \(AppMessages.and) \(AppMessages.kPPBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.pp))) \(AppMessages.inTheLast) 7 \(AppMessages.kDays)"
                
                break
            case .fifteenDays:
                xCount = 15
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.fastBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.fast))) \(AppMessages.and) \(AppMessages.kPPBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.pp))) \(AppMessages.inTheLast) 15 \(AppMessages.kDays)"
              break
            case .thirtyDays:
                xCount = 30
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.fastBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.fast))) \(AppMessages.and) \(AppMessages.kPPBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.pp))) \(AppMessages.inTheLast) 30 \(AppMessages.kDays)"
                
                break
            case .nintyDays:
                xCount = 90
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.fastBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.fast))) \(AppMessages.and) \(AppMessages.kPPBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.pp))) \(AppMessages.inTheLast) 90 \(AppMessages.kDays)"
                break
            case .oneYear:
                xCount = 1
                self.lblTitleDesc.text = "\(AppMessages.Average) \(AppMessages.fastBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.fast))) \(AppMessages.and) \(AppMessages.kPPBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.pp))) \(AppMessages.inTheLast) 1 \(AppMessages.year)"
                
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: yValues2,
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: true)
//
//                self.lblTitleDesc.text = "\(AppMessages.average) \(AppMessages.fastBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.fast))) \(AppMessages.and) \(AppMessages.kPPBloodGlucose) \(AppMessages.kIs) \(String(format: "%.2f", Float(self.object.average.pp))) \(AppMessages.forAllTime)"
//                break
            }
            
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: yValues2,
                color1: color1,
                color2: color2,
                isMultiLineChart: true,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            self.lblReading2.isHidden           = false
            self.lblReadingValue2.isHidden      = false
            self.lblReadingDateTime2.isHidden   = false
            
            break
        case .HbA1c,.MuscleMass,.SubcutaneousFat,.VisceralFat,.BoneMass:
            
            //for last value
            let value = JSON(readingValue1).doubleValue
            strLastReading1 = String(format: "%0.1f", value) + " " + self.readingListModel.measurements

            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .ACR:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .eGFR:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .FEV1Lung:
            let value = JSON(readingValue1).doubleValue
            strLastReading1 = "\(value.floorToPlaces(places: 2))" + " " + self.readingListModel.measurements
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
            
        case .cat:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .six_min_walk:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .fifteenDays:
                xCount = 15
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .fibro_scan:
            self.btnSelectFibroScanType.isHidden = false
            commonReadingValue()
            setCommonDesc()
            
            xValues.removeAll()
            yValues.removeAll()
            
            let arr = self.readingListModel.measurements.components(separatedBy: ",")
            switch self.selectedFibroScanType {
            case .LSM:
                for item in self.object.readingsData {
                    xValues.append(item.xValue)
                    yValues.append("\(item.lsm!)")
                }
                
                let value1 = JSON(self.readingListModel.readingValueData.lsm ?? 0).doubleValue
                if arr.count > 0 {
                    strLastReading1  = String(format: "%0.1f", value1) + " " + arr[0]
                }
                
                updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                    text2: AppMessages.lastReading + ":",
                                    measurements: arr[0])
                
                var arrChartLine    = [ChartLimitLineModel]()
                if let val = Double(self.object.lsmStandardMax.trim()) {
                    let obj1            = ChartLimitLineModel()
                    obj1.title          = "Max"
                    obj1.value          = val
                    arrChartLine.append(obj1)
                }
                if let val = Double(self.object.lsmStandardMin.trim()) {
                    let obj1            = ChartLimitLineModel()
                    obj1.title          = "Min"
                    obj1.value          = val
                    arrChartLine.append(obj1)
                }
                
                var xCount = 0
                switch self.summarySelectionType {
                case .sevenDays:
                    xCount = 7
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 7 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.lsm)))"
                    
                    break
                case .fifteenDays:
                    xCount = 15
    //                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
    //                                                             xValues: xValues,
    //                                                             yValues: yValues,
    //                                                             color: color1)
                    break
                case .thirtyDays:
                    xCount = 30
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 30 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.lsm)))"
                    
                    break
                case .nintyDays:
                    xCount = 90
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 90 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.lsm)))"
                    
                    break
                case .oneYear:
                    xCount = 1
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 1 \(AppMessages.yearIs) \(String(format: "%.2f", Float(self.object.average.lsm)))"
                    
                    break
    //            case .allTime:
    //
    //                self.lblTitleDesc.text = "\(AppMessages.average) \(self.readingListModel.readingName!) \(AppMessages.readingForAllTimeIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
    //
    //                break
                }
                
                CarePlanPopupChartManager.shared.setLineChart(
                    vwLineChart: self.vwLineChart,
                    xValues: xValues,
                    yValues: yValues,
                    yValues2: [""],
                    color1: color1,
                    color2: color2,
                    isMultiLineChart: false,
                    isShowLimit: self.object.thresholdShow == "N" ? false : true,
                    arrLimitLine: arrChartLine,
                    xCount: xCount)
                break
            case .CAP:
                for item in self.object.readingsData {
                    xValues.append(item.xValue)
                    yValues.append("\(item.cap!)")
                }
                
                let value1 = JSON(self.readingListModel.readingValueData.cap ?? 0).intValue
                if arr.count > 0 {
                    strLastReading1  = "\(value1)" + " " + arr[1]
                }
                updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                    text2: AppMessages.lastReading + ":",
                                    measurements: arr[1])
                
                var arrChartLine    = [ChartLimitLineModel]()
                if let val = Double(self.object.capStandardMax.trim()) {
                    let obj1            = ChartLimitLineModel()
                    obj1.title          = "Max"
                    obj1.value          = val
                    arrChartLine.append(obj1)
                }
                if let val = Double(self.object.capStandardMin.trim()) {
                    let obj1            = ChartLimitLineModel()
                    obj1.title          = "Min"
                    obj1.value          = val
                    arrChartLine.append(obj1)
                }
                
                var xCount = 0
                switch self.summarySelectionType {
                case .sevenDays:
                    xCount = 7
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 7 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.cap)))"
                    
                    break
                case .fifteenDays:
                    xCount = 15
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 15 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.cap)))"
                    break
                case .thirtyDays:
                    xCount = 30
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 30 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.cap)))"
                    
                    break
                case .nintyDays:
                    xCount = 90
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 90 \(AppMessages.daysIs) \(String(format: "%.2f", Float(self.object.average.cap)))"
                    
                    break
                case .oneYear:
                    xCount = 1
                    self.lblTitleDesc.text = "\(AppMessages.Average) \(self.readingListModel.readingName!) \(AppMessages.readingInTheLast) 1 \(AppMessages.yearIs) \(String(format: "%.2f", Float(self.object.average.cap)))"
                    
                    break
    //            case .allTime:
    //
    //                self.lblTitleDesc.text = "\(AppMessages.average) \(self.readingListModel.readingName!) \(AppMessages.readingForAllTimeIs) \(String(format: "%.2f", Float(self.object.average.readingValue)))"
    //
    //                break
                }
                CarePlanPopupChartManager.shared.setLineChart(
                    vwLineChart: self.vwLineChart,
                    xValues: xValues,
                    yValues: yValues,
                    yValues2: [""],
                    color1: color1,
                    color2: color2,
                    isMultiLineChart: false,
                    isShowLimit: self.object.thresholdShow == "N" ? false : true,
                    arrLimitLine: arrChartLine,
                    xCount: xCount)
                break
            }
            
            
            break
        case .fib4:
            
            let value = JSON(readingValue1).doubleValue
            strLastReading1 = String(format: "%0.2f", value) + " " + self.readingListModel.measurements

            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .sgot:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .sgpt:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .triglycerides:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .total_cholesterol:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .ldl_cholesterol:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .hdl_cholesterol:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .waist_circumference:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .platelet:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .serum_creatinine:
            let value = JSON(readingValue1).doubleValue
            strLastReading1 = String(format: "%0.1f", value) + " " + self.readingListModel.measurements
            
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        case .fatty_liver_ugs_grade:
            let value   = JSON(readingValue1).intValue
            let val     = GFunction.shared.getFattyLiver(value: value,
                                                     arrFattyLiverGrade: GFunction.shared.setArrFattyLiver())
            let strValue1       = val["name"].stringValue
            strLastReading1     = val["name"].stringValue
            
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
           
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            break
        
        case .random_blood_glucose:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            
            var xCount = 0
            switch self.summarySelectionType {
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
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .BodyFat,.Hydration,.Protein,.BaselMetabolicRate,.MetabolicAge,.SubcutaneousFat,.SkeletalMuscle:
            commonReadingValue()
            setCommonDesc()
            updateLastReadingUI(text1: AppMessages.lastReading + ":",
                                text2: AppMessages.lastReading + ":",
                                measurements: self.readingListModel.measurements)
            
            var arrChartLine    = [ChartLimitLineModel]()
            if let val = Double(self.object.standardMax.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Max"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
            if let val = Double(self.object.standardMin.trim()) {
                let obj1            = ChartLimitLineModel()
                obj1.title          = "Min"
                obj1.value          = val
                arrChartLine.append(obj1)
            }
        
            var xCount = 0
            switch self.summarySelectionType {
            case .sevenDays:
                xCount = 7
                //                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                                  xValues: xValues,
//                                                                  yValues: yValues,
//                                                                  color: color1)
                break
            case .fifteenDays:
                xCount = 15
                break
            case .thirtyDays:
                xCount = 30
//                CarePlanPopupChartManager.shared.setBarChart(vwBarChart: self.vwBarChart,
//                                                             xValues: xValues,
//                                                             yValues: yValues,
//                                                             color: color1)
              
                break
            case .nintyDays:
                xCount = 90
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                break
            case .oneYear:
                xCount = 1
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
                
                break
//            case .allTime:
//
//                CarePlanPopupChartManager.shared.setLineChart(
//                    vwLineChart: self.vwLineChart,
//                    xValues: xValues,
//                    yValues: yValues,
//                    yValues2: [""],
//                    color1: color1,
//                    color2: color2,
//                    isMultiLineChart: false)
//
//                break
            }
            CarePlanPopupChartManager.shared.setLineChart(
                vwLineChart: self.vwLineChart,
                xValues: xValues,
                yValues: yValues,
                yValues2: [""],
                color1: color1,
                color2: color2,
                isMultiLineChart: false,
                isShowLimit: self.object.thresholdShow == "N" ? false : true,
                arrLimitLine: arrChartLine,
                xCount: xCount)
            
            break
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature:
            break
        }
        
    }
}

extension ReadingChartDetailPopupVC : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
//        chartView.highlightValue(Highlight(x: entry.x, y: entry.y, dataSetIndex: 0))
        
//        let graphPoint = chartView.getMarkerPosition(entry: entry,  highlight: highlight)
//        let graphPoint = chartView.getMarkerPosition(highlight: highlight)

            // Adding top marker
//        self.readingChartValueVw.valueLabel.text = "\(entry.value)"
//        self.readingChartValueVw.dateLabel.text = "\(months[entry.xIndex])"
//        self.readingChartValueVw.center = CGPointMake(graphPoint.x, self.readingChartValueVw.center.y)
//        self.readingChartValueVw.isHidden = false
    }
}

