//
//  Navigation.swift
//  MyTatva
//
//  Created by Macbook Pro on 14/09/23.
//

import Foundation
//  Navigation.swift
@objc(Navigation)
class Navigation: NSObject {
    
    
    
    @objc
    func navigateToHistory(_ selectedType: NSString) -> Void {
        let historyModelVC = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
        historyModelVC.selectedType = HistoryType(rawValue: selectedType as String)
        navigate(modelVC: historyModelVC)
    }
    @objc
    func navigateToIncident() -> Void {
        if let carePlan = UIApplication.topViewController()?.parent?.parent as? TabbarVC {
            DispatchQueue.main.async {
                carePlan.selectedIndex = 1
            }
            
        }
    }
    
    @objc
    func navigateToEngagement(_ content_id : NSString) -> Void {
        let engageModelVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
        engageModelVC.contentMasterId = (content_id as String)
        navigate(modelVC: engageModelVC)
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
    func navigateToPlan(_ selectedType: NSString) -> Void {
        
        if let hcServiceLongestPlan = UserModel.shared.hcServicesLongestPlan {
            let planModelVC = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            planModelVC.viewModel.planDetails = PlanDetail(fromJson: JSON(hcServiceLongestPlan.toDictionary()))
            planModelVC.isBack = true
            navigate(modelVC: planModelVC)
        }else {
            let planModelVC = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            navigate(modelVC: planModelVC)
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
    func openAlert(_ selectedType: NSArray) -> Void {
        
        //let fileteredData = selectedType.firstObject as? NSDictionary
               //print(fileteredData?["filteredData"],"===========>>")
       //        print(fileteredData?["filteredData"] as? [ReadingListModel] ?? [],"+++++++++++++")
        
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
        print(fileteredData?["filteredData"],"===========>>")
        print(fileteredData?["filteredData"] as? NSArray ?? [],"+++++++++++++")
        let key = (selectedType[1] as? NSDictionary)?["firstRow"] as? String
        print(key)
        let array = fileteredData?["filteredData"] as? NSArray ?? []
        var arrReadingList: [ReadingListModel] = []
        for data in array {
            arrReadingList.append(ReadingListModel(fromDic: data as? NSDictionary ?? [:]))
        }
        let selectedIndex = arrReadingList.firstIndex(where: { $0.keys == key})
        let vc = UpdateReadingParentVC.instantiate(fromAppStoryboard: .goal)
        vc.selectedIndex = selectedIndex ?? 0
        let readingListModel = ReadingListModel()
        vc.arrList = arrReadingList//fileteredData?["filteredData"] as? [ReadingListModel] ?? []
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
//        vc.completionHandler = { obj in
//            if obj?.count > 0 {
//                print(obj ?? "")
//                //object
////                                    self.tblReadings.reloadData()
//                self.viewModel.apiCallFromStart_reading(refreshControl: self.refreshControl,
//                                                tblView: self.tblGoals,
//                                                withLoader: true)
//            }
//        }
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(vc, animated: true)
        }
        //self.navigate(modelVC: vc)
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
            let navController = UINavigationController(rootViewController: modelVC)
            navController.modalPresentationStyle = .fullScreen
            let topController = UIApplication.topViewController()
            topController?.present(navController, animated: true, completion: nil)
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
            modelVC = MyDevicesVC.instantiate(fromAppStoryboard: .setting)
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
