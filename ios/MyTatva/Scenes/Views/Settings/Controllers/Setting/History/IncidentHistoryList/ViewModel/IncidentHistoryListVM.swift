
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class IncidentHistoryListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [IncidentHistoryListModel]()
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
extension IncidentHistoryListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> IncidentHistoryListModel {
        return self.arrList[index]
    }
    
//    func manageSelection(index: Int) {
//        let object = self.arrList[index]
//        for item in self.arrList {
//            item.isSelected = false
//            if item.languagesId == object.languagesId {
//                item.isSelected = true
//            }
//        }
//    }
    
    func getSelectedObject() ->  IncidentHistoryListModel? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func managePagenation(tblView: UITableView,
                          refreshControl: UIRefreshControl? = nil,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.get_incident_duration_occurance_listAPI(tblView: tblView,
                                                                     withLoader: false) { [weak self]  (isDone) in
                            guard let self = self else {return}
                            
                            refreshControl?.endRefreshing()
                            self.vmResult.value = .success(nil)
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- API CALL ----------------------
extension IncidentHistoryListVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.get_incident_duration_occurance_listAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            tblView?.reloadData()
            
            self.vmResult.value = .success(nil)
        }
    }
    
    
    func get_incident_duration_occurance_listAPI(tblView: UITableView? = nil,
                                                 withLoader: Bool,
                                                 completion: ((Bool) -> Void)?){
        
        var params                      = [String : Any]()
        params["page"]                  = self.page
        
        //        params = params.filter({ (obj) -> Bool in
        //            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.get_incident_duration_occurance_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [IncidentHistoryListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    self.isNextPage = false
                    if self.page <= 1 {
                        self.arrList.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    if self.page <= 1 {
                        self.strErrorMessage = ""
                        self.arrList.removeAll()
                    }
                    
                    arr = IncidentHistoryListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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



