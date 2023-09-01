//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class ForgotPasswordViewModel {
    
    //MARK:- Class Variable
    
    private(set) var forgotPasswordResult = Bindable<Result<String?, AppError>>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension ForgotPasswordViewModel {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(countryCode: String,
                             mobile: UITextField) -> AppError? {
        
        if countryCode.trim() == "" {
            return AppError.validation(type: .enterCountryCode)
        }
        else if mobile.text!.trim() == "" {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.text!.count < Validations.PhoneNumber.Maximum.rawValue {
            return AppError.validation(type: .enterMinMobileNumber)
        }
        
        return nil
    }
}

// MARK: Web Services
extension ForgotPasswordViewModel {
    
    func apiForgotPassword(vc: UIViewController,
                           countryCode: String,
                           mobile: UITextField) {
        
        // Check validation
        if let error = self.isValidView(countryCode: countryCode,
                                        mobile: mobile) {
            
            //Set data for binding
            self.forgotPasswordResult.value = .failure(error)
            return
        }
        
        self.forgotPasswordResult.value = .success(nil)
        
//        GlobalAPI.shared.forgotPasswordAPI(email: email) { (isDone) in
//            if isDone {
//                self.forgotPasswordResult.value = .success(nil)
//            }
//        }
    }
}
