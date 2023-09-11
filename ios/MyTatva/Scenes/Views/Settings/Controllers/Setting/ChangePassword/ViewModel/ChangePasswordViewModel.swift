
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ChangePasswordViewModel {
    
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
extension ChangePasswordViewModel {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(oldPwd: String,
                             newPwd: String,
                             confirmPwd: String) -> AppError? {
        
        guard !oldPwd.isEmpty else {
            return AppError.validation(type: .enterCurrentPassword) }
        
        guard !newPwd.isEmpty else {
            return AppError.validation(type: .enterNewPassword) }
        
      
        guard newPwd.count >= ValidationConstant.minPassword else {
            return AppError.validation(type: .enterMinNewPassword) }
        
        guard !confirmPwd.isEmpty else {
            return AppError.validation(type: .enterConfirmPassword) }
        
        guard newPwd == confirmPwd else {
            return AppError.validation(type: .passwordMismatch) }
        
        
        return nil
    }
}

// MARK: Web Services
extension ChangePasswordViewModel {
    
    func apiCall(vc: UIViewController,
                 oldPwd: String,
                 newPwd: String,
                 confirmPwd: String) {
        // Check validation
        if let error = self.isValidView(oldPwd: oldPwd,
                                       newPwd: newPwd,
                                       confirmPwd: confirmPwd) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //----------------------------------------------
        GlobalAPI.shared.changePasswordAPI(currentPassword: oldPwd, newPassword: newPwd) { [weak self] (isDone) in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
    }
}


