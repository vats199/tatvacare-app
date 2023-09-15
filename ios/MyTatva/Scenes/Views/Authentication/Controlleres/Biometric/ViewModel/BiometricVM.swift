
import Foundation

class BiometricVM {
    
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
extension BiometricVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(newPwd: String,
                             confirmPwd: String) -> AppError? {
        
//        guard !oldPwd.isEmpty else {
//            return AppError.validation(type: .enterCurrentPassword) }
        
        if newPwd.isEmpty  {
            return AppError.validation(type: .enterNewPassword)
        }
        else if newPwd.count < Validations.Password.Maximum.rawValue  {
            return AppError.validation(type: .enterMinNewPassword)
        }
        else if !Validation.isPasswordValid(txt: newPwd) {
            return AppError.validation(type: .enterMinNewPassword)
        }
        else if confirmPwd.isEmpty  {
            return AppError.validation(type: .enterConfirmPassword)
        }
        else if newPwd != confirmPwd  {
            return AppError.validation(type: .passwordMismatch)
        }
        
        return nil
    }
}

// MARK: Web Services
extension BiometricVM {
    
    func apiCall(vc: UIViewController,
                 newPwd: String,
                 confirmPwd: String) {
        // Check validation
        if let error = self.isValidView(newPwd: newPwd,
                                       confirmPwd: confirmPwd) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        self.vmResult.value = .success(nil)
        
        //----------------------------------------------
//        GlobalAPI.shared.changePasswordAPI(currentPassword: "", newPassword: newPwd) { (isDone) in
//            if isDone {
//                self.vmResult.value = .success(nil)
//            }
//        }
    }
}
