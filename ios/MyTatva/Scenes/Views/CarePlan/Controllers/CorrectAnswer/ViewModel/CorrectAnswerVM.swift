//
//  CorrectAnswerPopUpVM.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import Foundation

class CorrectAnswerPopUpVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
   
    var result                     = JSON()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: ---------------- API CALL ----------------------
extension CorrectAnswerPopUpVM {
    
    
//    func apiCorrectAns(withLoader: Bool,
//                        completion: ((Bool) -> Void)?){
//
//
//        let params                      = [String : Any]()
//        //params["page"]                  = self.page
//
////        params = params.filter({ (obj) -> Bool in
////            if obj.value as? String != "" {
////                return true
////            }
////            else {
////                return false
////            }
////        })
//
//        print(JSON(params))
//
//        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.dose_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
//
//         var returnVal = false
//
//            switch result {
//            case .success(let response):
//
//                switch response.apiCode {
//                case .invalidOrFail:
//
//                    Alert.shared.showSnackBar(response.message)
//                    break
//                case .success:
//
//                    returnVal = true
//                    break
//                case .emptyData:
//
//                    break
//                case .inactiveAccount:
//
//                    UIApplication.shared.forceLogOut()
//                    Alert.shared.showSnackBar(response.message)
//                    break
//                case .otpVerify:
//                    break
//                case .emailVerify:
//                    break
//                case .forceUpdateApp:
//                    break
//                case .simpleUpdateAlert:
//                    break
//
//                case .socialIdNotRegister:
//                    break
//                case .userSessionExpire:
//                    break
//                case .unknown:
//                    break
//                default: break
//                }
//
//                completion?(returnVal)
//                break
//
//            case .failure(let error):
//
//                completion?(returnVal)
//                Alert.shared.showSnackBar(error.localizedDescription)
//                break
//
//            }
//        }
//    }
}

