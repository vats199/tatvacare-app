//
//  LoginWithPassVM.swift
//
//

//

import Foundation

class LoginWithPassVM {
    
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
extension LoginWithPassVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(countryCode: String,
                             mobile: UITextField,
                             password: UITextField,
                             vwPassword: UIView,
                             isAgreeTerms: Bool,
                             isRemember: Bool) -> AppError? {
        
        if countryCode.trim() == "" {
            return AppError.validation(type: .enterCountryCode)
        }
        else if mobile.text!.trim() == "" {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.text!.count < Validations.PhoneNumber.Maximum.rawValue {
            return AppError.validation(type: .enterMinMobileNumber)
        }
        else if password.text!.trim() == "" {
            return AppError.validation(type: .enterPassword)
        }
        else if !isAgreeTerms {
            return AppError.validation(type: .agreeTermsAndCondition)
        }
        
        return nil
    }
}

// MARK: Web Services
extension LoginWithPassVM {
    
    func apiLogin(vc: UIViewController,
                  countryCode: String,
                  mobile: UITextField,
                  password: UITextField,
                  vwPassword: UIView,
                  isAgreeTerms: Bool,
                  isRemember: Bool) {
        
        
        // Check validation
        
        if let error = self.isValidView(countryCode: countryCode,
                                        mobile: mobile,
                                        password: password,
                                        vwPassword: vwPassword,
                                        isAgreeTerms: isAgreeTerms,
                                        isRemember: isRemember) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        
//        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
//        UIApplication.shared.manageLogin()
//        self.vmResult.value = .success(nil)
        //LocationManager.shared.getLocation()
        
        var params                      = [String : Any]()
//
        params["contact_no"]            = mobile.text!
        params["password"]              = password.text!
//        params["device_type"]           = DeviceManager.shared.deviceType
//        params["device_token"]          = DeviceManager.shared.deviceToken
//        params["uuid"]                  = DeviceManager.shared.uuid
//        params["os_version"]            = DeviceManager.shared.osVersion
//        params["device_name"]           = DeviceManager.shared.DeviceName
//        params["model_name"]            = DeviceManager.shared.modelName
//        params["app_version"]           = Bundle.main.releaseVersionNumber
//        params["build_version_number"]  = Bundle.main.releaseVersionNumber
//        params["ip"]                    = DeviceManager.shared.getIPAddress
        
//        params["latitude"]              = LocationManager.shared.getUserLocation().coordinate.latitude
//        params["longitude"]             = LocationManager.shared.getUserLocation().coordinate.longitude
        //params["language"]              = GFunction.shared.getLanguage()
        
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.login), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            case .success(let response):

                switch response.apiCode {
                case .invalidOrFail:

                    FIRAnalytics.FIRLogEvent(eventName: .LOGIN_PASSWORD_INCORRECT,
                                             screen: .LoginWithPassword,
                                             parameter: nil)
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:

                    //Save data into user model and redirect to home screen.
//                    UserModel.currentUser = response.data
//                    UserDefaultsConfig.accessToken = response.data.accessToken
                    
                    var params = [String: Any]()
                    params[AnalyticsParameters.phone_no.rawValue] = mobile.text!
                    FIRAnalytics.FIRLogEvent(eventName: .LOGIN_PASSWORD_SUCCESS,
                                             screen: .LoginWithPassword,
                                             parameter: nil)
                    
                    UserDefaultsConfig.rememberMe = false
                    if isRemember {
                        UserDefaultsConfig.rememberMe   = true
                        UserDefaultsConfig.mobile       = mobile.text!
                        UserDefaultsConfig.password     = password.text!
                    }
                    
                    UserModel.shared = UserModel(fromJson: response.data)
                    UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    
                    UIApplication.shared.manageLogin()
                    
                    GlobalAPI.shared.updateDeviceAPI { [weak self]  (isDone) in
                        guard let self = self else {return}
                    }
                    
                    /*kAppSessionTimeStart    = Date()
                    kUserSessionActive      = true
                    FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START,
                                             screen: .LoginWithPassword,
                                             parameter: nil)*/
                    
                    self.vmResult.value = .success(nil)
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
