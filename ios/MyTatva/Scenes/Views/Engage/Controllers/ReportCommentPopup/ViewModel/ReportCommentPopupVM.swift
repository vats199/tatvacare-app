//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class ReportCommentPopupVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension ReportCommentPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             quantity: String,
                             container: UITextField,
                             goalListModel: GoalListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if container.text!.trim() == ""{
            return AppError.validation(type: .selectContainer)
        }
        
        return nil
    }
}

// MARK: Web Services
extension ReportCommentPopupVM {
    
    func apiCall(vc: UIViewController,
                 content_master_id: String,
                 content_type: String,
                 content_comments_id: String,
                 reported: String,
                 description: String,
                 report_type: String,
                 isReport : Bool,
                 screen: ScreenName,
                 completion : @escaping (Bool) -> Void) {
        
        // Check validation
//        if let error = self.isValidView(vc: vc,
//                                        date: date,
//                                        time: time,
//                                        quantity: quantity,
//                                        container: container,
//                                        goalListModel: goalListModel) {
//
//            //Set data for binding
//            self.vmResult.value = .failure(error)
//            return
//        }
        
        /*
         {
         content_master_id*    string
         content_comments_id*    string
         reported*    string
         Y to report N to remove report
         
         Enum:
         Array [ 2 ]
         description    string
         Description of the report
         
         report_type*    string
         S - Spam, I - Inappropriate, F - False information
         
         Enum:
         Array [ 3 ]
         
         }
         */
        
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
        params["content_comments_id"]   = content_comments_id
        params["reported"]              = reported
        if isReport{
            params["description"]           = description
            params["report_type"]           = report_type
        }

        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.report_comment), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    self.vmResult.value = .success(nil)
                    Alert.shared.showSnackBar(response.message)
                    var params = [String: Any]()
                    params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
                    params[AnalyticsParameters.content_type.rawValue]      = content_type
                    
                    if reported == "N"{
                        FIRAnalytics.FIRLogEvent(eventName: .USER_UN_REPORTED_COMMENT, parameter: params)
                    }else{
                        FIRAnalytics.FIRLogEvent(eventName: .USER_REPORTED_COMMENT, parameter: params)
                    }
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
                completion(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
}
