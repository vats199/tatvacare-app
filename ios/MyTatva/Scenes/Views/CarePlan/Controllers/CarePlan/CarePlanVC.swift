//

import UIKit
import SwiftUI

class CarePlanVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblTitle                     : UILabel!
    
    @IBOutlet weak var scrollMain                   : UIScrollView!
    @IBOutlet weak var btnNotification              : UIButton!
    
    //-------------------------- Incident Free box
    @IBOutlet weak var vwIncidentFreeParent         : UIView!
    @IBOutlet weak var vwIncidentFreeBox            : UIView!
//    @IBOutlet weak var vwIncidentFreeDays           : UIView!
    @IBOutlet weak var stackIncidentFreeDays        : UIStackView!
    @IBOutlet weak var lblHealthIncident            : UILabel!
    @IBOutlet weak var lblIncidentFreeDays          : UILabel!
    @IBOutlet weak var lblIncidentFreeDaysValue     : UILabel!
    @IBOutlet weak var lblIncidentRecorded          : UILabel!
    @IBOutlet weak var lblIncidentRecordedValue     : UILabel!
    @IBOutlet weak var lblNoIncidentMsg             : UILabel!
    @IBOutlet weak var btnAddNewIncident            : UIButton!
    @IBOutlet weak var btnViewAllIncident           : UIButton!
    
    @IBOutlet weak var vwBottom                     : UIView!
    
    //-------------------------- Reading History For you
    @IBOutlet weak var vwReadingHistory             : UIView!
    @IBOutlet weak var lblReadingHistory            : UILabel!
    @IBOutlet weak var colTopReadingHistory         : UICollectionView!
    
    @IBOutlet weak var vwSecondReadingHistory       : UIView!
    @IBOutlet weak var colSecondReadingHistory      : UICollectionView!
    @IBOutlet weak var colSecondReadingHistoryHeight: NSLayoutConstraint!
    @IBOutlet weak var btnViewMoreReadingHistory    : UIButton!
    
    //-------------------------- Book test
    @IBOutlet weak var vwBookTestParent             : UIView!
    @IBOutlet weak var lblBookTest                  : UILabel!
    @IBOutlet weak var btnViewMoreBookTest          : UIButton!
    @IBOutlet weak var colBookTest                  : UICollectionView!
    
    //-------------------------- Goal History For you
    @IBOutlet weak var vwGoalHistory                : UIView!
    @IBOutlet weak var btnSelectGoalType            : UIButton!
    @IBOutlet weak var lblGoalHistory               : UILabel!
    @IBOutlet weak var colGoalHistory               : UICollectionView!
    @IBOutlet weak var pageControl                  : AdvancedPageControlView!
    
    //-------------------------- Appointment History For you
    @IBOutlet weak var vwAppointmentParent          : UIView!
    @IBOutlet weak var vwAppointment                : UIView!
    @IBOutlet weak var lblAppointment               : UILabel!
    @IBOutlet weak var btnBookAppointment           : UIButton!
    @IBOutlet weak var btnViewAllAppointment        : UIButton!
    @IBOutlet weak var btnExpandAppointment         : UIButton!
    @IBOutlet weak var vwAppointmentSeparator       : UIView!
    @IBOutlet weak var tblAppointment               : UITableView!
    @IBOutlet weak var tblAppointmentHeight         : NSLayoutConstraint!
    
    //-------------------------- Precription view
    @IBOutlet weak var vwPrecriptionParent          : UIView!
    @IBOutlet weak var vwPrecriptionBox             : UIView!
    @IBOutlet weak var lblPrecription               : UILabel!
    @IBOutlet weak var btnViewAllPrecription        : UIButton!
    @IBOutlet weak var btnUpdatePrecription         : UIButton!
    @IBOutlet weak var tblPrecription               : UITableView!
    @IBOutlet weak var tblPrecriptionHeight         : NSLayoutConstraint!
    @IBOutlet weak var vwTestAdvisedBox             : UIView!
    @IBOutlet weak var imgTestAdvised               : UIImageView!
    @IBOutlet weak var lblTestAdvised               : UILabel!
    @IBOutlet weak var btnOrderTestAdvised          : UIButton!
    
    //-------------------------- Diet plan
    @IBOutlet weak var vwDietPlanParent             : UIView!
    @IBOutlet weak var vwDietPlan                   : UIView!
    @IBOutlet weak var lblDietPlan                  : UILabel!
    @IBOutlet weak var lblDietPlanDesc              : UILabel!
    @IBOutlet weak var lblNoMsgDietPlan             : UILabel!
    @IBOutlet weak var btnExpandDietPlan            : UIButton!
    @IBOutlet weak var btnViewAllDietPlan           : UIButton!
    @IBOutlet weak var tblDietPlan                  : UITableView!
    @IBOutlet weak var tblDietPlanHeight            : NSLayoutConstraint!
    
    //-------------------------- Records  view
    @IBOutlet weak var vwRecordsParent              : UIView!
    @IBOutlet weak var vwRecordsBox                 : UIView!
    @IBOutlet weak var lblRecords                   : UILabel!
    @IBOutlet weak var btnViewAllRecords            : UIButton!
    @IBOutlet weak var btnRecordsMore               : UIButton!
    @IBOutlet weak var colRecords                   : UICollectionView!
    @IBOutlet weak var lblAddRecord                 : UILabel!
    @IBOutlet weak var vwAddRecord                  : UIView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var strErrorMessage                     = ""
    var summarySelectionType: SelectionType = .sevenDays
    let viewModel                           = CarePlanVM()
    ////homeVM for book test related apis only
    let homeVM                              = HomeViewModel()
    let dietPlanHistoryListVM               = DietPlanHistoryListVM()
    let viewModelRecords                    = RecordsVM()
    let viewModelappointments               = AppointmentsHistoryVM()
    var arrReading1                         = [ReadingListModel]()
    var arrReading2                         = [ReadingListModel]()
    var lastSyncDate                        = Date()
    var isPageVisible                       = false
    var isContinueCoachmark                 = false
    var timerGoalHistory                    = Timer()
    var colGoalHistoryCurrentIndex          = -1
    var colGoalHistoryFullReload            = false
    var screenSection: ScreenSection        = .none
    
    var arrSelectionType: [JSON] = [
        [
            "name": "7 Days",
            "type": SelectionType.sevenDays.rawValue,
        ],
        [
            "name": "30 Days",
            "type": SelectionType.thirtyDays.rawValue
        ],
        [
            "name": "90 Days",
            "type": SelectionType.nintyDays.rawValue
        ],
        [
            "name": "1 Year",
            "type": SelectionType.oneYear.rawValue
        ],
//        [
//            "name": "All time",
//            "type": SelectionType.allTime.rawValue,
//        ]
    ]
    
    var arrReading1Temp : [JSON] = [
        [
            "img": "heart_beat_bg",
            "name": "Heart Rate",
            "desc": "120/80",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "weight_bg",
            "name": "Body Weight",
            "desc": "50kg",
            "desc2": "Updated Yesterday",
            "is_alert": 0
        ]]
    
    var arrReading2Temp : [JSON] = [
        [
            "img": "spo2_bg",
            "name": "SpO2",
            "desc": "120/80",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "fev_bg",
            "name": "FEV1",
            "desc": "120/80",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "weight_bg",
            "name": "Blood Glucose",
            "desc": "120/80",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "heart_beat_bg",
            "name": "BMI",
            "desc": "21",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "fev_bg",
            "name": "HbA1c",
            "desc": "80%",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "weight_bg",
            "name": "PEF",
            "desc": "85%",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "spo2_bg",
            "name": "ACR",
            "desc": "85%",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        [
            "img": "heart_beat_bg",
            "name": "eGFR",
            "desc": "85%",
            "desc2": "Updated on 20 July",
            "is_alert": 0
        ],
        
    ]
    
    var arrGoalHistory : [JSON] = [
        [
            "img": "goals_sleep",
            "name": "Medication",
            "desc": "Over the last 1 year, you done an average of 15 minutes of pranayam.",
            "type": "medicine",
            "medicine_list": [
                [
                    "img" : "medicine_temp",
                    "name" : "Formonide",
                    "dose_list": [
                        [
                            "name" : "M",
                            "isSelected": 1,
                            "is_tag": 0
                        ],
                        [
                            "name" : "T",
                            "isSelected": 1,
                            "is_tag": 0
                        ],
                        [
                            "name" : "W",
                            "isSelected": 0,
                            "is_tag": 0
                        ],
                        [
                            "name" : "T",
                            "isSelected": 1,
                            "is_tag": 1
                        ],
                        [
                            "name" : "F",
                            "isSelected": 1,
                            "is_tag": 0
                        ],
                        [
                            "name" : "S",
                            "isSelected": 1,
                            "is_tag": 1
                        ],
                        [
                            "name" : "S",
                            "isSelected": 1,
                            "is_tag": 0
                        ]
                    ]
                ],
                [
                    "img" : "medicine_temp",
                    "name" : "Formonide",
                    "dose_list": [
                        [
                            "name" : "M",
                            "isSelected": 1,
                            "is_tag": 1
                        ],
                        [
                            "name" : "T",
                            "isSelected": 1,
                            "is_tag": 0
                        ],
                        [
                            "name" : "W",
                            "isSelected": 0,
                            "is_tag": 0
                        ],
                        [
                            "name" : "T",
                            "isSelected": 1,
                            "is_tag": 1
                        ]
                    ]
                ],
                [
                    "img" : "medicine_temp",
                    "name" : "Formonide",
                    "dose_list": [
                        [
                            "name" : "W",
                            "isSelected": 0,
                            "is_tag": 0
                        ],
                        [
                            "name" : "T",
                            "isSelected": 1,
                            "is_tag": 1
                        ],
                        [
                            "name" : "F",
                            "isSelected": 1,
                            "is_tag": 0
                        ],
                        [
                            "name" : "S",
                            "isSelected": 1,
                            "is_tag": 1
                        ],
                        [
                            "name" : "S",
                            "isSelected": 1,
                            "is_tag": 0
                        ]
                    ]
                ]
            ]
        ],
        [
            "img": "goals_sleep",
            "name": "Pranayam",
            "desc": "Over the last 1 year, you done an average of 15 minutes of pranayam.",
            "type": "line_chart",
        ],
        [
            "img": "goals_sleep",
            "name": "Exercise",
            "desc": "Over the last 1 year, you done an average of 15 minutes of exercise.",
            "type": "bar_chart",
        ],
        [
            "img": "goals_sleep",
            "name": "Steps",
            "desc": "Over the last 1 year, you done an average of 15 minutes of steps.",
            "type": "line_chart",
        ]
    ]
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        
        self.vwIncidentFreeParent.isHidden  = true
//        self.vwIncidentFreeDays.isHidden    = true
//        self.vwDietPlanParent.isHidden      = true
        self.vwAppointmentParent.isHidden   = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isPageVisible = true
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appStatusActivity), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appStatusActivity), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        WebengageManager.shared.navigateScreenEvent(screen: .CarePlan)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if self.isPageVisible {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.updateAppData()
                GlobalAPI.shared.getPatientDetailsAPI { [weak self] (isDone) in
                    guard let self = self else {return}
                    if isDone {
                        self.updateAppData()
                    }
                }
            }
            
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.apiStart), with: nil, afterDelay: 0.5)
//            self.viewModel.apiCallFromStartSummary(colView1: self.colTopReadingHistory,
//                                                 colView2: self.colSecondReadingHistory,
//                                                 colView3: self.colGoalHistory)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .CarePlan, when: .Appear)
//        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIApplication.didBecomeActiveNotification, object: nil)
        
        self.isPageVisible = false
