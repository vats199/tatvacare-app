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
    func navigateToBookmark(_ selectedType: NSString) -> Void {
       
        PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow {
                let BookmarkVC = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                BookmarkVC.hidesBottomBarWhenPushed = true
                self.navigate(modelVC: BookmarkVC)
            }
            else {
                PlanManager.shared.alertNoSubscription()
            }
            
        })

        
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
            
        case "EngageContentDetailVC":
            modelVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
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
