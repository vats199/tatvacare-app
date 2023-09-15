//

//
//

import Foundation

class ApplyTestCouponVM {
    
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
extension ApplyTestCouponVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(code: UITextField) -> AppError? {
        
        if code.text!.trim() == "" {
            return AppError.validation(type: .enterCouponCode)
        }
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
extension ApplyTestCouponVM {
    
    func apiCall(vc: UIViewController,
                 code: UITextField) {
        
        // Check validation
        if let error = self.isValidView(code: code) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        self.vmResult.value = .success(nil)
        
        /*
         {
         "document_name": [
         {
         "prescription_name": "presciption1.jpg", //uploaded image name to azure
         },
         {
         "prescription_name": "presciption2.jpg", //uploaded image name to azure
         }
         ],
         "medicine_details": [
         {
         "dose_id": "71e737c3-196b-11ec-9978-a87eea410734",
         "medicine_name": "medicine_name",
         "start_date": "2021-01-01",
         "end_date": "2021-12-12",
         "dose_days": "M,T,W,TH,F,S,SU",
         "dose_time_slot": ["10:00","14:00","18:00"]
         }
         ]
         }
         
         */
//        var arrStrImage = [[String: Any]]()
//        func imageUploadSetup(){
//            ApiManager.shared.addLoader()
//            let dispatchGroup = DispatchGroup()
//
//
//
//           dispatchGroup.notify(queue: .main) {
//                //When media images upload done
//                ApiManager.shared.removeLoader()
//                updateData()
//            }
//        }
//
        func updateData(){
            
            var params                          = [String : Any]()
           
//            if isEdit {
//
//            }
//            else {
//                params["document_name"]             = arrStrImage
//            }
            
            print(JSON(params))
            
            ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.add_prescription), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
                switch result {
                
                case .success(let response):
                    
                    switch response.apiCode {
                    case .invalidOrFail:
                        
                        Alert.shared.showSnackBar(response.message)
                        break
                    case .success:
                        
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
        
        //----------------------------------------------
//        if arrPreciption.count != 0 {
//            imageUploadSetup()
//        }
//        else {
//            updateData()
//        }
//
    }
    
    //MARK: ---------------- get_cat_survey API ----------------------
    /*func get_prescription_detailsAPI(completion: ((Bool, MyPrescriptionDataModel, String) -> Void)?){
        
        /*
         No params
         */
        
        let params                  = [String : Any]()
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_prescription_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg = ""
            var obj = MyPrescriptionDataModel()
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
                    obj = MyPrescriptionDataModel(fromJson: response.data)
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
        
    }*/
}
