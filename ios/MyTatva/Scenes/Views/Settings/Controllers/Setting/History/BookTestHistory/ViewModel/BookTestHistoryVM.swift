//
//  RecordsVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import Foundation

class BookTestHistoryVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [LabTestHistoryModel]()
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
extension BookTestHistoryVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> LabTestHistoryModel {
        return self.arrList[index]
    }
    
    func managePagenation(tblView: UITableView?,
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
                        
                        self.TestHistoryListAPI(tblView: tblView,
                                                withLoader: false,
                                                search: search) { (isDone) in
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
extension BookTestHistoryVM {
    
    @objc func apiCallFromStart_TestHistory(tblView: UITableView?,
                                            refreshControl: UIRefreshControl? = nil,
                                            withLoader: Bool = false,
                                            search: String) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page              = 1
        self.isNextPage        = true
        
        //API Call
        self.TestHistoryListAPI(tblView: tblView,
                                withLoader: withLoader,
                                search: search) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            tblView?.reloadData()
            
            self.vmResult.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    func TestHistoryListAPI(tblView: UITableView?,
                            withLoader: Bool,
                            search: String,
                            completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["page"]          = self.page
        params["search"]        = search
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.order_history), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [LabTestHistoryModel]()
            
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
                    
                    arr = LabTestHistoryModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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
    
    //MARK: --------------- get_download_report API ----------------------
    func get_download_reportAPI(order_master_id: String,
                                completion: ((Bool, String, String) -> Void)?){
        
        /*
         {
           "order_master_id": "string",
           
         }
         */
        
        var params                      = [String : Any]()
        params["order_master_id"]       = order_master_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.get_download_report_url), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg     = ""
            var link    = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    msg = response.message
                    link = response.data["url"].stringValue
                    Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
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
                
                completion?(returnVal, msg, link)
                break
                
            case .failure(let error):
                msg = error.localizedDescription
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
