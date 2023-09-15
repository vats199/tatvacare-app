//
//  LoginWithPassVM.swift
//
//

//

import Foundation

class AskExpertAnswerPopupVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    var arrDocumentList : [DocumentData]    = []
    var object              = AskExpertListModel()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension AskExpertAnswerPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(content_master_id: String,
                             description: String,
                             content_comments_id: String = "") -> AppError? {
        
        if description.trim() == "" {
            return AppError.validation(type: .enterAnswer)
        }
        return nil
    }
}

// MARK: Web Services
extension AskExpertAnswerPopupVM {
    
    func apiCall(vc: UIViewController,
                 content_master_id: String,
                 description: String,
                 content_comments_id: String = "") {
        
        // Check validation
        if let error = self.isValidView(content_master_id: content_master_id,
                                        description: description,
                                        content_comments_id: content_comments_id) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        /*
         {
         content_master_id*    string
         description*    string
         content_comments_id    string
         optional by default. required if answer is going to update
         }
         
         */
        
        var params                      = [String : Any]()
        params["content_master_id"]     = content_master_id
        params["description"]           = description
        
        if content_comments_id.trim() != "" {
            params["content_comments_id"]   = content_comments_id
            
            var params = [String: Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
            params[AnalyticsParameters.content_comments_id.rawValue] = content_comments_id
            FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATE_ANSWER,
                                     screen: .SubmitAnswer,
                                     parameter: params)
        }
        else {
            var params = [String: Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
            FIRAnalytics.FIRLogEvent(eventName: .USER_SUBMIT_ANSWER,
                                     screen: .SubmitAnswer,
                                     parameter: params)
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.update_answer), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            case .success(let response):

                switch response.apiCode {
                case .invalidOrFail:

                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    Alert.shared.showSnackBar(response.message)
                    self.object = AskExpertListModel.init(fromJson: response.data)
                    self.vmResult.value = .success(nil)
                    break
                    

                case .emptyData:

                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:

                    //self.loginResult.value = .failure(.custom(errorDescription: apiData.message))
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
                default:break
                }
                break

            case .failure(let error):

                Alert.shared.showSnackBar(error.localizedDescription)
                break

            }
        }
    }
    
}

