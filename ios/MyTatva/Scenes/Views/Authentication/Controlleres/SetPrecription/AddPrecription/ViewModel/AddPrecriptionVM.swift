//

//
//

import Foundation

class PrecriptionImageListModel {
    
    var image: UIImage!
    var title: String!
    var date: Date!
    
    init(){}
}

class AddPrecriptionVM {
    
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
extension AddPrecriptionVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(arrPreciption: [DocumentDataModel],
                             arrMedication: [MedicineData]) -> AppError? {
        
        if arrMedication.count == 0 {
            return AppError.validation(type: .selectMedication)
        }
//        else if arrPreciption.count == 0 {
//            return AppError.validation(type: .selectPrescription)
//        }
        
        return nil
    }
}

// MARK: Web Services
extension AddPrecriptionVM {
    
    func apiCall(vc: UIViewController,
                 arrPreciption: [DocumentDataModel],
                 arrMedication: [MedicineData],
                 isEdit: Bool) {
        
        // Check validation
        if let error = self.isValidView(arrPreciption: arrPreciption,
                                        arrMedication: arrMedication) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
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
        var arrStrImage = [[String: Any]]()
        func imageUploadSetup(){
            ApiManager.shared.addLoader()
            let dispatchGroup = DispatchGroup()
            
            for item in arrPreciption {
                //For attach note upload
                dispatchGroup.enter()
                
                if let image = item.image {
                    ImageUpload.shared.uploadImage(true,
                                                   image,
                                                   nil,
                                                   BlobContainer.kAppContainer,
                                                   prefix: .drug) { (str1, str2) in
        //                print(str1)
        //                print(str2)
                        
                        var obj: [String: Any]      = [:]
                        item.documentUrl            = str2 ?? ""
                        //obj["prescription_name"]    = str2 ?? ""
                        
                        arrStrImage.append(obj)
                        dispatchGroup.leave()
                    }
                }
                else {
                    var obj: [String: Any]      = [:]
                    if let val = item.documentUrl.components(separatedBy: "/").last {
                        item.documentUrl = (val.components(separatedBy: "?").first!)
                        //obj["prescription_name"] =
                    }
                    dispatchGroup.leave()
                }
            }
            
           dispatchGroup.notify(queue: .main) {
                //When media images upload done
                ApiManager.shared.removeLoader()
                updateData()
            }
        }
        
        func updateData(){
            
            var params                          = [String : Any]()
            var api_name = ApiEndPoints.patient(.add_prescription)
            if isEdit {
                api_name = ApiEndPoints.patient(.update_prescription)
            }
            
            var arrFinalMedication = [[String: Any]]()
            for item in arrMedication {
                var obj = [String: Any]()
                obj["patient_dose_rel_id"]      = item.patientDoseRelId
                obj["dose_id"]                  = item.doseId
                if item.medecineId.trim() != "" {
                    obj["medecine_id"]          = item.medecineId
                }
                obj["medicine_name"]            = item.medicineName
                obj["start_date"]               = item.startDate
                obj["end_date"]                 = item.endDate
                obj["dose_days"]                = item.doseDays
                obj["dose_time_slot"]           = item.doseTimeSlot
                arrFinalMedication.append(obj)
            }
            
            params["medicine_details"]          = arrFinalMedication
            
            
            var arrFinalDoc = [[String: Any]]()
            for item in arrPreciption {
                var obj = [String: Any]()
                obj["prescription_document_rel_id"] = item.prescriptionDocumentRelId
                obj["prescription_name"]            = item.documentUrl
                arrFinalDoc.append(obj)
            }
            params["document_name"]                 = arrFinalDoc
            
//            if isEdit {
//                
//            }
//            else {
//                params["document_name"]             = arrStrImage
//            }
            
            print(JSON(params))
            
            ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
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
        if arrPreciption.count != 0 {
            imageUploadSetup()
        }
        else {
            updateData()
        }
        
    }
    
    //MARK: ---------------- get_cat_survey API ----------------------
    func get_prescription_detailsAPI(isActiveMedicineOnly: String = "Y",completion: ((Bool, MyPrescriptionDataModel, String) -> Void)?){
        
        /*
         No params
         */
        
        var params: [String:String] = [
            "is_active_medicine_only" : isActiveMedicineOnly
        ]
        
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
        
    }
}
