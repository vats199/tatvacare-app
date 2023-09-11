//
//  ScheduleAppointmentVM.swift
//  MyTatva
//
//  Created by 2022M43 on 20/06/23.
//

import Foundation
class ScheduleAppointmentVM: NSObject {
    //MARK: Outlet
    
    //MARK: Class Variables
    var pateintPlanRefID = ""
    var appointmentModel            = AppointmentModel()
    
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

extension ScheduleAppointmentVM {
    
    func check_bcp_hc_details(withLoader: Bool,
                                 completion: ((Bool) -> Void)?){
        
        /*
         {
         }
         */
        
        var params                      = [String : Any]()

        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.doctor(.check_bcp_hc_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    //self.strErrorMessage = response.message
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    self.appointmentModel = AppointmentModel(fromJson: response.data)
                    returnVal = true
                
                    break
                case .emptyData:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
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
                Alert.shared.showSnackBar(error.localizedDescription,  isError: true, isBCP: true)
                completion?(returnVal)
                
                break
                
            }
        }
    }
}
