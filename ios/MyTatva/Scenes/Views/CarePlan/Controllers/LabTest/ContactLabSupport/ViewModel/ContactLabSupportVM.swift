//

//
//

import Foundation

class ContactLabSupportVM {
    
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
extension ContactLabSupportVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(message: String) -> AppError? {
        
        if message.trim() == "" {
            return AppError.validation(type: .enterQuery)
        }
//        else if code.text!.count < Validations.MaxCharacterLimit.Pincode.rawValue {
//            return AppError.validation(type: .enterValidPincode)
//        }
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
extension ContactLabSupportVM {
    
    func apiCall(vc: UIViewController,
                 order_master_id: String,
                 message: String) {
        
        // Check validation
        if let error = self.isValidView(message: message) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        self.contact_spportAPI(order_master_id: order_master_id,
                               message: message) { [weak self] isDone in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
        }
    }
    
    //MARK: ---------------- pincode_availability API ----------------------
    func contact_spportAPI(order_master_id: String,
                           message: String,
                           completion: ((Bool) -> Void)?){
        //email
        
        var params                  = [String : Any]()
        params["order_master_id"]   = order_master_id
        params["message"]           = message
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.contact_spport), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message)
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .underMaintenance:
                    break
                case .socialIdNotRegister:
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                default: break
                }
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
}
