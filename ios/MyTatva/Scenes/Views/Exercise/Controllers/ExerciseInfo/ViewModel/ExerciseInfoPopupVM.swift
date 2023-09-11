//
//  ExerciseInfoPopupVM.swift
//  MyTatva
//
//  Created by hyperlink on 02/11/21.
//

import Foundation

class ExerciseInfoPopupVM {
    
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
