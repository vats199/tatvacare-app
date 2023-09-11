//
//  LoginWithPassVM.swift
//
//

//

import Foundation

class AskExpertQuestionVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    var arrDocumentList : [DocumentData]    = []
    var object                              = AskExpertListModel()
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension AskExpertQuestionVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(question: String,
                             topic_ids: [String],
                             documents: [[String:Any]]) -> AppError? {
        
        if question.trim() == "" {
            return AppError.validation(type: .enterQuestion)
        }
        else if topic_ids.count == 0 {
            return AppError.validation(type: .selectCategory)
        }
        return nil
    }
}

// MARK: Web Services
extension AskExpertQuestionVM {
    
    func apiCall(vc: UIViewController,
                 content_master_id: String,
                 question: String,
                 topic_ids: [String],
                 documents: [[String:Any]],
                 isEdit: Bool) {
        
        
        // Check validation
        
        if let error = self.isValidView(question: question,
                                        topic_ids: topic_ids,
                                        documents: documents) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
//        UserModel.shared.storeUserEntryDetails(withJSON: response.data)
//        UIApplication.shared.manageLogin()
        //LocationManager.shared.getLocation()
        
        /*
         Request :- {"documents":[],"question":"How to meditate?","topic_ids":["2ee9d703-24e8-11ec-ba54-00ff316bafd7","3c02b4d2-24e8-11ec-ba54-00ff316bafd7"]}
         ["document:"abc.jpg", document_type:""]
         
         {
         question*    string
         topic_ids*    [...]
         documents*    [...]
        
         Photo/PDF
         }
         */
        
        var params                  = [String : Any]()
        params["content_master_id"] = content_master_id
        params["question"]          = question
        params["topic_ids"]         = topic_ids
        params["documents"]         = documents
        
        var api_name = ApiEndPoints.content(.post_question)
        if isEdit {
            api_name = ApiEndPoints.content(.post_question_update)
        }
        else {
            var api_name = ApiEndPoints.content(.post_question)
            
            FIRAnalytics.FIRLogEvent(eventName: .USER_POST_QUESTION,
                                     screen: .PostQuestion,
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
        
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            case .success(let response):

                switch response.apiCode {
                case .invalidOrFail:

                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    Alert.shared.showSnackBar(response.message)
                    self.object = AskExpertListModel(fromJson: response.data)
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
    
    func documentUploadSetup(image : UIImage? = nil , document : String? = nil,completion : @escaping ((Bool,String) -> Void)){
        ApiManager.shared.addLoader()
        let dispatchGroup = DispatchGroup()
        
        
        //For attach note upload
        dispatchGroup.enter()
        ImageUpload.shared.uploadImage(true,
                                       image,
                                       document,
                                       BlobContainer.kAppContainer,
                                       prefix: .askanexpert) { (str1, str2) in
//                print(str1)
//                print(str2)
            completion(true,str2 ?? "")
            dispatchGroup.leave()
        }
       
        
        dispatchGroup.notify(queue: .main) {
            //When media images upload done
            ApiManager.shared.removeLoader()
        }
    }
}

