//
//  LoginSignupVM.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import Foundation
class LoginSignupVM {
    
    //MARK: - Class Variables
    
    private(set) var isResult = Bindable<Result<String?, AppError>>()
    var userAlreadyRegistered = false
    var isLogin_send_otp      = false
    
    //MARK: - init
    init() {
        
    }
    
    //---------------------------------------------------------
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
}

//------------------------------------------------------
//MARK: - Validation Methods
extension LoginSignupVM {
    
    private func validateView(countryCode: String, mobileNumber: String) -> AppError? {
        
        if countryCode.trim().isEmpty {
            return AppError.validation(type: .enterCountryCode)
        } else if mobileNumber.trim().isEmpty {
            return AppError.validation(type: .enterMobileNumber)
        } else if mobileNumber.trim().count < Validations.PhoneNumber.Maximum.rawValue {
            return AppError.validation(type: .enterMinMobileNumber)
        }
        
        return nil
    }
    
}

//------------------------------------------------------
//MARK: - WS Methods
extension LoginSignupVM {
    
    func apiCheckMobileNumber(countryCode: String, mobileNumber: String) {
//        guard let error = self.validateView(countryCode: countryCode, mobileNumber: mobileNumber) else {
//            self.isResult.value = .success(nil)
//            return
//        }
//        self.isResult.value = .failure(error)
//
        
        if let error = self.validateView(countryCode: countryCode,
                                         mobileNumber: mobileNumber) {
            
            //Set data for binding
            self.isResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.sendOtpAPI(country_code: countryCode,
                                    mobile: mobileNumber,
                                    type: .signup,
                                    screen: .SignUpWithPhone) { [weak self]  (isDone, userAlreadyRegistered) in
            guard let self = self else {return}
            if isDone {
                
                var params = [String:Any]()
                params[AnalyticsParameters.phone_no.rawValue] = mobileNumber
                FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_MOBILE_CAPTURE,
                                         screen: .LoginSignup,
                                         parameter: params)
                
                self.isLogin_send_otp = false
                self.userAlreadyRegistered = userAlreadyRegistered
                self.isResult.value = .success(nil)
            }
        }
    }
    
    
    func apiLogin(vc: UIViewController,
                  countryCode: String,
                  mobileNumber: String) {
        
        
        // Check validation
        
        if let error = self.validateView(countryCode: countryCode,
                                        mobileNumber: mobileNumber) {
            //Set data for binding
            self.isResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.sendOtpAPI(country_code: countryCode,
                                    mobile: mobileNumber,
                                    type: .login,
                                    screen: .LoginWithPhone) { [weak self]  (isDone, userAlreadyRegistered)  in
            guard let self = self else {return}
            if isDone {
                FIRAnalytics.FIRLogEvent(eventName: .LOGIN_SMS_SENT,
                                         screen: .LoginSignup,
                                         parameter: nil)
                self.isLogin_send_otp = true
                self.userAlreadyRegistered = userAlreadyRegistered
                self.isResult.value = .success(nil)
            }
        }
    }
    
    
}
