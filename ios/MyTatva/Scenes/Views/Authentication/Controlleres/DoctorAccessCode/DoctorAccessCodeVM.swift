//
//  DoctorAccessCodeVM.swift
//  MyTatva
//
//  Created by 2022M43 on 02/05/23.
//

import Foundation

class DoctorAccessCodeVM {
    
    //MARK: - Class Variables
    
    private(set) var isResult = Bindable<Result<String?, AppError>>()
    
    //MARK: - init
    init() {
        
    }
    
    //---------------------------------------------------------
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
}

//------------------------------------------------------
//MARK: - Validation Methods
extension DoctorAccessCodeVM {
    private func validateView(accessCode:String) ->AppError? {
        
        if accessCode.trim().isEmpty {
            return .validation(type: .enterAccessCode)
        }
        
        return nil
    }
}

//------------------------------------------------------
//MARK: - WS Methods
extension DoctorAccessCodeVM {
    
    func apiDoctorAccessCode(access_code: String) {
        if let error = self.validateView(accessCode: access_code) {
            self.isResult.value = .failure(error)
            return
        }
        GlobalAPI.shared.updateDoctorAccessCodeAPI(access_code: access_code) { [weak self]  (isDone, token)   in
            guard let self = self else {return}
            if isDone {
                self.isResult.value = .success(nil)
            }
        }
    }
}
