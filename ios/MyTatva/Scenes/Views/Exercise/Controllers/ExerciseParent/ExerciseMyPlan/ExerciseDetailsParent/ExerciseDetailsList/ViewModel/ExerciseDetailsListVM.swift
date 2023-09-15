
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ExerciseDetailsListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResultContentList = Bindable<Result<String?, AppError>>()
    var pageContentList                         = 1
    var isNextPageContentList                   = true
    var arrListContentList                      = [ContentListModel]()
    var object                                  : ExerciseDetailListModel!
    var strErrorMessageContentList : String     = ""
    
    var arrContent = ["<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>","<p>Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>"]
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: ---------------- Enage Content List API ----------------------
extension ExerciseDetailsListVM {
    
    func plan_days_details_API(withLoader: Bool,
                               exercise_plan_day_id: String,
                               routine: String = "",
                               plan_type: String,
                               type: String,
                               completion: ((Bool) -> Void)?){
        
        /*
         
         "exercise_plan_day_id": "string",
         "type": "A"
       }
         */
        
        var params                      = [String : Any]()
        params["exercise_plan_day_id"]  = exercise_plan_day_id
        
        var api_name = ApiEndPoints.content(.plan_days_details_by_id)
        if plan_type == "custom" {
            api_name = ApiEndPoints.content(.exercise_plan_days_details_by_id_custom)
            
            params["routine"]               = routine
            params["type"]                  = type
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageContentList = response.message
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    self.object = ExerciseDetailListModel(fromJson: response.data)
                    returnVal = true
                    
                    break
                case .emptyData:
                    self.strErrorMessageContentList = response.message
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
                self.strErrorMessageContentList = error.localizedDescription
//                Alert.shared.showSnackBar(error.localizedDescription)
                completion?(returnVal)
                
                break
                
            }
        }
    }
    
    func updateBreathingexerciseLogApi(withLoader: Bool,
                                       exercise_plan_day_id: String,
                                       routine: String,
                                       type : String,
                                       plan_type: String,
                                       add_type: String,
                                       completion: ((Bool) -> Void)?){
        
        /*
         
         {
           "exercise_plan_day_id": "string",
           "routine": "string",
           "type": "B"
         }
       }
         */
        
        var params                      = [String : Any]()
        params["exercise_plan_day_id"]  = exercise_plan_day_id
        params["type"]                  = type
        
        var api_name = ApiEndPoints.content(.update_breathing_exercise_log)
        if plan_type == "custom" {
            api_name = ApiEndPoints.content(.update_breathing_exercise_logs_custom)
            params["routine"]               = routine
            params["add_type"]              = add_type
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    var params              = [String : Any]()
                    params[AnalyticsParameters.exercise_plan_day_id.rawValue]  = exercise_plan_day_id
                    params[AnalyticsParameters.type.rawValue] = type
                    FIRAnalytics.FIRLogEvent(eventName: .USER_MARKED_VIDEO_DONE_EXERCISE,
                                             screen: .ExercisePlanDayDetail,
                                             parameter: params)
                    
                    
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
                Alert.shared.showSnackBar(error.localizedDescription)
                completion?(returnVal)
                
                break
                
            }
        }
    }
    
    
}
