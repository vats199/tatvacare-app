//
//  NotificationVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import Foundation

class NotificationVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [NotificationListModel]()
    var unReadCount: Int            = 0
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
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Notification Data ----------------------
extension NotificationVM {
    
    func getNotificationCount() -> Int {
        return self.arrList.count
    }
    
    func getNotificationObject(index: Int) -> NotificationListModel {
        return self.arrList[index]
    }
    
    func manageNotificationPagenation(tblView: UITableView?,
                                      index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.notificationListAPI(tblView: tblView,
                                                 withLoader: false) { [weak self] (isDone) in
                            
                            guard let self = self else {return}
                            
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
extension NotificationVM {
    
    @objc func apiCallFromStartNotification(tblView: UITableView?,
                                            refreshControl: UIRefreshControl? = nil,
                                            withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.notificationListAPI(tblView: tblView,
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
    
    
    func notificationListAPI(tblView: UITableView?,
                             withLoader: Bool,
                             completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["page"]          = self.page
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
//
        print(JSON(params))
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.get_notification), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                var arr                 = [NotificationListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = NotificationListModel.modelsFromDictionaryArray(array: response.data["list"].arrayValue)
                    self.arrList.append(contentsOf: arr)
                    tblView?.reloadData()
                    
                    if self.page <= 1 {
                        self.unReadCount = response.data["unread_counts"].intValue
                    }
                    
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

