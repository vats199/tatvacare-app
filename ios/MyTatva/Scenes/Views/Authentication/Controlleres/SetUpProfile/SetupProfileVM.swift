//
//  QuestionsOneVM.swift
//  MyTatva
//
//  Created by Uttam patel on 05/07/23.
//

import Foundation

class SetupProfileVM {
    
    //MARK: - Class Variables
    
    private(set) var isResult = Bindable<Result<String?, AppError>>()
    private(set) var isRChange = Bindable<Int>()
    
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
extension SetupProfileVM {
    private func validateView(name:String, email:String, date:String, isTermSelected: Bool, gender:String, code:String, isCheck: Bool) -> (AppError, Int?)? {
        
        if name.trim().isEmpty {
            return (.validation(type: .enterName), 0)
        } else if email.trim().isEmpty {
            return (.validation(type: .enterEmail), 1)
        } else if !Validation.isValidEmail(testStr: email) {
            return (.validation(type: .enterValidEmail), 1)
        } else if date.trim().isEmpty {
            return (.validation(type: .selectDob), 2)
        } else if gender.isEmpty {
            return (.validation(type: .selectGender), 3)
        } else if !isTermSelected {
            return (.validation(type: .agreeTermsAndCondition), 5)
        } else if !isCheck && !code.trim().isEmpty {
            return (.validation(type: .verifyAccessCode), 6)
        }
        
        return nil
    }
}

//------------------------------------------------------
//MARK: - WS Methods
extension SetupProfileVM {

    func apiRegisterTemp(name:String, email:String, date:String, isTermSelected: Bool, gender:String, code: String, isCheck: Bool) {
        if let error = self.validateView(name: name, email: email, date: date, isTermSelected: isTermSelected, gender: gender, code: code, isCheck: isCheck) {
            self.isResult.value = .failure(error.0)
            self.isRChange.value = error.1
            return
        }
        
        let dob_time = GFunction.shared.convertDateFormate(dt: date,
                                                           inputFormat: appDateFormat,
                                                           outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           status: .NOCONVERSION)
        
        var params                          = [String : Any]()
        params["email"]                     = email
        params["name"]                      = name
        params["dob"]                       = dob_time.0
        params["gender"]                    = gender == "Male" ? "M" : "F"
        params["access_code"]               = code
        
//        if kDoctorAccessCode.trim() != "" && kAccessFrom == .LinkPatient{
//            params["doctor_access_code"]    = kDoctorAccessCode
//        }

        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.register_temp_patient_profile), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:

//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    
                    UserModel.shared.storeUserEntryDetails(withJSON: response.data,false)
                    self.isResult.value = .success(nil)
                    break

                case .emptyData:
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .inactiveAccount:
                    //self.loginResult.value = .failure(.custom(errorDescription: apiData.message))
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
                default:break
                }
                break

            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
//                Alert.shared.showSnackBar(error.localizedDescription)
                break

            }
        }
    }
}
