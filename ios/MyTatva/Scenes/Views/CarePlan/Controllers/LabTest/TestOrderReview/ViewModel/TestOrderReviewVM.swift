//

//
//

import Foundation

class TestOrderReviewVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var order_master_id = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension TestOrderReviewVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(name: UITextField,
                             mobile: UITextField,
                             pincode: UITextField,
                             houseNumber: UITextField,
                             street: UITextField,
                             addressType: String) -> AppError? {
        
        if name.text!.trim() == "" {
            return AppError.validation(type: .enterName)
        }
        else if mobile.text!.trim() == "" {
            return AppError.validation(type: .enterMobileNumber)
        }
        else if mobile.text!.count < Validations.PhoneNumber.Maximum.rawValue {
            //txtMobile.applyThemeTextfieldBorderView(withError: true)
            return AppError.validation(type: .enterMinMobileNumber)
        }
        else if pincode.text!.trim() == "" {
            return AppError.validation(type: .enterPincode)
        }
        else if pincode.text!.count < Validations.MaxCharacterLimit.Pincode.rawValue {
            return AppError.validation(type: .enterValidPincode)
        }
        else if houseNumber.text!.trim() == "" {
            return AppError.validation(type: .enterHouseNumber)
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
extension TestOrderReviewVM {
    
    //MARK: ---------------- check_book_test API ----------------------
    func check_book_testAPI(final_payable_amount: String,
                            completion: ((Bool, String) -> Void)?){
        
        var params                          = [String : Any]()
        params["final_payable_amount"]      = final_payable_amount
        
        if NetworkManager.environment == .local || NetworkManager.environment == .uat {
            params["dev"]                   = true
        }
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.check_book_test), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var order_id = ""
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    returnVal = true
                    order_id = response.data.stringValue
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
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
                
                completion?(returnVal, order_id)
                break
            case .failure(let error):
                //print(error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
    func apiCall(vc: UIViewController,
                 appointment_date: String,
                 slot_time: String,
                 address_id: String,
                 member_id: String? = nil,
                 transaction_id: String,
                 order_total: String,
                 payable_amount: String,
                 final_payable_amount: String,
                 home_collection_charge: String,
                 service_charge: String,
                 bcp_flag:String? = nil,
                 bcp_test_price_data:[String:Any]? = nil,
                 patient_plan_rel_id:String? = nil) {
        
        // Check validation
        //        if let error = self.isValidView(name: name,
        //                                        mobile: mobile,
        //                                        pincode: pincode,
        //                                        houseNumber: houseNumber,
        //                                        street: street,
        //                                        addressType: addressType) {
        //
        //            //Set data for binding
        //            self.vmResult.value = .failure(error)
        //            return
        //        }
        
        /*
         {
           "appointment_date_time": "2022-04-04 11:30",
           "slot_time": "11:30 - 12:00",
           "address_id": "string",
           "member_id": "string",
           "transaction_id": "string",
           "order_total": 0,
           "payable_amount": 0,
           "final_payable_amount": 0,
           "home_collection_charge": 0
         }
         */
        
        var params                          = [String : Any]()
        //
        params["appointment_date"]          = appointment_date
//        params["appointment_date_time"]     = "2022-04-04 11:30"
        params["slot_time"]                 = slot_time
        params["address_id"]                = address_id
        params["transaction_id"]            = transaction_id
        params["order_total"]               = order_total
        params["payable_amount"]            = payable_amount
        params["final_payable_amount"]      = final_payable_amount
        params["home_collection_charge"]    = home_collection_charge
        params["service_charge"]            = service_charge
        params["discount_amount"]           = "\(kCouponCodeAmount)"
        params["discounts_master_id"]       = kDiscountMasterId
        params["discount_type"]             = kDiscountType
        
        if let member_id = member_id {
            params["member_id"]              = member_id
        }
        
        if let bcp_flag = bcp_flag {
            params["bcp_flag"]              = bcp_flag
        }
        
        if let bcp_test_price_data = bcp_test_price_data {
            params["bcp_test_price_data"] = bcp_test_price_data
        }
        
        if let patient_plan_rel_id = patient_plan_rel_id {
            params["patient_plan_rel_id"] = patient_plan_rel_id
        }
                
        if NetworkManager.environment == .local || NetworkManager.environment == .uat {
            params["dev"]                   = true
        }
        
        /*params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })*/
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.book_test), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    kCouponCodeAmount = 0
                    kDiscountMasterId = ""
                    kDiscountType     = ""
                    kApplyCouponName  = ""
                    kDiscountData     = nil
                    self.order_master_id = response.data["order_master_id"].stringValue
                    self.vmResult.value = .success(nil)
                    Alert.shared.showSnackBar(response.message, isBCP: true)
                    break
                    
                case .emptyData:
                    
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .inactiveAccount:
                    
                    //self.loginResult.value = .failure(.custom(errorDescription: apiData.message))
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
                default:break
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
        
    }
    
}
