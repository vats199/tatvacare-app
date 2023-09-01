//
//  LoginWithPassVM.swift
//
//

//

import Foundation
import UIKit

class AddAccountDetailsVM {
    
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
extension AddAccountDetailsVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(countryCode: String,
                             contact_no: String,
                             email: UITextField,
                             language_id: String,
                             firstName: UITextField,
                             lastName: UITextField,
                             dob: UITextField,
                             vwDob: UIView,
                             gender: String,
                             password: UITextField,
                             confirmPassword: UITextField,
                             account_role: String,
                             isAccessCodeVerified: Bool,
                             access_code: String,
                             active_deactive_id: String,
                             is_accept_terms_accept: Bool,
                             profile_pic: String,
                             whatsapp_optin: Bool,
                             email_verified: Bool,
                             medical_condition_ids: [MedicalConditionListModel])  -> AppError? {
        
        
        if !isAccessCodeVerified {
            return AppError.validation(type: .verifyAccessCode)
        }
        else if countryCode.trim() == "" {
            return AppError.validation(type: .enterCountryCode)
        }
        else if contact_no.trim() == "" {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if contact_no.count < Validations.PhoneNumber.Maximum.rawValue {
            return AppError.validation(type: .enterMinMobileNumber)
        }
        else if firstName.text!.trim() == "" {
            return AppError.validation(type: .enterFirstName)
        }
        else if !Validation.isAtleastOneAlphabaticString(txt: firstName.text!) {
            return AppError.validation(type: .enterValidFirstName)
        }
        else if lastName.text!.trim() == "" {
            return AppError.validation(type: .enterLastName)
        }
        else if !Validation.isAtleastOneAlphabaticString(txt: lastName.text!) {
            return AppError.validation(type: .enterValidLastName)
        }
        else if email.text!.trim() == "" {
            return AppError.validation(type: .enterEmail)
        }
        else if !email.text!.isValid(.email) {
            return AppError.validation(type: .enterValidEmail)
        }
//        else if password.text!.trim() == "" {
//            return AppError.validation(type: .enterPassword)
//        }
//        else if password.text!.count < Validations.Password.Minimum.rawValue {
//            return AppError.validation(type: .enterMinPassword)
//        }
//        else if !Validation.isPasswordValid(txt: password.text!) {
//            return AppError.validation(type: .enterValidPassword)
//        }
//        else if confirmPassword.text!.trim() == ""{
//            return AppError.validation(type: .enterConfirmPassword)
//        }
//        else if password.text! != confirmPassword.text!  {
//            return AppError.validation(type: .passwordMismatch)
//        }
        else if dob.text!.trim() == "" {
            return AppError.validation(type: .selectDob)
        }
        else if  !is_accept_terms_accept {
            return AppError.validation(type: .agreeTermsAndCondition)
        }
        else if medical_condition_ids.count == 0 {
            return AppError.validation(type: .selecteMedicalCondition)
        }
        
        return nil
    }
}

// MARK: Web Services
extension AddAccountDetailsVM {
    
