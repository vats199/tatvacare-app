//
//  NotificationVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import Foundation

class AllLabTestListVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [BookTestListModel]()
    var arrNotification             : [JSON] = [
        [
            "name" : "English",
            "isSelected": 1,
        ],[
            "name" : "Hindi",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ]
    ]
    
    var strErrorMessage : String     = ""
    var pateintPlanRefID             = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Notification Data ----------------------
extension AllLabTestListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> BookTestListModel {
        return self.arrList[index]
    }
    
    func managePagenation(tblView: UITableView?,
                          refreshControl: UIRefreshControl? = nil,
                          search: String,
                          type: LabTestType,
                          pincode: String,
                          index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.bookTestListAPI(tblView: tblView,
                                             search: search,
                                             type: type,
                                             pincode: pincode,
                                             withLoader: false) { [weak self] (isDone) in
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
extension AllLabTestListVM {
    
    func apiCallFromStart(tblView: UITableView?,
                          refreshControl: UIRefreshControl? = nil,
                          search: String,
                          type: LabTestType,
                          pincode: String,
                          withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.bookTestListAPI(tblView: tblView,
                             search: search,
                             type: type,
                             pincode: pincode,
                             withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
            UIView.animate(withDuration: 1) {
                tblView?.reloadData()
            }
            
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func bookTestListAPI(tblView: UITableView?,
                         search: String,
                         type: LabTestType,
                         pincode: String,
                         withLoader: Bool,
                         completion: ((Bool) -> Void)?){
        
        /*
         {
         "type": "all", "package", "test"
         "page": 1,
         "search": "string"
         "pincode": "844101"
         }
         */
        
        var params              = [String : Any]()
        params["page"]          = self.page
        params["search"]        = search
        params["type"]          = type.rawValue
        params["pincode"]       = pincode
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.tests_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                var arr                 = [BookTestListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    if self.page <= 1 {
                        self.arrList.removeAll()
                        tblView?.reloadData()
                    }
                    
                    returnVal = true
                    arr = BookTestListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    tblView?.reloadData()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
                        tblView?.reloadData()
                        
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
                self.strErrorMessage = error.localizedDescription
                //Alert.shared.showSnackBar(error.localizedDescription)
                completion?(returnVal)
                break
                
            }
        }
    }
}

