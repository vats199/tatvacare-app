//
//  GAPI.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 10/10/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation
import SwiftyJSON

///Gloabl API for used API in whole project
class GlobalAPI : NSObject {
    
    ///Shared instance
    static let shared : GlobalAPI = GlobalAPI()
    
    //MARK: ---------------- updateLocation API ----------------------
    func updateLocationAPI(city: String,
                           state: String,
                           country: String,
                           completion: ((Bool) -> Void)?){
        
        //        LocationManager.shared.getLocation()
        var params                  = [String : Any]()
        //        params["latitude"]          = "\(LocationManager.shared.getUserLocation().coordinate.latitude)"
        //        params["longitude"]         = "\(LocationManager.shared.getUserLocation().coordinate.longitude)"
        params["city"]              = city
        params["state"]             = state
        params["country"]           = country
        
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.update_patient_location), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    UserModel.shared = UserModel(fromJson: response.data)
                    if UserModel.shared.token != nil && UserModel.shared.token.trim() != "" {
                        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    }
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
    
    //MARK: ---------------- updateDevice API ----------------------
    func updateDeviceAPI(optional_update: Bool? = false,
                         completion: ((Bool) -> Void)?){
        
        /*
         {"device_token":"device_token",
         "device_type":"I",
         "uuid":"uuid",
         "os_version":"MACOSX",
         "device_name":"device_name",
         "model_name":"model_name",
         "build_version_number":"build_version_number",
         "ip":"127.0.0.1",
         "app_version":"V1"}
         */
        
        LocationManager.shared.getLocation()
        var params                      = [String : Any]()
        params["lat"]                   = "\(LocationManager.shared.getUserLocation().coordinate.latitude)"
        params["long"]                  = "\(LocationManager.shared.getUserLocation().coordinate.longitude)"
        params["device_token"]          = DeviceManager.shared.deviceToken
        params["device_type"]           = DeviceManager.shared.deviceType
        params["uuid"]                  = DeviceManager.shared.uuid
        params["os_version"]            = DeviceManager.shared.osVersion
        params["device_name"]           = DeviceManager.shared.DeviceName
        params["model_name"]            = DeviceManager.shared.modelName
        params["app_version"]           = Bundle.main.releaseVersionNumber
        //params["version_number"]        = Bundle.main.releaseVersionNumber
        params["build_version_number"]  = Bundle.main.buildVersion
        params["ip"]                    = DeviceManager.shared.getIPAddress
        
        if optional_update! {
            params["optional_update"]       = optional_update
        }
        //params["api_version"]           = "1"
        
        
        FreshDeskManager.shared.initFreshchatSDK()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.updateDeviceInfo), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    
                    if let vc = UIApplication.topViewController() as? AppUnderMaintenanceVC {
                        vc.dismiss(animated: true, completion: nil)
                    }
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    //Alert.shared.showSnackBar(response.message)
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
                    
                    if let vc = UIApplication.topViewController() as? AppUnderMaintenanceVC {
                        vc.dismiss(animated: true, completion: nil)
                    }
                    
