
import Foundation

class CreatePasswordVM {
    
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
extension CreatePasswordVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(newPwd: UITextField,
                             confirmPwd: UITextField,
                             vwNewPassword: UIView,
                             vwConfirmPassword: UIView) -> AppError? {
        
//        guard !oldPwd.isEmpty else {
//            return AppError.validation(type: .enterCurrentPassword) }
        
        if newPwd.text!.trim() == ""{
            return AppError.validation(type: .enterNewPassword)
        }
//        else if newPwd.count < Validations.Password.Minimum.rawValue  {
//            return AppError.validation(type: .enterMinNewPassword)
//        }
        else if !Validation.isPasswordValid(txt: newPwd.text!) {
            return AppError.validation(type: .enterValidPassword)
        }
        else if confirmPwd.text!.trim() == ""{
            return AppError.validation(type: .enterConfirmPassword)
        }
        else if newPwd.text! != confirmPwd.text!  {
            return AppError.validation(type: .passwordMismatch)
        }
        
        return nil
    }
}

// MARK: Web Services
extension CreatePasswordVM {
    
    func apiCall(vc: UIViewController,
                 countryCode: String,
                 mobile: String,
                 newPwd: UITextField,
                 confirmPwd: UITextField,
                 vwNewPassword: UIView,
                 vwConfirmPassword: UIView) {
        
        
        // Check validation
        if let error = self.isValidView (newPwd: newPwd,
                                         confirmPwd: confirmPwd,
                                         vwNewPassword: vwNewPassword,
                                         vwConfirmPassword: vwConfirmPassword) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        self.vmResult.value = .success(nil)
        
        //----------------------------------------------
        GlobalAPI.shared.forgotPasswordAPI(contact_no: mobile,
                                           password: newPwd.text!,
                                           conf_password: confirmPwd.text!) { [weak self] (isDone) in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
    }
}

