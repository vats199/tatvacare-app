//
//  FoodDiaryDetailVM.swift
//  MyTatva
//
//  Created by on 26/10/21.
//

import Foundation


class FoodDiaryDetailVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrData                     = [JSON]()
    var object                      = FoodInsightModel()
    
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Question Data ----------------------
extension FoodDiaryDetailVM {
    
    func getCount() -> Int {
        return self.arrData.count
    }
    
    func getObject(index: Int) -> JSON {
        return self.arrData[index]
    }
    
//    func manageRecordPagenation(tblView: UITableView,index: Int){
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            if index == self.arrData.count - 1 {
//                if self.isNextPage {
//                    self.page += 1
//
//                    if self.arrData.count > 0 {
//
//                        self.foodDetailAPI(tblView1: tblView,
//                                           tblView2: tblView, withLoader: false) { (isDone) in
//                            self.vmResult.value = .success(nil)
//                            tblView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
    
}

//MARK: ---------------- API CALL FOR Question ----------------------
extension FoodDiaryDetailVM {
    
    func foodDetailAPI(insight_date: String,
                       withLoader: Bool,
                       completion: ((Bool) -> Void)?){
        
        //insight_date
        
        var params              = [String : Any]()
        params["insight_date"]  = insight_date
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
//
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.food_insight), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    FIRAnalytics.FIRLogEvent(eventName: .USER_VIEWED_DAILY_INSIGHT,
                                             screen: .FoodDiaryDayInsight,
                                             parameter: nil)
                    self.object = FoodInsightModel(fromJson: response.data)
                    returnVal = true
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
                self.strErrorMessage = error.localizedDescription
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