//        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
        FIRAnalytics.manageTimeSpent(on: .CarePlan, when: .Disappear)
    }
    //------------------------------------------------------

    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.confugureUI()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
//        self.setupGoalHistoryGesture()
        
//        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
//        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
//        self.txtMobile.keyboardType     = .numberPad
        
        self.scrollMain.delegate                = self
        self.vwReadingHistory.isHidden          = false
        self.vwSecondReadingHistory.isHidden    = false
        self.vwGoalHistory.isHidden             = false
        self.vwBookTestParent.isHidden          = true
    }
    
    private func applyStyle() {
        
        //-------------------------- Incident Free box
        self.lblHealthIncident
            .font(name: .semibold, size: 19).textColor(color: .themeBlack)
        self.lblIncidentFreeDays
            .font(name: .medium, size: 14).textColor(color: .themeBlack.withAlphaComponent(0.6))
        self.lblIncidentFreeDaysValue
            .font(name: .medium, size: 13).textColor(color: .themeBlack)
        
        self.lblIncidentRecorded
            .font(name: .medium, size: 14).textColor(color: .themeBlack.withAlphaComponent(0.6))
        self.lblIncidentRecordedValue
            .font(name: .medium, size: 13).textColor(color: .themeBlack)
        self.lblNoIncidentMsg
            .font(name: .semibold, size: 14).textColor(color: .themeBlack)
        self.btnAddNewIncident
            .font(name: .medium, size: 12).textColor(color: .white)
        self.btnViewAllIncident.font(name: .regular, size: 13).textColor(color: UIColor.themePurple)
        
        //-------------------------- Recommended For you
        self.lblReadingHistory
            .font(name: .semibold, size: 19).textColor(color: .themeBlack)
        self.btnViewMoreReadingHistory
            .font(name: .medium, size: 14).textColor(color: .themeBlack)
        
        //-------------------------- Appointment
        self.lblAppointment
            .font(name: .semibold, size: 19).textColor(color: .themeBlack)
        self.btnViewAllAppointment.font(name: .regular, size: 13).textColor(color: UIColor.themePurple)
        self.btnBookAppointment.font(name: .medium, size: 14).textColor(color: UIColor.white)
        
        //-------------------------- Book Test
        self.lblBookTest
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        self.btnViewMoreBookTest
            .font(name: .semibold, size: 14).textColor(color: .themePurple)
        
        //-------------------------- Goal Summary
        self.lblGoalHistory
            .font(name: .semibold, size: 19).textColor(color: .themeBlack)
        self.btnSelectGoalType
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        
        //-------------------------- Precription Data
        self.lblPrecription
            .font(name: .semibold, size: 19).textColor(color: .themeBlack)
        self.btnViewAllPrecription
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        self.btnUpdatePrecription
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        
        self.lblTestAdvised
            .font(name: .semibold, size: 14).textColor(color: .themeBlack)
        self.btnOrderTestAdvised
            .font(name: .medium, size: 10).textColor(color: .themePurple)
        
        //-------------------------- Diet plan
        self.lblDietPlan
            .font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblDietPlanDesc
            .font(name: .medium, size: 11).textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblNoMsgDietPlan.font(name: .medium, size: 13).textColor(color: UIColor.themePurple)
        self.btnViewAllDietPlan
            .font(name: .regular, size: 13).textColor(color: UIColor.themePurple)
        
        //-------------------------- Records Data
        self.lblRecords.font(name: .semibold, size: 19).textColor(color: .themeBlack)
        self.btnViewAllRecords.font(name: .medium, size: 14).textColor(color: UIColor.themePurple)
        self.lblAddRecord.font(name: .medium, size: 10).textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.setup(collectionView: self.colTopReadingHistory)
            self.setup(collectionView: self.colSecondReadingHistory)
            self.setup(collectionView: self.colGoalHistory)
            self.setup(collectionView: self.colRecords)
            self.setup(collectionView: self.colBookTest)
            
            self.setup(tblView: self.tblPrecription)
            self.setup(tblView: self.tblAppointment)
            self.setup(tblView: self.tblDietPlan)
        }
    }
    
    private func confugureUI() {
        
        DispatchQueue.main.async {
            //-------------------------- Incident Free box
            self.vwIncidentFreeParent.layoutIfNeeded()
            self.vwIncidentFreeBox.layoutIfNeeded()
//            self.vwIncidentFreeDays.layoutIfNeeded()
            self.btnAddNewIncident.layoutIfNeeded()
            
            self.vwIncidentFreeBox.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .themeShadow()
            
//            self.vwIncidentFreeDays.cornerRadius(cornerRadius: 10)
            self.btnAddNewIncident.cornerRadius(cornerRadius: 5)
            self.btnAddNewIncident.themeShadow()
            
            //-------------------------- Reading History For you
            self.colTopReadingHistory.layoutIfNeeded()
            self.colSecondReadingHistory.layoutIfNeeded()
            self.vwSecondReadingHistory.layoutIfNeeded()
            
            self.vwSecondReadingHistory.backGroundColor(color: UIColor.themeLightGray.withAlphaComponent(0.5))
            
            self.colTopReadingHistory.themeShadow()
            self.colTopReadingHistory.clipsToBounds = true
            
            self.colSecondReadingHistory.themeShadow()
            self.colSecondReadingHistory.clipsToBounds = true
            
            //-------------------------- Update reading
            self.colBookTest.themeShadow()
            
            //-------------------------- Goal History For you
            self.colGoalHistory.register(UINib(nibName: "GoalSummaryChartCell", bundle: nil), forCellWithReuseIdentifier: "GoalSummaryChartCell")

            self.colGoalHistory.themeShadow()
            self.colGoalHistory.clipsToBounds = true
            
            self.pageControl.drawer = ExtendedDotDrawer.init(numberOfPages: 0,
                                                             height: self.pageControl.frame.height, width: 12, space: 5, raduis: self.pageControl.frame.height / 2, currentItem: 0, indicatorColor: UIColor.themePurple, dotsColor: UIColor.themePurple.withAlphaComponent(0.5), isBordered: false, borderColor: UIColor.clear, borderWidth: 0, indicatorBorderColor: UIColor.clear, indicatorBorderWidth: 0)
            self.pageControl.isHidden = true
            
            //-------------------------- vw Incident Parent
            self.btnViewAllIncident.layoutIfNeeded()
            self.btnViewAllIncident
                .cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            //-------------------------- vw Appointment Parent
            self.vwAppointmentParent.layoutIfNeeded()
            self.vwAppointment.layoutIfNeeded()
            self.vwAppointment.cornerRadius(cornerRadius: 10)
            self.vwAppointment.themeShadow()
            
            self.btnViewAllAppointment.layoutIfNeeded()
            self.btnViewAllAppointment
                .cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnBookAppointment.layoutIfNeeded()
            self.btnBookAppointment
                .cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .backGroundColor(color: UIColor.themePurple)
            
            //-------------------------- Precription Data
            self.btnViewAllPrecription.layoutIfNeeded()
            self.btnViewAllPrecription.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnUpdatePrecription.layoutIfNeeded()
            self.btnUpdatePrecription.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwPrecriptionBox.layoutIfNeeded()
            self.vwPrecriptionBox.cornerRadius(cornerRadius: 10)
            self.vwPrecriptionBox.themeShadow()
            
            self.btnOrderTestAdvised.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            //-------------------------- Deit plan Data
            self.vwDietPlanParent.layoutIfNeeded()
            self.vwDietPlan.layoutIfNeeded()
            self.vwDietPlan.cornerRadius(cornerRadius: 10)
            self.vwDietPlan.themeShadow()
            
            self.btnViewAllDietPlan.layoutIfNeeded()
            self.btnViewAllDietPlan.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            //-------------------------- Records Data
            self.btnViewAllRecords.layoutIfNeeded()
            self.btnViewAllRecords.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwAddRecord.layoutIfNeeded()
            self.vwAddRecord.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwRecordsBox.layoutIfNeeded()
            self.vwRecordsBox.cornerRadius(cornerRadius: 10)
            self.vwRecordsBox.themeShadow()

        }
    }
    
    private func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate             = self
        collectionView.dataSource           = self
        collectionView.prefetchDataSource   = self
        collectionView.reloadData()
    }
    
    private func setup(tblView: UITableView){
        tblView.tableFooterView         = UIView.init(frame: CGRect.zero)
//            self.tblPrecription.emptyDataSetSource     = self
//            self.tblPrecription.emptyDataSetDelegate   = self
        tblView.delegate                = self
        tblView.dataSource              = self
        tblView.rowHeight               = UITableView.automaticDimension
        tblView.sectionHeaderHeight     = 0
        tblView.sectionFooterHeight     = 0
        tblView.reloadData()
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    private func manageActionMethods(){
      
        
        self.btnSelectGoalType.addTapGestureRecognizer {
            self.btnSelectGoalType.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.btnSelectGoalType.isUserInteractionEnabled = true
            }
            let dropDown = DropDown()
            DropDown.appearance().textColor                 = UIColor.themeBlack
            DropDown.appearance().selectedTextColor         = UIColor.themeBlack
            DropDown.appearance().textFont                  = UIFont.customFont(ofType: .medium, withSize: 14)
            DropDown.appearance().backgroundColor           = UIColor.white
            DropDown.appearance().selectionBackgroundColor  = UIColor.white
            DropDown.appearance().cellHeight                = 40
            dropDown.anchorView                             = self.btnSelectGoalType
            
            let arr: [String] = self.arrSelectionType.map { (obj) -> String in
                return obj["name"].stringValue
            }
            
            dropDown.dataSource = arr
            dropDown.selectionAction = { (index, str) in
                dropDown.hide()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0){
                    let type = SelectionType.init(rawValue: self.arrSelectionType[index]["type"].stringValue) ?? .sevenDays
                    
                    if self.summarySelectionType != type {
                        self.colGoalHistoryCurrentIndex = -1
                        self.colGoalHistoryFullReload = true
                        
                        self.summarySelectionType = type
                        self.btnSelectGoalType.setTitle(str, for: .normal)
                        //self.colGoalHistory.reloadData()
                        self.scrollingFinished(scrollView: self.colGoalHistory)
    //                    self.colGoalHistory.pop()
                    }
                }
            }
            dropDown.show()
        }
        
        self.btnViewMoreReadingHistory.isSelected = false
        self.btnViewMoreReadingHistory.addTapGestureRecognizer {
            self.btnViewMoreReadingHistory.isSelected = !self.btnViewMoreReadingHistory.isSelected
            self.manageSummaryList()
        }
        
        self.vwIncidentFreeBox.addTapGestureRecognizer {
//            let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
//            vc.selectedType = .Incident
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnAddNewIncident.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .incident_records_history,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    self.isPageVisible = false
                    FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_REPORT_INCIDENT,
                                             screen: .CarePlan,
                                             parameter: nil)
                    
                    GlobalAPI.shared.get_incident_surveyAPI(withLoader: true,
                                                            showAlert: true) { [weak self] (isDone, obj, msg) in
                        guard let self = self else {return}
                        if isDone {
                            
                            let vc = AddIncidentPopupVC.instantiate(fromAppStoryboard: .carePlan)
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            vc.completionHandler = { objc in
                                if objc != nil {
                                    SurveySparrowManager.shared.startSurveySparrow(token: obj.surveyId)
                                    SurveySparrowManager.shared.completionHandler = { object in
                                        print(object as Any)
                                        
                                        if object != nil {
                                            GlobalAPI.shared.add_incident_detailsAPI(incident_tracking_master_id: obj.incidentTrackingMasterId,
                                                                                     survey_id: obj.surveyId,
                                                                                     response: object!["response"] as! [[String: Any]]) { (isDone, msg) in
                                                if isDone {
                                                    self.updateIncident(completion: nil)
                                                }
                                            }
                                        }
                                    }
                                }
        //                        let vc = CorrectAnswerPopUpVC.instantiate(fromAppStoryboard: .carePlan)
        //                        vc.modalPresentationStyle = .overFullScreen
        //                        self.present(vc, animated: false, completion: nil)
                                //            let nav = UINavigationController(rootViewController: vc)
                                //            UIApplication.topViewController()?.present(nav, animated: false, completion: nil)
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.btnViewAllIncident.addTapGestureRecognizer {
            let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
            vc.selectedType = .Incident
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnViewAllAppointment.addTapGestureRecognizer {
            FIRAnalytics.FIRLogEvent(eventName: .CAREPLAN_APPOINTMENT_VIEW_ALL,
                                     screen: .CarePlan,
                                     parameter: nil)
            
            let vc = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
            vc.isForList = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnBookAppointment.addTapGestureRecognizer {
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICK_BOOK_APPOINTMENT,
                                     screen: .CarePlan,
                                     parameter: nil)
            
            PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.btnViewMoreBookTest.addTapGestureRecognizer {
            let vc = LabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnExpandAppointment.isSelected = true
        self.btnExpandAppointment.addTapGestureRecognizer {
            
            UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
                self.btnExpandAppointment.isSelected = !self.btnExpandAppointment.isSelected
                self.tblAppointment.isHidden = !self.btnExpandAppointment.isSelected
                self.vwAppointmentSeparator.isHidden = !self.btnExpandAppointment.isSelected
                self.view.layoutIfNeeded()
            } completion: { isDone in
                self.view.layoutIfNeeded()
            }
        }
        
        self.btnExpandDietPlan.isSelected = true
        self.btnExpandDietPlan.addTapGestureRecognizer {
            UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
                self.btnExpandDietPlan.isSelected = !self.btnExpandDietPlan.isSelected
                self.tblDietPlan.isHidden = !self.btnExpandDietPlan.isSelected
                self.view.layoutIfNeeded()
            } completion: { isDone in
                self.view.layoutIfNeeded()
            }
        }
        
        self.btnViewAllDietPlan.addTapGestureRecognizer {
            self.isPageVisible = false
            let vc = DietPlanHistoryListVC.instantiate(fromAppStoryboard: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        self.vwDownloadDietPlan.addTapGestureRecognizer {
//            var param = [String : Any]()
//            param[AnalyticsParameters.feature_status.rawValue]      = FeatureStatus.active.rawValue
//            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_DIET_PLAN_CARD,
//                                     screen: .ExercisePlan,
//                                     parameter: param)
//
//            if let doc = self.viewModel.dietDetailsModel.documentUrl {
//                if let url = URL(string: doc) {
//                    GFunction.shared.openPdf(url: url)
//                }
//            }
//        }
        
        self.btnViewAllRecords.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .add_records_history_records,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow{
                    self.isPageVisible = false
                    let vc = RecordsVC.instantiate(fromAppStoryboard: .setting)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.vwAddRecord.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .add_records_history_records,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow{
                    self.isPageVisible = false
                    let vc = UploadRecordVC.instantiate(fromAppStoryboard: .setting)
                    vc.hidesBottomBarWhenPushed = true
                    vc.completionHandler = { [weak self] (isDone) in
                        guard let self = self else {return}
                        if isDone{
                            self.viewModelRecords.apiCallFromStartRecord(tblView: nil,
                                                                         colView: self.colRecords,
                                                                         search: "")
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.btnUpdatePrecription.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .add_medication,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    self.isPageVisible = false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        let vc = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                        vc.isEdit = true
                        vc.hidesBottomBarWhenPushed = true
                        (sceneDelegate.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.btnOrderTestAdvised.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .prescription_book_test,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    self.isPageVisible = false
                    let vc = RequestCallBackPopupVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    //vc.patient_dose_rel_id = object.patientDoseRelId
                    vc.completionHandler = { objc in
                            
                        if objc != nil {
                            if objc?.count > 0 {
                                self.dismiss(animated: true) {
                                    let profileVC = ProfileVC.instantiate(fromAppStoryboard: .setting)
                                    vc.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(profileVC, animated: true)
                                }
                            }
                            else {
                                let backvc = BackToCarePlanPopupVC.instantiate(fromAppStoryboard: .carePlan)
                                backvc.modalPresentationStyle = .overFullScreen
                                backvc.modalTransitionStyle = .crossDissolve
                                self.present(backvc, animated: true, completion: nil)
                            }
                        }
                    }
                    
                    self.present(vc, animated: true, completion: nil)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
            
        }
    }
}

//MARK: -------------------- set progress bar --------------------
extension CarePlanVC {
    
    private func manageSummaryList(){
        DispatchQueue.main.async {
            if !self.btnViewMoreReadingHistory.isSelected {
                self.reloadReading()
            }
            else {
                self.reloadReading()
            }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension CarePlanVC {
    
    @objc func appStatusActivity(_ notification: Notification)  {
        if notification.name == UIApplication.didBecomeActiveNotification{
            // become active notifictaion
            self.viewWillAppear(true)
        }else{
            // willResignActiveNotification
        }
        
    }
    
    @objc func apiStart(){
        self.viewModel.apiCallFromStartSummary(colView1: self.colTopReadingHistory,
                                             colView2: self.colSecondReadingHistory,
                                             colView3: self.colGoalHistory)
    }
    
    func updateAppData(){
        var planName = ""
        planName = UserModel.shared.hcServicesLongestPlan == nil ? "" : UserModel.shared.hcServicesLongestPlan.planName
        /*if UserModel.shared.patientPlans != nil {
            for plan in UserModel.shared.patientPlans {
                if plan.planType == kSubscription ||
                    plan.planType == KTrial ||
                    plan.planType == KFree {
                    planName = plan.planName
                }
            }
        }*/
        
        if planName.trim() != "" {
            self.lblTitle.text = AppMessages.CarePlan + " " + "(\(planName))"
        }
        else {
            self.lblTitle.text = AppMessages.CarePlan
        }
        
        //For diet
        self.lblDietPlanDesc.text = ""
        if UserModel.shared.hcList != nil && UserModel.shared.hcList.count > 0 {
            self.vwDietPlanParent.isHidden = false
            for item in UserModel.shared.hcList {
                let hc_name = item.firstName + " " + item.lastName
                if item.role.lowercased() == "Physiotherapist".lowercased() {
                }
                else if item.role.lowercased() == "Nutritionist".lowercased() {
                    self.lblDietPlanDesc.text = "By \(hc_name)"
                }
            }
        }
        else {
            self.vwDietPlanParent.isHidden = false
        }
        //                if let _ = self.viewModel.dietDetailsModel.documentUrl {
        //                    self.vwDietPlanParent.isHidden = false
        //                    self.lblDietPlan.text = AppMessages.DietPlan + " (\(self.viewModel.dietDetailsModel.documentTitle!)) \(AppMessages.byYourHealthCoach) \(self.viewModel.dietDetailsModel.firstName!) \(self.viewModel.dietDetailsModel.lastName!)"
        //
        //
        //                }
        //                else {
        //                    self.vwDietPlanParent.isHidden = true
        //                }
        
        self.vwDietPlanParent.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        GFunction.shared.updateNotification(btn: self.btnNotification)
    }
    
    private func updateIncident(completion: ((Bool) -> Void)?){
//        self.vwIncidentFreeParent.isHidden = true
//        self.vwIncidentFreeDays.isHidden = true
        
//        let data                = UserModel.shared
        
        if hide_incident_surveyMain {
            self.vwIncidentFreeParent.isHidden  = true
            completion?(true)
        }
        else {
            GlobalAPI.shared.get_incident_free_daysAPI() { [weak self] (isDone, data, msg) in
                guard let self = self else {return}
                self.vwIncidentFreeParent.isHidden  = false
                if isDone {
                    self.lblNoIncidentMsg.isHidden      = true
                    self.stackIncidentFreeDays.isHidden = false
                    self.lblIncidentRecorded.isHidden   = false
                    self.btnViewAllIncident.isHidden    = false
                    self.lblIncidentFreeDaysValue.text  = "\(data.days!)" //\(AppMessages.Days)"
                    
                    //                let time = GFunction.shared.convertDateFormate(dt: data.lastIncidentDate,
                    //                                                               inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                    //                                                               outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                    //                                                               status: .LOCAL)
                    let time = GFunction.shared.convertDateFormate(dt: data.lastIncidentDate,
                                                                   inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                                   outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                                   status: .NOCONVERSION)
                    
                    self.lblIncidentRecordedValue.text  = time.0
                }
                else {
//                    self.vwIncidentFreeDays.isHidden    = true
                    self.lblNoIncidentMsg.isHidden      = false
                    self.stackIncidentFreeDays.isHidden = true
                    self.lblIncidentRecorded.isHidden   = true
                    self.btnViewAllIncident.isHidden    = true
                    self.lblNoIncidentMsg.text          = msg
                }
                self.view.layoutIfNeeded()
                
                completion?(true)
            }
        }
        
//        if !data.medicalConditionName[0].medicalConditionName.lowercased()
//            .contains(kNASH.lowercased()) &&
//            !data.medicalConditionName[0].medicalConditionName.lowercased()
//            .contains(kNAFL.lowercased()){
//
//            GlobalAPI.shared.get_incident_free_daysAPI { (isDone, data, msg) in
//                self.vwIncidentFreeParent.isHidden  = false
//                if isDone {
//                    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn]) {
//                        self.vwIncidentFreeDays.isHidden    = false
//                        self.lblIncidentRecorded.isHidden   = false
//                    } completion: { isDone in
//                    }
//
//                    self.lblIncidentFreeDaysValue.text = "\(data.days!) Days"
//
//    //                let time = GFunction.shared.convertDateFormate(dt: data.lastIncidentDate,
//    //                                                               inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//    //                                                               outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//    //                                                               status: .LOCAL)
//                    let time = GFunction.shared.convertDateFormate(dt: data.lastIncidentDate,
//                                                                   inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
//                                                                   outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                                   status: .NOCONVERSION)
//
//                    self.lblIncidentRecordedValue.text  = time.0
//                }
//                else {
//                    self.vwIncidentFreeDays.isHidden    = true
//                    self.lblIncidentRecorded.isHidden   = true
//                    self.lblIncidentRecordedValue.text  = msg
//                }
//                completion?(true)
//            }
//        }
//        else {
//            completion?(true)
//        }
    }
    
    private func reloadReading(){
//            self.colTopReadingHistory.performBatchUpdates {
//
//            }self.colSecondReadingHistory.performBatchUpdates {
//
//            }

//      self.colTopReadingHistory.reloadSections([0])
//        self.colSecondReadingHistory.reloadSections([0])
        DispatchQueue.main.async {
            self.colTopReadingHistory.reloadData()
            self.colSecondReadingHistory.reloadData()
            
            self.colTopReadingHistory.layoutIfNeeded()
            self.colSecondReadingHistory.layoutIfNeeded()
            
            UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
                self.view.layoutIfNeeded()
            } completion: { isDone in
            }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension CarePlanVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        func updateCarePlan(){
            if self.isPageVisible {
                self.updateIncident { [weak self] (isDone) in
                    guard let self = self else {return}
                    
                    if self.isPageVisible {
                        self.viewModel.apiCallFromStart_Prescription(tblView: self.tblPrecription,
                                                                     refreshControl: nil, withLoader: false)
                    }
                    
//                        self.homeVM.tests_list_homeAPI(colView: self.colBookTest,
//                                                          separate: "No",
//                                                          withLoader: false) { isDone in
//
//                            if isDone {
//                                self.vwBookTestParent.isHidden = false
//                                self.colBookTest.layoutIfNeeded()
//                                self.colBookTest.reloadData()
//                                self.colBookTest.layoutIfNeeded()
//                            }
//                            else {
//                                self.vwBookTestParent.isHidden = true
//                            }
//
//                            //-----------------------------------------------------------------
//                            if self.isPageVisible {
//                                self.viewModel.apiCallFromStart_Prescription(tblView: self.tblPrecription,
//                                                                             refreshControl: nil, withLoader: false)
//                            }
//                        }
                }
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            
                //For readings
                if self.viewModel.getReadingCount() > 0 {
                    if self.viewModel.getReadingCount() <= 5 {
                        
                        self.vwReadingHistory.isHidden = false
                        self.vwSecondReadingHistory.isHidden = false
                        
                        if self.viewModel.getReadingCount() <= 2 {
                            self.vwSecondReadingHistory.isHidden = true
                        }
                        self.btnViewMoreReadingHistory.isHidden = true
                        
                        self.arrReading1 = self.viewModel.arrReading
                    }
                    else {
                        self.vwReadingHistory.isHidden = false
                        self.vwSecondReadingHistory.isHidden = false
                        self.btnViewMoreReadingHistory.isHidden = false
                    }
                    
                    self.arrReading1.removeAll()
                    self.arrReading2.removeAll()
                    for index in 0...self.viewModel.arrReading.count - 1 {
                        if index < 2 {
                            self.arrReading1.append(self.viewModel.arrReading[index])
                        }
                        else {
                            self.arrReading2.append(self.viewModel.arrReading[index])
                        }
                    }
                   
                    self.manageSummaryList()
                }
                else {
                    self.vwReadingHistory.isHidden = true
                    self.vwSecondReadingHistory.isHidden = true
                }
                
                //For Goals
                if self.viewModel.getGoalCount() > 0 {
                    self.vwGoalHistory.isHidden = false
                    self.pageControl.numberOfPages = self.viewModel.getGoalCount()
                    self.pageControl.isHidden = false
                }
                else {
                    self.vwGoalHistory.isHidden = true
                    self.pageControl.isHidden = true
                }
                
            self.colGoalHistory.reloadData()
            self.reloadReading()
                
//                    self.colGoalHistory.pop()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0, execute: {
                    self.colGoalHistoryCurrentIndex = -1
                    self.scrollingFinished(scrollView: self.colGoalHistory)
                    //self.colGoalHistory.reloadData()
                })
//            })
        }
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Password changed", completion: nil)
                updateCarePlan()
                
            break
            
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        //🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
        self.viewModel.vmResultPrescription.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                    if self.viewModel.getPrescriptionCount() > 0 {
                        self.vwPrecriptionParent.isHidden = false
                        self.tblPrecription.reloadData()
                    }
                    else {
                        self.vwPrecriptionParent.isHidden = false
                    }
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
            
            if self.isPageVisible {
                self.viewModelappointments.apiCallFromStart_Appointment(forToday: true,
                                                                        type: "",
                                                                        tblView: self.tblAppointment,
                                                                        withLoader: false)
            }
        })
        
        // Result binding observer
        self.viewModelappointments.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    if self.viewModelappointments.getCount() > 0 {
                        self.vwAppointmentParent.isHidden       = false
                        self.btnViewAllAppointment.isHidden     = false
                        self.btnExpandAppointment.isHidden      = false
                        self.tblAppointment.isHidden = !self.btnExpandAppointment.isSelected
                        self.vwAppointmentSeparator.isHidden = !self.btnExpandAppointment.isSelected
                    }
                    else {
                        self.vwAppointmentParent.isHidden       = false
                        self.btnViewAllAppointment.isHidden     = false
                        self.tblAppointment.isHidden            = true
                        self.vwAppointmentSeparator.isHidden    = true
                        self.btnExpandAppointment.isHidden      = true
                    }
                    self.tblAppointment.layoutIfNeeded()
                    self.tblAppointment.reloadData()
                    self.tblAppointment.layoutIfNeeded()
//                    UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
//                        self.view.layoutIfNeeded()
//                    } completion: { isDone in
//                        self.tblAppointment.layoutIfNeeded()
//                        self.view.layoutIfNeeded()
//                    }
                    
//                    if UserModel.shared.patientGuid.trim() == "" {
//                        self.vwAppointmentParent.isHidden       = true
//                    }
                })
            break
            
            case .failure(let error):
                print(error.errorDescription ?? "")
                self.vwAppointmentParent.isHidden = true
                //Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
            
            //Success of api response
            if self.isPageVisible {
                PlanManager.shared.removeLock(toView: self.vwDietPlan)
                self.dietPlanHistoryListVM.apiCallFromStart(tblView: self.tblDietPlan,
                                                            search: "",
                                                            isFromCarePlan: true)
            }
        })
        
        // Result binding observer
        self.dietPlanHistoryListVM.vmResult.bind(observer: { (result) in
            
            if self.isPageVisible {
                self.viewModelRecords.apiCallFromStartRecord(tblView: nil,
                                                             colView: self.colRecords,
                                                             search: "")
            }
            
            if self.dietPlanHistoryListVM.getCount() > 0 {
                self.lblNoMsgDietPlan.isHidden      = true
                self.btnExpandDietPlan.isHidden     = false
//                self.btnViewAllDietPlan.isHidden    = false
            }
            else {
                self.btnExpandDietPlan.isHidden     = true
//                self.btnViewAllDietPlan.isHidden    = true
                self.lblNoMsgDietPlan.isHidden      = false
                self.lblNoMsgDietPlan.text          = self.dietPlanHistoryListVM.strErrorMessage
            }
            
            PlanManager.shared.isAllowedByPlan(type: .diet_plan,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    PlanManager.shared.removeLock(toView: self.vwDietPlan)
                }
                else {
                    PlanManager.shared.addLock(toView: self.vwDietPlan,
                                               eventName: .USER_CLICKED_ON_DIET_PLAN_CARD,
                                               screen: .CarePlan)
                }
            })
            
            switch result {
            case .success(_):
                
                //Alert.shared.showAlert(message: "Records fetched", completion: nil)
            break
            
            case .failure(let error):
                print(error.errorDescription ?? "")
                
                //Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
                                            
        // Result binding observer
        self.viewModelRecords.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                //Alert.shared.showAlert(message: "Records fetched", completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    
                    //For Records
                    if self.viewModelRecords.getCount() > 0 {
                        self.vwRecordsParent.isHidden       = false
                        self.btnViewAllRecords.isHidden     = false
                        self.colRecords.isHidden            = false
                    }
                    else {
                        self.vwRecordsParent.isHidden       = false
                        self.btnViewAllRecords.isHidden     = true
                        self.colRecords.isHidden            = true
                    }
                    self.colRecords.layoutIfNeeded()
                    self.colRecords.reloadData()
                    self.colRecords.layoutIfNeeded()
                })
                
            break
            
            case .failure(let error):
                print(error.errorDescription ?? "")
                //Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
            
            self.startAppTour()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                switch self.screenSection {
                    
                case .DiagnosticTest:
                    break
                case .Prescription:
                    self.scrollMain.scrollToView(view: self.vwPrecriptionParent, animated: true)
                    break
                case .Records:
                    self.scrollMain.scrollToView(view: self.vwRecordsParent, animated: true)
                    break
                case .QuizPoll:
                    break
                case .none:
                    break
                }
            }
        })
    }
    
    private func startAppTour(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if self.isContinueCoachmark {
                self.isContinueCoachmark = false
                self.scrollMain.scrollToView(view: self.vwReadingHistory, animated: true)
                //self.scrollMain.setContentOffset(CGPoint(x: 0, y: self.colTopReadingHistory.frame.origin.y + self.colTopReadingHistory.frame.height), animated: true)
                let vc = CoachmarkCarePlanVC.instantiate(fromAppStoryboard: .home)
                vc.targetView = self.colTopReadingHistory
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        self.scrollMain.scrollToView(view: self.vwRecordsParent, animated: true)
//                        self.scrollMain.setContentOffset(CGPoint(x: 0, y: self.vwRecordsParent.frame.origin.y + self.vwRecordsParent.frame.height / 2), animated: true)
                        let vc = CoachmarkCarePlan2VC.instantiate(fromAppStoryboard: .home)
                        vc.targetView = self.vwRecordsParent
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        vc.completionHandler = { obj1 in
                            if obj1?.count > 0 {
                                Settings().isHidden(setting: .hide_engage_page) { isHidden in
                                    if isHidden {
                                        let vc = CoachmarkEngageToExerciseVC.instantiate(fromAppStoryboard: .home)
                                        if let item = self.tabBarController?.tabBar {
                                            vc.targetTabbar = item
                                        }
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.completionHandler = { obj3 in
                                            if obj3?.count > 0 {
                                                if let tab = self.tabBarController {
                                                    tab.selectedIndex = 2
                                                    if let exerciseParentVC = (tab.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? ExerciseParentVC{
                                                        exerciseParentVC.isContinueCoachmark = true
                                                    }
                                                }
                                            }
                                        }
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                    else {
                                        let vc = CoachmarkCarePlanToEngageVC.instantiate(fromAppStoryboard: .home)
                                        if let item = self.tabBarController?.tabBar {
                                            vc.targetTabbar = item
                                        }
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.completionHandler = { obj3 in
                                            if obj3?.count > 0 {
                                                if let tab = self.tabBarController {
                                                    tab.selectedIndex = 2
                                                    if let engageVC = (tab.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? EngageParentVC{
                                                        engageVC.isContinueCoachmark = true
                                                    }
                                                }
                                            }
                                        }
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

//MARK: -------------------- colGoalHistory swipe gesture --------------------
extension CarePlanVC: UIGestureRecognizerDelegate {
    
    func setupGoalHistoryGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        swipeRight.delegate = self
        self.colGoalHistory.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        self.colGoalHistory.addGestureRecognizer(swipeLeft)
        self.colGoalHistory.isScrollEnabled = false
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        let totalGoals      = self.viewModel.getGoalCount()
        let indexPath       = self.colGoalHistory.getVisibleCellIndexPath()
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                if indexPath?.item > 0 {
                    self.colGoalHistory.scrollToItem(at: IndexPath(item: (indexPath?.item ?? 0) - 1, section: 0), at: .centeredHorizontally, animated: true)
                }
                break
            case .down:
                print("Swiped down")
                break
            case .left:
                print("Swiped left")
                if indexPath?.item < totalGoals - 1 {
                    self.colGoalHistory.scrollToItem(at: IndexPath(item: (indexPath?.item ?? 0) + 1, section: 0), at: .centeredHorizontally, animated: true)
                }
                
                break
            case .up:
                print("Swiped up")
                break
            default:
                break
            }
            
            switch swipeGesture.state {
            case .ended:
                print("ended")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.scrollingFinished(scrollView: self.colGoalHistory)
                }
                
            case .changed:
                print("changed")
                break
            default:
                break
            }
        }
        
    }
}
                                              
