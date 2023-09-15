
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ExercisePlanDetailVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    var page                        = 1
    var isNextPage                   = true
    var arrPlanDaysList                      = [PlanDaysListModel]()
    var strErrorMessagePlanDays : String     = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update Content Data ----------------------
extension ExercisePlanDetailVM {
    
    func getCount() -> Int {
        return self.arrPlanDaysList.count
    }
    
    func getObject(index: Int) -> PlanDaysListModel {
        return self.arrPlanDaysList[index]
    }
    
    func managePagenationPlanDaysList(refreshControl: UIRefreshControl? = nil,
                                      tblView: UITableView? = nil,
                                      withLoader: Bool = false,
                                      content_master_id : String,
                                      index: Int,
                                      plan_type: String,
                                      type: String){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrPlanDaysList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrPlanDaysList.count > 0 {
                        
                        self.planDaysListAPI(tblView: tblView,
                                             withLoader: withLoader,
                                             content_master_id: content_master_id,
                                             plan_type: plan_type,
                                             type: type) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            refreshControl?.endRefreshing()
                            tblView?.reloadData()
                            self.vmResult.value = .success(nil)
                        }
                    }
                }
            }
        }
    }
}


//MARK: ---------------- Enage Content List API ----------------------
extension ExercisePlanDetailVM {
    
    @objc func apiCallFromStart_PlanDaysList(refreshControl: UIRefreshControl? = nil,
                                             tblView: UITableView? = nil,
                                             withLoader: Bool = false,
                                             content_master_id : String,
                                             plan_type: String,
                                             type: String) {
        
        self.page                       = 1
        self.isNextPage                 = true
        self.strErrorMessagePlanDays    = ""
        self.arrPlanDaysList.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.planDaysListAPI(tblView: tblView,
                             withLoader: withLoader,
                             content_master_id: content_master_id,
                             plan_type: plan_type,
                             type: type) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            tblView?.reloadData()
            self.vmResult.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    
    func planDaysListAPI(tblView: UITableView? = nil,
                         withLoader: Bool,
                         content_master_id: String,
                         plan_type: String,
                         type: String,
                         completion: ((Bool) -> Void)?){
        
        /*
         content_master_id
         "type": "A"/"H"
       }
         */
        
        var params                      = [String : Any]()
        //params["page"]                  = self.page
        params["content_master_id"]     = content_master_id
        
        var api_name = ApiEndPoints.content(.plan_days_list)
        if plan_type == "custom" {
            api_name            = ApiEndPoints.content(.exercise_plan_days_list)
            params["type"]      = type
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [PlanDaysListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.isNextPage = false
                    self.strErrorMessagePlanDays = response.message
                    
                    if self.page <= 1 {
                        self.arrPlanDaysList.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    if self.page <= 1 {
                        self.strErrorMessagePlanDays = ""
                        self.arrPlanDaysList.removeAll()
                    }
                    
                    arr = PlanDaysListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrPlanDaysList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessagePlanDays = response.message
                        self.arrPlanDaysList.removeAll()
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
                self.strErrorMessagePlanDays = error.localizedDescription
                completion?(returnVal)
                break
                
            }
        }
    }
}
