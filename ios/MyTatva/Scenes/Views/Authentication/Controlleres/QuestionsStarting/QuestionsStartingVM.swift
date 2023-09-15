//
//  QuestionsStartingVM.swift
//  MyTatva
//
//  Created by 2022M43 on 25/07/23.
//

import Foundation

class QuestionsStartingVM {
    
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
//MARK: - WS Methods
extension QuestionsStartingVM {
    
    func apiAccountFor(relation: String, sub_relation: String = "") {
        
        GlobalAPI.shared.signup_AccountForAPI(relation: relation, sub_relation: sub_relation) { [weak self]  (isDone, signup_token)   in
            guard let self = self else {return}
            if isDone {
                self.isResult.value = .success(nil)
               
                FIRAnalytics.FIRLogEvent(eventName: relation == AccountCreationFor.Myself.rawValue ? .NEW_USER_SIGNED_AS_MYSELF : .NEW_USER_SIGNED_AS_SOMEONE_ELSE,
                                         screen: .SelectRole,
                                         parameter: nil)
                
            }
        }
    }
}
