
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ViewAllBoormarkVM {

    
    //MARK:- Class Variable
    private(set) var vmResultContentList = Bindable<Result<String?, AppError>>()
    var pageContentList                         = 1
    var isNextPageContentList                   = true
    var arrListContentList                      = [ContentListModel]()
    var strErrorMessageContentList : String     = ""
    
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
extension ViewAllBoormarkVM {
    
    func getCountContentList() -> Int {
        return self.arrListContentList.count
    }
    
    func getObjectContentList(index: Int) -> ContentListModel {
        return self.arrListContentList[index]
    }
    
    func manageSelectionContentList(index: Int) {
//       let object = self.arrListTopicList[index]
//
//        for item in self.arrListTopicList {
//            if item.topicMasterId == object.topicMasterId {
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
    
    func managePagenationContentList(refreshControl: UIRefreshControl? = nil,
                                     tblView: UITableView? = nil,
                                     withLoader: Bool = false,
                                     type: String,
                                     index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrListContentList.count - 1 {
                if self.isNextPageContentList {
                    self.pageContentList += 1
                    
                    if self.arrListContentList.count > 0 {
                        
                        self.contentListAPI(tblView: tblView,
                                            withLoader: withLoader,
                                            type: type) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            self.vmResultContentList.value = .success(nil)
                            tblView?.reloadData()
                            refreshControl?.endRefreshing()
                        }
                    }
                }
            }
        }
    }
}


//MARK: ---------------- Enage Content List API ----------------------
extension ViewAllBoormarkVM {
    
    @objc func apiCallFromStart_ContentList(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                type: String) {
        
        self.pageContentList                = 1
        self.isNextPageContentList          = true
        self.strErrorMessageContentList     = ""
        self.arrListContentList.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.contentListAPI(tblView: tblView,
                            withLoader: withLoader,
                            type: type) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultContentList.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func contentListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        type: String,
                        completion: ((Bool) -> Void)?){
        
        /*
         "page": "string",
         "type": "string",
       }
         */
        
        var params                      = [String : Any]()
        params["page"]                  = self.pageContentList
        params["type"]                  = type
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.bookmark_content_list_by_type), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [ContentListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.isNextPageContentList = false
                    self.strErrorMessageContentList = response.message
                    
                    if self.pageContentList <= 1 {
                        self.arrListContentList.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageContentList <= 1 {
                        self.strErrorMessageContentList = ""
                        self.arrListContentList.removeAll()
                    }
                    
                    arr = ContentListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrListContentList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageContentList = false
                    
                    if self.pageContentList <= 1 {
                        self.strErrorMessageContentList = response.message
                        self.arrListContentList.removeAll()
                        
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
                self.isNextPageContentList = false
                self.strErrorMessageContentList = error.localizedDescription
                completion?(returnVal)
//                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
