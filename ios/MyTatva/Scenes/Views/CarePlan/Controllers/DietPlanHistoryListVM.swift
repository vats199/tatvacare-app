//
//  DietPlanHistoryListVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/23.
//

import Foundation

class DietPlanHistoryListVM {
    
    //MARK: ---------------------- Class Variable ----------------------
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [DietPlanListModel]()
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Record Data ----------------------
extension DietPlanHistoryListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> DietPlanListModel {
        return self.arrList[index]
    }
    
    func managePagenation(tblView: UITableView?,
                          refreshControl: UIRefreshControl? = nil,
                          index: Int,
                          search: String){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        //
                        self.diet_plan_listAPI(tblView: tblView,
                                           withLoader: false,
                                           search: search) { [weak self] (isDone) in
                            
                            guard let self = self else {return}
                            
                            refreshControl?.endRefreshing()
                            self.vmResult.value = .success(nil)
                            
                            if let tbl = tblView {
                                tbl.removeBottomIndicator()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension DietPlanHistoryListVM {
    
    @objc func apiCallFromStart(tblView: UITableView?,
                                refreshControl: UIRefreshControl? = nil,
                                withLoader: Bool = false,
                                search: String,
                                isFromCarePlan: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        
        self.page              = 1
        self.isNextPage        = true
        
        //API Call
        self.diet_plan_listAPI(tblView: tblView,
                               withLoader: withLoader,
                               search: search,
                               isFromCarePlan: isFromCarePlan) { (isLoaded) in
            
            refreshControl?.endRefreshing()
                                         
            UIView.animate(withDuration: 1) {
                tblView?.reloadData()
            }
            
            self.vmResult.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    func diet_plan_listAPI(tblView: UITableView?,
                           colView : UICollectionView? = nil,
                           withLoader: Bool,
                           search: String,
                           isFromCarePlan: Bool = false,
                           completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["page"]          = self.page
        params["search"]        = search
        params["home"]          = isFromCarePlan
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.diet_plan_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [DietPlanListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.isNextPage = false
                    self.strErrorMessage = response.message
                    
                    if self.page <= 1 {
                        self.arrList.removeAll()
                    }
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.page <= 1 {
                        self.strErrorMessage = ""
                        self.arrList.removeAll()
                    }
                    
                    arr = DietPlanListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    break
                case .emptyData:
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
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
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
