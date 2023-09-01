

import Foundation

class AskExpertFilterVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
//    var page                        = 1
//    var isNextPage                  = true
//    //var arrList                     = [DoseListModel]()
    var strErrorMessage : String    = ""
    var object                      = ContenFilterListModel()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension AskExpertFilterVM {
    
}

//MARK: ---------------- API CALL ----------------------
extension AskExpertFilterVM {
   
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.ask_an_expert_filters), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.object = ContenFilterListModel(fromJson: response.data)
                    self.vmResult.value = .success(nil)
                    
                    break
                case .emptyData:
                    self.strErrorMessage = response.message
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
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}



