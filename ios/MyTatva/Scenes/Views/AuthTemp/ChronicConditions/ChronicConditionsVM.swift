//
//  ChronicConditionsVM.swift
//  MyTatva
//
//  Created by 2022M43 on 04/07/23.
//

import Foundation
class ChronicConditionsModel {
    
    var image: UIImage!
    var name: String!
    var isSelected = false

    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
}

enum ChronicConditionsOptions: String {
    case fattyLiver = "Fatty Liver"
    case COPD = "COPD"
    case Asthama = "Asthama"
    case Diabetes = "Diabetes"
    case Other = "Other"
}

class ChronicConditionsVM: NSObject {
    //MARK: Outlet
    
    //MARK: Class Variables
    var arrList                     = [MedicalConditionListModel]()
    private(set) var isConditionChange = Bindable<Bool>()
    private(set) var isResult = Bindable<Result<String?, AppError>>()
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
}

//MARK: - CallMethods
extension ChronicConditionsVM {
    
    func numberOfRows() -> Int { self.arrList.count }
    func listOfRow(_ index: Int) -> MedicalConditionListModel { self.arrList[index] }
    func didSelectect(_ index: Int) {
        self.arrList.forEach({$0.isSelected = false})
        self.arrList[index].isSelected = true
    }
    
}

//MARK: - API - Calling 
extension ChronicConditionsVM {
    
    func ApiConditionList(withLoader: Bool,
                          completion: ((Bool) -> Void)?) {
        
        let params                      = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.medical_condition_group_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [MedicalConditionListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
//                    Alert.shared.showSnackBar(response.message)
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    
                    returnVal = true
                    arr = MedicalConditionListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
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
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                completion?(returnVal)
//                Alert.shared.showSnackBar(error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
    func apiAddDetails(other_condition: String = "",medical_condition_ids: [MedicalConditionListModel]) {
        
        UserModel.shared.retrieveUserData()
        var params                          = [String : Any]()
        params["email"]                     = UserModel.shared.email
        params["languages_id"]              = UserDefaultsConfig.languageId//language_id
        params["name"]                      = UserModel.shared.name
        params["dob"]                       = UserModel.shared.dob
        params["gender"]                    = UserModel.shared.gender
        params["account_role"]              = "P"
        params["active_deactive_id"]        = ""
        //params["is_accept_terms_accept"]    = isTermSelected == true ? "Y" : "N"
        params["whatsapp_optin"]            = "Y"
        params["email_verified"]            = "N"
        
        params["contact_no"]                = UserModel.shared.contactNo
        
        if (UserModel.shared.accessCode ?? "").trim() != "" || (UserModel.shared.doctorAccessCode ?? "").trim() != "" {
            params["doctor_access_code"]        = UserModel.shared.doctorAccessCode
            params["access_code"]               = UserModel.shared.accessCode
            params["access_from"]               = "Doctor"
        }
        
        let arrTemp: [String] = medical_condition_ids.map { (obj) -> String in
            return obj.medicalConditionGroupId
        }
        params["medical_condition_group_id"]     = arrTemp.first!
        params["other_condition"]                = other_condition
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.register), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:

                    //Save data into user model and redirect to home screen.
//                    UserModel.currentUser = response.data
//                    UserDefaultsConfig.accessToken = response.data.accessToken

                    UserModel.shared.storeUserEntryDetails(withJSON: response.data)
                    
                    GlobalAPI.shared.updateDeviceAPI { [weak self] (isDone) in
                        guard let self = self else {return}
                    }
                    
                    //UIApplication.shared.manageLogin()
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