                    Alert.shared.showAlert(title: "", message: response.message, actionTitles: [AppMessages.ok], actions: [ { [self] (yes) in
                        
                        DispatchQueue.main.async {
                            if let url = URL(string: AppCredential.shareapp.rawValue),
                            UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.open(url)
                            }
                        }
                    }])
                    
                    break
                    
                case .underMaintenance:
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                       
                        let vc = AppUnderMaintenanceVC.instantiate(fromAppStoryboard: .auth)
                        vc.strtitle    = response.data["title"].stringValue
                        vc.strDesc     = response.data["message"].stringValue
                        vc.modalPresentationStyle   = .overFullScreen
                        vc.modalTransitionStyle     = .crossDissolve
                        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                    }
                    
                    break
              
                case .optionalUpdateApp:
                    if let vc = UIApplication.topViewController() as? AppUnderMaintenanceVC {
                        vc.dismiss(animated: true, completion: nil)
                    }
         
                    Alert.shared.showAlert("", actionOkTitle: AppMessages.Update, actionCancelTitle: AppMessages.Skip, message: response.message) { (isDone) in
                        if isDone {
                            DispatchQueue.main.async {
                                if let url = URL(string: AppCredential.shareapp.rawValue),
                                UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        else {
                            //Skip to update app
                            self.updateDeviceAPI(optional_update: true) { isDone in
                            }
                        }
                    }
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- Send OTP ----------------------
    func sendOtpAPI(country_code: String,
                    mobile: String,
                    type: OTPType,
                    screen: ScreenName,
                    completion: ((_ isDone: Bool,
                                  _ userAlreadyRegistered: Bool) -> Void)?){
        
        //contact_no
        
        var params                  = [String : Any]()
        //params["country_code"]      = country_code
        params["contact_no"]        = mobile
        
        var apiName = ApiEndPoints.patient(.forgot_password_send_otp)
        switch type {
        
        case .login:
            apiName = ApiEndPoints.patient(.login_send_otp)
        case .forgotPassword:
            apiName = ApiEndPoints.patient(.forgot_password_send_otp)
        case .signup:
            apiName = ApiEndPoints.patient(.send_otp_signup)
        }
        
        ApiManager.shared.makeRequest(method: apiName, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal = false
            var userAlreadyRegistered = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBarGreen(response.message, isError: true)
                    break
                case .success:
                    returnVal           = true
                    ///Note: access_code is actually doctor_access_code for register api
                    /*
                     IMP Note *************************************
                     accessCode var is actual doctor access code(in register API),
                     doctorAccessCode is just random number, so from response
                     store access_code to doctorAccessCode
                     and store doctor_access_code to accessCode
                     */
                    if response.data["access_code"].stringValue != "" {
                        kDoctorAccessCode   = response.data["access_code"].stringValue
                    }
                    if response.data["doctor_access_code"].stringValue != "" {
                        kAccessCode         = response.data["doctor_access_code"].stringValue
                    }
                    kAccessFrom         = .LinkPatient
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBarGreen(response.message)

                    switch type {
                    case .signup:
                        
                        var params = [String: Any]()
                        params[AnalyticsParameters.phone_no.rawValue]   = mobile
                        FIRAnalytics.FIRLogEvent(eventName: .SIGNUP_OTP_SENT_SUCCESS,
                                                 screen: screen,
                                                 parameter: params)
                        
                    default: break
                    }
                    break
                case .emptyData:
                    Alert.shared.showSnackBarGreen(response.message, isError: true)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBarGreen(response.message, isError: true)
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .underMaintenance:
                    break
                case .userAlreadyRegistered:
                    returnVal               = true
                    userAlreadyRegistered   = true
//                    Alert.shared.showAlert(message: response.message) { (_) in
//                        UIApplication.shared.setLogin()
//                    }
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                    
                default: break
                }
                
                completion?(returnVal, userAlreadyRegistered)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBarGreen(error.localizedDescription, isError: true)
//                Alert.shared.showSnackBar(error.localizedDescription)
                completion?(returnVal, userAlreadyRegistered)
                break
                
            }
        }
    }
    
    //MARK: ---------------- verify OTP ----------------------
    func verifyOtpAPI(country_code: String,
                      mobile: String,
                      otp: String,
                      type: OTPType,
                      completion: ((Bool, VerifyUserModel) -> Void)?){
        
        //contact_no
        
        var params                  = [String : Any]()
        //params["country_code"]      = country_code
        params["contact_no"]        = mobile
        params["otp"]               = otp
        params["access_code"]       = kAccessCode
        
        var apiName = ApiEndPoints.patient(.forgot_password_verify_otp)
        switch type {
        
        case .login:
            apiName = ApiEndPoints.patient(.login_verify_otp)
        case .forgotPassword:
            apiName = ApiEndPoints.patient(.forgot_password_verify_otp)
        case .signup:
            apiName = ApiEndPoints.patient(.verify_otp_signup)
        }
        
        ApiManager.shared.makeRequest(method: apiName, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var verifyUserModel     = VerifyUserModel()
                switch response.apiCode {
                case .invalidOrFail:
                    
                    switch type {
                        
                    case .login:
                        var params = [String: Any]()
                        params[AnalyticsParameters.phone_no.rawValue] = mobile
                        FIRAnalytics.FIRLogEvent(eventName: .LOGIN_OTP_INCORRECT,
                                                 screen: .LoginOtp,
                                                 parameter: params)
                        break
                    case .forgotPassword:
                        break
                    case .signup:
                        break
                    }
                    Alert.shared.showSnackBarGreen(response.message, isError: true)
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    vOtp        = response.data["otp"].stringValue
                    //vUserId     = response.data["id"].stringValue
                    
                    if type == .login {
                        UserModel.shared = UserModel(fromJson: response.data)
                        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    }
                    if type == .signup {
                        kAccessCode = ""
                        UserDefaultsConfig.kUserStep = response.data["step"].intValue
                        verifyUserModel = VerifyUserModel(fromJson: response.data)
                        UserModel.shared = UserModel(fromJson: response.data)
                        UserDefaultsConfig.accessToken = response.data["token"].stringValue
                        UserModel.shared.storeUserEntryDetails(withJSON: response.data,false)
                    }
                    
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    Alert.shared.showSnackBarGreen(response.message, isError: true)
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBarGreen(response.message, isError: true)
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
                
                completion?(returnVal, verifyUserModel)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBarGreen(error.localizedDescription, isError: true)
//                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- forgotPassword API ----------------------
    func forgotPasswordAPI(email: String,
                           completion: ((Bool) -> Void)?){
        //email
        
        var params                  = [String : Any]()
        params["email"]       = email
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.user(.forgotPassword), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
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
    
    //MARK: ---------------- getPatientDetails API ----------------------
    func getPatientDetailsAPI(withLoader: Bool = false,
                              completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_patient_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    UserModel.shared = UserModel(fromJson: response.data)
                    if UserModel.shared.token != nil &&
                        UserModel.shared.token.trim() != "" &&
                        UserModel.isUserLoggedIn &&
                        UserModel.isVerifiedUser {
                        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    }
                    returnVal   = true
                    break
                case .emptyData:
                    
                    //Alert.shared.showSnackBar(response.message)
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
                print(error.localizedDescription)
//                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- sendEmailVerificationLink API ----------------------
    func sendEmailVerificationLinkAPI(completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.send_email_verification_link), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_EMAIL_VERIFICATION,
                                             screen: .Home,
                                             parameter: nil)
                    Alert.shared.showSnackBar(response.message)
                    returnVal   = true
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
    
    //MARK: ---------------- updateProfile API ----------------------
    func updateProfileAPI(dob: String? = "",
                          name: String? = "",
                          email: String? = "",
                          gender: String? = "",
                          profile_pic: String? = "",
                          address: String? = "",
                          completion: ((Bool) -> Void)?){
        
        //LocationManager.shared.getLocation()
        var params                  = [String : Any]()
        //        params["latitude"]      = "\(LocationManager.shared.getUserLocation().coordinate.latitude)"
        //        params["longitude"]     = "\(LocationManager.shared.getUserLocation().coordinate.longitude)"
        
        let dob_time = GFunction.shared.convertDateFormate(dt: dob ?? "",
                                                           inputFormat: appDateFormat,
                                                           outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           status: .NOCONVERSION)
        
        params["dob"]               = dob_time.0
        params["name"]              = name!.trim()
        params["email"]             = email!.trim()
        params["gender"]            = gender!.trim()
        params["profile_pic"]       = profile_pic!.trim()
        params["address"]           = address!.trim()
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(params)
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.update_profile), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
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
                    
                    UserModel.shared = UserModel(fromJson: response.data)
                    if UserModel.shared.token != nil && UserModel.shared.token.trim() != "" {
                        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    }
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
    
    //MARK: ---------------- verify doctor link API ----------------------
    func verifyDoctorLinkAPI(doctorAccessCode: String,
                             completion: ((Bool, String) -> Void)?){
        
        var params                      = [String : Any]()
        params["access_code"]           = doctorAccessCode
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.verify_doctor_access_code), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    msg = response.message
//                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    returnVal = true
//                    kDoctorAccessCode   = doctorAccessCode
//                    kAccessCode         = doctorAccessCode
                    kAccessFrom         = .Doctor
                    kDoctorName         = response.data["name"].stringValue
//                    Alert.shared.showSnackBar(response.message, isBCP: true)
                    break
                case .emptyData:
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                //print(error.localizedDescription)
//                Alert.shared.showSnackBar(error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
    //MARK: ---------------- logout API ----------------------
    func logoutAPI(completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.logout), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
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
    
    //MARK: ---------------- delete account API ----------------------
    func deleteAccountAPI(completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.delete_account), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
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
    
    //MARK: ---------------- coach_marks API ----------------------
    func coach_marksAPI(completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.coach_marks), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    CoachmarkListModel.arrList = CoachmarkListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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
    
    //MARK: ---------------- appConfig API ----------------------
    func appConfigAPI(completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.combine(.appConfig), methodType: .post, parameter: params, withErrorAlert: false, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    awsAppConfig = AppConfig(fromJson: response.data)
                    
                    let _ = AWSUploadConfigration.init()
                    // AWS Image upload configration
                    AWSUploadManager.shared.configure()
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
    
    //MARK: ---------------- get_no_login_setting_flags API ----------------------
    func get_no_login_setting_flagsAPI(completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        let params                          = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_no_login_setting_flags), methodType: .post, parameter: params, withErrorAlert: false, withLoader: false, withdebugLog: true) { (result) in
            
            var returnVal       = false
            switch result {
            case .success(let response):
                switch response.apiCode {
                case .invalidOrFail:
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal                           = true
                    UserDefaultsConfig.language_page    = response.data["language_page"].stringValue
                    break
                case .emptyData:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    
                    //UIApplication.shared.forceLogOut()
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- updateOtherDetail API ----------------------
    func updateOtherDetailAPI(profileImage: String? = "",
                              aboutMe: String? = "",
                              age: String? = "",
                              city: String? = "",
                              state: String? = "",
                              zipcode: String? = "",
                              lat: String? = "",
                              long: String? = "",
                              gender: String? = "",
                              favDrinks: String? = "",
                              specificDrinks: String? = "",
                              personalityType: String? = "",
                              completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         */
        
        var params                          = [String : Any]()
        params["profile_image"]             = profileImage
        params["about_me"]                  = aboutMe
        params["age"]                       = age
        params["city"]                      = city
        params["state"]                     = state
        params["zipcode"]                   = zipcode
        params["latitude"]                  = lat
        params["longitude"]                 = long
        params["gender"]                    = gender
        params["fav_drinks"]                = favDrinks
        params["specific_drinks"]           = specificDrinks
        params["personality_type"]          = personalityType
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.user(.updateOtherDetail), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
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
    
    //MARK: ---------------- updateOtherDetail API ----------------------
    func addReadingGoalAPI(readings: [[String: Any]],
                           goals: [[String: Any]],
                           completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         
         {"readings":[{"reading_id":"de3dcfe5-1a17-11ec-a706-a87eea410734","reading_datetime":"2021-09-22 15:15:15","reading_value":"100"}],
         "goals":[{"goal_id":"a99daf7a-1a16-11ec-a706-a87eea410734","goal_value":"100","start_date":"2021-09-22","end_date":"2021-09-22"}]}
         
         */
        var params                          = [String : Any]()
        params["readings"]                  = readings
        params["goals"]                     = goals
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.add_reading_goal), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
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
    
    //MARK: ---------------- editProfile API ----------------------
    func editProfileAPI(name: String? = "",
                        email: String? = "",
                        country_code: String? = "",
                        mobile: String? = "",
                        profileImage: String? = "",
                        aboutMe: String? = "",
                        age: String? = "",
                        city: String? = "",
                        state: String? = "",
                        zipcode: String? = "",
                        lat: String? = "",
                        long: String? = "",
                        gender: String? = "",
                        completion: ((Bool) -> Void)?){
        
        /*
         PARAMETER:
         
         */
        
        var params                          = [String : Any]()
        params["name"]                      = name
        params["email"]                     = email
        params["country_code"]              = country_code
        params["mobile"]                    = mobile
        params["gender"]                    = gender
        params["age"]                       = age
        params["city"]                      = city
        params["state"]                     = state
        params["zipcode"]                   = zipcode
        params["latitude"]                  = lat
        params["longitude"]                 = long
        params["about_me"]                  = aboutMe
        params["profile_image"]             = profileImage
        
        LocationManager.shared.getLocation()
        params["latitude"]                  = "\(LocationManager.shared.getUserLocation().coordinate.latitude)"
        params["longitude"]                 = "\(LocationManager.shared.getUserLocation().coordinate.longitude)"
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.user(.editProfile), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    Alert.shared.showSnackBar(response.message)
                    returnVal   = true
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
    
    //MARK: ---------------- changePassword API ----------------------
    func changePasswordAPI(currentPassword: String,
                           newPassword: String,
                           completion: ((Bool) -> Void)?){
        //mobile, country_code
        
        var params                  = [String : Any]()
        params["current_password"]  = currentPassword
        params["new_password"]      = newPassword
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.user(.changePassword), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
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
    
    //MARK: ---------------- forgotPassword API ----------------------
    func forgotPasswordAPI(contact_no: String,
                           password: String,
                           conf_password: String,
                           completion: ((Bool) -> Void)?){
        //mobile, country_code
        
        var params                  = [String : Any]()
        params["contact_no"]        = contact_no
        params["password"]          = password
        params["conf_password"]     = conf_password
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.forgot_password), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
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
    
    //MARK: ---------------- contactUs API ----------------------
    func contactUsAPI(subject: String,
                      message: String,
                      completion: ((Bool) -> Void)?){
        
        var params                  = [String : Any]()
        params["subject"]           = subject
        params["message"]           = message
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.combine(.contactUs), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
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
    
    //MARK: ---------------- editNotificationSetting API ----------------------
    func editNotificationSettingAPI(isAllow: Bool,
                                    completion: ((Bool) -> Void)?){
        
        var params                          = [String : Any]()
        params["allow_push_notification"]   = isAllow ? 1 : 0
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.combine(.editNotificationSetting), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
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
    
    //MARK: ---------------- update_notification API ----------------------
    func update_notificationAPI(image_url: String,
                                we_notification_id: String,
                                deep_link: String,
                                title: String,
                                mesage: String,
                                data: [String: Any],
                                completion: ((Bool) -> Void)?){
        
        /*
         {
           "image_url": "string",
           "we_notification_id": "string",
           "deep_link": "string",
           "mesage": "string",
           "data": {}
         }
         */
        
        var params                      = [String : Any]()
        params["image_url"]             = image_url
        params["we_notification_id"]    = we_notification_id
        params["deep_link"]             = deep_link
        params["title"]                 = title
        params["mesage"]                = mesage
        params["data"]                  = data
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.update_notification), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    //Alert.shared.showSnackBar(response.message)
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
                print(error.localizedDescription)
//                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- addCard API ----------------------
    func addCardAPI(name: String,
                    number: String,
                    expDate: String,
                    cvv: String,
                    completion: ((Bool) -> Void)?){
        /*
         card_holder_name
         card_number
         expiry_date - The expiry date eg:08-2021
         cvv
         */
        
        var params                  = [String : Any]()
        params["card_holder_name"]  = name
        params["card_number"]       = number
        params["expiry_date"]       = expDate
        params["cvv"]               = cvv
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.user(.addCard), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
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
    
    //MARK: ---------------- addCard API ----------------------
    func deleteCardAPI(id: String,
                       completion: ((Bool) -> Void)?){
        /*
         card_holder_name
         card_number
         expiry_date - The expiry date eg:08-2021
         cvv
         */
        
        var params                  = [String : Any]()
        params["card_id"]           = id
        
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.user(.deleteCard), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
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
    
    //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: ---------------- Update goal and reading API ----------------------
    //MARK: ---------------- update_goal_logs API ----------------------
    func update_goal_logsAPI(goal_id: String? = "",
                             achieved_value: String = "",
                             patient_sub_goal_id: String = "",
                             start_time: String = "",
                             end_time: String = "",
                             achieved_datetime: String = "",
                             showAlert: Bool = true,
                             completion: ((Bool,
                                           _ achieved_datetime: Date,
                                           _ startTime: Date,
                                           _ endTime: Date) -> Void)?){
        
        /*
         {
         "patient_goal_rel_id": "string",
         "achieved_value": "string",
         "patient_sub_goal_id": "string",
         "start_time": "string",
         "end_time": "string",
         "achieved_datetime": "string"
         }
         
         {
         patient_goal_rel_id*    string
         achieved_value*    string
         patient_sub_goal_id    string
         Like exercise id or something else
         
         start_time*    string
         end_time*    string
         achieved_datetime*    string
         dateTimeFormat YYYY-MM-DD HH:MM:SS
         
         
         {"achieved_datetime":"2021-09-30 12:57:20","achieved_value":"20","patient_goal_rel_id":"25b7f7cc-1a16-11ec-9b7c-02004825dc14","patient_sub_goal_id":"08cf7a61-2112-11ec-9b7c-02004825dc14"
         }
         
         }
         */
        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = "ss"
        dateFormatter.timeZone              = .current
        let secDt                           = dateFormatter.string(from: Date())
        
        let datetime = GFunction.shared.convertDateFormate(dt: achieved_datetime + secDt,
                                                           inputFormat: appDateFormat + appTimeFormat + "ss",
                                                           outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           status: .NOCONVERSION)
        
        let startTime = GFunction.shared.convertDateFormate(dt: start_time + secDt,
                                                            inputFormat:  appDateFormat + appTimeFormat + "ss",
                                                            outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                            status: .NOCONVERSION)
        
        let endTime = GFunction.shared.convertDateFormate(dt: end_time + secDt,
                                                          inputFormat:  appDateFormat + appTimeFormat + "ss",
                                                          outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                          status: .NOCONVERSION)
        
        var params                          = [String : Any]()
        params["goal_id"]                   = goal_id
        params["achieved_value"]            = achieved_value
        params["patient_sub_goal_id"]       = patient_sub_goal_id
        params["start_time"]                = startTime.0
        params["end_time"]                  = endTime.0
        params["achieved_datetime"]         = datetime.0
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.update_goal_logs), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
                    break
                case .success:
                    returnVal = true
                    
                    let object = GoalLogsModel(fromJson: response.data)
                    if object.todaysAchievedValue >= object.targetValue {
                        var params              = [String: Any]()
                        params[AnalyticsParameters.goal_id.rawValue]        = goal_id
                        params[AnalyticsParameters.goal_value.rawValue]     = object.targetValue
                        FIRAnalytics.FIRLogEvent(eventName: .GOAL_COMPLETED,
                                                 screen: ScreenName.LogGoal,
                                                 parameter: params)
                    }
                    
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
                    break
                case .emptyData:
                    
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
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
                completion?(returnVal, datetime.1, startTime.1, endTime.1)
                break
                
            case .failure(let error):
                if showAlert {
                    Alert.shared.showSnackBar(error.localizedDescription)
                }
                break
                
            }
        }
    }
    
    //MARK: ---------------- update_patient_readings API ----------------------
    func update_patient_readingsAPI(reading_id: String? = "",
                                    reading_datetime: String = "",
                                    reading_value: String = "",
                                    duration: String = "",
                                    reading_value_data: [String: Any]? = nil,
                                    height_unit: String? = "",
                                    weight_unit: String? = "",
                                    isHideMessage: Bool = false,
                                    completion: ((Bool, Date) -> Void)?){
        
        /*
         {
         "reading_id": "string",
         "reading_datetime": "string",
         "reading_value": "string"
         }
         
         {
         reading_id*    string
         reading_datetime*    string
         reading_value*    string
         if key = bmi send data like reading_value:{height:'10',weight:'10'}
         if key = blood_glucose send data like reading_value:{fast:'10',pp:'10'}
         if key = bloodpressure send data like reading_value:{diastolic:'10',systolic:'10'}
         
         
         }
         */
        
        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = "ss"
        dateFormatter.timeZone              = .current
        let secDt                           = dateFormatter.string(from: Date())
        
        let datetime = GFunction.shared.convertDateFormate(dt: reading_datetime + secDt,
                                                           inputFormat: appDateFormat + appTimeFormat + "ss",
                                                           outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           status: .NOCONVERSION)
        
        var params                          = [String : Any]()
        params["reading_id"]                = reading_id
        params["reading_datetime"]          = datetime.0
        params["reading_value"]             = reading_value
        params["duration"]                  = duration
        
        if height_unit?.trim() != "" {
            params["height_unit"]           = height_unit
        }
        if  weight_unit?.trim() != "" {
            params["weight_unit"]           = weight_unit
        }
        
        if reading_value_data != nil {
            params["reading_value_data"]    = reading_value_data
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.update_patient_readings), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    isHideMessage ? kBMISuccessMessage = response.message : Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    isHideMessage ? kBMISuccessMessage = response.message : Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    
                    isHideMessage ? kBMISuccessMessage = response.message : Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    isHideMessage ? kBMISuccessMessage = response.message : Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, datetime.1)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- update_patient_readings API ----------------------
    func update_patient_dosesAPI(arr: [MedicationTodayList],
                                 medication_date: String,
                                 goalMasterId: String,
                                 completion: ((Bool) -> Void)?){
        
        /*
         mediation ka request ka ho jaye to update karna Vaibhav
         Request data required to send for update medication
         {
         "medication_data":[
         {
         "dose_status":[
         {
         "dose_time_slot":"10:00",
         "dose_taken":"Y"
         },
         ],
         "patient_dose_rel_id":"58d6e713-205f-11ec-9b7c-02004825dc14"
         },
         {
         "dose_status":[
         {
         "dose_time_slot":"14:00",
         "dose_taken":"Y"
         },
         ],
         "patient_dose_rel_id":"5b315af0-250a-11ec-9b7c-02004825dc14"
         }
         ]
         }
         
         
         }
         */
        
        var arrMedication               = [[String : Any]]()
        for item in arr {
            var obj = [String: Any]()
            obj["patient_dose_rel_id"]  = item.patientDoseRelId
            
            var arrDose                 = [[String : Any]]()
            for dose in item.doseTimeSlot {
                var child = [String: Any]()
                child["dose_time_slot"]     = dose.time
                child["dose_taken"]         = dose.taken
                arrDose.append(child)
            }
            obj["dose_status"] = arrDose
            arrMedication.append(obj)
        }
        
        var params                          = [String : Any]()
        params["medication_data"]           = arrMedication
        
        let start_dt = GFunction.shared.convertDateFormate(dt: medication_date,
                                                           inputFormat: appDateFormat,
                                                       outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                       status: .NOCONVERSION)
        
        params["medication_date"]           = start_dt.0
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.update_patient_doses), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    
                    let data = JSON(response.data)
                    let todaysAchievedValue = data["todays_achieved_value"].intValue
                    let targetValue         = data["goal_value"].intValue
                    if todaysAchievedValue >= targetValue {
                        var params              = [String: Any]()
                        params[AnalyticsParameters.goal_id.rawValue]        = goalMasterId
                        params[AnalyticsParameters.goal_value.rawValue]     = targetValue
                        FIRAnalytics.FIRLogEvent(eventName: .GOAL_COMPLETED,
                                                 screen: .LogGoal,
                                                 parameter: params)
                    }
                    
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
    
    //MARK:HEALTH KIT UPDATE 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: ---------------- Update goal and reading API ----------------------
    func update_goal_and_reading_from_healthkitAPI(completion: ((Bool) -> Void)?){
        
        var dayFromToday = 30//180
        if UserModel.shared.syncAt != nil && UserModel.shared.syncAt.trim() != "" {
            let time = GFunction.shared.convertDateFormate(dt: UserModel.shared.syncAt,
                                                               inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                               outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                               status: .NOCONVERSION)
            
            dayFromToday = Calendar.current.dateComponents([.day], from: time.1, to: Date()).day ?? dayFromToday
            if  dayFromToday < 7 {
                dayFromToday = 7
            }
        }
        
        HealthKitManager.shared.fetchAllRecords(dayFromToday: dayFromToday,
                                                sampleIdentifier: [
                                                    .stepCount,
                                                    .dietaryWater/*,
                                                    .activeEnergyBurned*/,
                                                    .appleExerciseTime,
                                                    .oxygenSaturation,
                                                    .forcedExpiratoryVolume1,
                                                    .peakExpiratoryFlowRate,
                                                    .bloodPressureSystolic,
                                                    .bloodPressureDiastolic,
                                                    .restingHeartRate,
                                                    .bodyMass,
                                                    .bodyMassIndex,
                                                    .bloodGlucose]) { result, error in
            if let error = error{
                print(error)
                return
            }
            
            //Update all data in chunk
            func updateData(arrGoal: [[String: Any]]? = nil,
                            arrReading: [[String:Any]]? = nil,
                            completion: ((Bool) -> Void)?) {
                
                var params = [String  :Any]()
                
                if let arr = arrGoal {
                    params["goal_data"]     = arr
                }
                if let arr = arrReading {
                    params["reading_data"]  = arr
                }
                
                ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.update_readings_goals), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in

    //                {
    //                  "data" : true,
    //                  "message" : "Goal Readings updated successfully",
    //                  "code" : "1"
    //                }

                    switch result {
                    case .success(let response):
                        var returnVal = false
                        switch response.apiCode {
                        case .invalidOrFail:

                            break
                        case .success:
                            FIRAnalytics.FIRLogEvent(eventName: .READING_CAPTURED_APPLE_HEALTH, parameter: nil)
                            returnVal = true
                            break
                        case .emptyData:

                            break
                        case .inactiveAccount:

                            UIApplication.shared.forceLogOut()
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
                        print(error.localizedDescription)
                        break
                    }
                }
            }
            
            print("result======", result)
            if let result = result{
//               let dispatchGroup1 = DispatchGroup()
               
                let arrTempReading  = result.reading_data
                let arrTempGoal     = result.goal_data
                
                let readingList     = GFunction.shared.chunked(array: arrTempReading.reversed(), into: 60)
                let goalList        = GFunction.shared.chunked(array: arrTempGoal.reversed(), into: 60)
                
                
//                updateData(arrGoal: result.goal_data, arrReading: result.reading_data) { (isDone) in
//
//                    completion?(isDone)
//                }
                
                ///Logic of passing data in the chunk of 20 items to store healthkit data
                ///
                
                /*
                 var index = 0
                 func updateReading(){
                     dispatchGroup1.enter()

                     if readingList.count > 0 {
                         let item = readingList[index]
                         
                         updateData(arrReading: item) { (isDone) in
                             if isDone {
                                 index += 1
                                 if index < readingList.count {
                                     updateReading()
                                 }
                             }
                             dispatchGroup1.leave()
                         }
                     }
                     else {
                         dispatchGroup1.leave()
                     }
                 }

                 updateReading()

                 dispatchGroup1.notify(queue: DispatchQueue.main) {
                     let dispatchGroup2 = DispatchGroup()

                     var index = 0
                     func updateGoal(){
                         dispatchGroup2.enter()

                         if goalList.count > 0 {
                             let item = goalList[index]
                             updateData(arrGoal: item) { (isDone) in
                                 if isDone {
                                     index += 1
                                     if index < goalList.count {
                                         updateGoal()
                                     }
                                 }
                                 dispatchGroup2.leave()
                             }
                         }
                         else {
                             dispatchGroup2.leave()
                         }
                     }
                     updateGoal()

                     dispatchGroup2.notify(queue: DispatchQueue.main) {
                         completion?(true)
                     }
                 }
                */
                
                let readOperation = BlockOperation()
                let goalOperation = BlockOperation()
                for reading in readingList {
                    
                    readOperation.addExecutionBlock {
                        updateData(arrReading: reading) { (isDone) in
                            if isDone {
                            }
                        }
                    }
                }
                
                for goal in goalList {
                    goalOperation.addExecutionBlock {
                        updateData(arrGoal: goal) { (isDone) in
                            if isDone {
                            }
                        }
                    }
                }
                
                readOperation.completionBlock = {
                    print("I'm done fetching readOperation")
                }
                
                goalOperation.completionBlock = {
                    print("I'm done fetching goalOperation")
                }

//                DispatchQueue.main.async {
                    let operationQueue = OperationQueue()
                    operationQueue.maxConcurrentOperationCount = -1
                    readOperation.addDependency(goalOperation)
                    operationQueue.addOperation(readOperation)
                    operationQueue.addOperation(goalOperation)
//                }
                
                
//                DispatchQueue.global(qos: .background).async {
//
//                    let dispatchGroup1 = DispatchGroup()
//                    for reading in readingList {
//                        dispatchGroup1.enter()
//                        updateData(arrReading: reading) { (isDone) in
//                            dispatchGroup1.leave()
//                            if isDone {
//                            }
//                        }
//                    }
//
//                    dispatchGroup1.notify(queue: .main) {
//                        let dispatchGroup2 = DispatchGroup()
//
//                        for goal in goalList {
//                            dispatchGroup2.enter()
//                            updateData(arrGoal: goal) { (isDone) in
//                                dispatchGroup2.leave()
//                                if isDone {
//                                }
//                            }
//                        }
//                    }
//                }
            }
                                                    }
    }
     
    //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: ---------------- Graphs of goal and reading API ----------------------
    //MARK: ---------------- get_reading_records API ----------------------
    func get_reading_recordsAPI(reading_id: String? = "",
                                reading_time: SelectionType = .sevenDays,
                                completion: ((Bool, ReadingChartDetailModel, String) -> Void)?){
        
        /*
         {
         "reading_id": "string",
         "reading_time": "string"
         
         For 7 days send 7D
         For 30 days send 30D
         For 90 days send 90D
         For 1 Year send 1Y
         For All send ALL
         }
         */
        
        
        var params                         = [String : Any]()
        params["reading_id"]               = reading_id
        
        switch reading_time {
        case .sevenDays:
            params["reading_time"]       = "7D"
            break
        case .fifteenDays:
            params["reading_time"]       = "15D"
            break
        case .thirtyDays:
            params["reading_time"]       = "30D"
            break
        case .nintyDays:
            params["reading_time"]       = "90D"
            break
        case .oneYear:
            params["reading_time"]       = "1Y"
            break
//        case .allTime:
//            params["reading_time"]       = "ALL"
//            break
        }
        
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.get_reading_records), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var object  = ReadingChartDetailModel()
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    object = ReadingChartDetailModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
//                    Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, object, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- get_goal_records API ----------------------
    func get_goal_recordsAPI(goal_id: String? = "",
                             reading_time: SelectionType = .sevenDays,
                             completion: ((Bool, GoalChartDetailModel, String, SelectionType) -> Void)?){
        
        /*
         {
         "reading_id": "string",
         "reading_time": "string"
         
         For 7 days send 7D
         For 30 days send 30D
         For 90 days send 90D
         For 1 Year send 1Y
         For All send ALL
         }
         */
        
        var params                  = [String : Any]()
        params["goal_id"]           = goal_id
        
        switch reading_time {
        case .sevenDays:
            params["goal_time"]     = "7D"
            break
        case .fifteenDays:
            params["reading_time"]       = "15D"
            break
        case .thirtyDays:
            params["goal_time"]     = "30D"
            break
        case .nintyDays:
            params["goal_time"]     = "90D"
            break
        case .oneYear:
            params["goal_time"]     = "1Y"
            break
//        case .allTime:
//            params["goal_time"]     = "ALL"
//            break
        }
        
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.get_goal_records), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var returnVal   = false
            var object      = GoalChartDetailModel()
            var msg         = ""
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    returnVal = true
                    msg = response.message
                    object = GoalChartDetailModel(fromJson: response.data)
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    object = GoalChartDetailModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, object, msg, reading_time)
                break
                
            case .failure(let error):
//                Alert.shared.showSnackBar(error.localizedDescription)
                msg = error.localizedDescription
                completion?(returnVal, object, msg, reading_time)
                break
                
            }
        }
    }
    
    //MARK: ---------------- get_goal_records API ----------------------
    func last_seven_days_medicationAPI(completion: ((Bool, [MedicineHistoryModel], String) -> Void)?){
        
        /*
         No params
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.last_seven_days_medication), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var arr = [MedicineHistoryModel]()
            var msg = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    arr = MedicineHistoryModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, arr, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
        
    }
    
    //MARK: ---------------- get_cat_survey API ----------------------
    func get_cat_surveyAPI(completion: ((Bool, CATSurveyModel, String) -> Void)?){
        
        /*
         No params
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.get_cat_survey), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg = ""
            var obj = CATSurveyModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    obj = CATSurveyModel(fromJson: response.data)
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
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
                
                completion?(returnVal, obj, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
        
    }
    
    //MARK: ---------------- add_cat_survey API ----------------------
    func add_cat_surveyAPI(cat_survey_master_id: String,
                           survey_id : String,
                           Score : String,
                           response : [[String: Any]],
                           completion: ((Bool, String) -> Void)?){
        
        /*{
         "response": "string",
         "score": "string",
         "survey_id": "string",
         "cat_survey_master_id": "string"
       }*/
        
        var params                          = [String : Any]()
        params["cat_survey_master_id"]      = cat_survey_master_id
        params["survey_id"]                 = survey_id
        params["score"]                     = Score
        params["response"]                  = response
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.add_cat_survey), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: --------------- Content details API ----------------------
    func content_by_idAPI(content_master_id: String,
                          completion: ((Bool, ContentListModel) -> Void)?){
        
        /*
         No params
         */
        
        var params                  = [String : Any]()
        params["content_master_id"] = content_master_id
//        params["content_master_id"] = "9747525f-4bdb-11ee-a125-b856859b798d"

        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.content_by_id), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var data = ContentListModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    data = ContentListModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, data)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: --------------- get_incident_free_days API ----------------------
    func get_incident_free_daysAPI(completion: ((Bool, IncidentFreeModel, String) -> Void)?){
        
        /*
         No params
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.get_incident_free_days), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            var data = IncidentFreeModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    data = IncidentFreeModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, data, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: --------------- get_incident_free_days API ----------------------
    func get_incident_surveyAPI(withLoader: Bool,
                                showAlert: Bool,
                                completion: ((Bool, IncidentSurvayModel, String) -> Void)?){
        
        /*
         No params
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.get_incident_survey), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var data    = IncidentSurvayModel()
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
                    break
                case .success:
                    returnVal = true
                    data = IncidentSurvayModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    if showAlert {
                        Alert.shared.showSnackBar(response.message)
                    }
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
                
                completion?(returnVal, data, msg)
                break
                
            case .failure(let error):
                if showAlert {
                    Alert.shared.showSnackBar(error.localizedDescription)
                }
                break
                
            }
        }
    }
    
    //MARK: --------------- add_incident_details API ----------------------
    func add_incident_detailsAPI(incident_tracking_master_id: String,
                                 survey_id: String,
                                 response: [[String: Any]],
                                 completion: ((Bool, String) -> Void)?){
        
        /*
         {
           "survey_id": "string",
           "response": "string"
         }
         */
        
        var params                              = [String : Any]()
        params["survey_id"]                     = survey_id
        params["response"]                      = response
        params["incident_tracking_master_id"]   = incident_tracking_master_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.add_incident_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg     = ""
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
                    msg = response.message
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: --------------- update_likes API ----------------------
    func update_likesAPI(content_master_id: String,
                         content_type: String,
                         is_active: String,
                         screen: ScreenName,
                         completion: ((Bool, String) -> Void)?){
        
        /*
         {
           "content_master_id": "string",
           "is_active": "Y"
         }
         */
        
        
        if is_active == "Y" {
            var params = [String: Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
            params[AnalyticsParameters.content_type.rawValue]      = content_type
            FIRAnalytics.FIRLogEvent(eventName: .USER_LIKED_CONTENT,
                                     screen: screen,
                                     parameter: params)
        }
        else {
            var params = [String: Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
            params[AnalyticsParameters.content_type.rawValue]      = content_type
            FIRAnalytics.FIRLogEvent(eventName: .USER_UNLIKED_CONTENT,
                                     screen: screen,
                                     parameter: params)
        }
        
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
        params["is_active"]             = is_active
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.update_likes), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: --------------- update_bookmarks API ----------------------
    func update_bookmarksAPI(content_master_id: String,
                             content_type: String,
                             is_active: String,
                             forQuestion: Bool,
                             screen: ScreenName,
                             completion: ((Bool, String) -> Void)?){
        
        /*
         {
           "content_master_id": "string",
           "is_active": "Y"
         }
         */
        if forQuestion {
            var params = [String: Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
            
            if is_active == "Y" {
                FIRAnalytics.FIRLogEvent(eventName: .USER_BOOKMARKED_QUESTION,
                                         screen: screen,
                                         parameter: params)
            }
            else {
                FIRAnalytics.FIRLogEvent(eventName: .USER_UN_BOOKMARK_QUESTION,
                                         screen: screen,
                                         parameter: params)
            }
            
        }
        else {
            var params = [String: Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
            params[AnalyticsParameters.content_type.rawValue]      = content_type
            
            if is_active == "Y" {
                FIRAnalytics.FIRLogEvent(eventName: .USER_BOOKMARKED_CONTENT,
                                         screen: screen,
                                         parameter: params)
            }
            else {
                FIRAnalytics.FIRLogEvent(eventName: .USER_UN_BOOKMARK_CONTENT,
                                         screen: screen,
                                         parameter: params)
            }
            
        }
        
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
        params["is_active"]             = is_active
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.update_bookmarks), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: --------------- update_share_count API ----------------------
    func update_share_countAPI(content_master_id: String,
                         completion: ((Bool, String) -> Void)?){
        
        /*
         {
           "content_master_id": "string",
         }
         */
        
        
        //FIRAnalytics.FIRLogEvent(eventName: .USER_UN_BOOKMARK_CONTENT, parameter: ["content_master_id": content_master_id])
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
    
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.update_share_count), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: --------------- get_incident_list_by_add_rel_id API ----------------------
    func get_incident_list_by_add_rel_idAPI(incident_tracking_master_id: String,
                                            patient_incident_add_rel_id: String,
                                            completion: ((Bool, IncidentHistoryDetailModel, String) -> Void)?){
        
        /*
         No params
         */
        
        var params                              = [String : Any]()
        params["incident_tracking_master_id"]   = incident_tracking_master_id
        params["patient_incident_add_rel_id"]   = patient_incident_add_rel_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.get_incident_list_by_add_rel_id), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var data    = IncidentHistoryDetailModel()
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    data = IncidentHistoryDetailModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, data, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
    //MARK: --------------- unreport comment api ----------------------
    
   /* func apiUnreportComment(content_master_id: String,
                 content_comments_id: String,
                 reported: String,
                 completion : @escaping (Bool,String) -> Void) {
    
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
        params["content_comments_id"]   = content_comments_id
        params["reported"]              = reported
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.report_comment), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                var returnVal = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    break
                case .success:
                    var params = [String: Any]()
                    params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
                    FIRAnalytics.FIRLogEvent(eventName: .USER_UN_REPORTED_COMMENT, parameter: params)
                    
                    returnVal = true
                    break
                case .emptyData:
                    break
                case .inactiveAccount:
                    UIApplication.shared.forceLogOut()
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .simpleUpdateAlert:
                    break
                    
                case .socialIdNotRegister:
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                default: break
                }
                completion(returnVal,response.message)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }*/

    //MARK: --------------- delete comment api ----------------------
    func apiDeleteComment(content_comments_id: String,
                          screen: ScreenName,
                          completion : @escaping (Bool,String, ContentListModel) -> Void) {
        
        var params                      = [String : Any]()
        params["content_comments_id"]   = content_comments_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.remove_comment), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                var returnVal = false
                var obj = ContentListModel()

                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    var params = [String: Any]()
                    params[AnalyticsParameters.content_comments_id.rawValue] = content_comments_id
                    FIRAnalytics.FIRLogEvent(eventName: .USER_DELETED_OWN_COMMENT,
                                             screen: screen,
                                             parameter: params)
                    
                    obj = ContentListModel(fromJson: response.data)
                    returnVal = true
                    break
                case .emptyData:
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

                completion(returnVal,response.message, obj)

                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK: ---------------- health_coach_details_by_id API ----------------------
    func getHealthCoachDetailsAPI(health_coach_id: String,
                             completion: ((Bool, HealthCoachDetailsModel) -> Void)?){
        
        /*
         */
        
        var params                  = [String : Any]()
        params["health_coach_id"]   = health_coach_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.health_coach_details_by_id), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var object  = HealthCoachDetailsModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    object = HealthCoachDetailsModel(fromJson: response.data)
                    
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, object)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- link_healthcoach_chat API ----------------------
    func link_healthcoach_chatAPI(health_coach_id: String,
                                  restore_id: String = "",
                                  completion: ((Bool) -> Void)?){
        
        /*
         */
        
        var params                  = [String : Any]()
//        params["health_coach_id"]   = health_coach_id
        params["restore_id"]        = restore_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.link_healthcoach_chat), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    //Alert.shared.showSnackBar(response.message)
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
    
    //MARK: ---------------- get_cat_survey API ----------------------
    func get_zydus_infoAPI(completion: ((Bool, HospitalDetailsModel, String) -> Void)?){
        
        /*
         No params
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_zydus_info), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg     = ""
            var obj     = HospitalDetailsModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    obj = HospitalDetailsModel(fromJson: response.data)
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
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
                
                completion?(returnVal, obj, msg)
                break
                
            case .failure(let error):
                msg = error.localizedDescription
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
        
    }
    
    //MARK: ---------------- post_question API ----------------------
    func post_questionAPI(question: String,
                          topic_ids: String,
                          document: String,
                          document_type: String,
                          completion: ((Bool) -> Void)?){
        
        /*
         {
         question*    string
         topic_ids*    [...]
         document*    string
         document_type*    string
          
         }
         */
        
        var params                  = [String : Any]()
        params["question"]          = question
        params["topic_ids"]         = topic_ids
        params["document"]          = document
        params["document_type"]     = document_type
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.post_question), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    //Alert.shared.showSnackBar(response.message)
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
    
    //MARK: ---------------- get_voicetoken API ----------------------
    func get_voicetokenAPI(room_id: String,
                           room_name: String,
                           type: String,
                           appointment_id: String,
                           completion: ((Bool, String, String) -> Void)?){
        
        /*
         No params
         
         room_id
         room_name
         */
        
        var params                  = [String : Any]()
        params["appointment_id"]    = appointment_id
        params["room_id"]           = room_id
        params["room_name"]         = room_name
        params["type"]              = type
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.doctor(.get_voicetoken), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var token     = ""
            var identity  = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    token       = response.data["token"].stringValue
                    identity    = response.data["identity"].stringValue
                    
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, token, identity)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- get cart Count API ----------------------
    func get_cart_infoAPI(completion: ((Bool, Int, Bool) -> Void)?){
        
        /*
         No params
         
         room_id
         room_name
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.get_cart_info), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var cartCount = 0
            var returnVal = false
            var isBCPFlag = false
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    cartCount   = response.data["total_test"].intValue
                    isBCPFlag   = response.data["bcp_flag"].boolValue
                    
                    
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, cartCount, isBCPFlag)
                break
                
            case .failure(let error):
                completion?(returnVal, cartCount, isBCPFlag)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    
    //MARK: ---------------- signup account for ----------------------
    func signup_AccountForAPI(relation: String,
                              sub_relation: String = "",
                              completion: ((Bool, String) -> Void)?){
        
        /*
         No params

         */
        
        var params                  = [String : Any]()
        params["relation"]          = relation
        params["sub_relation"]      = sub_relation
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.update_signup_for), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal = false
            var token     = ""
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    
                    /*guard response.data["access_code"].stringValue.isEmpty else {
                        UserDefaultsConfig.kUserStep = 3
//                        UIApplication.shared.manageLogin()
                        let vc = AddpatientDetailsVC.instantiate(fromAppStoryboard: .auth)
                        vc.isBackShown = true
                        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                        return
                    }*/
                    
                    returnVal   = true
                    UserModel.shared.storeUserEntryDetails(withJSON: response.data,false)
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .inactiveAccount:
                    UIApplication.shared.forceLogOut()
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
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
                
                completion?(returnVal, token)
                break
                
            case .failure(let error):
//                Alert.shared.showSnackBar(error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
    //MARK: ---------------- update doctor access code ----------------------
    func updateDoctorAccessCodeAPI(access_code: String,
                              completion: ((Bool, String) -> Void)?){
        
        /*
         No params

         */
        
        var params                  = [String : Any]()
        params["access_code"]       = access_code
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.update_access_code), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal = false
            var token     = ""
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    token       = response.data["token"].stringValue
                    
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, token)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//------------------------------------------------------
//MARK: - Exercise Routine APIs
extension GlobalAPI{
    
    func getRoutines(planDate:Date?=nil,completion:((String?,JSON?,ApiKeys.ApiStatusCode) -> ())? = nil) {
        
        let planDate = planDate ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
                
        let param: [String:Any] = [
            "plan_date": dateFormatter.string(from: planDate)
        ]
        
        ApiManager.shared.makeRequest(method: .content(.exercise_plan_details), parameter: param) { result in
            switch result{
            case.success(let apiResponse):
                let statusCode = apiResponse.apiCode
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    completion?(nil,apiResponse.data,statusCode)
                    
                    break
                    
                case .emptyData:
                    completion?(apiResponse.message,nil,statusCode)
                    
                    break
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
            case .failure(_):
                debugPrint("Error")
            }
        }
        
    }
    
    
    //MARK: ---------------- Walkthrough List Data ----------------------
    func apiWalkthroughList(completionHandler: @escaping(([WalkthroughListModel]) -> Void)) {

        ApiManager.shared.makeRequest(method: .patient(.onbording_signup_data), parameter: [:], withLoader: false) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):

                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    var arr = [WalkthroughListModel]()
                    arr = WalkthroughListModel.modelsFromDictionaryArray(array: apiResponse.data.arrayValue)
                    
                    completionHandler(arr)
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }

                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }

    }
    
}

//------------------------------------------------------
//MARK: - PlanDetails
extension GlobalAPI {
    
    func planDetailsAPI(plan_id: String,
                        durationType:String?=nil,
                        patientPlanRelId:String="",
                        withLoader: Bool,
                        completion: ((Bool, CarePlanDetailsModel, String) -> Void)?){
        
        /*
         No params
         */
        
        var params                  = [String : Any]()
        params["plan_id"]           = plan_id
        params["patient_plan_rel_id"] = patientPlanRelId
        if let durationType = durationType {
            params["duration_type"] = durationType
        }
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.plans_details_by_id), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var msg         = ""
            var obj         = CarePlanDetailsModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    obj = CarePlanDetailsModel(fromJson: response.data)
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, obj, msg)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
        
    }
        
}

//MARK: - BCA Select Address List APIs
extension GlobalAPI {
    
    func addressListAPI(completionHandler: @escaping(([LabAddressListModel]) -> Void)) {

        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.address_list), parameter: [:], withLoader: false) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):

                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    var arr = [LabAddressListModel]()
                    arr = LabAddressListModel.modelsFromDictionaryArray(array: apiResponse.data.arrayValue)
                    
                    if !arr.isEmpty {
                        arr.first?.isSelected = true
                    }
                    
                    completionHandler(arr)
                    break
                case .emptyData:
                    completionHandler([])
                    break
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }

                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }

    }
    
}
