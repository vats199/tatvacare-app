//
//  SelectLocationPopUpVM.swift
//  MyTatva
//
//  Created by 2022M43 on 11/09/23.
//

import Foundation
class SelectLocationPopUpVM {
    
    //MARK: Outlet
    
    //MARK: Class Variables
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
}

// MARK: Validation Methods
extension SelectLocationPopUpVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(code: UITextField) -> AppError? {
        
        if code.text!.trim() == "" {
            return AppError.validation(type: .enterPincode)
        }
        else if code.text!.count < Validations.MaxCharacterLimit.Pincode.rawValue {
            return AppError.validation(type: .enterValidPincode)
        }
        return nil
    }
}

// MARK: Web Services
extension SelectLocationPopUpVM {
    
    func apiCall(code: UITextField) {
        
        // Check validation
        if let error = self.isValidView(code: code) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        self.pincode_availabilityAPI(pincode: code.text!) { [weak self] isDone in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
        
        
    }
    
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
                    self.vmResult.value = .failure(.custom(errorDescription: response.message))
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    self.vmResult.value = .failure(.custom(errorDescription: response.message))
                    //Alert.shared.showSnackBar(response.message)
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
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
}

