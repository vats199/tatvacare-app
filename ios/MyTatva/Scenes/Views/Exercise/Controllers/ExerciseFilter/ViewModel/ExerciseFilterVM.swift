

import Foundation

class ExerciseFilterVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                            = 1
    var isNextPage                      = true
    var strErrorMessage : String        = ""
    var arrList                         = [ExerciseFilterModel]()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension ExerciseFilterVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> ExerciseFilterModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
        //       let object = self.arrListTopicList[index]
        //
        //        for item in self.arrListTopicList {
        //            if item.topicMasterId == object.topicMasterId {
        //                if item.isSelected {
        //                    item.isSelected = false
        //                }
        //                else {
        //                    item.isSelected = true
        //                }
        //            }
        //        }
    }
    
}

//MARK: ---------------- API CALL ----------------------
extension ExerciseFilterVM {
   
    func content_filtersAPI(tblView: UITableView? = nil,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.exercise_filters), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.arrList = ExerciseFilterModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    tblView?.reloadData()
                    self.vmResult.value = .success(nil)
                    
                    break
                case .emptyData:
                    self.strErrorMessage = response.message
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
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}



