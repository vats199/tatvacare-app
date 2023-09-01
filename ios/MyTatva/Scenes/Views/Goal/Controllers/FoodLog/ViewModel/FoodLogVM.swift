

//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class FoodLogVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult                   = Bindable<Result<String?, AppError>>()
    private(set) var vmResultMealType           = Bindable<Result<String?, AppError>>()
    private(set) var vmResultSearch             = Bindable<Result<String?, AppError>>()
    private(set) var vmResultFrequent           = Bindable<Result<String?, AppError>>()
    private(set) var vmResultMyFood             = Bindable<Result<String?, AppError>>()
    
    var pageMealType                            = 1
    var isNextPageMealType                      = true
    var arrListMealType                         = [MealTypeListModel]()
    var strErrorMessageMealType : String        = ""
    
    var pageSearchFood                          = 1
    var isNextPageSearchFood                    = true
    var arrSearchFood                           = [FoodSearchListModel]()
    var strErrorMessageNoSearch: String         = ""
    
    var pageFrequentFood                        = 1
    var isNextPageFrequentFood                  = true
    var arrFrequentFood                         = [FoodSearchListModel]()
    var strErrorMessageFrequentFood: String     = ""
    
    var pageMyFood                              = 1
    var isNextPageMyFood                        = true
    var arrMyFood                               = [FoodSearchListModel]()
    var arrMyFoodImages                         = [FoodImageModel]()
    var strErrorMessageMyFood: String           = ""
    
    var objcFoodLogAnalysis                     = FoodLogAnalysisModel()
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update MealType Data ----------------------
extension FoodLogVM {
    
    func getCountMealType() -> Int {
        return self.arrListMealType.count
    }
    
    func getObjectMealType(index: Int) -> MealTypeListModel {
        return self.arrListMealType[index]
    }
    
