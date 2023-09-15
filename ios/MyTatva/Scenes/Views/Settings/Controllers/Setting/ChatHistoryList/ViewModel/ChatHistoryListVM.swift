
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class ChatHistoryListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [HealthCoachListModel]()
    var strErrorMessage : String    = ""
//    var listSnapshot: snapshot!
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension ChatHistoryListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> HealthCoachListModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
        let object = self.arrList[index]
        for item in self.arrList {
            item.isSelected = false
            if item.healthCoachId == object.healthCoachId {
                item.isSelected = true
            }
        }
    }
    
    func getSelectedObject() ->  HealthCoachListModel? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func managePagenation(list_type: String,
                          tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.health_coachListAPI(list_type: list_type,
                                                 tblView: tblView,
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
extension ChatHistoryListVM {
    
    @objc func apiCallFromStart(list_type: String,
                                refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.health_coachListAPI(list_type: list_type,
                                 tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    
    func health_coachListAPI(list_type: String,
                             tblView: UITableView? = nil,
                             withLoader: Bool,
                             completion: ((Bool) -> Void)?){
        
        
        //list_type
        var params                      = [String : Any]()
        params["list_type"]             = list_type
        
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.linked_health_coach_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [HealthCoachListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = HealthCoachListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
                    
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
    
    //MARK: ---------------- update_healthcoach_chat_initiate API ----------------------
    func update_healthcoach_chat_initiateAPI(health_coach_ids: [String],
                           completion: ((Bool) -> Void)?){
        //email
        
        var params                      = [String : Any]()
        params["health_coach_ids"]      = health_coach_ids
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.update_healthcoach_chat_initiate), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    
                    //Alert.shared.showSnackBar(response.message)
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
                
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}



