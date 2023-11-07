//
//  Navigation.swift
//  MyTatva
//
//  Created by Macbook Pro on 14/09/23.
//

import Foundation
//  Navigation.swift
import React
@objc(Navigation)
class Navigation: NSObject {
    
    @objc
    func showTabbar() -> Void {
        DispatchQueue.main.async {
            if let tabbar = UIApplication.topViewController()?.parent as? TabbarVC {
                tabbar.tabBar.isHidden = false
            }
        }
    }
    
    @objc
    func hideTabbar() -> Void {
        DispatchQueue.main.async {
            if let tabbar = UIApplication.topViewController()?.parent as? TabbarVC {
                tabbar.tabBar.isHidden = true
            }
        }
    }
    
    @objc
    func navigateToHistory(_ selectedType: NSString) -> Void {
        let historyModelVC = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
        historyModelVC.selectedType = HistoryType(rawValue: selectedType as String)
        navigate(modelVC: historyModelVC)
    }
    
    @objc
    func navigateToIncident(_ surveyDetails :NSArray) -> Void {
        let planData = surveyDetails.firstObject as? NSDictionary
        let surveyDetails = planData?["surveyDetails"] as? NSDictionary
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: surveyDetails!, options: [])
            let obj = IncidentSurvayModel(fromJson: try JSON.init(data: jsonData))
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
                                    //self.updateIncident(completion: nil)
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
        }catch {
            print(error)
        }
        
        //Uncomment below to open care paln tab from tabbar
        /*if let carePlan = UIApplication.topViewController()?.parent as? TabbarVC {
            DispatchQueue.main.async {
                carePlan.selectedIndex = 1
            }
        }*/
    }
    
    @objc
    func navigateToEngagement(_ content_id : NSString) -> Void {
        let engageModelVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
        engageModelVC.contentMasterId = (content_id as String)
        //        navigate(modelVC: engageModelVC)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.navigationController?.pushViewController(engageModelVC, animated: true)
        }
    }
    
    @objc
    func navigateToShareKit() -> Void {
        DispatchQueue.main.async {
            if let vc = UIApplication.topViewController() {
                GFunction.shared.openShareSheet(this: vc, msg: "https://mytatva.page.link/Tqvv")
            }
        }
    }
    
    
    @objc
    func openPlanDetails(_ planDetails :NSArray) -> Void {
        let planData = planDetails.firstObject as? NSDictionary
        let planDetails = planData?["planDetails"] as? NSDictionary
        do {    
            let jsonData = try JSONSerialization.data(withJSONObject: planDetails!, options: [])
            let vc = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.viewModel.planDetails = PlanDetail(fromJson: try JSON.init(data: jsonData))
            vc.isBack = true
            navigate(modelVC: vc)
        }catch {
            print(error)
        }
    }
    
    @objc
    func onPressRenewPlan(_ planDetails: NSArray) -> Void {
        let planData = planDetails.firstObject as? NSDictionary
        let planDetails = planData?["planDetails"] as? NSDictionary
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: planDetails!, options: [])
            let object = PlanDetail(fromJson: try JSON.init(data: jsonData))
            GlobalAPI.shared.planDetailsAPI(plan_id: object.planMasterId,
                                            durationType: object.enableRentBuy ? object.planType == kIndividual ? kRent : nil : nil,
                                            patientPlanRelId: object.patientPlanRelId,
                                            withLoader: true) { [weak self] isDone, object1, msg in
                guard let self = self else {return}
                if isDone {
                    let vc = BCPCarePlanDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                    
                    vc.plan_id              = object.planMasterId
                    vc.viewModel.cpDetail   = object1
                    vc.patientPlanRelId     = object.patientPlanRelId
    //                vc.isScrollToBuy    = isScrollToBuy
                    vc.completionHandler = { obj in
                      //to refresh data
                    }
                    self.navigate(modelVC: vc)
                }
            }
        }catch {
            print(error)
        }
       
    }
    
    @objc
    func navigateToPlan(_ selectedType: NSString) -> Void {
        if let hcServiceLongestPlan = UserModel.shared.hcServicesLongestPlan {
            let planModelVC = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            planModelVC.viewModel.planDetails = PlanDetail(fromJson: JSON(hcServiceLongestPlan.toDictionary()))
            planModelVC.isBack = true
            DispatchQueue.main.async {
                UIApplication.topViewController()?.navigationController?.pushViewController(planModelVC, animated: true)
            }
        } else {
            let planModelVC = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            DispatchQueue.main.async {
                UIApplication.topViewController()?.navigationController?.pushViewController(planModelVC, animated: true)
            }
        }
    }
    
    
    @objc
    func navigateToBookmark() -> Void {
        
        DispatchQueue.main.async {
            PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    let vc = BookmarkVC.instantiate(fromAppStoryboard: .engage)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigate(modelVC: vc)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
            
        }
    }
    
    @objc
    func navigateToMedicines(_ selectedType: NSString) -> Void {
        PlanManager.shared.isAllowedByPlan(type: .add_medication,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    let vc = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                    vc.isEdit = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigate(modelVC: vc)
                }
            }
            else {
                PlanManager.shared.alertNoSubscription()
            }
        })
    }
    
    @objc
    func navigateToExercise(_ selectedType: NSArray) -> Void {
        PlanManager.shared.isAllowedByPlan(type: .exercise_my_routine_exercise,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow {
                if let tabbarVC = UIApplication.topViewController()?.parent as? TabbarVC {
                    DispatchQueue.main.async {
                        tabbarVC.selectedIndex = 3
                    }
                }
            }
            else {
                self.openMedicineExerciseDiet(selectedType)
            }
        })
    }
    
    @objc
    func navigateToDiscover() -> Void {
        if let tabbarVC = UIApplication.topViewController()?.parent as? TabbarVC {
            DispatchQueue.main.async {
                tabbarVC.selectedIndex = 2
            }
        }
    }
    
    @objc
    func navigateToChronicCareProgram(_ selectedType: NSString) -> Void {
        DispatchQueue.main.async {
            let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.showPlanType = BCPCarePlanVC.planType(rawValue: selectedType as String)
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func navigateToBookAppointment(_ selectedType: NSString) -> Void {
        PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow {
                DispatchQueue.main.async {
                    print("selected appointment:", selectedType)
                    let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.selectedFor = .D
                    if selectedType == "HC" {
                        vc.selectedFor = .H
                    }
                    vc.hidesBottomBarWhenPushed = true
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                DispatchQueue.main.async {
                    PlanManager.shared.alertNoSubscription()
                }
            }
        })
    }
    
    @objc
    func openMedicineExerciseDiet(_ selectedType: NSArray) {
        let fileteredData = selectedType.firstObject as? NSDictionary
        let key = (selectedType[1] as? NSDictionary)?["firstRow"] as? String
        let array = fileteredData?["filteredData"] as? NSArray ?? []
        var arrReadingList: [GoalListModel] = []
        do {
            for data in array {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                arrReadingList.append(GoalListModel(fromJson: JSON.init(data)))
            }
            let selectedIndex = arrReadingList.firstIndex(where: { $0.keys == key})
            
            let vc = UpdateGoalParentVC.instantiate(fromAppStoryboard: .goal)
            
            
            vc.selectedIndex            = selectedIndex ?? 0
            vc.arrList                  = arrReadingList
            vc.modalPresentationStyle   = .overFullScreen
            vc.modalTransitionStyle     = .crossDissolve
            
            
            vc.completionHandler = { obj in
                print("data waiting to updated---")
                if obj?.count > 0 {
                    print("data updated---")
                    RNEventEmitter.emitter.sendEvent(withName: "updatedGoalReadingSuccess", body: [:])
                }
            }
            DispatchQueue.main.async {
                UIApplication.topViewController()?.present(vc, animated: true)
            }
        }catch{
            print(error)
        }
    }
    
    @objc
    func openUpdateGoal(_ selectedType: NSArray) {
        let fileteredData = selectedType.firstObject as? NSDictionary
        let key = (selectedType[1] as? NSDictionary)?["firstRow"] as? String
        let array = fileteredData?["filteredData"] as? NSArray ?? []
        var arrReadingList: [GoalListModel] = []
        do{
            for data in array {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                arrReadingList.append(GoalListModel(fromJson: JSON.init(data)))
            }
            let myHealthDiaryItems = ["Diet", "Medication", "Exercise"]
            arrReadingList = arrReadingList.filter({!myHealthDiaryItems.contains($0.goalName)})
            let selectedIndex = arrReadingList.firstIndex(where: { $0.keys == key})
            
            let vc = UpdateGoalParentVC.instantiate(fromAppStoryboard: .goal)
            
            
            vc.selectedIndex            = selectedIndex ?? 0
            vc.arrList                  = arrReadingList
            vc.modalPresentationStyle   = .overFullScreen
            vc.modalTransitionStyle     = .crossDissolve
            
            
            vc.completionHandler = { obj in
                print("data waiting to updated---")
                if obj?.count > 0 {
                    print("data updated---")
                    RNEventEmitter.emitter.sendEvent(withName: "updatedGoalReadingSuccess", body: [:])
                }
                /*if type == .Medication ||
                 type == .Pranayam {
                 
                 if obj?.count > 0 {
                 print(obj ?? "")
                 //self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,colViewHome: self.colReading,withLoader: false)
                 }
                 }
                 else {
                 if obj?.count > 0 {
                 print(obj ?? "")
                 //object
                 //self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,colViewHome: self.colReading,withLoader: false)
                 }
                 }*/
            }
            DispatchQueue.main.async {
                UIApplication.topViewController()?.present(vc, animated: true)
            }
        }catch {
            print(error)
        }
    }
    
    @objc
    func openAddWeightHeight(){
        let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
        vc.isEdit = true
        DispatchQueue.main.async {
            vc.hidesBottomBarWhenPushed = true
            self.navigate(modelVC: vc)
        }
    }
    
    @objc
    func openUpdateReading(_ selectedType: NSArray) -> Void {
        
        //let fileteredData = selectedType.firstObject as? NSDictionary
        //print(fileteredData?["filteredData"],"===========>>")
        //print(fileteredData?["filteredData"] as? [ReadingListModel] ?? [],"+++++++++++++")
        
        // let data = fileteredData?["filteredData"] as! NSDictionary
        //print(data,"+++++++++>>")
        
        
        
        
        //let obj = ReadingListModel(backgroundColor: "#BE89F0", imageIconUrl: "https://admin-uat.mytatva.in/assets/azure_images/icons/pef.png", colorCode: "#BE89F0", createdAt: "2023-02-02 11:32:19", imageUrl: "https://admin-uat.mytatva.in/assets/azure_images/icons/pef.png", imgExtn: "", isActive: "", isDeleted: "0", keys: "pef", mandatory: "N", maxLimit: "1", measurements: "", minLimit: "", readingName: "pef", readingsMasterId: "", updatedAt: "", updatedBy: "", readingDatetime: "", readingValue: 0.0, information: "", duration: 2, readingRequired: "", totalReadingAverage: "", defaultReading: "", graph: "", inRange: nil, notConfigured: "")
        /*DispatchQueue.main.async {
         let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
         vc.readingType          = .FEV1Lung
         vc.readingListModel     = readingList
         self.navigate(modelVC: vc)
         //        self.pages.append(vc)
         return
         }*/
        let fileteredData = selectedType.firstObject as? NSDictionary
        
        do {
            let key = (selectedType[1] as? NSDictionary)?["firstRow"] as? String
            //print(key)
            let array = fileteredData?["filteredData"] as? NSArray ?? []
            var arrReadingList: [ReadingListModel] = []
            
            for data in array {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                arrReadingList.append(ReadingListModel(fromJson: JSON.init(jsonData)))
            }
            let selectedIndex = arrReadingList.firstIndex(where: { $0.keys == key})
            let vc = UpdateReadingParentVC.instantiate(fromAppStoryboard: .goal)
            vc.selectedIndex = selectedIndex ?? 0
            
            vc.arrList = arrReadingList//fileteredData?["filteredData"] as? [ReadingListModel] ?? []
            
            vc.completionHandler = { obj in
                print("data waiting to updated---")
                if obj?.count > 0 {
                    print("data updated---")
                    RNEventEmitter.emitter.sendEvent(withName: "updatedGoalReadingSuccess", body: [:])
                    //print(obj ?? "")
                    //object
                    //                                    self.tblReadings.reloadData()
                    //self.viewModel.apiCallFromStart_reading(refreshControl: self.refreshControl, tblView: self.tblGoals,withLoader: true)
                }
            }
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                UIApplication.topViewController()?.present(vc, animated: true)
            }
        }catch {
            print(error)
        }
        
        
        
        
        //print(fileteredData?["filteredData"],"===========>>")
        //print(fileteredData?["filteredData"] as? NSArray ?? [],"+++++++++++++")
        
    }
    
    
    @objc
    func openHealthKitSyncView() {
        //if UserDefaultsConfig.isShowCoachmark {
        if !UserDefaultsConfig.isShowHealthPermission {
            UserDefaultsConfig.isShowHealthPermission = true
            DispatchQueue.main.async {
                GFunction.shared.navigateToHealthConnect { obj in
                    if obj?.count > 0 {
                        //self.viewWillAppear(true)
                    }
                }
            }
            
            //UserDefaultsConfig.isShowCoachmark = false
        }
        // }
    }
    
    
    //    @objc
    //        func showPopUpBMI(_ selectedType: NSString) -> Void {
    //            let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
    //            vc.readingType          = .SPO2
    //            vc.readingListModel     = item
    //            self.pages.append(vc)
    //        }
    
    @objc func navigate(modelVC: UIViewController) {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.navigationController?.pushViewController(modelVC, animated: true)
//            let navController = UINavigationController(rootViewController: modelVC)
//            navController.modalPresentationStyle = .fullScreen
//            let topController = UIApplication.topViewController()
//            topController?.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc
    func navigateTo(_ destination: NSString) -> Void {
        var modelVC: UIViewController;
        switch destination {
        case "GlobalSearchParentVC":
            modelVC = GlobalSearchParentVC.instantiate(fromAppStoryboard: .home)
        case "SearchDeviceVC":
            modelVC = SearchDeviceVC.instantiate(fromAppStoryboard: .home)
        case "IncidentHistoryListVC":
            modelVC = IncidentHistoryListVC.instantiate(fromAppStoryboard: .setting)
        case "PlanDetailsVC":
            modelVC = PlanDetailsVC.instantiate(fromAppStoryboard: .setting)
        case "ExerciseParentVC":
            modelVC = ExerciseParentVC.instantiate(fromAppStoryboard: .exercise)
        case "LabTestListVC":
            modelVC = LabTestListVC.instantiate(fromAppStoryboard: .carePlan)
        case "AllLabTestListVC":
            modelVC = AllLabTestListVC.instantiate(fromAppStoryboard: .carePlan)
        case "NotificationVC":
            modelVC = NotificationVC.instantiate(fromAppStoryboard: .setting)
        case "SettingVC":
            modelVC = SettingVC.instantiate(fromAppStoryboard: .setting)
        case "ProfileVC":
            modelVC = ProfileVC.instantiate(fromAppStoryboard: .setting)
        case "AppointmentsHistoryVC":
            modelVC = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
        case "SetLocationVC":
            modelVC = SetLocationVC.instantiate(fromAppStoryboard: .auth)
            (modelVC as? SetLocationVC)?.isEdit = true
        case "SetGoalsVC":
            modelVC = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
            
        case "AccountSettingVC":
            modelVC = AccountSettingVC.instantiate(fromAppStoryboard: .setting)
        case "BCPCarePlanDetailVC":
            //            modelVC = BCPCarePlanDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
            modelVC = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
        case "FoodDiaryParentVC":
            modelVC = FoodDiaryParentVC.instantiate(fromAppStoryboard: .goal)
        case "UpdateGoalParentVC":
            modelVC =   UpdateMedicationPopupVC.instantiate(fromAppStoryboard: .goal)
        case "HelpAndSupportVC":
            modelVC =   HelpAndSupportVC.instantiate(fromAppStoryboard: .setting)
            //        case "HistoryParentVC":
        case "MyDevices":
            modelVC
            = DevicesVC.instantiate(fromAppStoryboard: .home)
        default:
            return;
        }
        
        navigate(modelVC: modelVC)
    }
    
    @objc
    func goBack() -> Void {
        DispatchQueue.main.async {
            let topController = UIApplication.topViewController()
            topController?.dismiss(animated: true, completion: nil)
        }
    }
}

@objc(RNEventEmitter)
open class RNEventEmitter: RCTEventEmitter {

  public static var emitter: RCTEventEmitter!

  override init() {
    super.init()
    RNEventEmitter.emitter = self
  }

  open override func supportedEvents() -> [String] {
    ["updatedGoalReadingSuccess","bookmarkUpdated","bottomTabNavigationInitiated","profileUpdatedSuccess","locationUpdatedSuccessfully"]
  }
}