    func manageSelectionMealType(index: Int) {
//       let object = self.arrListTopicList[index]
//
//        for item in self.arrListTopicList {
//            if item.topicMasterId == object.topicMasterId {
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update Search food Data ----------------------
extension FoodLogVM {
    
    func getCountSeachList() -> Int {
        return self.arrSearchFood.count
    }
    
    func getObjectSeachList(index: Int) -> FoodSearchListModel {
        return self.arrSearchFood[index]
    }
    
    func manageSelectionSeachList(index: Int) {
//       let object = self.arrListTopicList[index]
//
//        for item in self.arrListTopicList {
//            if item.topicMasterId == object.topicMasterId {
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
    
    func managePagenationSeachList(tblView: UITableView? = nil,
                                     withLoader: Bool = false,
                                     food_name: String,
                                     index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrSearchFood.count - 1 {
                if self.isNextPageSearchFood {
                    self.pageSearchFood += 1
                    
                    if self.arrSearchFood.count > 0 {
                        
                        self.search_foodListAPI(tblView: tblView,
                                            withLoader: withLoader,
                                            food_name: food_name) { (isLoaded) in
                            
                            
                            self.vmResultSearch.value = .success(nil)
                            tblView?.reloadData()
                            if isLoaded {
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update Frequent food Data ----------------------
extension FoodLogVM {
    
    func getCountFrequentFood() -> Int {
        return self.arrFrequentFood.count
    }
    
    func getObjectFrequentFood(index: Int) -> FoodSearchListModel {
        return self.arrFrequentFood[index]
    }
    
    func manageSelectionFrequentFood(index: Int) {
//       let object = self.arrListTopicList[index]
//
//        for item in self.arrListTopicList {
//            if item.topicMasterId == object.topicMasterId {
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
    
    func managePagenationFrequentFood(tblView: UITableView? = nil,
                                     withLoader: Bool = false,
                                     index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrFrequentFood.count - 1 {
                if self.isNextPageFrequentFood {
                    self.pageFrequentFood += 1
                    
                    if self.arrFrequentFood.count > 0 {
                        
                        self.frequently_added_foodAPI(tblView: tblView,
                                            withLoader: withLoader) { (isLoaded) in
                            
                            
                            self.vmResultFrequent.value = .success(nil)
                            tblView?.reloadData()
                            if isLoaded {
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update My food Data ----------------------
extension FoodLogVM {
    
    func getCountMyFood() -> Int {
        return self.arrMyFood.count
    }
    
    func getObjectMyFood(index: Int) -> FoodSearchListModel {
        return self.arrMyFood[index]
    }
    
    func manageSelectionMyFood(index: Int) {
//       let object = self.arrListTopicList[index]
//
//        for item in self.arrListTopicList {
//            if item.topicMasterId == object.topicMasterId {
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
    
    func managePagenationMyFood(tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                patient_meal_rel_id: String,
                                index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrMyFood.count - 1 {
                if self.isNextPageMyFood {
                    self.pageMyFood += 1
                    
                    if self.arrMyFood.count > 0 {
                        
                        self.my_added_foodAPI(tblView: tblView,
                                              withLoader: withLoader, patient_meal_rel_id: patient_meal_rel_id) { (isLoaded) in
                            
                            
                            self.vmResultMyFood.value = .success(nil)
                            tblView?.reloadData()
                            if isLoaded {
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- Enage Content List API ----------------------
extension FoodLogVM {
    
    @objc func apiCallFromStart_mealTypeList(pickerView: UIPickerView? = nil,
                                             withLoader: Bool = false) {
        
        self.pageMealType                = 1
        self.isNextPageMealType          = true
        self.strErrorMessageMealType     = ""
        self.arrListMealType.removeAll()
        pickerView?.reloadAllComponents()
        
        //API Call
        self.mealTypeListAPI(pickerView: pickerView,
                            withLoader: withLoader) { (isLoaded) in
            
            
            self.vmResultMealType.value = .success(nil)
            pickerView?.reloadAllComponents()
            if isLoaded {
            }
        }
    }
    
    
    func mealTypeListAPI(pickerView: UIPickerView? = nil,
                        withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        /*
       
       }
         */
        
        let params                      = [String : Any]()
        //params["page"]                  = self.pageMealType
       
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.meal_types), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [MealTypeListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageMealType <= 1 {
                        //self.arrListContentList.removeAll()
                    }
                    
                    arr = MealTypeListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrListMealType.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageMealType = false
                    
                    if self.pageMealType <= 1 {
                        self.strErrorMessageMealType = response.message
                        self.arrListMealType.removeAll()
                        
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
                
                self.strErrorMessageMealType = error.localizedDescription
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
}

//MARK: ---------------- Food search List API ----------------------
extension FoodLogVM {
    
    @objc func apiCallFromStart_search_food(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                food_name: String) {
        
        self.pageSearchFood                 = 1
        self.isNextPageSearchFood           = true
        self.strErrorMessageNoSearch        = ""
        
        //API Call
        self.search_foodListAPI(tblView: tblView,
                            withLoader: withLoader,
                            food_name: food_name) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultSearch.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func search_foodListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        food_name: String,
                        completion: ((Bool) -> Void)?){
        
        /*
         
         food_name
       }
         */
        
        var params                      = [String : Any]()
        params["food_name"]             = food_name
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.search_food), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [FoodSearchListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageNoSearch = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    var param = [String : Any]()
                    param[AnalyticsParameters.food_name.rawValue] = food_name
                    FIRAnalytics.FIRLogEvent(eventName: .USER_SEARCHED_FOOD_DISH,
                                             screen: .SearchFood,
                                             parameter: param)
                    
                    returnVal = true
                    if self.pageSearchFood <= 1 {
                        //self.arrListContentList.removeAll()
                    }
                    
                    self.arrSearchFood.removeAll()
                    tblView?.reloadData()
                    arr = FoodSearchListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrSearchFood.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageSearchFood = false
                    
                    if self.pageSearchFood <= 1 {
                        self.strErrorMessageNoSearch = response.message
                        self.arrSearchFood.removeAll()
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
                
                self.strErrorMessageNoSearch = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- frequently added food List API ----------------------
extension FoodLogVM {
    
    @objc func apiCallFromStart_frequently_added_food(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        self.pageFrequentFood                 = 1
        self.isNextPageFrequentFood           = true
        self.strErrorMessageFrequentFood      = ""
        self.arrFrequentFood.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.frequently_added_foodAPI(tblView: tblView,
                            withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultFrequent.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func frequently_added_foodAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        /*
         
       }
         */
        
        let params                      = [String : Any]()
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.frequently_added_food), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [FoodSearchListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageFrequentFood = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageMealType <= 1 {
                        //self.arrListContentList.removeAll()
                    }
                    
                    arr = FoodSearchListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrFrequentFood.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageFrequentFood = false
                    
                    if self.pageFrequentFood <= 1 {
                        self.strErrorMessageFrequentFood = response.message
                        self.arrFrequentFood.removeAll()
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
                
                self.strErrorMessageFrequentFood = error.localizedDescription
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- Already added food List API ----------------------
extension FoodLogVM {
    
    @objc func apiCallFromStart_my_added_food(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                patient_meal_rel_id: String,
                                withLoader: Bool = false) {
        
        self.pageMyFood                 = 1
        self.isNextPageMyFood           = true
        self.strErrorMessageMyFood      = ""
        self.arrMyFood.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.my_added_foodAPI(tblView: tblView,
                              withLoader: withLoader,
                              patient_meal_rel_id: patient_meal_rel_id) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultMyFood.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func my_added_foodAPI(tblView: UITableView? = nil,
                          withLoader: Bool,
                          patient_meal_rel_id: String,
                          completion: ((Bool) -> Void)?){
        
        /*
         {
           "patient_meal_rel_id": "string"
         }
         */
        
        var params                      = [String : Any]()
        params["patient_meal_rel_id"]   = patient_meal_rel_id
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.patient_meal_rel_by_id), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [FoodSearchListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageMyFood = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageMyFood <= 1 {
                        //self.arrListContentList.removeAll()
                    }
                    
                    arr = FoodSearchListModel.modelsFromDictionaryArray(array: response.data["food_data"].arrayValue)
                    self.arrMyFood.append(contentsOf: arr)
                    
                    self.arrMyFoodImages = FoodImageModel.modelsFromDictionaryArray(array: response.data["image_data"].arrayValue)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageMyFood = false
                    
                    if self.pageMyFood <= 1 {
                        self.strErrorMessageMyFood = response.message
                        self.arrMyFood.removeAll()
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
                
                self.strErrorMessageMyFood = error.localizedDescription
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

// MARK: Validation Methods
extension FoodLogVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(txtSelectFoodType: UITextField,
                             txtDate: UITextField,
                             arrImg: [FoodImageModel],
                             arrMyFood: [FoodSearchListModel]) -> AppError? {
        if txtDate.text!.trim() == "" {
            return AppError.validation(type: .selectDate)
        }
        else if txtSelectFoodType.text!.trim() == "" {
            return AppError.validation(type: .selectFoodType)
        }
//        else if arrImg.count == 0 {
//            return AppError.validation(type: .enterMobileNumber)
//        }
        else if arrMyFood.count == 0 {
            return AppError.validation(type: .addFood)
        }
         
        for food in arrMyFood {
            let calories        = food.energyKcal.components(separatedBy: " ").first!
            let caloriesDouble  = (Double(calories) ?? 0) * (Double(food.quantity) ?? 0)
            
            if food.energyKcal == "" {
                return AppError.validation(type: .addCal)
            }
            else if Int(caloriesDouble) > kMaxFoodCalorie {
                return AppError.validation(type: .addValidCal)
            }
        }
        return nil
    }
}

// MARK: Web Services
extension FoodLogVM {
    
    func apiFoodLog(vc: UIViewController,
                    isAdd: Bool,
                    txtDate : UITextField,
                    txtSelectFoodType: UITextField,
                    arrImg: [FoodImageModel],
                    selectedMealType: MealTypeListModel,
                    arrMyFood: [FoodSearchListModel],
                    patient_meal_rel_id: String? = "") {
        
        // Check validation
        if isAdd {
            if let error = self.isValidView(txtSelectFoodType: txtSelectFoodType,
                                            txtDate: txtDate,
                                            arrImg: arrImg,
                                            arrMyFood: arrMyFood) {
                //Set data for binding
                self.vmResult.value = .failure(error)
                return
            }
        }
        
        var arrImages = [String]()
        //MARK: ---------------- Food Log API ----------------------
        func updateData(){
            /*
             {
             meal_types_id*    string
             meal_data*    string
             [{food_item_id:8,quantity:5,unit_name:number,calories:370.083333333}]
             Send total calories means percalory * total quantity
             
             meal_images    string
             Send image name like ['image1.jpg','image2.jpg']
             
             }
             */
            var arrMeal = [[String: Any]]()
            for item in arrMyFood {
                var obj                 = [String: Any]()
                obj["food_item_id"]     = item.foodItemId == "0" ? item.foodName : item.foodItemId
                obj["food_name"]        = item.foodName
                obj["quantity"]         = item.quantity
                obj["unit_name"]        = item.unitName
                
                let cal: Double         = Double(item.energyKcal.components(separatedBy: " ").first ?? "") ?? 0
                let tota_cal            = cal * (Double(item.quantity) ?? 0)
                obj["calories"]         = tota_cal
                
                arrMeal.append(obj)
            }
            
            var params                      = [String : Any]()
            params["meal_types_id"]         = selectedMealType.mealTypesId
            params["meal_data"]             = arrMeal
            params["meal_images"]           = arrImages
            params["meal_date"]             = txtDate.text!.changeDateFormat(from: .default(format: .ddmmyyyy), to: .default(format: .yyyymmdd), type: .noconversion) ?? Date().toString(style: .short)
            
            var api_name = ApiEndPoints.goalReading(.add_meal)
            if patient_meal_rel_id?.trim() != "" {
                
                params["patient_meal_rel_id"]   = patient_meal_rel_id
                api_name = ApiEndPoints.goalReading(.edit_meal)
            }
            
            params = params.filter({ (obj) -> Bool in
                if obj.value as? String != "" {
                    return true
                }
                else {
                    return false
                }
            })
            
            ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
                switch result {
                case .success(let response):
                    
                    switch response.apiCode {
                    case .invalidOrFail:
                        
                        Alert.shared.showSnackBar(response.message)
                        break
                    case .success:
                        if patient_meal_rel_id?.trim() == ""{
                            var param = [String  : Any]()
                            param[AnalyticsParameters.meal_types_id.rawValue] = selectedMealType.mealTypesId
                            FIRAnalytics.FIRLogEvent(eventName: .USER_LOGGED_MEAL,
                                                     screen: .LogFood,
                                                     parameter: param)
                        }

                        self.objcFoodLogAnalysis = FoodLogAnalysisModel(fromJson: response.data)
                        
                        if self.objcFoodLogAnalysis.todaysAchievedValue >= self.objcFoodLogAnalysis.targetValue {
                            var params              = [String: Any]()
                            params[AnalyticsParameters.goal_id.rawValue]        = self.objcFoodLogAnalysis.goalMasterId
                            params[AnalyticsParameters.goal_value.rawValue]     = self.objcFoodLogAnalysis.targetValue
                            FIRAnalytics.FIRLogEvent(eventName: .GOAL_COMPLETED,
                                                     screen: .LogGoal,
                                                     parameter: params)
                        }
                        
                        self.vmResult.value = .success(nil)
                        Alert.shared.showSnackBar(response.message)
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
                    
                    break
                    
                case .failure(let error):
                    
                    Alert.shared.showSnackBar(error.localizedDescription)
                    break
                    
                }
            }
        }
        
        func imageUploadSetup(){
            ApiManager.shared.addLoader()
            let dispatchGroup = DispatchGroup()
            for image in arrImg {
                
                if image.newImage != nil {
                    //For attach note upload
                    dispatchGroup.enter()
                    ImageUpload.shared.uploadImage(true,
                                                   image.newImage,
                                                   nil,
                                                   BlobContainer.kAppContainer,
                                                   prefix: .food) { (str1, str2) in
                        //                print(str1)
                        //                print(str2)
                        arrImages.append(str2 ?? "")
                        dispatchGroup.leave()
                    }
                }
                else {
                    if let val = image.imageUrl.components(separatedBy: "/").last {
                        arrImages.append(val.components(separatedBy: "?").first!)
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                //When media images upload done
                ApiManager.shared.removeLoader()
                updateData()
            }
        }
        
        //----------------------------------------------
        if arrImg.count > 0 {
            imageUploadSetup()
        }
        else {
            updateData()
        }
    }
}
