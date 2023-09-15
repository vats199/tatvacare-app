//

import UIKit

class HomeVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:-------------------- Outlet --------------------
    @IBOutlet weak var imgLogo                      : UIImageView!
    @IBOutlet weak var scrollMain                   : UIScrollView!
    @IBOutlet weak var btnSearch                    : UIButton!
    @IBOutlet weak var btnNotification              : UIButton!
    
    //-------------------------- Welcome box
    @IBOutlet weak var vwWelcomeParent              : UIView!
    @IBOutlet weak var vwWelcomeBox                 : UIView!
    @IBOutlet weak var lblWelcome                   : UILabel!
    @IBOutlet weak var lblWelcomeDesc               : UILabel!
    @IBOutlet weak var lblProfileComplete           : UILabel!
    @IBOutlet weak var btnWelcomeComplete           : UIButton!
    @IBOutlet weak var welcomeProgressBar           : LinearProgressBar!
    
    //-------------------------- Verify email box
    @IBOutlet weak var vwVerifyEmailParent          : UIView!
    @IBOutlet weak var vwVerifyEmailBox             : UIView!
    @IBOutlet weak var lblVerifyEmail               : UILabel!
    
    //-------------------------- Daily summary
    @IBOutlet weak var vwDailySummaryParent         : UIView!
    @IBOutlet weak var lblDailySummary              : UILabel!
    @IBOutlet weak var btnDailySummaryInfo          : UIButton!
    @IBOutlet weak var tblDailySummary              : UITableView!
    @IBOutlet weak var tblDailySummaryHeight        : NSLayoutConstraint!
    @IBOutlet weak var btnViewMoreSummary           : UIButton!
    
    //-------------------------- Care Plan
    @IBOutlet weak var vwCarePlanMain               : UIView!
    @IBOutlet weak var vwCarePlan                   : UIView!
    @IBOutlet weak var imgCarePlan                  : UIImageView!
    @IBOutlet weak var lblCPTitle                   : UILabel!
    @IBOutlet weak var lblCPSubTitle                : UILabel!
    @IBOutlet weak var vwActive                     : UIView!
    @IBOutlet weak var lblActive                    : UILabel!
    @IBOutlet weak var btnCarePlan                  : UIButton!
        
    //-------------------------- Upcoming appointment
    @IBOutlet weak var vwBottom                     : UIView!
    @IBOutlet weak var vwUpcomingAppointmentParent  : UIView!
    @IBOutlet weak var vwUpcomingAppointmentBox     : UIView!
    @IBOutlet weak var vwUpcomingAppointmentTitleBox: UIView!
    @IBOutlet weak var lblUpcomingAppointment       : UILabel!
    @IBOutlet weak var imgAppointmentDoctor         : UIImageView!
    @IBOutlet weak var lblAppointmentDoctorName     : UILabel!
    @IBOutlet weak var lblAppointmentDoctorDesc     : UILabel!
    @IBOutlet weak var lblAppointmentDate           : UILabel!
    @IBOutlet weak var lblAppointmentTime           : UILabel!
    @IBOutlet weak var lblAppointmentAddress        : UILabel!
    @IBOutlet weak var btnCancelAppointment         : UIButton!
    @IBOutlet weak var btnVideoCallAppointment      : UIButton!
    
    //-------------------------- Recommended For you
    @IBOutlet weak var vwRecommendedParent          : UIView!
    @IBOutlet weak var lblRecommended               : UILabel!
    @IBOutlet weak var colRecommended               : UICollectionView!
    
    //-------------------------- Update reading
    @IBOutlet weak var vwReadingParent              : UIView!
    @IBOutlet weak var lblReading                   : UILabel!
    @IBOutlet weak var colReading                   : UICollectionView!
    
    //-------------------------- Book test
    @IBOutlet weak var vwBookTestParent             : UIView!
    @IBOutlet weak var lblBookTest                  : UILabel!
    @IBOutlet weak var btnViewMoreBookTest          : UIButton!
    @IBOutlet weak var colBookTest                  : UICollectionView!
    
    //-------------------------- Doctor quotes
    @IBOutlet weak var vwDoctorQuotesParent         : UIView!
    @IBOutlet weak var vwDoctorQuotesBox            : UIView!
    @IBOutlet weak var lblDoctorQuotesTitle         : UILabel!
    @IBOutlet weak var lblDoctorQuotesDesc          : UILabel!
    
    //-------------------------- Poll & Quiz
    @IBOutlet weak var vwPollQuizParent             : UIView!
    @IBOutlet weak var colPollQuiz                  : UICollectionView!
    @IBOutlet weak var pageControlPollQuiz          : AdvancedPageControlView!
    
    //-------------------------- Stay informed
    @IBOutlet weak var vwStayInformed               : UIView!
    @IBOutlet weak var lblStayInformed              : UILabel!
    @IBOutlet weak var colStayInformed              : UICollectionView!
    
    //-------------------------- My Device
    @IBOutlet weak var svMydevice: UIView!
    @IBOutlet weak var vwMyDeviceParent: UIView!
    @IBOutlet weak var vwMyDevice: UIView!
    @IBOutlet weak var lblMyDevice: UILabel!
    @IBOutlet weak var vwTblMyRoutine: UIView!
    @IBOutlet weak var tblMyDevices: UITableView!
    @IBOutlet weak var tblMyDeviceConstHeight: NSLayoutConstraint!
    //------------------------------------------------------
    
    //MARK:-------------------- Class Variable --------------------
    let viewModel                       = HomeViewModel()
    let chatHistoryListVM               = ChatHistoryListVM()
    var strErrorMessage                 = ""
    var kMaxReloadAttempSummary         = 0
    var isPageVisible                   = false
    var isOpenGoal                      = false
    var isOpenReading                   = false
    var isOpenGoalReadingKey            = ""
    var screenSection: ScreenSection = .none
    
    var arrSummary : [JSON] = [
        [
            "img": "medication",
            "name": "Medication",
            "progress": 20,
            "desc": "2 of 8 doses",
        ],
        [
            "img": "pranayam",
            "name": "Pranayam",
            "progress": 60,
            "desc": "10 of 15 minutes",
        ],
        [
            "img": "steps",
            "name": "Steps",
            "progress": 90,
            "desc": "3500 of 4000",
        ],
        [
            "img": "exercise",
            "name": "Exercise",
            "progress": 80,
            "desc": "40 of 60 minutes",
        ],
        [
            "img": "goals_sleep",
            "name": "Sleep",
            "progress": 80,
            "desc": "40 of 60 minutes",
        ],
        [
            "img": "goals_water",
            "name": "Water",
            "progress": 80,
            "desc": "1.5 of 2 liters",
        ],
    ]
    
    var arrRecommended : [JSON] = [
        [
            "img": "b2",
            "title": "Asthma Management Plans",
            "desc": "Starting at Rs. 600 per month",
        ],
        [
            "img": "b4",
            "title": "New Diet Plans",
            "desc": "Integrating the patient in the planning of their exercise programme",
        ]
    ]
    var arrReading : [JSON] = [
        [
            "img": "spo2",
            "name": "SPO2",
            "desc": "82%",
            "desc2": "Updated today",
            "is_alert": 0
        ],
        [
            "img": "lung",
            "name": "Lung Function",
            "desc": "98%",
            "desc2": "last updated Jan 12",
            "is_alert": 1
        ],
        [
            "img": "body_weight",
            "name": "Body Weight",
            "desc": "50kg",
            "desc2": "Updated yesterday",
            "is_alert": 0
        ],
    ]
    var arrInform : [JSON] = [
        [
            "img": "user1",
            "name": "Establishing Good Sleep Hygiene",
            "desc": "Poor sleep can increase the risk of flare-ups with chronic lung disease, but practicing.. good.. sleep hygiene...  can improve your sleep. Learn 7 sleep hygiene tips here.",
            "desc2": "Updated today",
            "is_alert": 0
        ],
        [
            "img": "user3",
            "name": "The Link Between COPD Flare-Ups and Stress Management",
            "desc": "Chronic stress may also cause more frequent flare-ups of chronic obstructive pulmonary disease (COPD) symptoms. For this reason, it’s important to learn how to manage stress. ",
            "desc2": "last updated Jan 12",
            "is_alert": 1
        ]
    ]
    
    //    var arrPollQuiz : [JSON] = [
    //        [
    //            "img": "user1",
    //            "name": "Poll Card",
    //            "desc": "A castor oil pack can be made easily at home works wonderfully in drawing toxins out of the body.",
    //            "type": "poll",
    //            "type": "poll",
    //            "button": "Start Poll Card"
    //        ],
    //        [
    //            "img": "user1",
    //            "name": "Quiz",
    //            "desc": "A castor oil pack can be made easily at home works wonderfully in drawing toxins out of the body.",
    //            "type": "poll",
    //            "type": "quiz",
    //            "button": "Start Quiz"
    //        ]
    //    ]
    
    //MARK:-------------------- Life Cycle Method --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appStatusActivity), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appStatusActivity), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.isPageVisible = true
        
        Settings().isHidden(setting: .hide_home_chat_bubble) { isHidden in
            if !isHidden {
                FreshDeskManager.shared.addChatButton(vw: self.view)
            }
        }
        
        Settings().isHidden(setting: .hide_home_bca) { [weak self] isHidden in
            guard let self = self else { return }
            print("BCA hidden:- ", isHidden)
            self.vwMyDeviceParent.isHidden = isHidden
        }
        
        Settings().isHidden(setting: .hide_home_my_device) { [weak self] isHidden in
            guard let self = self else { return }
            print("Mydevice hidden:- ", isHidden)
            self.svMydevice.isHidden = isHidden
        }
        
        WebengageManager.shared.navigateScreenEvent(screen: .Home)
        self.kMaxReloadAttempSummary = 0
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if self.isPageVisible {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.apiStart), with: nil, afterDelay: 0.5)
        }
        
        if self.viewModel.arrRecommended.count == 0 {
            self.vwRecommendedParent.isHidden = true
        }
        
        if self.viewModel.arrStayInformed.count == 0 {
            self.vwStayInformed.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            GlobalAPI.shared.getPatientDetailsAPI { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.updateAppData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .Home, when: .Appear)
        //        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIApplication.didBecomeActiveNotification, object: nil)
        
        //        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.isPageVisible = false
        FIRAnalytics.manageTimeSpent(on: .Home, when: .Disappear)
    }
    
    //MARK:-------------------- Memory Management Method --------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:-------------------- Custom Method --------------------
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.addObserverOnHeightTbl()
        self.confugureUI()
        self.manageActionMethods()
        
        self.scrollMain.delegate            = self
        self.vwReadingParent.isHidden       = true
        self.vwBookTestParent.isHidden      = true
        self.vwDoctorQuotesParent.isHidden  = true
        self.vwPollQuizParent.isHidden      = true
        
        //        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
        //        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        //        self.txtMobile.keyboardType     = .numberPad
        
        if !UserDefaultsConfig.isShowHealthPermission {
            UserDefaultsConfig.isShowHealthPermission = true
            
            GFunction.shared.navigateToHealthConnect { obj in
                if obj?.count > 0 {
                    self.viewWillAppear(true)
                }
            }
        }
    }
    
    private func applyStyle() {
        
        //-------------------------- Welcome box
        
        self.lblWelcome
            .font(name: .bold, size: 20).textColor(color: .white)
        self.lblWelcomeDesc
            .font(name: .semibold, size: 16).textColor(color: .white)
        self.lblProfileComplete
            .font(name: .bold, size: 14).textColor(color: .white)
        self.btnWelcomeComplete
            .font(name: .semibold, size: 16).textColor(color: .themePurple)
            .cornerRadius(cornerRadius: 5)
            .themeShadow()
        //-------------------------- Verify email box
        
        self.lblVerifyEmail
            .font(name: .semibold, size: 16).textColor(color: .themeOrange)
        
        //-------------------------- Daily summary
        
        self.lblDailySummary
            .font(name: .bold, size: 20).textColor(color: .themeBlack)
        self.btnViewMoreSummary
            .font(name: .medium, size: 14).textColor(color: .themeBlack)
        
        //-------------------------- Upcoming appointment
        
        self.imgCarePlan.image = UIImage(named: "bcp")
        self.lblCPTitle
            .font(name: .medium, size: 14).textColor(color: .themeBlack).text = "Chronic Care Programs"
        self.lblCPSubTitle
            .font(name: .regular, size: 11).textColor(color: .themeGray).text = "Bundled with lab test and medical devices"
        self.vwCarePlan.borderColor(color: .colorFromHex(hex: 0xF0F0F0)).cornerRadius(cornerRadius: 12.0)
        self.vwCarePlanMain.shadow(color: .themeGray, shadowOffset: .zero, shadowOpacity: 0.1)
        self.lblActive
            .font(name: .semibold, size: 7).textColor(color: .themeNormal).text = "ACTIVE"
        self.vwActive.backGroundColor(color: .themeNormal.withAlphaComponent(0.25)).cornerRadius(cornerRadius: 5.0).isHidden = true
        
        //-------------------------- Upcoming appointment
        
        self.lblUpcomingAppointment
            .font(name: .semibold, size: 16).textColor(color: .themeBlack)
        self.lblAppointmentDoctorName
            .font(name: .semibold, size: 16).textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblAppointmentDoctorDesc
            .font(name: .semibold, size: 16).textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblAppointmentDate
            .font(name: .semibold, size: 17).textColor(color: .themeBlack)
        self.lblAppointmentTime
            .font(name: .semibold, size: 17).textColor(color: .themeBlack)
        self.lblAppointmentAddress
            .font(name: .regular, size: 15).textColor(color: .themeBlack)
        self.btnCancelAppointment
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        self.btnVideoCallAppointment
            .font(name: .medium, size: 14).textColor(color: .white)
            .cornerRadius(cornerRadius: 5)
            .themeShadow()
        //-------------------------- Recommended For you
        
        self.lblRecommended
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        
        //-------------------------- Update reading
        self.lblReading
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        
        //-------------------------- Book Test
        self.lblBookTest
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        self.btnViewMoreBookTest
            .font(name: .semibold, size: 14).textColor(color: .themePurple)
        
        //-------------------------- Doctor quotes
        
        self.lblDoctorQuotesTitle
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        self.lblDoctorQuotesDesc
            .font(name: .regular, size: 12).textColor(color: .themeBlack)
        
        //-------------------------- Stay informed
        
        self.lblStayInformed
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        
        //-------------------------- My Devices
        self.lblMyDevice
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
//            self.svMydevice.isHidden = true
            
            self.setup(collectionView: self.colRecommended)
            self.setup(collectionView: self.colReading)
            self.setup(collectionView: self.colStayInformed)
            self.setup(collectionView: self.colPollQuiz)
            self.setup(collectionView: self.colBookTest)
            
            self.tblDailySummary.tableFooterView        = UIView.init(frame: CGRect.zero)
            self.tblDailySummary.emptyDataSetSource     = self
            self.tblDailySummary.emptyDataSetDelegate   = self
            self.tblDailySummary.delegate               = self
            self.tblDailySummary.dataSource             = self
            self.tblDailySummary.rowHeight              = UITableView.automaticDimension
            self.tblDailySummary.reloadData()
            
            self.tblMyDevices.delegate                  = self
            self.tblMyDevices.dataSource                = self
        }
    }
    
    private func confugureUI() {
        self.vwWelcomeParent.isHidden = true
        self.vwUpcomingAppointmentParent.isHidden = true
        
        DispatchQueue.main.async {
            //-------------------------- Welcome box
            //vwWelcomeParent
            self.vwWelcomeBox.layoutIfNeeded()
            self.vwWelcomeBox.cornerRadius(cornerRadius: 15)
            let colorWelcomeBg = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(0.4),
                                                                     endColor: UIColor.themePurple.withAlphaComponent(0.1),
                                                                     locations: [0, 1],
                                                                     startPoint: CGPoint(x: 0, y: self.vwWelcomeBox.frame.maxY),
                                                                     endPoint: CGPoint(x: self.vwWelcomeBox.frame.maxX, y: self.vwWelcomeBox.frame.maxY),
                                                                     gradiantWidth: self.vwWelcomeBox.frame.width,
                                                                     gradiantHeight: self.vwWelcomeBox.frame.height)
            
            self.vwWelcomeBox.backgroundColor = colorWelcomeBg
            self.welcomeProgressBar.layoutIfNeeded()
            self.setProgress(progressBar: self.welcomeProgressBar, color: UIColor.white)
            self.welcomeProgressBar.progressValue = CGFloat(50)
            
            //-------------------------- Verify email box
            //        @IBOutlet weak var vwVerifyEmailParent          : UIView!
            self.vwVerifyEmailParent.isHidden = true
            self.vwVerifyEmailBox.layoutIfNeeded()
            self.vwVerifyEmailBox.cornerRadius(cornerRadius: 8)
            self.vwVerifyEmailBox.backgroundColor = UIColor.themeOrange.withAlphaComponent(0.1)
            
            //-------------------------- Daily summary
            //@IBOutlet weak var vwDailySummaryParent         : UIView!
            self.btnViewMoreSummary.isSelected = false
            
            //-------------------------- Upcoming appointment
            //        @IBOutlet weak var vwUpcomingAppointmentParent  : UIView!
            self.vwBottom.layoutIfNeeded()
            self.vwBottom.cornerRadius(cornerRadius: 30)
            self.vwBottom.themeShadow()
            
            self.vwUpcomingAppointmentBox.layoutIfNeeded()
            self.vwUpcomingAppointmentBox.cornerRadius(cornerRadius: 8)
                .themeShadow()
            
            self.vwUpcomingAppointmentTitleBox.layoutIfNeeded()
            self.vwUpcomingAppointmentTitleBox.roundCorners([.topLeft, .topRight], radius: 8)
            let colorAppointmentTitle = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(0.1),
                                                                            endColor: UIColor.themePurple.withAlphaComponent(0.4),
                                                                            locations: [0, 1],
                                                                            startPoint: CGPoint(x: 0, y: self.vwUpcomingAppointmentTitleBox.frame.maxY),
                                                                            endPoint: CGPoint(x: self.vwUpcomingAppointmentTitleBox.frame.maxX, y: self.vwUpcomingAppointmentTitleBox.frame.maxY),
                                                                            gradiantWidth: self.vwUpcomingAppointmentTitleBox.frame.width,
                                                                            gradiantHeight: self.vwUpcomingAppointmentTitleBox.frame.height)
            
            self.vwUpcomingAppointmentTitleBox.backgroundColor = colorAppointmentTitle
            
            //        @IBOutlet weak var btnCancelAppointment         : UIButton!
            //        @IBOutlet weak var btnVideoCallAppointment      : UIButton!
            
            //-------------------------- Recommended For you
            //        @IBOutlet weak var vwRecommendedParent          : UIView!
            //        @IBOutlet weak var colRecommended               : UICollectionView!
            
            //-------------------------- Update reading
            //        @IBOutlet weak var vwReadingParent              : UIView!
            //        @IBOutlet weak var colReading                   : UICollectionView!
            
            //-------------------------- Update reading
            self.colBookTest.themeShadow()
            
            //-------------------------- Doctor quotes
            self.updateDoctorCardLayout()
            self.colPollQuiz.themeShadow()
            
            //-------------------------- Stay informed
            //        @IBOutlet weak var vwStayInformed               : UIView!
            //        @IBOutlet weak var colStayInformed              : UICollectionView!
            
            
            //-------------------------- Poll & Quiz
            self.pageControlPollQuiz.drawer = ExtendedDotDrawer.init(numberOfPages: 0,
                                                                     height: self.pageControlPollQuiz.frame.height, width: 12, space: 5, raduis: self.pageControlPollQuiz.frame.height / 2, currentItem: 0, indicatorColor: UIColor.themePurple, dotsColor: UIColor.themePurple.withAlphaComponent(0.5), isBordered: false, borderColor: UIColor.clear, borderWidth: 0, indicatorBorderColor: UIColor.clear, indicatorBorderWidth: 0)
            
            //-------------------------- My Devices
            self.vwTblMyRoutine.layoutIfNeeded()
            self.vwTblMyRoutine.borderColor(color: .ThemeDeviceGray, borderWidth: 1)
            self.vwTblMyRoutine.layer.cornerRadius = 12
        }
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    //MARK:-------------------- Action Method --------------------
    private func manageActionMethods(){
        self.vwVerifyEmailBox.addTapGestureRecognizer {
            GlobalAPI.shared.sendEmailVerificationLinkAPI { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                }
            }
        }
        
        self.btnViewMoreSummary.addTapGestureRecognizer {
            self.manageSummaryList()
        }
        
        self.btnCarePlan.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            var params = [String: Any]()
            FIRAnalytics.FIRLogEvent(eventName: .HOME_CARE_PLAN_CARD_CLICKED, screen: .Home, parameter: params)
            
            if let hcServiceLongestPlan = UserModel.shared.hcServicesLongestPlan {
                let vc = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                vc.viewModel.planDetails = PlanDetail(fromJson: JSON(hcServiceLongestPlan.toDictionary()))
                vc.isBack = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        self.btnViewMoreBookTest.addTapGestureRecognizer {
            let vc = LabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnDailySummaryInfo.addTapGestureRecognizer {
            Alert.shared.showAlert(message: AppMessages.dailySummaryInfo) { [weak self] isDone in
                guard let _ = self else {return}
                
            }
        }
        
        self.vwDoctorQuotesBox.addTapGestureRecognizer { [weak self] in
            guard let _ = self else {return}
            //            Alert.shared.showAlert(message: UserModel.shared.doctorSays.descriptionField ?? "") { (isDone) in
            //
            //            }
            
            if let obj = UserModel.shared.doctorSays {
                if let url = URL(string: obj.deepLink) {
                    let _ = DynamicLinks.dynamicLinks()
                        .handleUniversalLink(url) { dynamiclink, error in
                            // ...
                            print("dynamiclink: \(dynamiclink)")
                            print("dynamiclink url: \(dynamiclink?.url)")
                            sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                        }
                }
            }
        }
    }
}

