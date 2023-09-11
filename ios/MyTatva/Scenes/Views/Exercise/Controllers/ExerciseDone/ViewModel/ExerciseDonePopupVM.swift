//
//  ExerciseDonePopupVM.swift
//  MyTatva
//
//  Created by hyperlink on 27/10/21.
//

import Foundation

class ExerciseDonePopupVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


// MARK: Web Services
extension ExerciseDonePopupVM {
    
    func apiCall(isDone : Bool,completion : @escaping (Bool) -> Void) {
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.report_comment), methodType: .post, parameter: [:], withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    self.vmResult.value = .success(nil)
                    Alert.shared.showSnackBar(response.message)
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
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
                completion(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
}
