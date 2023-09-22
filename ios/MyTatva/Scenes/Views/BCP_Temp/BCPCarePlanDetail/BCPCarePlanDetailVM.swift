//
//  BCPCarePlanDetailVM.swift
//  MyTatva
//
//  Created by Hlink on 05/06/23.
//

import Foundation

class BCPCarePlanDetailVM {
    //MARK: - Class Variables
    
    private var arrPlans = [(title: String,arrPlans:[DurationDetailModel])]() {
        didSet {
            self.isPlanChange.value = true
        }
    }
    
    private(set) var isPlanChange = Bindable<Bool>()
    
    private var arrFeatures = [(sectionDetail:PlanDataDetailModel, arrSub: [PlanDataDetailModel])]() {
        didSet {
            self.isFeatureChange.value = true
        }
    }
    
    var cpDetail                     = CarePlanDetailsModel()
    private(set) var isDetailsChange = Bindable<Bool>()
    private(set) var isFeatureChange = Bindable<Bool>()
    
    //MARK: - init
    init() {
        
    }
    
    //---------------------------------------------------------
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
}

//------------------------------------------------------
//MARK: - Class Methods
extension BCPCarePlanDetailVM {
    
    func getNumOfSection() -> Int { self.arrPlans.count }
    func getTitle(_ sec:Int) -> String { self.arrPlans[sec].title }
    func getNumOfRows(_ sec: Int) -> Int { self.arrPlans[sec].arrPlans.count }
    func getSelectedPlan() -> DurationDetailModel? { self.arrPlans[0].arrPlans.first(where: { $0.isSelected }) }
    func getListOfRow(_ ip: IndexPath) -> DurationDetailModel { self.arrPlans[ip.section].arrPlans[ip.row] }
    func didSelect(_ ip: IndexPath) {
        self.arrPlans[ip.section].arrPlans = self.arrPlans[ip.section].arrPlans.compactMap({ obj -> DurationDetailModel in
            let tmp = obj
            tmp.isSelected = false
            return tmp
        })
        self.arrPlans[ip.section].arrPlans[ip.row].isSelected = true
        
        let obj = self.arrPlans[ip.section].arrPlans[ip.row]
        
        var params              = [String : Any]()
        params[AnalyticsParameters.plan_id.rawValue]            = obj.planMasterId
        params[AnalyticsParameters.plan_type.rawValue]          = self.cpDetail.planDetails.planType
        params[AnalyticsParameters.plan_duration.rawValue]      = obj.durationTitle
        
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_SUBSCRIPTION_DURATION,
                                 screen: .BcpDetails,
                                 parameter: params)
        
    }
    func getNumOfSectionInFeature() -> Int { self.arrFeatures.count }
    func getTitleForFeature(_ sec:Int) -> PlanDataDetailModel { self.arrFeatures[sec].sectionDetail }
    func getNumOfRowsInFeature(_ sec: Int) -> Int { self.arrFeatures[sec].arrSub.count }
    func getListOfRowInFeature(_ ip: IndexPath) -> PlanDataDetailModel { self.arrFeatures[ip.section].arrSub[ip.row] }
    func getSizeOfPlan() -> CGFloat {
        switch self.arrPlans[0].arrPlans.count {
        case 1: return ScreenSize.width / 2
        case 2: return ScreenSize.width / 4
        default: return ScreenSize.width / 5
        }
    }
    
    func setHeight(_ height: CGFloat, ip:IndexPath? = nil, sec:Int?=nil) {
        if let sec = sec {
            self.arrFeatures[sec].sectionDetail.height = height
        }else if let ip = ip {
            self.arrFeatures[ip.section].arrSub[ip.row].height = height
        }
    }
    
}

//------------------------------------------------------
//MARK: - WS Methods
extension BCPCarePlanDetailVM {
    
    func getPlans() {
        
        self.arrPlans = [
            ("Select plan as per your need",self.cpDetail.durationDetails)
        ]
        
    }
    
    func getFeatures() {
        self.arrFeatures = self.cpDetail.arrData.filter({ $0.type == "header" }).compactMap({ (secDetail) -> (PlanDataDetailModel,[PlanDataDetailModel]) in
            let arrSub = self.cpDetail.arrData.filter({$0.parentTitle == secDetail.title})
            return (secDetail,arrSub)
        })
    }
 
    func getPlanDetails(durationType:String,patientPlanRelId:String="") {
        
        let planMasterId = self.cpDetail.planDetails.planMasterId ?? ""
//        let planMasterId = "2605dfb7-3762-11ee-b5a3-1dbb567d70ba"
        GlobalAPI.shared.planDetailsAPI(plan_id: planMasterId,
                                        durationType: durationType,
                                        patientPlanRelId: patientPlanRelId,
                                        withLoader: true) { [weak self] isDone, object1, msg in
            guard let self = self else {return}
            if isDone {
                self.cpDetail   = object1
                self.isDetailsChange.value = true
            }
        }
        
    }
    
    func cancelPlanAPI(patient_plan_rel_id: String,
                    withLoader: Bool,
                    completion: ((Bool) -> Void)?){
        
        var params                              = [String : Any]()
        params["patient_plan_rel_id"]           = patient_plan_rel_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.cancel_patient_plan), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
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
                
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
        
    }
    
    func purchasePlan(){
        
        guard let selectedPlan = self.getSelectedPlan() else { return }
        
        if selectedPlan.iosPrice > 0 {
            InAppManager.shared.purchaseProduct(productID: selectedPlan.iosProductId) { (jsonObj, stringObj) in
                
                if jsonObj != nil {
                    InAppManager.shared.completeTransaction()
                    
                    var transaction_id = InAppManager.shared.getOriginalTransectionId(jsonResponse: jsonObj!)
                    
                    if self.cpDetail.planDetails.planType == kSubscription {
                        transaction_id = InAppManager.shared.getOriginalSubscriptionTransectionId(jsonResponse: jsonObj!)
                    }
                    
                    self.addPlanAPI(plan_master_id: self.cpDetail.planDetails.planMasterId,
                                              transaction_id: transaction_id,
                                              receipt_data: stringObj ?? "",
                                              plan_type: self.cpDetail.planDetails.planType,
                                              plan_package_duration_rel_id: selectedPlan.planPackageDurationRelId,
                                    purchase_amount: JSON(selectedPlan.iosPrice as Any).doubleValue,
                                              withLoader: true) { [weak self] isDone in
                        guard let self = self else {return}
                        if isDone {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self] (isDone) in
                                    guard let self = self else {return}
                                    UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            //Free plan
            self.addPlanAPI(plan_master_id: self.cpDetail.planDetails.planMasterId,
                                      transaction_id: "Free",
                                      receipt_data: "",
                                      plan_type: self.cpDetail.planDetails.planType,
                                      plan_package_duration_rel_id: selectedPlan.planPackageDurationRelId,
                            purchase_amount: JSON(selectedPlan.iosPrice as Any).doubleValue,
                                      withLoader: true) { isDone in
                if isDone {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                        GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self] (isDone) in
                            
                            guard let self = self else {return}
                            
                            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
    }
    
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
    
}

