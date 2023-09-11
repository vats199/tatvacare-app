
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class DaySelectionPopupVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    var isFromPrescription   : Bool = false
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [DaysListModel]()
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
extension DaySelectionPopupVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> DaysListModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
        
        //if object["name"].stringValue.lowercased().contains("All".lowercased()) {
        //            for i in 0...self.arrDays.count - 1 {
        //                var obj  = self.arrDays[i]
        //
        //                obj["isSelected"].intValue = 0
        //                if obj["name"].stringValue == object["name"].stringValue {
        //                    obj["isSelected"].intValue = 1
        //                }
        //                self.arrDays[i] = obj
        //            }
        //        }
        //        else {
        //            for i in 0...self.arrDays.count - 1 {
        //                var obj  = self.arrDays[i]
        //
        //                if obj["name"].stringValue.lowercased().contains("All".lowercased()) {
        //                    obj["isSelected"].intValue = 0
        //                }
        //
        //                if obj["name"].stringValue == object["name"].stringValue {
        //                    if obj["isSelected"].intValue == 1 {
        //                        obj["isSelected"].intValue = 0
        //                    }
        //                    else {
        //                        obj["isSelected"].intValue = 1
        //                    }
        //                }
        //                self.arrDays[i] = obj
        //            }
        //        }
        
        let object = self.arrList[index]
        
        if object.day.lowercased().contains("All".lowercased()) {
            for i in 0...self.arrList.count - 1 {
                let obj  = self.arrList[i]
                
                obj.isSelected = false
                if obj.day == object.day {
                    obj.isSelected = true
                }
            }
        }
        else {
            for item in self.arrList {
                
                if item.day.lowercased().contains("All".lowercased()) {
                    item.isSelected = false
                }
                
                if item.day == object.day {
                    
                    if item.isSelected {
                        item.isSelected = false
                    }
                    else {
                        item.isSelected = true
                    }
                }
            }
        }
        
    }
    
    func getSelectedObject() ->  [DaysListModel]? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp
    }
    
    func managePagenation(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.getDaysListAPI(tblView: tblView,
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
extension DaySelectionPopupVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.getDaysListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            if isLoaded {
                tblView?.reloadData()
            }
            else {
                tblView?.reloadData()
            }
        }
    }
    
    
    func getDaysListAPI(tblView: UITableView? = nil,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.get_days_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [DaysListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = DaysListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    if !self.isFromPrescription {
                        self.arrList = self.arrList.filter({ obj in
                            return obj.daysKeys != "ALL"
                        })
                    }
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