//MARK: -------------------- set progress bar --------------------
extension HomeVC {
    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightPurple
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
        switch progressBar {
            
        case self.welcomeProgressBar:
            progressBar.barThickness        = 10
            progressBar.barColor            = color
            
            progressBar.barColorForValue = { value in
                switch value {
                case 0..<20:
                    return color
                case 20..<60:
                    return color
                case 60..<80:
                    return color
                default:
                    return color
                }
            }
            break
            
        default: break
        }
    }
    
}

//MARK: -------------------- Manage Summary List Method --------------------
extension HomeVC {
    
    func manageSummaryList(){
        DispatchQueue.main.async {
            if !self.btnViewMoreSummary.isSelected {
                self.btnViewMoreSummary.isSelected = true
                self.tblDailySummary.reloadData()
            }
            else {
                self.btnViewMoreSummary.isSelected = false
                self.tblDailySummary.reloadData()
            }
        }
    }
}

//MARK: -------------------- PollQuiz DoctorSays Manage --------------------
extension HomeVC {
    
    func managePollQuizListWithDocQuotes(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            self.vwDoctorQuotesParent.isHidden  = true
            self.vwPollQuizParent.isHidden      = true
            if self.viewModel.getPollQuizCount() > 0 {
                self.vwPollQuizParent.isHidden      = false
                self.vwDoctorQuotesParent.isHidden  = true
                
                self.colPollQuiz.layoutIfNeeded()
                self.colPollQuiz.reloadData()
                self.colPollQuiz.layoutIfNeeded()
                
                return
            }
            else if let obj = UserModel.shared.doctorSays {
                //            if let obj = UserModel.shared.doctorSays {
                self.vwPollQuizParent.isHidden      = true
                self.vwDoctorQuotesParent.isHidden  = false
                Settings().isHidden(setting: .hide_doctor_says) { isHidden in
                    self.vwDoctorQuotesParent.isHidden  = isHidden
                }
                
                self.lblDoctorQuotesTitle.text = obj.title
                self.lblDoctorQuotesDesc.text  = obj.descriptionField
                
                self.updateDoctorCardLayout()
                return
            }
            self.colPollQuiz.layoutIfNeeded()
            self.colPollQuiz.reloadData()
            self.colPollQuiz.layoutIfNeeded()
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension HomeVC {
    
    @objc func appStatusActivity(_ notification: Notification)  {
        if notification.name == UIApplication.didBecomeActiveNotification{
            // become active notifictaion
            self.viewWillAppear(true)
        }else{
            // willResignActiveNotification
        }
        
    }
    
    @objc func apiStart(){
        self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                               colViewHome: self.colReading)
    }
    
    func updateAppData(){
        if UserModel.shared.profileCompletion == "N" {
            
            let vc = CustomiseProfilePopupVC.instantiate(fromAppStoryboard: .home)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                if obj?.count > 0 {
                    
                    //FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_PROFILE_COMPLETION, parameter: nil)
                    
                    if let obj = UserModel.shared.profileCompletionStatus {
                        if obj.location == "N" {
                            
                            let loc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                            loc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(loc, animated: true)
                        }
                        else if obj.drugPrescription == "N" {
                            let goal = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                            goal.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(goal, animated: true)
                            
                        }
                        else if obj.goalReading == "N" {
                            
                            let goal = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                            goal.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(goal, animated: true)
                        }
                    }
                }
            }
            //self.present(vc, animated: true, completion: nil)///this is hidden for now
        }
        
        UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
            if UserModel.shared.emailVerified == "Y" {
                self.vwVerifyEmailParent.isHidden = true
            }
            else {
                self.vwVerifyEmailParent.isHidden = false
            }
            self.view.layoutIfNeeded()
        } completion: { isDone in
        }
        
