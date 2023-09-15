//
//  AddSupportQuestionPopupVM.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import Foundation


class AddSupportQuestionPopupVM{

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
   
    var arrQueryType : [QueryReasonListModel] = []
    var result                     = JSON()
    var strErrorMessage = ""
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension AddSupportQuestionPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(query_reason_master_id : String,
                             description: String,query_docs : [String]) -> AppError? {
        
        if query_reason_master_id.trim() == ""{
            return AppError.validation(type: .Selectwhatabout)
        }
        else if description.trim() == ""{
            return AppError.validation(type: .enterQuestion)
        }
//        else if query_docs.count <= 0{
//            return AppError.validation(type: .uploadAttachment)
//        }
        
        return nil
    }
}

//MARK: ---------------- API CALL ----------------------
extension AddSupportQuestionPopupVM {
    
    
    func apiAddSupportQuestion(withLoader: Bool,query_reason_master_id : String,
                               description: String,query_docs : [String],
                               completion: ((Bool) -> Void)?){
        // Check validation
        if let error = self.isValidView(query_reason_master_id: query_reason_master_id, description: description, query_docs: query_docs) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        //        var imageTitle = ""
        //        if query_docs.count > 0{
        //            attachnmentUploadSetup(image: query_docs[0], document: nil) { status, title in
        //                imageTitle = title
        //                uploadData()
        //            }
        //        }

        var params                      = [String : Any]()
        params["query_reason_master_id"] = query_reason_master_id
        params["description"] = description
        params["query_docs"] = query_docs
        /*{
         "query_reason_master_id": "string",
         "description": "string",
         "query_docs": "string"
         }*/
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.send_query), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    FIRAnalytics.FIRLogEvent(eventName: .USER_SENT_QUERY,
                                             screen: .FaqQuery,
                                             parameter: nil)
                    self.vmResult.value = .success(response.message)
//                    Alert.shared.showSnackBar(response.message)
                    returnVal = true
                    break
                case .emptyData:
                    
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
                
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    func attachnmentUploadSetup(image : UIImage? = nil , document : String? = nil,completion : @escaping ((Bool,String) -> Void)){
        ApiManager.shared.addLoader()
        let dispatchGroup = DispatchGroup()
        
        
        //For attach note upload
        dispatchGroup.enter()
        ImageUpload.shared.uploadImage(true,
                                       image,
                                       document,
                                       BlobContainer.kAppContainer,
                                       prefix: .support) { (str1, str2) in
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
    
    func queryReasonListAPI(withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        let params              = [String : Any]()
        
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.query_reason_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    let arr = QueryReasonListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrQueryType.append(arr)
                  //  self.arrNotification.removeAll()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.strErrorMessage = response.message
//                    self.isNextPage = false
//
//                    if self.page <= 1 {
//                        self.strErrorMessage = response.message
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
