

import Foundation

class UpdateMedicationPopupVM {
    
    
    //MARK:- Class Variable
    
    private(set) var vmArrResult = Bindable<Result<String?, AppError>>()
    private(set) var vmResult    = Bindable<Result<String?, AppError>>()
    
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [MedicationTodayList]()
    var object                      = MedicationTodayModel()
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension UpdateMedicationPopupVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> MedicationTodayList {
        return self.arrList[index]
    }
    
    func managePagenation(medication_date: String,
                          tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.patientTodaysMedicationListAPI(medication_date: medication_date,
                                                            tblView: tblView,
                                                            withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmArrResult.value = .success(nil)
                            tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func markAllData(){
        self.arrList = self.arrList.filter({ (obj) -> Bool in
            for item in obj.doseTimeSlot {
                item.taken = "Y"
            }
            return true
        })
    }
}

//MARK: ---------------- API CALL ----------------------
extension UpdateMedicationPopupVM {
    
    @objc func apiCallFromStart(medication_date: String,
                                refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.patientTodaysMedicationListAPI(medication_date: medication_date,
                                            tblView: tblView,
                                            withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmArrResult.value = .success(nil)
            tblView.reloadData()
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func patientTodaysMedicationListAPI(medication_date: String,
                                        tblView: UITableView,
                                        withLoader: Bool,
                                        completion: ((Bool) -> Void)?){
        
        /*
         {
         "patient_dose_rel_id": "string",
         "dose_taken": "string"
         }
         */
        
        var params                      = [String : Any]()
        
        let start_dt = GFunction.shared.convertDateFormate(dt: medication_date,
                                                           inputFormat: appDateFormat,
                                                           outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           status: .NOCONVERSION)
        
        params["medication_date"]       = start_dt.0
        //params["page"]                  = self.page
        
        //        params = params.filter({ (obj) -> Bool in
        //            if obj.value as? String != "" {
        //                return true
        //            }
        //            else {
        //                return false
        //            }
        //        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.patient_todays_medication_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [MedicationTodayList]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.object = MedicationTodayModel(fromJson: response.data)
                    
                    //arr = MedicationTodayModel.modelsFromDictionaryArray(array: response.data["medication"].arrayValue)
                    arr.append(contentsOf: self.object.medication)
                    self.arrList.append(contentsOf: arr)
                    tblView.reloadData()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
                        tblView.reloadData()
                        
                        //GFunction.shared.addErrorLabel(view: self.view, errorMessage: response.message)
                        //GFunction.shared.showSnackBar(response.message)
                    }
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
    
    func apiUpdateData(vc: UIViewController,
                       medication_date: String,
                       goalMasterId: String) {
        
        //        // Check validation
        //        if let error = self.isValidView(vc: vc,
        //                                        date: date,
        //                                        time: time,
        //                                        exercise: exercise,
        //                                        exercise_duration: exercise_duration,
        //                                        exerciseListModel: exerciseListModel,
        //                                        goalListModel: goalListModel) {
        //
        //            //Set data for binding
        //            self.vmResult.value = .failure(error)
        //            return
        //        }
        //
        if self.arrList.count > 0 {
            GlobalAPI.shared.update_patient_dosesAPI(arr: self.arrList,
                                                     medication_date: medication_date,
                                                     goalMasterId: goalMasterId) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.vmResult.value = .success(nil)
                    Settings().isHidden(setting: .home_from_react_native) { isFromRN in
                        if isFromRN {
                            RNEventEmitter.emitter.sendEvent(withName: "updatedGoalReadingSuccess", body: [:])
                        }
                    }
                    
                }
            }
        }
        else {
            self.vmResult.value = .success(nil)
        }
        
    }
}



