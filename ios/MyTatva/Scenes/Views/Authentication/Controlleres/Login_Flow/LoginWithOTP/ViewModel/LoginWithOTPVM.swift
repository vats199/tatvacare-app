//
//  LoginViewModel.swift
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class LoginWithOTPVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension LoginWithOTPVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(countryCode: String,
                             txtMobile: UITextField) -> AppError? {
        
//        txtMobile.applyThemeTextfieldBorderView(withError: false)
        
        if countryCode.trim() == "" {
            return AppError.validation(type: .enterCountryCode)
        }
        else if txtMobile.text!.trim() == "" {
            //txtMobile.applyThemeTextfieldBorderView(withError: true)
            return AppError.validation(type: .enterMobileNumber)
        }
        else if txtMobile.text!.count < Validations.PhoneNumber.Maximum.rawValue {
            //txtMobile.applyThemeTextfieldBorderView(withError: true)
            return AppError.validation(type: .enterMinMobileNumber)
        }
        
        return nil
    }
}

// MARK: Web Services
extension LoginWithOTPVM {
    
    func apiLogin(vc: UIViewController,
                  countryCode: String,
                  txtMobile: UITextField) {
        
        
        // Check validation
        
        if let error = self.isValidView(countryCode: countryCode,
                                        txtMobile: txtMobile) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.sendOtpAPI(country_code: countryCode,
                                    mobile: txtMobile.text!,
                                    type: .login,
                                    screen: .LoginWithPhone) { [weak self]  (isDone, userAlreadyRegistered)  in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
    }
}
