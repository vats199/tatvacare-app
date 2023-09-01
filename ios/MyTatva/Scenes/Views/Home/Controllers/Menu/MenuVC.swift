//
//  MenuVC.swift

//
//  Copyright © 2021. All rights reserved.
//

import UIKit

enum MenuList : String, CaseIterable {
    case FoodDiary          = "Food Diary"
    case OrderTest          = "Order Tests"
    case MyTatvaPlans       = "MyTatva Plans"
    case TransactionHistory = "Transaction History"
    case DefineYourGoals    = "Define Your Goals"
    case GoalsHealthTrends  = "Goals and Health Trends"
    case DiagnosticReport   = "Diagnostic Report(s)"
    case YourBadges         = "Your Badges"
    case History            = "History"
    case Bookmarks          = "Bookmarks"
    case BookAppointment    = "Book Appointment"
    case BookTest           = "Book Your Test"
    case AppTour            = "App Tour"
    case ShareApp           = "Share App"
    case RateApp            = "Rate App"
    case ReportIncident     = "Report Incident"
    case ContactUs          = "Contact Us"
    case FAQs               = "FAQs"
    case Terms              = "Terms & Conditions"
    case PrivacyPolicy      = "Privacy Policy"
    case Logout             = "Logout"
}

class MenuVC: UIViewController {
    
    //MARK: -------------------------- Outlets --------------------------
    @IBOutlet weak var vwTop                : UIView!
    @IBOutlet weak var imgUser              : UIImageView!
    @IBOutlet weak var lblUser              : UILabel!
    @IBOutlet weak var lblPlanType          : UILabel!
    @IBOutlet weak var lblDoctor            : UILabel!
    @IBOutlet weak var btnAccountSetting    : UIButton!
    
    @IBOutlet weak var lblPatientMode       : UILabel!
    @IBOutlet weak var btnSwitchMode        : UIButton!
    
    @IBOutlet weak var tblMenuList          : UITableView!
    
    @IBOutlet weak var lblVersion           : UILabel!
    
    //MARK: -------------------------- Class Variable --------------------------
    ///set up DiffableDataSource of menu list table
    typealias tblMenuDataSource = UITableViewDiffableDataSource<Int, MenuListModel>
    lazy var menuDataSource: tblMenuDataSource = {
      let datasource = tblMenuDataSource(tableView: self.tblMenuList,
                                         cellProvider: { (tableView, indexPath, object) -> UITableViewCell? in
          let cell      = tableView.dequeueReusableCell(withClass: MenuCell.self, for: indexPath)
          cell.object   = object
          return cell
      })
      return datasource
    }()
    
    fileprivate var arrMenuListTemp : [JSON] = []
    fileprivate var arrMenuList: [MenuListModel] = []
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: -------------------------- UserDefined Methods --------------------------
    fileprivate func setUpView() {
        self.applyStyle()
        self.updateMenuData()
        self.setup(tblView: self.tblMenuList)
        self.manageActionMethods()
        
        DispatchQueue.main.async {
            self.imgUser.layoutIfNeeded()
            //self.imgUser.cornerRadius(cornerRadius: self.imgUser.frame.size.height / 2)
        }
        
    }
    
    fileprivate func setup(tblView: UITableView){
        self.tblMenuList.delegate                   = self
//        self.tblMenuList.dataSource                 = self
        self.tblMenuList.rowHeight                  = UITableView.automaticDimension
        
        self.applySnapshot()
    }
    
    func applySnapshot(){
        ///Apply snapshot
        var snapshot = self.menuDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(self.arrMenuList, toSection: 0)
        self.menuDataSource.apply(snapshot)
    }
    
