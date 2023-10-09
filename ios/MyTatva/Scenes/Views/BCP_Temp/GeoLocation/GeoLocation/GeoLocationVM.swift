//
//  GeoLocationVM.swift
//  MyTatva
//
//  Created by 2022M43 on 29/08/23.
//

import Foundation
class GeoLocationVM {
    //MARK: Outlet
    
    //MARK: Class Variables
    
    //MARK: Init
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
}

extension GeoLocationVM {
    
    //MARK: ---------------- pincode_availability API ----------------------
    func pincode_availabilityAPI(pincode: String,
                                 completion: ((Bool) -> Void)?){
        //email
        
        var params              = [String : Any]()
        params["Pincode"]       = pincode
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.pincode_availability), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
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
                
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
}
