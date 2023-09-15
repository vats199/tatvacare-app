
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class SearchFoodVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResultSearch = Bindable<Result<String?, AppError>>()
    
    var pageSearchFood              = 1
    var isNextPageSearchFood        = true
    var arrList                     = [FoodSearchListModel]()
    //var arrFilteredList             = [FoodSearchListModel]()
    var strErrorMessageNoSearch : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension SearchFoodVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> FoodSearchListModel { 
        return self.arrList[index]
    }
    
//    func manageSelection(index: Int) {
//        let object = self.arrList[index]
//        for item in self.arrList {
//            item.isSelected = false
//            if item.stateMasterId == object.stateMasterId {
//                item.isSelected = true
//            }
//        }
//    }
    
//    func getSelectedObject() ->  FoodSearchListModel? {
//        let arrTemp = self.arrList.filter { (obj) -> Bool in
//            return obj.isSelected
//        }
//        return arrTemp.first
//    }
    
    func managePagenationSeachList(tblView: UITableView? = nil,
                                   withLoader: Bool = false,
                                   food_name: String,
                                   index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPageSearchFood {
                    self.pageSearchFood += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.search_foodListAPI(tblView: tblView,
                                            withLoader: withLoader,
                                            food_name: food_name) { (isLoaded) in
                            
                            self.vmResultSearch.value = .success(nil)
                            
                            if let tbl = tblView {
                                tbl.removeBottomIndicator()
                            }
                        }
                    }
                }
            }
        }
    }
    
//    func manageSearch(keyword: String,
//                      tblView: UITableView) {
//        if keyword.trim() == "" {
//            self.arrFilteredList = self.arrList
//            tblView.reloadData()
//        }
//        else {
//            self.arrFilteredList = self.arrList.filter({ return $0.stateName.lowercased().contains(keyword.lowercased())})
//            tblView.reloadData()
//        }
//    }
}

//MARK: ---------------- API CALL ----------------------
extension SearchFoodVM {
    
    @objc func apiCallFromStart_search_food(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                food_name: String) {
        
        self.pageSearchFood                 = 1
        self.isNextPageSearchFood           = true
        self.strErrorMessageNoSearch        = ""
        
        //API Call
        self.search_foodListAPI(tblView: tblView,
                            withLoader: withLoader,
                            food_name: food_name) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultSearch.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func search_foodListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        food_name: String,
                        completion: ((Bool) -> Void)?){
        
        /*
         
         food_name
       }
         */
        
        var params                      = [String : Any]()
        params["food_name"]             = food_name
        params["page"]                  = self.pageSearchFood
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.search_food), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [FoodSearchListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageNoSearch = response.message
                    //Alert.shared.showSnackBar(response.message)
                    if self.pageSearchFood <= 1 {
                        self.arrList.removeAll()
                        tblView?.reloadData()
                    }
                    break
                case .success:
                    
                    var param = [String : Any]()
                    param[AnalyticsParameters.food_name.rawValue] = food_name
                    FIRAnalytics.FIRLogEvent(eventName: .USER_SEARCHED_FOOD_DISH,
                                             screen: .SearchFood,
                                             parameter: param)
                    
                    returnVal = true
                    if self.pageSearchFood <= 1 {
                        self.arrList.removeAll()
                        tblView?.reloadData()
                    }

                    arr = FoodSearchListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageSearchFood = false
                    
                    if self.pageSearchFood <= 1 {
                        self.strErrorMessageNoSearch = response.message
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
                
                self.strErrorMessageNoSearch = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}