    fileprivate func applyStyle(){
        self.lblUser
            .font(name: .semibold, size: 20)
            .textColor(color: .themeBlack)
        self.lblPlanType
            .font(name: .regular, size: 15)
            .textColor(color: .themeBlack)
        
        self.lblDoctor
            .font(name: .regular, size: 15)
            .textColor(color: .themeBlack)
        self.btnAccountSetting
            .font(name: .regular, size: 15)
            .textColor(color: .themePurple)
        self.lblVersion
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblVersion.text = "V " + "\(Bundle.main.releaseVersionNumber ?? "")"
        //+ "(\(Bundle.main.buildVersionNumber ?? ""))"
        
        self.lblPatientMode.font(name: .regular, size: 17).textColor(color: .themePurple)
        
        let strMode            = "Switch to caregiver mode"
        
        let defaultDicPrice : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themePurple as Any
        ]
        let attributeDicPrice : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themePurple,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        self.btnSwitchMode.setAttributedTitle(strMode.getAttributedText(defaultDic: defaultDicPrice, attributeDic: attributeDicPrice, attributedStrings: [strMode]), for: .normal)
        
    }
    
    //MARK: -------------------------- Action Method --------------------------
    private func manageActionMethods(){
        self.hero.isEnabled     = true
        self.imgUser.hero.id    = "imgUser"
        self.imgUser.addTapGestureRecognizer {
//            let vc = AccountSettingVC.instantiate(fromAppStoryboard: .setting)
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.hero.isEnabled = true
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = ProfileVC.instantiate(fromAppStoryboard: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.lblUser.addTapGestureRecognizer {
//            let vc = AccountSettingVC.instantiate(fromAppStoryboard: .setting)
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.hero.isEnabled = true
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = ProfileVC.instantiate(fromAppStoryboard: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnAccountSetting.addTapGestureRecognizer {
            let vc = AccountSettingVC.instantiate(fromAppStoryboard: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .Menu, when: .Appear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        WebengageManager.shared.navigateScreenEvent(screen: .Menu)
        self.setData()
        self.updateMenuData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .Menu, when: .Disappear)
    }
}

//MARK: -------------------------- UITableview delegate method --------------------------
extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let strTitle = self.arrMenuListTemp[indexPath.row]["name"].stringValue.localized
        let strTitle = self.arrMenuList[indexPath.row].name
        
        if let menuItem = MenuList.init(rawValue: strTitle!) {
            var params                                  = [String : Any]()
            params[AnalyticsParameters.menu.rawValue]   = menuItem.rawValue
            FIRAnalytics.FIRLogEvent(eventName: .MENU_NAVIGATION,
                                     screen: .Menu,
                                     parameter: params)
            
            switch menuItem {
                
            case .FoodDiary:
                PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                   sub_features_id: GoalType.Diet.rawValue,
                                                   completion: { isAllow in
                    if isAllow {
                        let vc = FoodDiaryParentVC.instantiate(fromAppStoryboard: .goal)
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        PlanManager.shared.alertNoSubscription()
                    }
                })
                break
            case .OrderTest:
                break
            case .MyTatvaPlans:
//                let vc = PlanParentVC.instantiate(fromAppStoryboard: .setting)
                let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .YourBadges:
                break
            case .History:
                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Bookmarks:
                PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow {
                        let vc = BookmarkVC.instantiate(fromAppStoryboard: .engage)
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        PlanManager.shared.alertNoSubscription()
                    }
                })
                break
            case .BookAppointment:
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
                break
            case .BookTest:
                let vc = LabTestListVC.instantiate(fromAppStoryboard: .carePlan)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .AppTour:
                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.isShowCoachmark)
                UIApplication.shared.setHome()
                break
            case .ShareApp:
                //            GFunction.shared.openShareSheet(this: self, msg: AppCredential.shareapp.rawValue)
                GFunction.shared.openShareSheet(this: self, msg: "https://mytatva.page.link/Tqvv")
                break
            case .RateApp:
                GFunction.shared.rateApp()
                break
            case .ReportIncident:
                FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_REPORT_INCIDENT,
                                         screen: .Menu,
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
                                                                                 response: object!["response"] as! [[String: Any]]) { [weak self] (isDone, msg) in
                                            guard let _ = self else {return}
                                            if isDone {
                                            }
                                        }
                                    }
                                }
                            }
                            //                        let vc = CorrectAnswerPopUpVC.instantiate(fromAppStoryboard: .carePlan)
                            //                        vc.modalPresentationStyle = .overFullScreen
                            //                        vc.modalTransitionStyle = .crossDissolve
                            //                        self.present(vc, animated: false, completion: nil)
                            //            let nav = UINavigationController(rootViewController: vc)
                            //            UIApplication.topViewController()?.present(nav, animated: false, completion: nil)
                        }
                        
                        self.dismiss(animated: true) {
                            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                break
            case .FAQs:
                break
            case .Logout:
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.logoutMessage) { [weak self] (isDone) in
                            guard let self = self else {return}
                            if isDone {
                                //UIApplication.shared.forceLogOut()
                                GlobalAPI.shared.logoutAPI { [weak self] (isDone) in
                                    guard let _ = self else {return}
                                    if isDone {
                                        
                                        if kUserSessionActive {
                                            kUserSessionActive      = false
                                            FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_END,
                                                                     screen: .Menu  ,
                                                                     parameter: nil)
                                        }
                                        
                                        UIApplication.shared.forceLogOut()
                                    }
                                }
                            }
                        }
                    }
                }
                break
            case .TransactionHistory:
                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                vc.selectedType = .Payments
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .DefineYourGoals:
                let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .GoalsHealthTrends:
                let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .DiagnosticReport:
                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                vc.selectedType = .Tests
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .ContactUs:
                let vc = HelpAndSupportVC.instantiate(fromAppStoryboard: .setting)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .Terms:
                //            GFunction.shared.openLink(strLink: kTerms, inApp: true)
                let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
                vc.webType = .Terms
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
//                let vc = WebViewPopupVC.instantiate(fromAppStoryboard: .setting)
//                vc.webType = .Terms
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
//                UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
                break
            case .PrivacyPolicy:
                let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
                vc.webType = .Privacy
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
//                let vc = WebViewPopupVC.instantiate(fromAppStoryboard: .setting)
//                vc.webType = .Privacy
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
//                UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
                break
            }
        }
        
    }
}

