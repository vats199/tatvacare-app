//

//
//

import Foundation

class SignupMobileVM {
    
    //MARK: -------------------------- Class Variable --------------------------
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var userAlreadyRegistered = false
    
    //MARK: -------------------------- Init --------------------------
    init() {
    }
    
    //MARK: -------------------------- Deinit --------------------------
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: -------------------------- Validation Methods --------------------------
extension SignupMobileVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(countryCode: String,
                             mobile: UITextField) -> AppError? {
        
        if countryCode.trim() == "" {
            return AppError.validation(type: .enterCountryCode)
        }
        else if mobile.text!.trim() == ""{
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.text!.count < Validations.PhoneNumber.Maximum.rawValue {
            return AppError.validation(type: .enterMinMobileNumber)
        }
      
        return nil
    }
}

// MARK: -------------------------- Web Services --------------------------
extension SignupMobileVM {
    
    func apiSignup(vc: UIViewController,
                           countryCode: String,
                           mobile: UITextField) {
        
        // Check validation
        if let error = self.isValidView(countryCode: countryCode,
                                        mobile: mobile) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.sendOtpAPI(country_code: countryCode,
                                    mobile: mobile.text!,
                                    type: .signup,
                                    screen: .SignUpWithPhone) { [weak self]  (isDone, userAlreadyRegistered) in
            guard let self = self else {return}
            if isDone {
                self.userAlreadyRegistered = userAlreadyRegistered
                self.vmResult.value = .success(nil)
            }
        }

    }
    
    
}
