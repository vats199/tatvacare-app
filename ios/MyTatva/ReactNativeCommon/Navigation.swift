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
//        case "BookTestListModel":
//                         modelVC = BookTestListModel.instantiate(fromAppStoryboard: .exercise)
            
            
            
        default:
            return;
        }
        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: modelVC)
            navController.modalPresentationStyle = .fullScreen
            let topController = UIApplication.topViewController()
            topController?.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc
    func goBack() -> Void {
        DispatchQueue.main.async {
            let topController = UIApplication.topViewController()
            topController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
