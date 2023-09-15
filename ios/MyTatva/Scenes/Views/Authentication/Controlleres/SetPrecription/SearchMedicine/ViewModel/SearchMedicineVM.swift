
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class SearchMedicineVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [SearchMedicineModel]()
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
extension SearchMedicineVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> SearchMedicineModel {
        return self.arrList[index]
    }
    
    func managePagenation(tblView: UITableView?,
                          medicine_name: String,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.getMedicineListAPI(tblView: tblView,
                                                withLoader: false,
                                                medicine_name: medicine_name) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            self.vmResult.value = .success(nil)
                            //tblView?.reloadData()
                            
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

//MARK: ---------------- API CALL ----------------------
extension SearchMedicineVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView,
                                medicine_name: String,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.getMedicineListAPI(tblView: tblView,
                                withLoader: withLoader,
                                medicine_name: medicine_name) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            if isLoaded {
                tblView.reloadData()
            }
            else {
                tblView.reloadData()
            }
        }
    }
    
    
    func getMedicineListAPI(tblView: UITableView?,
                            withLoader: Bool,
                            medicine_name: String,
                            completion: ((Bool) -> Void)?){
        
        var params                      = [String : Any]()
        params["page_no"]               = self.page
        params["medicine_name"]         = medicine_name
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_medicine_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [SearchMedicineModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
//                    self.strErrorMessage = response.message
                    self.strErrorMessage = ""
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    if self.page <= 1 {
                        self.arrList.removeAll()
                        tblView?.reloadData()
                    }
                    
                    returnVal = true
                    arr = SearchMedicineModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    //tblView?.reloadData()
                
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
                break
                
            }
        }
    }
}



