
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ContactUsViewModel {
    
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
extension ContactUsViewModel {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(subject: String,
                             message: String) -> AppError? {
        
        guard !subject.isEmpty else {
            return AppError.validation(type: .selectSubject) }
        
        guard !message.isEmpty else {
            return AppError.validation(type: .enterMessage) }
        
        return nil
    }
}

// MARK: Web Services
extension ContactUsViewModel {
    
    func apiCall(vc: UIViewController,
                 subject: String,
                 message: String) {
        // Check validation
        if let error = self.isValidView(subject: subject,
                                        message: message) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //----------------------------------------------
        GlobalAPI.shared.contactUsAPI(subject: subject,
                                      message: message) { [weak self] (isDone) in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
    }
}


