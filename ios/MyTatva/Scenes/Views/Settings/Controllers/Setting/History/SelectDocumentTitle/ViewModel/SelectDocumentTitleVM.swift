//
//  SelectDocumentTitleVM.swift
//  MyTatva
//
//  Created by hyperlink on 03/11/21.
//

import Foundation

class SelectDocumentTitleVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList : [Title]           = []
    var arrFilteredList : [Title]   = []
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
extension SelectDocumentTitleVM {
    
    func getCount() -> Int {
        return self.arrFilteredList.count
    }
    
    func getObject(index: Int) -> Title {
        return self.arrFilteredList[index]
    }
    
    func manageSearch(keyword: String) {
        let titles = self.arrList.contains(where: { title in
            title.title == keyword
        })
        if keyword.trim() != "" && !titles{
            let obj : Title = Title()
            obj.title = keyword
            obj.isCustom = true
            obj.recordsTitleMasterId = ""
            self.arrList.append(obj)
        }
        
        if keyword.trim() == "" {
            self.arrFilteredList = self.arrList
        }
        else {
            self.arrFilteredList = self.arrList.filter({ return $0.title.lowercased().contains(keyword.lowercased())})
        }
    }
    
    func manageSelection(index: Int) {
//        let object = self.arrList[index]
//        for item in self.arrList {
//            item.isSelected = false
//            if item.recordsTitleMasterId == object.recordsTitleMasterId {
//                item.isSelected = true
//            }
//        }
    }
    
    func getSelectedObject() ->  Title? {
//        let arrTemp = self.arrList.filter { (obj) -> Bool in
//            return obj.isSelected
//        }
//        return arrTemp.first
        return nil
    }
    
    func managePagenation(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.documentTitleListAPI(tblView: tblView,
                                                  withLoader: false) { [weak self] (isDone) in
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
extension SelectDocumentTitleVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.documentTitleListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            if isLoaded {
                self.arrFilteredList = self.arrList
                tblView?.reloadData()
            }
            else {
                tblView?.reloadData()
            }
        }
    }
    
    
    func documentTitleListAPI(tblView: UITableView? = nil,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.test_types), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    let objc = TestTypeModel(fromJson: response.data)
                    self.arrList.append(contentsOf: objc.title)
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
}
