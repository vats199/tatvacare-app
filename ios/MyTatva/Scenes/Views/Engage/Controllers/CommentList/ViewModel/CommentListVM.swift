
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class CommentListVM {

    
    //MARK:- Class Variable
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [CommentData]()
    var strTotalComment             = ""
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
extension CommentListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> CommentData {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
        
        //if object["name"].stringValue.lowercased().contains("All".lowercased()) {
        //            for i in 0...self.arrDays.count - 1 {
        //                var obj  = self.arrDays[i]
        //
        //                obj["isSelected"].intValue = 0
        //                if obj["name"].stringValue == object["name"].stringValue {
        //                    obj["isSelected"].intValue = 1
        //                }
        //                self.arrDays[i] = obj
        //            }
        //        }
        //        else {
        //            for i in 0...self.arrDays.count - 1 {
        //                var obj  = self.arrDays[i]
        //
        //                if obj["name"].stringValue.lowercased().contains("All".lowercased()) {
        //                    obj["isSelected"].intValue = 0
        //                }
        //
        //                if obj["name"].stringValue == object["name"].stringValue {
        //                    if obj["isSelected"].intValue == 1 {
        //                        obj["isSelected"].intValue = 0
        //                    }
        //                    else {
        //                        obj["isSelected"].intValue = 1
        //                    }
        //                }
        //                self.arrDays[i] = obj
        //            }
        //        }
        
        //let object = self.arrList[index]
        
       
    }
    
    func managePagenation(tblView: UITableView,
                          content_master_id: String,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.commentListAPI(tblView: tblView,
                                            withLoader: false,
                                            content_master_id: content_master_id) { [weak self] (isDone) in
                            
                            guard let self = self else {return}
                            
                            self.vmResult.value = .success(nil)
                            tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- API CALL ----------------------
extension CommentListVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                content_master_id: String,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.commentListAPI(tblView: tblView,
                            withLoader: withLoader,
                            content_master_id: content_master_id) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            if isLoaded {
                tblView?.reloadData()
            }
            else {
                tblView?.reloadData()
            }
        }
    }
    
    
    func commentListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        content_master_id: String,
                        completion: ((Bool) -> Void)?){
        
        /*
         {
           "show": "two",
           "content_master_id": "string",
           "page": "string"
         }
         */
        
        var params                      = [String : Any]()
        params["page"]                  = self.page
        params["show"]                  = "all"
        params["content_master_id"]     = content_master_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.comment_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [CommentData]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = CommentData.modelsFromDictionaryArray(array: response.data["comment_data"].arrayValue)
                    self.strTotalComment = response.data["total"].stringValue
                    
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
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //Add comment api
    func update_commentAPI(content_master_id: String,
                           content_type: String,
                           comment: String,
                           content_comments_id: String? = "",
                           screen: ScreenName,
                           completion: ((Bool, ContentListModel) -> Void)?){
        
        
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
        params["comment"]               = comment
        params["content_comments_id"]   = content_comments_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.update_comment), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var obj                 = ContentListModel()
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    var params = [String: Any]()
                    params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
                    params[AnalyticsParameters.content_type.rawValue]      = content_type
                    FIRAnalytics.FIRLogEvent(eventName: .USER_COMMENTED, parameter: params)
                    
                    obj = ContentListModel(fromJson: response.data)
                    returnVal = true
                    
                    break
                case .emptyData:
                    returnVal = false
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
                
                completion?(returnVal, obj)
                break
                
            case .failure(let error):
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal, obj)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}



