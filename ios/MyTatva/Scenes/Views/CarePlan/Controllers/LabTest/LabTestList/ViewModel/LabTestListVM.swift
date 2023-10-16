
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class LabTestListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmArrayResult = Bindable<Result<String?, AppError>>()
    private(set) var isRemovedFromCart = Bindable<Bool>()
    
    var pageTest                        = 1
    var isNextPageTest                  = true
    var arrTestList                     = [BookTestListModel]()
    
    var pagePkg                         = 1
    var isNextPagePkg                   = true
    var arrPkgList                      = [BookTestListModel]()
    
    var strCall                         = ""
    var strErrorTestMessage : String    = ""
    var strErrorPkgMessage : String     = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension LabTestListVM {
    
    func getTestCount() -> Int {
        return self.arrTestList.count
    }
    
    func getPkgCount() -> Int {
        return self.arrPkgList.count
    }
    
    func getTestObject(index: Int) -> BookTestListModel {
        return self.arrTestList[index]
    }
    
    func getPkgObject(index: Int) -> BookTestListModel {
        return self.arrPkgList[index]
    }
    
    func manageTestPagenation(separate: String,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrTestList.count - 1 {
                if self.isNextPageTest {
                    self.pageTest += 1
                    
                    if self.arrTestList.count > 0 {
                        
                        self.tests_list_homeAPI(separate: separate,
                                                withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmArrayResult.value = .success(nil)
                        }
                    }
                }
            }
        }
    }
    
    func manageReadingPagenation(separate: String,
                                 index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrPkgList.count - 1 {
                if self.isNextPagePkg {
                    self.pagePkg += 1
                    
                    if self.arrPkgList.count > 0 {
                        
                        self.tests_list_homeAPI(separate: separate,
                                                withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmArrayResult.value = .success(nil)
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- API CALL for Tests ----------------------
extension LabTestListVM {
    
    @objc func apiCallFromStart_test(refreshControl: UIRefreshControl? = nil,
                                        separate: String,
                                        withLoader: Bool = false) {
        
        self.arrTestList.removeAll()
        self.arrPkgList.removeAll()
        self.pageTest               = 1
        self.pagePkg                = 1
        self.isNextPageTest         = true
        self.isNextPagePkg          = true
        
        //API Call
        self.tests_list_homeAPI(separate: separate,
                                withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmArrayResult.value = .success(nil)
            if isLoaded {
                
            }
            else {
            }
        }
    }
    
    
    func tests_list_homeAPI(separate: String,
                            withLoader: Bool,
                            completion: ((Bool) -> Void)?){
        
        
        var params              = [String : Any]()
        params["separate"]      = separate
        //params["page"]                  = self.pageReading
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.tests_list_home), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr1                = [BookTestListModel]()
                var arr2                = [BookTestListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr1 = BookTestListModel.modelsFromDictionaryArray(array: response.data["tests"].arrayValue)
                    self.arrTestList.append(contentsOf: arr1)
                    
                    arr2 = BookTestListModel.modelsFromDictionaryArray(array: response.data["packages"].arrayValue)
                    self.arrPkgList.append(contentsOf: arr2)
                    
                    self.strCall = response.data["call"]["mobile"].stringValue
                    break
                case .emptyData:
                    
                    returnVal = true
//                    self.isNextPageReading = false
//
//                    if self.pageReading <= 1 {
//                        self.strErrorReadingMessage = response.message
//                        self.arrReadingList.removeAll()
//
//                        //GFunction.shared.addErrorLabel(view: self.view, errorMessage: response.message)
//                        //GFunction.shared.showSnackBar(response.message)
//                    }
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

//MARK: ---------------- Cart APIs ----------------------
extension LabTestListVM {
    
    func updateCartAPI(isAdd: Bool,
                       code: String,
                       labTestId: String,
                       screen: ScreenName,
                       completion: ((Bool) -> Void)?){
        /*
         
         {
           "code": "string"
         }
         */
        
        var params                  = [String : Any]()
        params["code"]              = code
        
        var apiName = ApiEndPoints.tests(.remove_from_cart)
        if isAdd {
            apiName = ApiEndPoints.tests(.add_to_cart)
        }
        
        ApiManager.shared.makeRequest(method: apiName, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
//                    Alert.shared.showSnackBar(response.message)
                    kIsCartModified = true
                    self.isRemovedFromCart.value = true
                    /*if isAdd {
                        var params1 = [String: Any]()
                        params1[AnalyticsParameters.lab_test_id.rawValue]  = labTestId
                        FIRAnalytics.FIRLogEvent(eventName: .TEST_ADDED_TO_CART,
                                                 screen: screen,
                                                 parameter: params1)
                    }
                    else {
                        var params1 = [String: Any]()
                        params1[AnalyticsParameters.lab_test_id.rawValue]  = labTestId
                        FIRAnalytics.FIRLogEvent(eventName: .TEST_REMOVED_FROM_CART,
                                                 screen: screen,
                                                 parameter: params1)
                    }*/
                    
                    break
                case .emptyData:
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
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
