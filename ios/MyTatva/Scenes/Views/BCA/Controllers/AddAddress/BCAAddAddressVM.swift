//
//  BCAAddAddressVM.swift
//  MyTatva
//
//  Created by Uttam patel on 12/06/23.
//



import Foundation

class BCAAddAddressVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<LabAddressListModel?, AppError>>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension BCAAddAddressVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(name: String,
                             mobile: String,
                             pincode: UITextField,
                             houseNumber: UITextField,
                             street: UITextField,
                             addressType: String) -> AppError? {
        
        /*if name.text!.trim() == "" {
            return AppError.validation(type: .enterName)
        }
        else if !Validation.isAtleastOneAlphabaticString(txt: name.text!) {
            return AppError.validation(type: .enterValidName)
        }
        else if mobile.text!.trim() == "" {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.text!.count < Validations.PhoneNumber.Maximum.rawValue {
            //txtMobile.applyThemeTextfieldBorderView(withError: true)
            return AppError.validation(type: .enterMinMobileNumber)
        }
        else */if pincode.text!.trim() == "" {
            return AppError.validation(type: .enterPincode)
        }
        else if pincode.text!.count < Validations.MaxCharacterLimit.Pincode.rawValue {
            return AppError.validation(type: .enterValidPincode)
        }
        else if houseNumber.text!.trim() == "" {
            return AppError.validation(type: .enterFullAddress)
        }
        else if houseNumber.text!.count < 25 {
            return AppError.validation(type: .enterValidHouseFullAddress)
        }
        else if street.text!.trim() == "" {
            return AppError.validation(type: .enterStreet)
        }
//        else if addressType.text!.trim() == "" {
//            return AppError.validation(type: .PleaseSelect)
//        }
        
        return nil
    }
}

// MARK: Web Services
extension BCAAddAddressVM {
    
    func apiCall(vc: UIViewController,
                 address_id: String,
                 name: String,
                 mobile: String,
                 pincode: UITextField,
                 houseNumber: UITextField,
                 street: UITextField,
                 addressType: String,
                 isEdit: Bool) {
        
        // Check validation
        if let error = self.isValidView(name: name,
                                        mobile: mobile,
                                        pincode: pincode,
                                        houseNumber: houseNumber,
                                        street: street,
                                        addressType: addressType) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        self.pincode_availabilityAPI(pincode: pincode.text!) { [weak self] isDone in
            guard let self = self else {return}
            if isDone {
                var params                      = [String : Any]()
        //
                params["address_id"]            = address_id
                params["name"]                  = name
                params["pincode"]               = pincode.text!
                params["contact_no"]            = mobile
                params["address_type"]          = addressType
                params["address"]               = houseNumber.text!
                params["street"]                = street.text!
                
                params = params.filter({ (obj) -> Bool in
                    if obj.value as? String != "" {
                        return true
                    }
                    else {
                        return false
                    }
                })
                
                ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.update_address), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

                    switch result {
                    case .success(let response):

                        switch response.apiCode {
                        case .invalidOrFail:
                            Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                            break
                        case .success:

                            self.vmResult.value = .success(LabAddressListModel(fromJson: response.data))
                            Alert.shared.showSnackBar(response.message, isBCP: true)
                            
                            if isEdit {
                                var params1 = [String: Any]()
                                params1[AnalyticsParameters.address_id.rawValue]  = address_id
                                FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_UPDATED,
                                                         screen: .AddAddress,
                                                         parameter: params1)
                            }
                            else {
                                //var params1 = [String: Any]()
                                //params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
                                FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_ADDED,
                                                         screen: .AddAddress,
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
    }
    
    //MARK: ---------------- pincode_availability API ----------------------
    func pincode_availabilityAPI(pincode: String,
                                 completion: ((Bool) -> Void)?){
        //email
        
        var params              = [String : Any]()
        params["Pincode"]       = pincode
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.pincode_availability), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
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
}

