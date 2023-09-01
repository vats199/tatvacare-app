//
//  MyDeviceVM.swift
//  MyTatva
//
//  Created by 2022M43 on 12/06/23.
//

import Foundation
class MyDeviceVM: NSObject {
    //MARK: Outlet

    //MARK: Class Variables
    var pateintPlanRefId = ""
    var deviceData : MyDeviceModel?
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
}



//------------------------------------------------------
//MARK: - Class Methods -
extension MyDeviceVM {
    func getNumOfRows() -> Int { return self.deviceData == nil ? 0 : self.deviceData?.devices.count ?? 0 }
    func getDeviceData() -> DeviceDetailsModel? { self.deviceData?.devices[0] }
}

extension MyDeviceVM {
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
                                 screen: .BcpDeviceDetails,
                                 parameter: params)
        
//        let vc = DeviceAskingPopupVC.instantiate(fromAppStoryboard: .home)
        let vc = ConnectBCAPopUp.instantiate(fromAppStoryboard: .bca)
        vc.details = self.getDeviceData()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .overFullScreen
        navi.modalTransitionStyle = .crossDissolve
        UIApplication.topViewController()?.present(navi, animated: true)
    }
    
    func my_devices(patient_plan_rel_id: String = "",
                    withLoader: Bool,
                    completion: ((Bool) -> Void)?){
      
        var params                                     = [String : Any]()
        params["patient_plan_rel_id"]                  = patient_plan_rel_id
    
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.my_devices), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message,isError: true, isBCP: true)
                
                    break
                case .success:
                    self.deviceData = MyDeviceModel(fromJson: response.data)
                    returnVal = true
                    break
                case .emptyData:
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message)
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .underMaintenance:
                    break
              case .socialIdNotRegister:
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                default: break
                }
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
}
