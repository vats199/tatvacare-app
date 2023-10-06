//
//  HelpAndSupportVM.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import Foundation

class PlanListVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrPlan : [PlanListModel]   = []
    
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Question Data ----------------------
extension PlanListVM {
    
    func getCount() -> Int {
        return self.arrPlan.count
    }
    
    func getPlansCount(index: Int) -> Int {
        return self.arrPlan[index].planDetails.count
    }
    
    func getObject(index: Int) -> PlanListModel {
        return self.arrPlan[index]
    }
    
    func managePagenation(tblView: UITableView,
                          refreshControl: UIRefreshControl,
                          plan_type: String){
        if self.isNextPage {
            self.page += 1
            
            if self.arrPlan.count > 0 {
                
                self.plansListAPI(tblView: tblView,
                                  withLoader: false,
                                  plan_type: plan_type) { [weak self] (isDone) in
                    guard let self = self else {return}
                    
                    tblView.reloadData()
                    refreshControl.endRefreshing()
                    self.vmResult.value = .success(nil)
                }
            }
        }
    }
    
}

//MARK: ---------------- API CALL FOR Plan List ----------------------
extension PlanListVM {
    
    @objc func apiCallFromStartPlansList(tblView: UITableView,
                                        refreshControl: UIRefreshControl? = nil,
                                        plan_type: String,
                                        withLoader: Bool = false) {
        
        self.page              = 1
        self.isNextPage        = true
        
        //API Call
        self.plansListAPI(tblView: tblView,
                           withLoader: withLoader,
                          plan_type: plan_type) { (isLoaded) in
            
            self.vmResult.value = .success(nil)
            refreshControl?.endRefreshing()
            tblView.reloadData()
        }
    }
    
    
    func plansListAPI(tblView: UITableView,
                      withLoader: Bool,
                      plan_type: String,
                      completion: ((Bool) -> Void)?){
        
        /*
         {
           "plan_type": "I","S"
           "page": "string"
         }
         */
        
        
        var params              = [String : Any]()
        params["plan_type"]     = plan_type
        params["page"]          = self.page
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.plans_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal       = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    self.strErrorMessage = response.message
                    self.isNextPage = false
                    if self.page <= 1 {
                        self.arrPlan.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    if self.page <= 1 {
                        self.strErrorMessage = ""
                        self.arrPlan.removeAll()
                    }
                    
                    let arr = PlanListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrPlan.append(arr)
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrPlan.removeAll()
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
                self.isNextPage = false
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal)
                
                break
                
            }
        }
    }
}

//MARK: ---------------- API CALL FOR Plan Details ----------------------
extension PlanListVM {
    
    func planDetailsAPI(plan_id: String,
                           withLoader: Bool,
                           completion: ((Bool, PlanDetailsModel, String) -> Void)?){
        
        /*
         No params
         */
        
        var params                  = [String : Any]()
        params["plan_id"]           = plan_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.plans_details_by_id), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var msg         = ""
            var obj         = PlanDetailsModel()
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
                    obj = PlanDetailsModel(fromJson: response.data)
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

//MARK: ---------------- API CALL FOR Buy/Add Plan ----------------------
extension PlanListVM {
    
    func addPlanAPI(plan_master_id: String,
                    transaction_id: String,
                    receipt_data: String,
                    plan_type: String,
                    plan_package_duration_rel_id: String,
                    purchase_amount: Double,
                    withLoader: Bool,
                    completion: ((Bool) -> Void)?){
        
        /*
         {
           "plan_master_id": "string",
           "transaction_id": "string",
           "receipt_data": "string",
           "plan_package_duration_rel_id": "string",
           "device_type": "A"
         }
         */
        
        var params                              = [String : Any]()
        params["plan_master_id"]                = plan_master_id
        params["transaction_id"]                = transaction_id
        params["receipt_data"]                  = receipt_data
        params["plan_type"]                     = plan_type
        params["plan_package_duration_rel_id"]  = plan_package_duration_rel_id
        params["device_type"]                   = "I"
        params["purchase_amount"]               = purchase_amount
//        params["discount_amount"]               = "\(kBCPCouponCodeAmount)"
//        params["discounts_master_id"]           = kBCPDiscountMasterId
//        params["discount_type"]                 = kBCPDiscountType
//        params["subscription_id"]               = subscription_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.add_patient_plan), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
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
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
        
    }
    
    func cancelPlanAPI(patient_plan_rel_id: String,
                    withLoader: Bool,
                    completion: ((Bool) -> Void)?){
        
        /*
         {
           "plan_master_id": "string",
           "transaction_id": "string",
           "plan_package_duration_rel_id": "string"
         }
         */
        
        var params                              = [String : Any]()
        params["patient_plan_rel_id"]           = patient_plan_rel_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.cancel_patient_plan), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
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
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
        
    }
    
}
