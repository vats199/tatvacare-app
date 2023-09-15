//
//  LoginWithPassVM.swift
//
//

//

import Foundation

class SetLocationVM {
    
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
extension SetLocationVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(city: String,
                             state: String,
                             country: String) -> AppError? {
        
        if state.trim() == ""{
            return AppError.validation(type: .selectState)
        }
        else if city.trim() == ""{
            return AppError.validation(type: .selectCity)
        }
        return nil
    }
}

// MARK: Web Services
extension SetLocationVM {
    
    func apiCall(vc: UIViewController,
                 city: String,
                 state: String,
                 country: String) {
        
        // Check validation
        if let error = self.isValidView(city: city,
                                        state: state,
                                        country: country) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
//        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
//        UIApplication.shared.manageLogin()
        
        //LocationManager.shared.getLocation()
        
        GlobalAPI.shared.updateLocationAPI(city: city,
                                           state: state,
                                           country: country) { [weak self] (isDone) in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }

    }
}

