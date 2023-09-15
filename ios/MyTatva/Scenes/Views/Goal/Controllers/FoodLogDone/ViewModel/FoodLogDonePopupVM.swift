//
//  FoodLogDonePopupVM.swift
//  MyTatva
//
//  Created by on 27/10/21.
//

import Foundation

class FoodLogDonePopupVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult    = Bindable<Result<String?, AppError>>()
    
    var arrList : [JSON]         = [
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
        ]
    ]
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
extension FoodLogDonePopupVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> JSON {
        return self.arrList[index]
    }
}

//MARK: ---------------- API CALL ----------------------
extension FoodLogDonePopupVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView.reloadData()
        
        //API Call
        self.mealCaloriesListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            tblView.reloadData()
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func mealCaloriesListAPI(tblView: UITableView,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.combine(.contactUs), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr                 = [MedicationTodayList]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                   
                    break
                case .emptyData:
                    
                    returnVal = true
                    
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
