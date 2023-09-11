//
//  AddPatientDetailVM.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import Foundation
class AddPatientDetailVM {
    
    //MARK: - Class Variables
    
    private(set) var isResult = Bindable<Result<String?,AppError>>()
    
    //MARK: - init
    init() {
        
    }
    
    //---------------------------------------------------------
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
}

//------------------------------------------------------
//MARK: - Validation Methods
extension AddPatientDetailVM {
    private func validateView(firstName:String,lastName:String,gender:String,dob:String,email:String,condition:String,isTermSelected:Bool) -> AppError? {
        
        if firstName.trim().isEmpty {
            return .validation(type: .enterFirstName)
        } else if !Validation.isAtleastOneAlphabaticString(txt: firstName) {
            return .validation(type: .enterValidFirstName)
        } else if lastName.trim().isEmpty {
            return .validation(type: .enterLastName)
        } else if !Validation.isAtleastOneAlphabaticString(txt: lastName) {
            return .validation(type: .enterValidLastName)
        } else if gender.isEmpty {
            return .validation(type: .selectGender)
        } else if dob.trim().isEmpty {
            return .validation(type: .selectDob)
        } else if email.trim().isEmpty {
            return .validation(type: .enterEmail)
        } else if !Validation.isValidEmail(testStr: email) {
            return .validation(type: .enterValidEmail)
        } else if condition.trim().isEmpty {
            return .validation(type: .selectCondition)
        } else if !isTermSelected {
            return .validation(type: .agreeTermsAndCondition)
        }
        
        return nil
    }
}

//------------------------------------------------------
//MARK: - WS Methods
extension AddPatientDetailVM {
    func apiAddDetails(firstName:String,lastName:String,gender:String,dob:String,email:String,condition:String,isTermSelected:Bool, medical_condition_ids: [MedicalConditionListModel]) {
        if let error = self.validateView(firstName: firstName, lastName: lastName, gender: gender, dob: dob, email: email, condition: condition, isTermSelected: isTermSelected) {
            self.isResult.value = .failure(error)
            return
        }
        
        let dob_time = GFunction.shared.convertDateFormate(dt: dob,
                                                           inputFormat: appDateFormat,
                                                           outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           status: .NOCONVERSION)
        
        var params                          = [String : Any]()
        params["email"]                     = email
        params["languages_id"]              = UserDefaultsConfig.languageId//language_id
        params["name"]                      = firstName + " " + lastName
        params["dob"]                       = dob_time.0
        params["gender"]                    = gender == "Male" ? "M" : "F"
        params["account_role"]              = "P"
        params["active_deactive_id"]        = ""
        params["is_accept_terms_accept"]    = isTermSelected == true ? "Y" : "N"
        params["whatsapp_optin"]            = "Y"
        params["email_verified"]            = "N"
        params["access_from"]               = "Doctor"
        params["contact_no"]                = UserModel.shared.contactNo
        
        
        if kDoctorAccessCode.trim() != "" && kAccessFrom == .LinkPatient{
            params["doctor_access_code"]    = kDoctorAccessCode
        }
        
        params["access_code"]               = kAccessCode
        
        let arrTemp: [String] = medical_condition_ids.map { (obj) -> String in
            return obj.medicalConditionGroupId
        }
        params["medical_condition_group_id"]     = arrTemp.first!
        
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
                    self.isResult.value = .success(nil)
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

