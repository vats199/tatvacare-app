
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ExerciseMyPlanVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult           = Bindable<Result<String?, AppError>>()
    var page                            = 1
    var isNextPage                      = true
    var arrPlanList                     = [PlanDataModel]()
    var strErrorMessagePlanList : String     = ""
    
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
extension ExerciseMyPlanVM {
    
    func getCount() -> Int {
        return self.arrPlanList.count
    }
    
    func getObject(index: Int) -> PlanDataModel {
        if self.arrPlanList.count > 0 {
            return self.arrPlanList[index]
        }else {
            return PlanDataModel()
        }
    }
    
    func managePagenation(tblView: UITableView? = nil,
                          refreshControl: UIRefreshControl? = nil,
                          withLoader: Bool = false,
                          search: String,
                          index: Int){
        
        if index == self.arrPlanList.count - 1 {
            if self.isNextPage {
                self.page += 1
                
                if self.arrPlanList.count > 0 {
                    self.planListAPI(tblView: tblView,
                                     withLoader: withLoader,
                                     search: search) { [weak self] (isDone) in
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


//MARK: ---------------- Enage Content List API ----------------------
extension ExerciseMyPlanVM {
    
    @objc func apiCallFromStart_PlanList(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                         search: String) {
        
        self.page                       = 1
        self.isNextPage                 = true
        self.strErrorMessagePlanList    = ""

        self.arrPlanList.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.planListAPI(tblView: tblView,
                         withLoader: withLoader,
                         search: search) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            tblView?.reloadData()
            self.vmResult.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    
    func planListAPI(tblView: UITableView? = nil,
                     withLoader: Bool,
                     search: String,
                     completion: ((Bool) -> Void)?){
        
        /*
         
         "page": "string"
       }
         */
        
        var params                      = [String : Any]()
        params["page"]                  = self.page
        params["search"]                = search
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.exercise_plan_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [PlanDataModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessagePlanList = response.message
                    
                    self.isNextPage = false
                    if self.page <= 1 {
                        self.arrPlanList.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    if self.page <= 1 {
                        self.arrPlanList.removeAll()
                    }
                    
                    arr = PlanDataModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrPlanList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    if self.page <= 1 {
                        self.strErrorMessagePlanList = response.message
                        self.arrPlanList.removeAll()
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
                self.strErrorMessagePlanList = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