//MARK: ----------------------- Set data -----------------------
extension MenuVC {
    
    fileprivate func setData() {
        let data                = UserModel.shared
        
//        self.lblGreeting.text   = GFunction.shared.getGreeting()
        
        self.imgUser.image          = nil
        self.imgUser.setCustomImage(with: data.profilePic ?? "", andLoader: true, completed: nil)
        self.lblUser.text           = data.name
        self.lblPlanType.text       = ""//"Coach Premium Plan"
        
        /*if UserModel.shared.patientPlans != nil {
            for plan in UserModel.shared.patientPlans {
                if plan.planType == kSubscription ||
                    plan.planType == KTrial ||
                    plan.planType == KFree {
                    self.lblPlanType.text = plan.planName
                }
            }
        }*/
        
        self.lblPlanType.text = UserModel.shared.hcServicesLongestPlan == nil ? "" : UserModel.shared.hcServicesLongestPlan.planName
        
        self.lblDoctor.text         = "Dr. Sameer Sharma"
        //self.btnAccountSetting    = "Coach Premium Plan"
        self.lblPatientMode.text    = "Patient Mode is on"
        //self.btnSwitchMode.text     = "Coach Premium Plan"
    }
    
    fileprivate func updateMenuData(){
        self.arrMenuList.removeAll()
        for item in MenuList.allCases {
            
            switch item {
                
            case .FoodDiary:
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "food_diary"
//                obj.index       = 0
//                self.arrMenuList.append(obj)
                break
            case .OrderTest:
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "order_test"
//                obj.index       = 1
//                self.arrMenuList.append(obj)
                break
            case .MyTatvaPlans:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "tatva_plans"
                obj.index       = 0
                self.arrMenuList.append(obj)
                break
                
            case .TransactionHistory:
                PlanManager.shared.isAllowedByPlan(type: .history_payments,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow {
                        let obj         = MenuListModel()
                        obj.name        = item.rawValue
                        obj.imageName   = "TransactiionHistory"
                        obj.index       = 1
                        self.arrMenuList.append(obj)
                    }
                })
                
                break
                
            case .DefineYourGoals:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "DefineGoals"
                obj.index       = 2
                self.arrMenuList.append(obj)
                break
                
            case .GoalsHealthTrends:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "HealthTrends"
                obj.index       = 3
                self.arrMenuList.append(obj)
                break
                
            case .DiagnosticReport:
                Settings().isHidden(setting: .hide_diagnostic_test) { isHidden in
                    if !isHidden {
                        let obj         = MenuListModel()
                        obj.name        = item.rawValue
                        obj.imageName   = "DiagnosticReport"
                        obj.index       = 4
                        self.arrMenuList.append(obj)
                    }
                }
                break
                
            case .Bookmarks:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "bookmarks"
                obj.index       = 5
                self.arrMenuList.append(obj)
                break
                
            case .History:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "history"
                obj.index       = 6
                self.arrMenuList.append(obj)
                break
              
            case .AppTour:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "menu_app_tour"
                obj.index       = 6
                self.arrMenuList.append(obj)
                break
                
            case .ShareApp:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "share_filled"
                obj.index       = 7
                self.arrMenuList.append(obj)
                break
                
            case .RateApp:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "rate_ic"
                obj.index       = 8
                self.arrMenuList.append(obj)
                break
            
            case .ContactUs:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "contactUs"
                obj.index       = 9
                self.arrMenuList.append(obj)
                break
                
            case .Terms:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "Terms_purple"
                obj.index       = 10
                self.arrMenuList.append(obj)
                break
                
            case .PrivacyPolicy:
                let obj         = MenuListModel()
                obj.name        = item.rawValue
                obj.imageName   = "privacy_policy"
                obj.index       = 11
                self.arrMenuList.append(obj)
                break
                
            case .YourBadges:
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "badge"
//                obj.index       = 3
//                self.arrMenuList.append(obj)
                break
            
            case .ReportIncident:
                //        if data.medicalConditionName.count > 0 {
                //            if !data.medicalConditionName[0].medicalConditionName.lowercased()
                //                .contains(kNASH.lowercased()) &&
                //                !data.medicalConditionName[0].medicalConditionName.lowercased()
                //                .contains(kNAFL.lowercased()){
                //
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "report"
//                obj.index       = 7
//                self.arrMenuList.append(obj)
                //            }
                //        }
//                if !hide_incident_surveyMain {
//                    let obj         = MenuListModel()
//                    obj.name        = item.rawValue
//                    obj.imageName   = "report"
//                    obj.index       = 7
//                    self.arrMenuList.append(obj)
//                }
                break
            
            case .FAQs:
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "food_diary"
//                obj.index       = 9
//                self.arrMenuList.append(obj)
                break
            
            case .BookAppointment:
                //if UserModel.shared.patientGuid.trim() != "" {
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "home_date"
//                obj.index       = 13
//                self.arrMenuList.append(obj)
//            }
                break
            case .BookTest:
//                Settings.isHidden(setting: .hide_diagnostic_test) { isHidden in
//                    if !isHidden {
//                        let obj         = MenuListModel()
//                        obj.name        = item.rawValue
//                        obj.imageName   = "menu_test"
//                        obj.index       = 14
//                        self.arrMenuList.append(obj)
//                    }
//                }
                break
            case .Logout:
//                let obj         = MenuListModel()
//                obj.name        = item.rawValue
//                obj.imageName   = "menu_logout_dark"
//                obj.index       = 15
//                self.arrMenuList.append(obj)
                break
            }
        }
        self.arrMenuList = self.arrMenuList.sorted(by: { obj1, obj2 in
            return obj1.index < obj2.index
        })
        
        self.applySnapshot()
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension MenuVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblMenuList {
            let contentOffset = scrollView.contentOffset
            let scale       = (-contentOffset.y * 0.0001) + 1
            let translate   = (-contentOffset.y * 0.05) + 1
            if contentOffset.y <= 0 {
                self.vwTop.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.lblVersion.transform = CGAffineTransform(translationX: translate, y: 0)
            }
            else {
                self.vwTop.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.lblVersion.transform = CGAffineTransform(translationX: (translate), y: 0)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        switch scrollView {
        case self.tblMenuList:
            if scrollView.isAtBottom {
            }
            break
        default:
            break
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            //didEndDecelerating will be called for sure
            return
        }
        switch scrollView {
        case self.tblMenuList:
            if scrollView.isAtBottom {
            }
            break
        default:
            break
        }
    }
}
