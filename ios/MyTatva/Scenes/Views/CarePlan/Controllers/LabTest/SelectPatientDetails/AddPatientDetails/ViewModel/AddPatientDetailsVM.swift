//

//
//

import Foundation

class AddPatientDetailsVM {
    
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
extension AddPatientDetailsVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(name: UITextField,
                             age: UITextField,
                             email: UITextField,
                             relation: String) -> AppError? {
        
        if name.text!.trim() == "" {
            return AppError.validation(type: .enterName)
        }
        else if !Validation.isAtleastOneAlphabaticString(txt: name.text!) {
            return AppError.validation(type: .enterValidName)
        }
        else if email.text!.trim() == "" {
            return AppError.validation(type: .enterEmail)
        }
        else if !email.text!.isValid(.email) {
            return AppError.validation(type: .enterValidEmail)
        }
        else if age.text!.trim() == "" {
            return AppError.validation(type: .enterAge)
        }
//        else if addressType.text!.trim() == "" {
//            return AppError.validation(type: .PleaseSelect)
//        }
        
        return nil
    }
}

// MARK: Web Services
extension AddPatientDetailsVM {
    
    func apiCall(vc: UIViewController,
                 member_id: String,
                 name: UITextField,
                 email: UITextField,
                 relation: String,
                 age: UITextField,
                 gender: String,
                 isEdit: Bool) {
        
        // Check validation
        if let error = self.isValidView(name: name,
                                        age: age,
                                        email: email,
                                        relation: relation) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        
        /*
         {
           "member_id": "string",
           "name": "string",
           "age": 24,
           "gender": "Male",
           "indication": "string"
         }
         
         */
        var params                      = [String : Any]()
//
        params["member_id"]             = member_id
        params["name"]                  = name.text!
        params["email"]                 = email.text!
        params["age"]                   = age.text!
        params["gender"]                = gender
        params["relation"]              = relation
        params["indication"]            = ""
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.update_patient_members), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            case .success(let response):

                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:

                    self.vmResult.value = .success(nil)
                    Alert.shared.showSnackBar(response.message)
                    
                    if isEdit {
                        
                    }
                    else {
                        //var params1 = [String: Any]()
                        //params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
                        FIRAnalytics.FIRLogEvent(eventName: .LABTEST_PATIENT_ADDED,
                                                 screen: .AddPatientDetails,
                                                 parameter: nil)
                    }
                    
                    break

                case .emptyData:

                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:

                    //self.loginResult.value = .failure(.custom(errorDescription: apiData.message))
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
                default:break
                }
                break

            case .failure(let error):

                Alert.shared.showSnackBar(error.localizedDescription)
                break

            }
        }
    }
    
}
