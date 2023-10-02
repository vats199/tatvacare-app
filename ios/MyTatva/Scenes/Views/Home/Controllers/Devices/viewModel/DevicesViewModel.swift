//
//  DevicesViewModel.swift
//  MyTatva
//
//  Created by Himanshu on 02/10/23.
//

import Foundation
class DevicesViewModel {
    func showDeviceConnectPopUp() {
        guard !UserModel.shared.height.isEmpty else {
            Alert.shared.showAlert(Bundle.appName(), actionOkTitle: AppMessages.add, actionCancelTitle: AppMessages.cancel, message: "Enter your height") { [weak self] isDone in
                guard let self = self, isDone else { return }
                let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        var params = [String:Any]()
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKS_ON_CONNECT,
                                 screen: .Home,
                                 parameter: params)
        
//        let vc = DeviceAskingPopupVC.instantiate(fromAppStoryboard: .home)
        let vc = ConnectBCAPopUp.instantiate(fromAppStoryboard: .bca)
        vc.completion = { [weak self] isDone in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        vc.isFromHome = true
        vc.details = UserModel.shared.devices.first(where: {$0.key == "bca"})
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .overFullScreen
        navi.modalTransitionStyle = .crossDissolve
        UIApplication.topViewController()?.present(navi, animated: true)
    }

}
