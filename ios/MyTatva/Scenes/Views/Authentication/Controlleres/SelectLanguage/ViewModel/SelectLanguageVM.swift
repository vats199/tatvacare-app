//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class SelectLanguageVM {
    
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
extension SelectLanguageVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(language: UITextField) -> AppError? {
        
        if language.text!.trim() == ""{
            return AppError.validation(type: .selectLanguage)
        }
            
       
        return nil
    }
}

// MARK: Web Services
extension SelectLanguageVM {
    
    func apiSelectLanguage(vc: UIViewController,
                           language: UITextField) {
        
        // Check validation
        if let error = self.isValidView(language: language) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        var params              = [String: Any]()
        params[AnalyticsParameters.language_selected.rawValue] = language.text
        FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_LANGUAGE_SELECTION,
                                 screen: .SelectLanguage,
                                 parameter: params)
        self.vmResult.value = .success(nil)
        
//        GlobalAPI.shared.forgotPasswordAPI(email: email) { (isDone) in
//            if isDone {
//                self.forgotPasswordResult.value = .success(nil)
//            }
//        }
    }
}
