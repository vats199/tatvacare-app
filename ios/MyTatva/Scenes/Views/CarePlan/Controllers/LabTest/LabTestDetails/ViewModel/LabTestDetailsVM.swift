//
//  FoodDiaryDetailVM.swift
//  MyTatva
//
//  Created by on 26/10/21.
//

import Foundation


class LabTestDetailsVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrData                     = [JSON]()
    var object                      = BookTestListModel()
    
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
extension LabTestDetailsVM {
    
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
extension LabTestDetailsVM {
    
    func test_detailAPI(lab_test_id: String,
                        pincode: String,
                        withLoader: Bool){
        
        //lab_test_id
        var params              = [String : Any]()
        params["lab_test_id"]   = lab_test_id
        params["pincode"]       = pincode
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.test_detail), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.vmResult.value = .failure(AppError.custom(errorDescription: response.message))
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    //FIRAnalytics.FIRLogEvent(eventName: .USER_VIEWED_DAILY_INSIGHT, parameter: nil)
                    self.object = BookTestListModel(fromJson: response.data)
                    self.vmResult.value = .success(nil)
                    break
                case .emptyData:
                    self.vmResult.value = .failure(AppError.custom(errorDescription: response.message))
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
                break
                
            case .failure(let error):
                self.vmResult.value = .failure(AppError.custom(errorDescription: error.localizedDescription))
                //self.strErrorMessage = error.localizedDescription
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
