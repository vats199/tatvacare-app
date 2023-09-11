
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class SelectCityVM {

    //MARK:- Class Variable
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [CityListModel]()
    var arrFilteredList             = [CityListModel]()
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
extension SelectCityVM {
    
    func getCount() -> Int {
        return self.arrFilteredList.count
    }
    
    func getObject(index: Int) -> CityListModel {
        return self.arrFilteredList[index]
    }
    
    func manageSelection(index: Int) {
        let object = self.arrFilteredList[index]
        for item in self.arrFilteredList {
            item.isSelected = false
            if item.cityMasterId == object.cityMasterId {
                item.isSelected = true
            }
        }
    }
    
    func getSelectedObject() ->  CityListModel? {
        let arrTemp = self.arrFilteredList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func manageSearch(keyword: String) {
        if keyword.trim() == "" {
            self.arrFilteredList = self.arrList
        }
        else {
            self.arrFilteredList = self.arrList.filter({ return $0.cityName.lowercased().contains(keyword.lowercased())})
        }
    }
    
    func managePagenation(tblView: UITableView,
                          state_name: String,
                          index: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.cityListAPI(tblView: tblView,
                                         withLoader: false,
                                         state_name: state_name) { [weak self] (isDone) in
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
extension SelectCityVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                state_name: String,
                                withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.cityListAPI(tblView: tblView,
                         withLoader: withLoader,
                         state_name: state_name) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
            self.arrFilteredList = self.arrList
            if isLoaded {
                tblView?.reloadData()
            }
            else {
                tblView?.reloadData()
            }
        }
    }
    
    func cityListAPI(tblView: UITableView? = nil,
                             withLoader: Bool,
                             state_name: String,
                             completion: ((Bool) -> Void)?){
        
        
        var params                      = [String : Any]()
        params["state_name"]            = state_name
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.city_list_by_state_name), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [CityListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = CityListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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
}



