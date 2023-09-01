//
//  AddWeightHeightVM.swift
//  MyTatva
//
//  Created by on 10/11/21.
//

import Foundation

class AddWeightHeightVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [WeightMonthsModel]()
    var strErrorMessage             = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension AddWeightHeightVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(heightUnit: String,
                             weightUnit: String,
                             heightCm: String,
                             heightFt: String? = "",
                             heightIn: String? = "",
                             weightKg: String,
                             weightLbs: String? = "",
                             setWeightKg: String,
                             setWeightLbs: String? = "",
                             setWeightDays: String) -> AppError? {
        
        let heightUnitVal   = HeightUnit.init(rawValue: heightUnit) ?? .cm
        let weightUnitVal   = WeightUnit.init(rawValue: weightUnit) ?? .kg
        
        if heightCm.trim() == "" && heightFt!.trim() == ""{
            return AppError.validation(type: .enterHeight)
        }
        switch heightUnitVal {
            
        case .cm:
            if JSON(heightCm).intValue > kMaxHeightCm || JSON(heightCm).intValue < kMinHeightCm{
                return AppError.validation(type: .enterValidHeightCm)
            }
            break
        case .feet_inch:
            if (JSON(heightFt!).intValue >= kMaxHeightFt && JSON(heightIn!).intValue > 0)
                || JSON(heightFt!).intValue < kMinHeightFt{
                return AppError.validation(type: .enterValidHeightFt)
            }
            else if heightIn!.trim() == ""{
                return AppError.validation(type: .enterHeight)
            }
            break
        }
        
        if weightKg.trim() == ""{
            return AppError.validation(type: .enterWeight)
        }
        
        switch weightUnitVal {
        case .kg:
            if JSON(weightKg).doubleValue > JSON(kMaxBodyWeightKg).doubleValue ||
                        JSON(weightKg).doubleValue < JSON(kMinBodyWeightKg).doubleValue {
                return AppError.validation(type: .enterValidWeightKg)
            }
            break
        case .lbs:
            if JSON(weightLbs!).doubleValue > JSON(kMaxBodyWeightLbs).doubleValue ||
                        JSON(weightLbs!).doubleValue < JSON(kMinBodyWeightLbs).doubleValue {
                return AppError.validation(type: .enterValidWeightLbs)
            }
            break
        }
        
        if setWeightKg.trim() == ""{
            return AppError.validation(type: .enterSetWeight)
        }
        
        switch weightUnitVal {
        case .kg:
            if JSON(setWeightKg).doubleValue > JSON(kMaxBodyWeightKg).doubleValue ||
                        JSON(setWeightKg).doubleValue < JSON(kMinBodyWeightKg).doubleValue {
                return AppError.validation(type: .enterValidSetWeightKg)
            }
            break
        case .lbs:
            if JSON(setWeightLbs!).doubleValue > JSON(kMaxBodyWeightLbs).doubleValue ||
                        JSON(setWeightLbs!).doubleValue < JSON(kMinBodyWeightLbs).doubleValue {
                return AppError.validation(type: .enterValidSetWeightLbs)
            }
            break
        }
        if setWeightDays.trim() == ""{
            return AppError.validation(type: .selectSetWeightDays)
        }
        return nil
    }
}

//MARK: ---------------- Update Months Data ----------------------
extension AddWeightHeightVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> WeightMonthsModel {
        return self.arrList[index]
    }
}
// MARK: Web Services
extension AddWeightHeightVM {
    
    func apiCall(vc: UIViewController,
                 heightUnit: String,
                 weightUnit: String,
                 heightCm: String,
                 heightFt: String? = "",
                 heightIn: String? = "",
                 weightKg: String,
                 weightLbs: String? = "",
                 setWeightKg: String,
                 setWeightLbs: String? = "",
                 setWeightDays: String,
                 activity_level: String,
                 weightMonthsModel: WeightMonthsModel) {
        
        // Check validation
        if let error = self.isValidView(heightUnit: heightUnit,
                                        weightUnit: weightUnit,
                                        heightCm: heightCm,
                                        heightFt: heightFt,
                                        heightIn: heightIn,
                                        weightKg: weightKg,
                                        weightLbs: weightLbs,
                                        setWeightKg: setWeightKg,
                                        setWeightLbs: setWeightLbs,
                                        setWeightDays: setWeightDays) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        self.updateHeightWeightAPI(withLoader: true,
                                   height: heightCm,
                                   weight: weightKg,
                                   setWeight: setWeightKg,
                                   setWeightDays: setWeightDays,
                                   activity_level: activity_level,
                                   weightMonthsModel: weightMonthsModel,
                                   weight_unit: weightUnit,
                                   height_unit: heightUnit) { [weak self]  (isDone) in
            guard let self = self else {return}
            
            if isDone{
                
                self.calculate_bmr_caloriesAPI(withLoader: true,
                                               height: heightCm,
                                               current_weight: weightKg,
                                               goal_weight: setWeightKg,
                                               activity_level: activity_level,
                                               weightMonthsModel: weightMonthsModel,
                                               weight_unit: weightUnit,
                                               height_unit: heightUnit) { [weak self]  isDone in
                    guard let self = self else {return}
                    if isDone {
                        self.vmResult.value = .success(nil)
                    }
                }
            }
        }
    }
    
