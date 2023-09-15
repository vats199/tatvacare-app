
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class NotificationSettingsVM {

    //MARK:- Class Variable
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [NotificationReminderListModel]()
    var arrFilteredList             = [NotificationReminderListModel]()
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
extension NotificationSettingsVM {
    
    func getCount() -> Int {
        return self.arrFilteredList.count
    }
    
    func getObject(index: Int) -> NotificationReminderListModel {
        return self.arrFilteredList[index]
    }
    
    func manageSelection(index: Int) {
        let object = self.arrFilteredList[index]
        for item in self.arrFilteredList {
            item.isSelected = false
            if item.notificationMasterId == object.notificationMasterId {
                item.isSelected = true
            }
        }
    }
    
    func getSelectedObject() ->  NotificationReminderListModel? {
        let arrTemp = self.arrFilteredList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func managePagenation(tblView: UITableView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.notification_master_listAPI(tblView: tblView,
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
    
    func manageSearch(keyword: String,
                      tblView: UITableView) {
        if keyword.trim() == "" {
            self.arrFilteredList = self.arrList
            tblView.reloadData()
        }
        else {
            self.arrFilteredList = self.arrList.filter({ return $0.title.lowercased().contains(keyword.lowercased())})
            tblView.reloadData()
        }
    }
}

//MARK: ---------------- API CALL ----------------------
extension NotificationSettingsVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.notification_master_listAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
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
    
    
    func notification_master_listAPI(tblView: UITableView? = nil,
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
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.notification_master_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [NotificationReminderListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = NotificationReminderListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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

extension NotificationSettingsVM {
    
    //MARK: ---------------- notification_details API ----------------------
    func notification_detailsAPI(notification_master_id: String,
                                 completion: ((Bool, JSON) -> Void)?){
        
        /*
         4 type of response
         
         Meal
         Water
         Common
         Reading- Vitals
         */
        
        var params                         = [String : Any]()
        params["notification_master_id"]   = notification_master_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.notification_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal   = false
            var object      = JSON()
            
            switch result {
            case .success(let response):
                
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    object      = response.data
                    
//                    let data = JSON(response.data)
//                    let todaysAchievedValue = data["todays_achieved_value"].intValue
//                    let targetValue         = data["goal_value"].intValue
//                    if todaysAchievedValue >= targetValue {
//                        var params              = [String: Any]()
//                        params[AnalyticsParameters.goal_id.rawValue]        = goalMasterId
//                        params[AnalyticsParameters.goal_value.rawValue]     = targetValue
//                        FIRAnalytics.FIRLogEvent(eventName: .GOAL_COMPLETED, parameter: params)
//                    }
                    
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
                
                completion?(returnVal, object)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: ---------------- update_notification_reminder API ----------------------
    func update_notification_reminderAPI(notification_master_id: String,
                                         is_active: Bool,
                                         completion: ((Bool) -> Void)?){
        
        /*
         
         */
        
        var params                          = [String : Any]()
        params["notification_master_id"]    = notification_master_id
        params["is_active"]                 = is_active == true ? "Y" : "N"
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.update_notification_reminder), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal   = false
            
            switch result {
            case .success(let response):
                
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    Alert.shared.showSnackBar(response.message)
                    
                    params[AnalyticsParameters.notification_master_id.rawValue] = notification_master_id
                    if is_active == true {
                        FIRAnalytics.FIRLogEvent(eventName: .USER_ENABLED_NOTIFICATION,
                                                 screen: .NotificationSettings,
                                                 parameter: params)
                    }
                    else {
                        FIRAnalytics.FIRLogEvent(eventName: .USER_DISABLED_NOTIFICATION,
                                                 screen: .NotificationSettings,
                                                 parameter: params)
                    }
                    
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
    
    //MARK: ---------------- update_meal_reminder API ----------------------
    func update_meal_reminderAPI(notification_master_id: String,
                                 meal_data: [[String: Any]],
                                 remind_everyday: String,
                                 remind_everyday_time: String,
                                 completion: ((Bool) -> Void)?){
        
        /*
         
         {
           "meal_data": [
             {
               "meal_types_id": "string",
               "meal_time": "string",
               "is_active": "Y"
             }
           ],
           "notification_master_id": "string",
           "remind_everyday": "Y",
           "remind_everyday_time": "string"
         }
         
         */
        
        var params                          = [String : Any]()
        params["notification_master_id"]    = notification_master_id
        params["meal_data"]                 = meal_data
        params["remind_everyday"]           = remind_everyday
        params["remind_everyday_time"]      = remind_everyday_time
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.update_meal_reminder), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal   = false
            
            switch result {
            case .success(let response):
                
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    Alert.shared.showSnackBar(response.message)
                    
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
    
    //MARK: ---------------- update_readings_notifications API ----------------------
    func update_readings_notificationsAPI(notification_data: [[String: Any]],
                                          completion: ((Bool) -> Void)?){
        
        /*
         {
         {
           "notification_data": [
             {
               "days_of_week": "string",
               "frequency": "string",
               "day_time": "string",
               "readings_master_id": "string",
               "is_active": "Y"
             }
           ]
         }
         
         */
        
        var params                          = [String : Any]()
        params["notification_data"]         = notification_data
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.update_readings_notifications), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal   = false
            
            switch result {
            case .success(let response):
                
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    Alert.shared.showSnackBar(response.message)
                    
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
    
    //MARK: ---------------- update_notification_details API ----------------------
    func update_notification_detailsAPI(notification_master_id: String,
                                        days_of_week: String,
                                        frequency: String,
                                        day_time: String,
                                        goal_type: String,
                                 remind_everyday: String,
                                 remind_everyday_time: String,
                                 completion: ((Bool) -> Void)?){
        
        /*
         
         {
           "notification_master_id": "string",
           "day_time": "string",
           "goal_type": "sleep",
           "remind_everyday": "Y",
           "remind_everyday_time": "string"
         }
         
         */
        
        var params                          = [String : Any]()
        params["notification_master_id"]    = notification_master_id
        params["days_of_week"]              = days_of_week
        params["frequency"]                 = frequency
        params["day_time"]                  = day_time
        params["goal_type"]                 = goal_type
        params["remind_everyday"]           = remind_everyday
        params["remind_everyday_time"]      = remind_everyday_time
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.update_notification_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal   = false
            
            switch result {
            case .success(let response):
                
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    Alert.shared.showSnackBar(response.message)
                    
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
    
    //MARK: ---------------- update_water_reminder API ----------------------
    func update_water_reminderAPI(notification_master_id: String,
                                  notify_from: String,
                                  notify_to: String,
                                  remind_every: String,
                                  total_reminds: String,
                                  remind_everyday: String,
                                  is_active: String,
                                  reminds_type: String,
                                  remind_everyday_time: String,
                                  completion: ((Bool) -> Void)?){
        
        /*
         {
           "notification_master_id": "string",
           "notify_from": "string",
           "notify_to": "string",
           "remind_every": 0,
           "total_reminds": 0,
           "remind_everyday": "Y",
           "is_active": "Y",
           "reminds_type": "H",
           "remind_everyday_time": "string"
         }
         */
        
        var params                          = [String : Any]()
        params["notification_master_id"]    = notification_master_id
        params["notify_from"]               = notify_from
        params["notify_to"]                 = notify_to
        params["remind_every"]              = remind_every
        params["total_reminds"]             = total_reminds
        params["remind_everyday"]           = remind_everyday
        params["is_active"]                 = is_active
        params["reminds_type"]              = reminds_type
        params["remind_everyday_time"]      = remind_everyday_time
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.notificationAPI(.update_water_reminder), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal   = false
            
            switch result {
            case .success(let response):
                
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal   = true
                    Alert.shared.showSnackBar(response.message)
                    
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


