
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class LanguageListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [LanguageListModel]()
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
extension LanguageListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> LanguageListModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
        let object = self.arrList[index]
        for item in self.arrList {
            item.isSelected = false
            if item.languagesId == object.languagesId {
                item.isSelected = true
            }
        }
    }
    
    func getSelectedObject() ->  LanguageListModel? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func managePagenation(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.languageListAPI(tblView: tblView,
                                             withLoader: false) { [weak self]  (isDone) in
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

//MARK: ---------------- Update Data contentLanguageList ----------------------
extension LanguageListVM {
    
    func getCount_contentLanguageList() -> Int {
        return self.arrList.count
    }
    
    func getObject_contentLanguageList(index: Int) -> LanguageListModel {
        return self.arrList[index]
    }
    
    func manageSelection_contentLanguageList(index: Int) {
        let object = self.arrList[index]
        for item in self.arrList {
            item.isSelected = false
            if item.languagesId == object.languagesId {
                item.isSelected = true
            }
        }
    }
    
    func getSelectedObject_contentLanguageList() ->  LanguageListModel? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func managePagenation_contentLanguageList(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.contentLanguageListAPI(tblView: tblView,
                                                    withLoader: false) { [weak self]  (isDone) in
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
extension LanguageListVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.languageListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func languageListAPI(tblView: UITableView? = nil,
                             withLoader: Bool,
                             completion: ((Bool) -> Void)?){
        
        
        let params                      = [String : Any]()
        //params["page"]                  = self.page
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.getLanguageList), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [LanguageListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    self.isNextPage = false
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    arr = LanguageListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    tblView?.reloadData()
                
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
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- API CALL contentLanguageList ----------------------
extension LanguageListVM {
    
    @objc func apiCallFromStart_contentLanguageList(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.contentLanguageListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func contentLanguageListAPI(tblView: UITableView? = nil,
                             withLoader: Bool,
                             completion: ((Bool) -> Void)?){
        
        
        let params                      = [String : Any]()
        //params["page"]                  = self.page
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.contentLanguageList), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [LanguageListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.arrList.removeAll()
                    arr = LanguageListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}





