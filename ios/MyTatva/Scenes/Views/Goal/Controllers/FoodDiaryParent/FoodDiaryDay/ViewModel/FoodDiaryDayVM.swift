
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class FoodDiaryDayVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult                   = Bindable<Result<String?, AppError>>()
    var pageContentList                         = 1
    var isNextPageContentList                   = true
    var arrListContentList                      = [ContentListModel]()
    var strErrorMessageContentList : String     = ""
    

    var object                                  = FoodDiaryDayModel()
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Enage Content List API ----------------------
extension FoodDiaryDayVM {
    
    func foodLogsListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        insight_date: String){
        
        /*
         YYYY-MM-DD
        
         "insight_date": "string",
        
       }
         */
        
        var params                      = [String : Any]()
        //params["page"]                  = self.pageContentList
        params["insight_date"]          = insight_date
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.food_logs), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    self.object = FoodDiaryDayModel(fromJson: response.data)
                    self.vmResult.value = .success(nil)
                    
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
                
                break
                
            case .failure(let error):
                
                self.strErrorMessageContentList = error.localizedDescription
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