        GFunction.shared.updateNotification(btn: self.btnNotification)
        self.tblMyDevices.reloadData()
        
        if let hcServiceLongestPlan = UserModel.shared.hcServicesLongestPlan {
            self.lblCPTitle.text = hcServiceLongestPlan.planName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
            
            let expiringDays = Date().daysBetween((dateFormatter.date(from: hcServiceLongestPlan.expiryDate) ?? Date()))
            
            self.vwActive.isHidden = true
            if expiringDays > 1{
                self.lblCPSubTitle.text = "Expiring in \(expiringDays) days"
            } else if expiringDays == 1 {
                self.lblCPSubTitle.text = "Expiring tomorrow"
            } else if expiringDays == 0 {
                self.lblCPSubTitle.text = "Expiring today"
            } else if expiringDays < 0 {
                self.lblCPSubTitle.text = ""
            }
        }else {
            self.vwActive.isHidden = true
            self.lblCPTitle.text = "Chronic Care Programs"
            self.lblCPSubTitle.text = "Bundled with lab test and medical devices"
        }
        
    }
    
    func updateDoctorCardLayout(){
        self.vwDoctorQuotesParent.layoutIfNeeded()
        self.vwDoctorQuotesParent.backgroundColor = .clear
        self.vwDoctorQuotesParent.themeShadow()
        self.vwDoctorQuotesBox.layoutIfNeeded()
        self.vwDoctorQuotesBox.cornerRadius(cornerRadius: 15)
        
        let colorvwDoctorQuotesBg = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(0.4),
                                                                        endColor: UIColor.themePurple.withAlphaComponent(0.1),
                                                                        locations: [0, 1],
                                                                        startPoint: CGPoint(x: 0, y: self.vwDoctorQuotesBox.frame.maxY),
                                                                        endPoint: CGPoint(x: self.vwDoctorQuotesBox.frame.maxX, y: self.vwDoctorQuotesBox.frame.maxY),
                                                                        gradiantWidth: self.vwDoctorQuotesBox.frame.width,
                                                                        gradiantHeight: self.vwDoctorQuotesBox.frame.height)
        
        
        self.vwDoctorQuotesBox.backgroundColor = colorvwDoctorQuotesBg
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension HomeVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    if self.isOpenGoal {
                        
                        if self.viewModel.arrGoal.count > 0 {
                            for item in self.viewModel.arrGoal {
                                if item.keys == self.isOpenGoalReadingKey {
                                    
                                    var params = [String: Any]()
                                    params[AnalyticsParameters.goal_name.rawValue]   = item.goalName
                                    params[AnalyticsParameters.goal_id.rawValue]     = item.goalMasterId
                                    FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_REMINDER_NOTIFICATION, parameter: params)
                                    
                                    self.selectGoal(obj: item)
                                    self.isOpenGoal = false
                                }
                            }
                        }
                    }
                    if self.isOpenReading {
                        if self.viewModel.arrReading.count > 0 {
                            for item in self.viewModel.arrReading {
                                if item.keys == self.isOpenGoalReadingKey {
                                    
                                    var params = [String: Any]()
                                    params[AnalyticsParameters.reading_name.rawValue]   = item.readingName
                                    params[AnalyticsParameters.reading_id.rawValue]     = item.readingsMasterId
                                    FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_REMINDER_NOTIFICATION, parameter: params)
                                    
                                    self.selectReading(obj: item)
                                    self.isOpenReading = false
                                }
                            }
                        }
                    }
                }
                
                //-----------------------------------------------------------------
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    if self.isPageVisible {
                        self.viewModel.recommended_contentAPI(colView: self.colRecommended,
                                                              withLoader: false) { (isDone) in
                            if isDone {
                                
                                self.vwRecommendedParent.isHidden = false
                                self.colRecommended.layoutIfNeeded()
                                self.colRecommended.reloadData()
                                self.colRecommended.layoutIfNeeded()
                            }
                            else {
                                self.vwRecommendedParent.isHidden = true
                            }
                            
                            //-----------------------------------------------------------------
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                if self.isPageVisible {
                                    
                                    //-----------------------------------------------------------------
                                    //                                    if self.isPageVisible {
                                    //                                        self.viewModel.stay_informedAPI(colView: self.colStayInformed,
                                    //                                                                        withLoader: false) { (isDone) in
                                    //                                            if isDone {
                                    //                                                self.vwStayInformed.isHidden = false
                                    //                                                self.colStayInformed.layoutIfNeeded()
                                    //                                                self.colStayInformed.reloadData()
                                    //                                                self.colStayInformed.layoutIfNeeded()
                                    //                                            }
                                    //                                            else {
                                    //                                                self.vwStayInformed.isHidden = true
                                    //                                            }
                                    //
                                    //                                            if self.isPageVisible {
                                    //                                                self.viewModel.pollQuizListAPI(colView: self.colPollQuiz, completion: nil)
                                    //                                            }
                                    //                                        }
                                    //                                    }
                                    
                                    func stayAndQuiz(){
                                        if self.isPageVisible {
                                            self.viewModel.stay_informedAPI(colView: self.colStayInformed,
                                                                            withLoader: false) { [weak self] (isDone) in
                                                guard let self = self else {return}
                                                if isDone {
                                                    self.vwStayInformed.isHidden = false
                                                    self.colStayInformed.layoutIfNeeded()
                                                    self.colStayInformed.reloadData()
                                                    self.colStayInformed.layoutIfNeeded()
                                                }
                                                else {
                                                    self.vwStayInformed.isHidden = true
                                                }
                                                
                                                if self.isPageVisible {
                                                    self.viewModel.pollQuizListAPI(colView: self.colPollQuiz, completion: nil)
                                                }
                                            }
                                        }
                                    }
                                    Settings().isHidden(setting: .hide_diagnostic_test) { isHidden in
                                        if !isHidden {
                                            self.viewModel.tests_list_homeAPI(colView: self.colBookTest,
                                                                              separate: "No",
                                                                              withLoader: false) { [weak self]  isDone in
                                                guard let self = self else {return}
                                                if isDone {
                                                    
                                                    self.vwBookTestParent.isHidden = false
                                                    self.colBookTest.layoutIfNeeded()
                                                    self.colBookTest.reloadData()
                                                    self.colBookTest.layoutIfNeeded()
                                                }
                                                else {
                                                    self.vwBookTestParent.isHidden = true
                                                }
                                                
                                                //-----------------------------------------------------------------
                                                stayAndQuiz()
                                            }
                                        }
                                        else {
                                            stayAndQuiz()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                //-----------------------------------------------------------------
                DispatchQueue.main.async {
                    if self.viewModel.getGoalCount() > 0 {
                        self.vwDailySummaryParent.isHidden = false
                        
                        if self.viewModel.arrGoal.count <= 4 {
                            self.btnViewMoreSummary.isHidden = true
                        }
                        else {
                            self.btnViewMoreSummary.isHidden = false
                        }
                    }
                    else {
                        self.vwDailySummaryParent.isHidden = true
                        if self.kMaxReloadAttempSummary < kMaxReloadAttemp {
                            self.kMaxReloadAttempSummary += 1
                            self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                                                   colViewHome: self.colReading)
                        }
                    }
                    
                    if self.viewModel.getReadingCount() > 0 {
                        self.vwReadingParent.isHidden = false
                    }
                    else {
                        self.vwReadingParent.isHidden = true
                        if self.kMaxReloadAttempSummary < kMaxReloadAttemp {
                            self.kMaxReloadAttempSummary += 1
                            self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                                                   colViewHome: self.colReading)
                        }
                    }
                }
                
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        // Result binding observer PollQuiz
        self.viewModel.vmResultPollQuiz.bind(observer: { (result) in
            
            self.chatHistoryListVM.apiCallFromStart(list_type: "C",
                                                    refreshControl: nil,
                                                    tblView: nil,
                                                    withLoader: false)
            switch result {
            case .success(_):
                self.managePollQuizListWithDocQuotes()
                
                break
                
            case .failure(_):
                self.managePollQuizListWithDocQuotes()
                //Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
            
            self.startAppTour()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                switch self.screenSection {
                    
                case .DiagnosticTest:
                    self.scrollMain.scrollToView(view: self.vwBookTestParent, animated: true)
                    break
                case .Prescription:
                    break
                case .Records:
                    break
                case .QuizPoll:
                    self.scrollMain.scrollToView(view: self.vwPollQuizParent, animated: true)
                    break
                case .none:
                    break
                }
            }
        })
        
        self.chatHistoryListVM.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Set tag with send msg
                //                let arrTag: [String] = self.chatHistoryListVM.arrList.map { (obj) -> String in
                //                    if obj.tagName.trim() != "" {
                //                        FreshDeskManager.shared.sendMessage(msg: "Welcome to the chat between you and your healthcoach", tag: obj.tagName)
                //                        return obj.healthCoachId
                //                    }
                //                    return ""
                //                }
                //
                //                let arrIds = arrTag.filter({ item in
                //                    return item.trim() != ""
                //                })
                //
                //                self.chatHistoryListVM.update_healthcoach_chat_initiateAPI(health_coach_ids: arrIds) { isDone in
                //                    if isDone {
                //
                //                    }
                //                }
                
                break
                
            case .failure(_):
                //Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
                
            case .none: break
            }
        })
    }
    
    func startAppTour(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            if UserDefaultsConfig.isShowCoachmark {
                GlobalAPI.shared.coach_marksAPI { [weak self] isDone in
                    guard let self = self else {return}
                    if isDone {
                        
                        let vc = CoachmarkHomeVC.instantiate(fromAppStoryboard: .home)
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        vc.completionHandler = { obj in
                            
                            if obj?.count > 0 {
                                
                                self.scrollMain.scrollToView(view: self.vwDailySummaryParent, animated: true)
                                //self.scrollMain.setContentOffset(CGPoint(x: 0, y: self.tblDailySummary.frame.origin.y), animated: true)
                                
                                let vc = CoachmarkHome2VC.instantiate(fromAppStoryboard: .home)
                                vc.targetView = self.tblDailySummary
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalTransitionStyle = .crossDissolve
                                vc.completionHandler = { obj1 in
                                    
                                    if obj1?.count > 0 {
                                        
                                        self.scrollMain.scrollToView(view: self.vwReadingParent, animated: true)
                                        //                                        self.scrollMain.setContentOffset(CGPoint(x: 0, y: self.vwReadingParent.frame.origin.y + self.vwReadingParent.frame.height), animated: true)
                                        
                                        let vc = CoachmarkHome3VC.instantiate(fromAppStoryboard: .home)
                                        vc.targetView = self.colReading
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.completionHandler = { obj2 in
                                            if obj2?.count > 0 {
                                                
                                                let vc = CoachmarkHome4VC.instantiate(fromAppStoryboard: .home)
                                                if let item = self.tabBarController?.tabBar {
                                                    vc.targetTabbar = item
                                                }
                                                vc.modalPresentationStyle = .overFullScreen
                                                vc.modalTransitionStyle = .crossDissolve
                                                vc.completionHandler = { obj3 in
                                                    if obj3?.count > 0 {
                                                        if let tab = self.tabBarController {
                                                            tab.selectedIndex = 1
                                                            if let carePlanVC = (tab.viewControllers?[1] as? UINavigationController)?.viewControllers.first as? CarePlanVC{
                                                                carePlanVC.isContinueCoachmark = true
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
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
