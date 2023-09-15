//

//
//

import Foundation

class ChooseLocationPinVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    private var addAddressVM = AddAddressVM()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension ChooseLocationPinVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(code: UITextField) -> AppError? {
        
        if code.text!.trim() == "" {
            return AppError.validation(type: .enterPincode)
        }
        else if code.text!.count < Validations.MaxCharacterLimit.Pincode.rawValue {
            return AppError.validation(type: .enterValidPincode)
        }
//        else if code.text!.trim() == "" {
//            return AppError.validation(type: .enterAge)
//        }
//        else if addressType.text!.trim() == "" {
//            return AppError.validation(type: .PleaseSelect)
//        }
        
        return nil
    }
}

// MARK: Web Services
extension ChooseLocationPinVM {
    
    func apiCall(vc: UIViewController,
                 code: UITextField) {
        
        // Check validation
        if let error = self.isValidView(code: code) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        self.addAddressVM.pincode_availabilityAPI(pincode: code.text!) { [weak self] isDone in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
    }
    
}
