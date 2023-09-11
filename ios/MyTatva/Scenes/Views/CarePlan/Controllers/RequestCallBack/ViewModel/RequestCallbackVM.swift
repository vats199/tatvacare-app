//
//  RequestCallBackPopupVM.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import Foundation

class RequestCallBackPopupVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
   
    var result                     = JSON()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: ---------------- API CALL ----------------------
extension RequestCallBackPopupVM {
    
    
    func apiRequestCallback(withLoader: Bool,
                            patient_dose_rel_id: String,
                            completion: ((Bool) -> Void)?){
        
        
        var params                      = [String : Any]()
        params["callback_for"]          = "T"//"P"
        
        if patient_dose_rel_id.trim() != "" {
            params["patient_dose_rel_id"]   = patient_dose_rel_id
        }
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.request_prescription_card_callback), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
         var returnVal = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    self.vmResult.value = .success(nil)
                    Alert.shared.showSnackBar(response.message)
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
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

