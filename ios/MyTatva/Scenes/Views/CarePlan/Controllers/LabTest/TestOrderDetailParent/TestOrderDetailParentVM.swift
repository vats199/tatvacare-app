//
//  FoodDiaryDetailVM.swift
//  MyTatva
//
//  Created by on 26/10/21.
//

import Foundation


class TestOrderDetailParentVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrData                     = [JSON]()
    var object                      = LabTestOrderSummaryModel()
    
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
extension TestOrderDetailParentVM {
    
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
extension TestOrderDetailParentVM {
    
    func apiCall(order_master_id: String,
                 withLoader: Bool){
        
        self.order_summaryAPI(order_master_id: order_master_id,
                              withLoader: withLoader) { [weak self] isDone in
            guard let self = self else {return}
            if isDone {
                self.vmResult.value = .success(nil)
            }
            else {
                self.vmResult.value = .failure(AppError.custom(errorDescription: ""))
            }
        }
    }
    
    func order_summaryAPI(order_master_id: String,
                          withLoader: Bool,
                          completion: ((Bool) -> Void)?){
        
        //lab_test_id
        var params                  = [String : Any]()
        params["order_master_id"]   = order_master_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.order_summary), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal = false
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    self.object = LabTestOrderSummaryModel(fromJson: response.data)
                    break
                case .emptyData:
                    self.strErrorMessage = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    self.strErrorMessage = response.message
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
                Alert.shared.showSnackBar(error.localizedDescription)
                
                completion?(returnVal)
                break
                
            }
        }
    }
}
