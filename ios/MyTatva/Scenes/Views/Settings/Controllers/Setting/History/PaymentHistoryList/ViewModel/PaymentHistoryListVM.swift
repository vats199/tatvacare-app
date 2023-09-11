
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

enum PaymentHistoryType: String, CaseIterable {
    case plan
    case test
}

class PaymentHistoryListVM {
    //MARK:- Class Variable
    
    private(set) var vmResultContentList = Bindable<Result<String?, AppError>>()
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [PaymentHistoryListModel]()
    var arrPlan_payment             = [PaymentHistoryListModel]()
    var arrTest_payment             = [PaymentHistoryListModel]()
    var strErrorMessage : String     = ""
    
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
extension PaymentHistoryListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> PaymentHistoryListModel {
        return self.arrList[index]
    }
    
    func manageSelectionContentList(index: Int) {
        let object = self.arrList[index]
        if object.isSelected {
            object.isSelected = false
        }
        else {
            object.isSelected = true
        }
    }
    
    func managePagenation(refreshControl: UIRefreshControl? = nil,
                          tblView: UITableView? = nil,
                          withLoader: Bool = false,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.payment_historyListAPI(tblView: tblView,
                                                    withLoader: withLoader) { (isDone) in
                            
                            refreshControl?.endRefreshing()
                            tblView?.reloadData()
                            
                            self.vmResultContentList.value = .success(nil)
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


//MARK: ---------------- Enage Content List API ----------------------
extension PaymentHistoryListVM {
    
    @objc func apiCallFromStart_payment_history(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        
        self.page               = 1
        self.isNextPage         = true
        self.strErrorMessage    = ""
        
        //API Call
        self.payment_historyListAPI(tblView: tblView,
                            withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            tblView?.reloadData()
            self.vmResultContentList.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    
    func payment_historyListAPI(tblView: UITableView? = nil,
                                withLoader: Bool,
                                completion: ((Bool) -> Void)?){
        
        /*
         
         "page": "string"
       }
         */
        
        let params                      = [String : Any]()
//        params["page"]                  = self.page
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" && obj.value as? [String] != [] {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.payment_history), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    break
                case .success:
                    
                    returnVal = true
                    self.strErrorMessage = ""
                    
                    self.arrPlan_payment = PaymentHistoryListModel.modelsFromDictionaryArray(array: response.data["plan_payment"].arrayValue)
                    self.arrTest_payment = PaymentHistoryListModel.modelsFromDictionaryArray(array: response.data["test_payment"].arrayValue)
                    
//                    arr = PaymentHistoryListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
//                    self.arrList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    self.strErrorMessage = response.message
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
