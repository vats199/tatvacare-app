
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class SetGoalsVM {

    
    //MARK:- Class Variable
    
    private(set) var vmArrayResult = Bindable<Result<String?, AppError>>()
    private(set) var vmSubmitResult = Bindable<Result<String?, AppError>>()
    
    var pageGoal                        = 1
    var isNextPageGoal                  = true
    var arrGoalList                     = [GoalListModel]()
    
    
    var pageReading                     = 1
    var isNextPageReading               = true
    var arrReadingList                  = [ReadingListModel]()
    
    var strErrorGoalMessage : String    = ""
    var strErrorReadingMessage : String = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension SetGoalsVM {
    
    func getGoalCount() -> Int {
        return self.arrGoalList.count
    }
    
    func getReadingCount() -> Int {
        return self.arrReadingList.count
    }
    
    func getGoalObject(index: Int) -> GoalListModel {
        return self.arrGoalList[index]
    }
    
    func getReadingObject(index: Int) -> ReadingListModel {
        return self.arrReadingList[index]
    }
    
    func manageGoalPagenation(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrGoalList.count - 1 {
                if self.isNextPageGoal {
                    self.pageGoal += 1
                    
                    if self.arrGoalList.count > 0 {
                        
                        self.goalListAPI(tblView: tblView,
                                         withLoader: false) { [weak self]  (isDone) in
                            guard let self = self else {return}
                            self.vmArrayResult.value = .success(nil)
                            tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func manageReadingPagenation(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrReadingList.count - 1 {
                if self.isNextPageReading {
                    self.pageReading += 1
                    
                    if self.arrReadingList.count > 0 {
                        
                        self.readingListAPI(tblView: tblView,
                                            withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmArrayResult.value = .success(nil)
                            tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- API CALL for goals ----------------------
extension SetGoalsVM {
    
    @objc func apiCallFromStart_goal(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView,
                                withLoader: Bool = false) {
        
        
        
        self.arrGoalList.removeAll()
        tblView.reloadData()
        self.pageGoal               = 1
        self.isNextPageGoal         = true
        
        //API Call
        self.goalListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmArrayResult.value = .success(nil)
            if isLoaded {
                tblView.reloadData()
            }
            else {
                tblView.reloadData()
            }
        }
    }
    
    
    func goalListAPI(tblView: UITableView,
                             withLoader: Bool,
                             completion: ((Bool) -> Void)?){
        
        
        let params                      = [String : Any]()
        //params["page"]                  = self.pageGoal
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.medial_condition_goal_patient_rel_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [GoalListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = GoalListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrGoalList.append(contentsOf: arr)
                    tblView.reloadData()
                
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageGoal = false
                    
                    if self.pageGoal <= 1 {
                        self.strErrorGoalMessage = response.message
                        self.arrGoalList.removeAll()
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
}

//MARK: ---------------- API CALL for readings ----------------------
extension SetGoalsVM {
    
    @objc func apiCallFromStart_reading(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView,
                                withLoader: Bool = false) {
        
        
        
        self.arrReadingList.removeAll()
        tblView.reloadData()
        self.pageReading            = 1
        self.isNextPageReading      = true
        
        //API Call
        self.readingListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmArrayResult.value = .success(nil)
            if isLoaded {
                tblView.reloadData()
            }
            else {
                tblView.reloadData()
            }
        }
    }
    
    
    func readingListAPI(tblView: UITableView,
                             withLoader: Bool,
                             completion: ((Bool) -> Void)?){
        
        
        let params                      = [String : Any]()
        //params["page"]                  = self.pageReading
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.medical_condition_reading_patient_rel_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [ReadingListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = ReadingListModel.modelsFromDictionaryArray(array: response.data.arrayValue).filter({ !(ReadingType(rawValue: $0.keys)?.isSprirometerVital ?? false) })
                    self.arrReadingList.append(contentsOf: arr)
                    tblView.reloadData()
                
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageReading = false
                    
                    if self.pageReading <= 1 {
                        self.strErrorReadingMessage = response.message
                        self.arrReadingList.removeAll()
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
}

// MARK: Validation Methods
extension SetGoalsVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(arrReading: [ReadingListModel],
                             arrGoal: [GoalListModel]) -> AppError? {
        
        if arrGoal.count == 0 {
            return AppError.validation(type: .selectGoal)
        }
        else if arrReading.count == 0 {
            return AppError.validation(type: .selectReading)
            
        }
        
        return nil
    }
}


//MARK: ---------------- API CALL to Save Reading Goal ----------------------
extension SetGoalsVM {
    
    func apiAddReadingGoalCall(vc: UIViewController,
                 arrReading: [ReadingListModel],
                 arrGoal: [GoalListModel]) {
        
        // Check validation
        if let error = self.isValidView(arrReading: arrReading,
                                        arrGoal: arrGoal) {
            
            //Set data for binding
            self.vmSubmitResult.value = .failure(error)
            return
        }
        
        /*
         {"readings":[{"reading_id":"de3dcfe5-1a17-11ec-a706-a87eea410734","reading_datetime":"2021-09-22 15:15:15","reading_value":"100"}],
         "goals":[{"goal_id":"a99daf7a-1a16-11ec-a706-a87eea410734","goal_value":"100","start_date":"2021-09-22","end_date":"2021-09-22"}]}
         
         */
       
        var arrFinalGoal = [[String: Any]]()
        for item in arrGoal {
            var obj = [String: Any]()
            obj["goal_id"]                  = item.goalMasterId
            obj["mandatory"]                = item.mandatory
//            obj["start_date"]               = "2021-09-22"
//            obj["end_date"]                 = "2021-09-22"
            obj["goal_value"]               = item.goalValue
            
            var params              = [String: Any]()
            params[AnalyticsParameters.goal_id.rawValue]        = item.goalMasterId
            params[AnalyticsParameters.goal_name.rawValue]      = item.goalName
            params[AnalyticsParameters.goal_value.rawValue]     = item.goalValue
            FIRAnalytics.FIRLogEvent(eventName: .GOAL_TARGET_VALUE_UPDATED,
                                     screen: .SetUpGoalsReadings,
                                     parameter: params)
            
            arrFinalGoal.append(obj)
        }
        
        var arrFinalReading = [[String: Any]]()
        for item in arrReading {
            var obj = [String: Any]()
            obj["reading_id"]               = item.readingsMasterId
            obj["mandatory"]                = item.mandatory
//            obj["reading_datetime"]         = "2021-09-22 15:15:15"
//            obj["reading_value"]            = "100"
            arrFinalReading.append(obj)
        }
        
        var params                          = [String : Any]()
        params["readings"]                  = arrFinalReading
        params["goals"]                     = arrFinalGoal
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.add_reading_goal), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    self.vmSubmitResult.value = .success(nil)
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
