//
//  HelpAndSupportVM.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import Foundation

class HelpAndSupportVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                      = 1
    var isNextPage                = true
    var arrQuestion : [FAQListModel] = []
    
    var strErrorMessage : String     = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Question Data ----------------------
extension HelpAndSupportVM {
    
    func getCount() -> Int {
        return self.arrQuestion.count
    }
    
    func getObject(index: Int) -> FAQListModel? {
        if self.arrQuestion.count > 0 {
            return self.arrQuestion[index]
        }
        else {
            return nil
        }
    }
    
    func manageFaqPagenation(tblView: UITableView){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.isNextPage {
                self.page += 1
                
                if self.arrQuestion.count > 0 {
                    
                    self.questionListAPI(tblView: tblView,
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

//MARK: ---------------- API CALL FOR Question ----------------------
extension HelpAndSupportVM {
    
    @objc func apiCallFromStartQuestion(tblView: UITableView,refreshControl: UIRefreshControl? = nil,
                                withLoader: Bool = false) {
        
        self.arrQuestion.removeAll()
        tblView.reloadData()
        
        self.page              = 1
        self.isNextPage        = true
        
        //API Call
        self.questionListAPI(tblView: tblView,
                           withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
            UIView.animate(withDuration: 1) {
                tblView.reloadData()
            }
            
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func questionListAPI(tblView: UITableView,
                         withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["page"]          = self.page
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_faqs), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    let arr = FAQListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrQuestion.append(arr)
                  //  self.arrNotification.removeAll()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
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
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