    //MARK: ---------------- API CALL FOR updateHeightWeight ----------------------
    func updateHeightWeightAPI(withLoader: Bool,
                               height: String,
                               weight: String,
                               setWeight: String,
                               setWeightDays: String,
                               activity_level: String,
                               weightMonthsModel: WeightMonthsModel,
                               weight_unit: String,
                               height_unit: String,
                               completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["weight"]        = weight
        params["height"]        = height
        params["weight_unit"]   = weight_unit
        params["height_unit"]   = height_unit
        
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.update_height_weight), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
//                    Alert.shared.showSnackBar(response.message)
                  //  self.arrNotification.removeAll()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.strErrorMessage = response.message
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
    
    //MARK: ---------------- API CALL FOR calculate_bmr_months ----------------------
    func calculate_bmr_monthsAPI(withLoader: Bool,
                                 height: String,
                                 current_weight: String,
                                 goal_weight: String,
                                 completion: ((Bool) -> Void)?){
        
        /*
         {
           "current_weight": 0,
           "height": 0,
           "goal_weight": 0
         }
         */
        
        var params                  = [String : Any]()
        params["current_weight"]    = current_weight
        params["height"]            = height
        params["goal_weight"]       = goal_weight
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.calculate_bmr_months), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [WeightMonthsModel]()
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = WeightMonthsModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList = arr
                    //Alert.shared.showSnackBar(response.message)
                    
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    //self.strErrorMessage = response.message
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
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK: ---------------- API CALL FOR calculate_bmr_calories ----------------------
    func calculate_bmr_caloriesAPI(withLoader: Bool,
                                   height: String,
                                   current_weight: String,
                                   goal_weight: String,
                                   activity_level: String,
                                   weightMonthsModel: WeightMonthsModel,
                                   weight_unit: String,
                                   height_unit: String,
                                   completion: ((Bool) -> Void)?){
        
        /*
         {
           "current_weight": 0,
           "height": 0,
           "goal_weight": 0,
           "rate": "string",
           "type": "string",
           "months": "string",
           "activity_level": "S"
         weight_unit
         height_unit
         }
         */
        
        var params                  = [String : Any]()
        params["current_weight"]    = current_weight
        params["height"]            = height
        params["goal_weight"]       = goal_weight
        params["rate"]              = weightMonthsModel.rate
        params["type"]              = weightMonthsModel.type
        params["months"]            = weightMonthsModel.months
        params["activity_level"]    = activity_level
        params["weight_unit"]       = weight_unit
        params["height_unit"]       = height_unit
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.calculate_bmr_calories), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [WeightMonthsModel]()
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = WeightMonthsModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList = arr
                    //Alert.shared.showSnackBar(response.message)
                    
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    //self.strErrorMessage = response.message
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
    
    //MARK: ---------------- API CALL FOR check_bmr_disclaimer ----------------------
    func check_bmr_disclaimerAPI(withLoader: Bool,
                                 height: String,
                                 current_weight: String,
                                 goal_weight: String,
                                 activity_level: String,
                                 weightMonthsModel: WeightMonthsModel,
                                 completion: ((Bool, String, String) -> Void)?){
        
        /*
         {
           "current_weight": 0,
           "height": 0,
           "goal_weight": 0,
           "rate": "string",
           "type": "string",
           "months": "string",
           "activity_level": "S"
         }
         
         */
        
        var params                  = [String : Any]()
        params["current_weight"]    = current_weight
        params["height"]            = height
        params["goal_weight"]       = goal_weight
        params["rate"]              = weightMonthsModel.rate
        params["type"]              = weightMonthsModel.type
        params["months"]            = weightMonthsModel.months
        params["activity_level"]    = activity_level
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.check_bmr_disclaimer), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var bmiDisclaimer       = ""
                var caloriesDisclaimer  = ""
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal           = true
                    bmiDisclaimer       = response.data["bmi"].stringValue
                    caloriesDisclaimer  = response.data["calories"].stringValue
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    
                    returnVal = true
                    //self.strErrorMessage = response.message
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
                
                completion?(returnVal, bmiDisclaimer, caloriesDisclaimer)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

