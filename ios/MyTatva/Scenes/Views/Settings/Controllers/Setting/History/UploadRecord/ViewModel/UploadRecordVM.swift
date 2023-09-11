//
//  UploadRecordVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import Foundation

struct DocumentData {
    var title : String!
    var urlPath : String?
    var isImage : Bool!
    var image : UIImage?
}

class UploadRecordsVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                                = 1
    var isNextPage                          = true
    var object                              =  TestTypeModel()
    
    var strErrorMessage : String            = ""
    var arrDocumentList : [DocumentData]    = []
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}
//MARK: ---------------- Update Data ----------------------
extension UploadRecordsVM {
    
    func getDocumentCount() -> Int {
        return self.arrDocumentList.count
    }
    
    func getDocumentObject(index: Int) -> DocumentData {
        return self.arrDocumentList[index]
    }
}

// MARK: Validation Methods
extension UploadRecordsVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(test_type_id : String,
                             test_type  :String,
                             title : String,
                             description : String,
                             document_data : [String]) -> AppError? {
        
        if title.trim() == "" {
            return AppError.validation(type: .enterDocumentTitle)
        }
        else if test_type.trim() == "" {
            return AppError.validation(type: .selectTestType)
        }
//        else if description.trim() == "" {
//            return AppError.validation(type: .enterDescription)
//        }
        else if document_data.count <= 0 {
            return AppError.validation(type: .uploadDocument)
        }
        
        return nil
    }
}

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension UploadRecordsVM {
    
    func uploadRecordAPI(withLoader: Bool,
                         test_type:String,
                         test_type_id : String,
                         title : String,
                         description : String,
                         document_data : [String],
                         completion: ((Bool) -> Void)?){
        
        // Check validation
        
        if let error = self.isValidView(test_type_id: test_type_id,
                                        test_type: test_type,
                                        title: title,
                                        description: description,
                                        document_data: document_data) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        var params              = [String : Any]()
        /*{
          "test_type_id": "string",
          "title": "string",
          "description": "string",
          "document_data": "string"
        }*/
        
        params["test_type_id"]  = test_type_id
        params["title"]         = title
        params["description"]   = description
        params["document_data"] = document_data
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.updated_records), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                var returnVal           = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    FIRAnalytics.FIRLogEvent(eventName: .USER_RECORDS_UPDATED,
                                             screen: .UploadRecord,
                                             parameter: nil)
                    returnVal = true
                self.vmResult.value = .success(nil)
                    
                  //  self.arrNotification.removeAll()
                    
                    break
                case .emptyData:
                    returnVal = true
                    self.strErrorMessage = response.message
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
    
    
    func documentUploadSetup(image : UIImage? = nil , document : String? = nil,completion : @escaping ((Bool,String) -> Void)){
        ApiManager.shared.addLoader()
        let dispatchGroup = DispatchGroup()
        
        
        //For attach note upload
        dispatchGroup.enter()
        ImageUpload.shared.uploadImage(true,
                                       image,
                                       document,
                                       BlobContainer.kAppContainer,
                                       prefix: .record) { (str1, str2) in
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

    
    func testTypeListAPI(withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        let params              = [String : Any]()
        
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.test_types), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.object = TestTypeModel(fromJson: response.data)
//                    let arr = TestTypeListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
//                    self.arrTestType.append(arr)
                  //  self.arrNotification.removeAll()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
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
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