    func registerApiCall(vc: UIViewController,
                         countryCode: String,
                         contact_no: String,
                         email: UITextField,
                         language_id: String,
                         firstName: UITextField,
                         lastName: UITextField,
                         dob: UITextField,
                         vwDob: UIView,
                         gender: String,
                         password: UITextField,
                         confirmPassword: UITextField,
                         vwPassword: UIView,
                         vwConfirmPassword: UIView,
                         account_role: String,
                         isAccessCodeVerified: Bool,
                         access_code: String,
                         active_deactive_id: String,
                         is_accept_terms_accept: Bool,
                         profile_pic: String,
                         whatsapp_optin: Bool,
                         email_verified: Bool,
                         medical_condition_ids: [MedicalConditionListModel]) {
        
        
        // Check validation
        if let error = self.isValidView(countryCode: countryCode,
                                        contact_no: contact_no,
                                        email: email,
                                        language_id: language_id,
                                        firstName: firstName,
                                        lastName: lastName,
                                        dob: dob,
                                        vwDob: vwDob,
                                        gender: gender,
                                        password: password,
                                        confirmPassword: confirmPassword,
                                        account_role: account_role,
                                        isAccessCodeVerified: isAccessCodeVerified,
                                        access_code: access_code,
                                        active_deactive_id: active_deactive_id,
                                        is_accept_terms_accept: is_accept_terms_accept,
                                        profile_pic: profile_pic,
                                        whatsapp_optin: whatsapp_optin,
                                        email_verified: email_verified,
                                        medical_condition_ids: medical_condition_ids) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        /*
         {
           "contact_no": "string",
           "email": "string",
           "language_id": "string",
           "name": "string",
           "dob": "string",
           "gender": "M",
           "password": "string",
           "conf_password": "string",
           "account_role": "P",
           "access_code": "string",
           "active_deactive_id": "string",
           "is_accept_terms_accept": "Y",
           "profile_pic": "string",
           "whatsapp_optin": "Y",
           "email_verified": "Y"
         }
         access_from('LinkPatient', 'Doctor')
         
         {"contact_no":"9999999999","name":"name","email":"patient@gmail.com","password":"password","gender":"M","dob":"1995-02-02","account_role":"P","languages_id":"442886c3-1959-11ec-9978-a87eea410734","medical_condition_ids":["88f50848-195e-11ec-9978-a87eea410734"]}

         */
        
        
//        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
//        UIApplication.shared.manageLogin()
//        self.vmResult.value = .success(nil)
        //LocationManager.shared.getLocation()
        
        let dob_time = GFunction.shared.convertDateFormate(dt: dob.text!,
                                                           inputFormat: appDateFormat,
                                                           outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           status: .NOCONVERSION)
        
        var params                          = [String : Any]()
        params["contact_no"]                = contact_no.trim()
        params["email"]                     = email.text!.trim()
        params["languages_id"]              = UserDefaultsConfig.languageId//language_id
        params["name"]                      = firstName.text!.trim() + " " + lastName.text!.trim()
        params["dob"]                       = dob_time.0
        params["gender"]                    = gender.trim()
        params["password"]                  = password.text!.trim()
        params["account_role"]              = account_role
        params["access_code"]               = access_code
        params["active_deactive_id"]        = active_deactive_id
        params["is_accept_terms_accept"]    = is_accept_terms_accept == true ? "Y" : "N"
        params["profile_pic"]               = profile_pic.trim()
        params["whatsapp_optin"]            = whatsapp_optin == true ? "Y" : "N"
        params["email_verified"]            = email_verified == true ? "Y" : "N"
        params["access_from"]               = kAccessFrom.rawValue
        
        if kDoctorAccessCode.trim() != "" && kAccessFrom == .LinkPatient{
            params["doctor_access_code"]    = kDoctorAccessCode
        }
        
        params["access_code"]               = kAccessCode
        
        let arrTemp: [String] = medical_condition_ids.map { (obj) -> String in
            return obj.medicalConditionGroupId
        }
        params["medical_condition_group_id"]     = arrTemp.first!
        
//        params["email"]                 = email
//        params["device_type"]           = DeviceManager.shared.deviceType
//        params["device_token"]          = DeviceManager.shared.deviceToken
//        params["uuid"]                  = DeviceManager.shared.uuid
//        params["os_version"]            = DeviceManager.shared.osVersion
//        params["device_name"]           = DeviceManager.shared.DeviceName
//        params["model_name"]            = DeviceManager.shared.modelName
//        params["app_version"]           = Bundle.main.releaseVersionNumber
//        params["build_version_number"]  = Bundle.main.releaseVersionNumber
//        params["ip"]                    = DeviceManager.shared.getIPAddress
//
//        params["latitude"]              = LocationManager.shared.getUserLocation().coordinate.latitude
//        params["longitude"]             = LocationManager.shared.getUserLocation().coordinate.longitude
//        params["language"]              = GFunction.shared.getLanguage()
        
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.register), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:

                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:

                    //Save data into user model and redirect to home screen.
//                    UserModel.currentUser = response.data
//                    UserDefaultsConfig.accessToken = response.data.accessToken

                    UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    
                    GlobalAPI.shared.updateDeviceAPI { [weak self] (isDone) in
                        guard let self = self else {return}
                    }
                    
//                    UIApplication.shared.manageLogin()
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
