//
//  VerificationVM.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import Foundation
class VerificationVM {
    
    //MARK: - Class Variables
    
    private(set) var isResult = Bindable<Result<String?,AppError>>()
    var verifyUserModel         = VerifyUserModel()
    
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
extension VerificationVM {
    
//    private func validateView(otp:String,optEntered:Bool) -> AppError? {
//
//        if !optEntered {
//            return AppError.validation(type: .enterOTP)
//        } else if otp.trim().count < kOTPCount {
//            return AppError.validation(type: .validOTP)
//        }
//
//        return nil
//    }
    
    
    private func validateView(countryCode: String,
                             mobile: String,
                             otp: String,
                             isOTPEntered: Bool) -> AppError? {
        if countryCode.trim() == ""  {
            return AppError.validation(type: .enterCountryCode)
        }
        else if mobile.trim() == ""  {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.count < ValidationConstant.minMobileDigit  {
            return AppError.validation(type: .enterMinMobileNumber)
        }
        else if !isOTPEntered {
            return AppError.validation(type: .enterOTP)
        }
        else if otp.count < kOTPCount {
            return AppError.validation(type: .validOTP)
        }
//        else if otp != vOtp {
//            return AppError.validation(type: .validOTP)
//        }
        return nil
    }
}

//------------------------------------------------------
//MARK: - WSMethods
extension VerificationVM {
    
//    func apiVerifyOTP(otp:String,optEntered:Bool) {
//        guard let error = self.validateView(otp: otp,optEntered: optEntered) else {
//            self.isResult.value = .success(nil)
//            return
//        }
//        self.isResult.value = .failure(error)
//    }
    
    func apiCall(vc: UIViewController,
                 countryCode: String,
                 mobile: String,
                 otp: String,
                 isOTPEntered: Bool,
                 otpType: OTPType) {
        
        // Check validation
        if let error = self.validateView(countryCode: countryCode,
                                        mobile: mobile,
                                        otp: otp,
                                        isOTPEntered: isOTPEntered) {
            
            //Set data for binding
            self.isResult.value = .failure(error)
            return
        }
        // Make request and set home controller.
//        let userModel = UserModel(fromJson: [:])
//        UserModel.currentUser = userModel
//        UserDefaultsConfig.isAuthorization = true
        
        GlobalAPI.shared.verifyOtpAPI(country_code: countryCode,
                                      mobile: mobile,
                                      otp: otp,
                                      type: otpType) { [weak self] (isDone, object) in
            guard let self = self else {return}
            if isDone {
                self.verifyUserModel = object
                self.isResult.value = .success(nil)
            }
        }
    }
}

