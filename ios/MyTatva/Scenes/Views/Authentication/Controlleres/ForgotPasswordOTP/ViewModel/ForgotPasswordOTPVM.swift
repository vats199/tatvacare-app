//
//  OTPViewModel.swift
//
//  Created by 2020M03 on 17/06/21.
//

import Foundation

class ForgotPasswordOTPVM {
    
    //MARK:- Class Variable
    
    private(set) var otpResult = Bindable<Result<String?, AppError>>()
    private var pinLimit: Int = 4
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension ForgotPasswordOTPVM {
    
    /// Validate fields.
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(countryCode: String,
                             mobile: String,
                             otp: String,
                             isOTPEntered: Bool) -> AppError? {
        
        if countryCode.trim() == "" {
            return AppError.validation(type: .enterCountryCode)
        }
        else if mobile.trim() == "" {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.count < Validations.PhoneNumber.Maximum.rawValue {
            return AppError.validation(type: .enterMinMobileNumber)
        }
        else if !isOTPEntered {
            return AppError.validation(type: .enterOTP)
        }
        else if otp.count != pinLimit {
            return AppError.validation(type: .validOTP)
        }
//        else if otp != vOtp {
//            return AppError.validation(type: .validOTP)
//        }
        
        return nil
    }
}

// MARK: Web Services
extension ForgotPasswordOTPVM {
    /**
     This API for OTP verification.
     
     - Parameter otp: User enterd OTP code.
     
     ### End point
     user/login
     
     ### Method
     POST
     
     ### Required parameters
     email, device_token, device_type, signup_type
     
     ### Optional parameters
     password, social_id
     */
    func apiCall(vc: UIViewController,
                            countryCode: String,
                            mobile: String,
                            otp: String,
                            isOTPEntered: Bool) {
        // Check validation
        if let error = self.isValidView(countryCode: countryCode,
                                        mobile: mobile,
                                        otp: otp,
                                        isOTPEntered: isOTPEntered) {
            
            //Set data for binding
            self.otpResult.value = .failure(error)
            return
        }
        // Make request and set home controller.
//        let userModel = UserModel(fromJson: [:])
//        UserModel.currentUser = userModel
//        UserDefaultsConfig.isAuthorization = true
        
        self.otpResult.value = .success(nil)
    }
}
