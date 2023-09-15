//
//  ExerciseStartVM.swift
//  MyTatva
//
//  Created by hyperlink on 27/10/21.
//

import Foundation

class ExerciseStartVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult       = Bindable<Result<String?, AppError>>()
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension ExerciseStartVM {
    
    
    func update_goal_logsAPI(goal_id: String,achieved_value: String,
                             patient_sub_goal_id: String,
                             start_time: String,
                             end_time: String,
                             achieved_datetime: String,
                        completion: ((Bool, Date) -> Void)?){
        
        let params              = [String : Any]()
        
        
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
        
        GlobalAPI.shared.update_goal_logsAPI(goal_id: goal_id,
                                             achieved_value: achieved_value,
                                             patient_sub_goal_id: patient_sub_goal_id,
                                             start_time: start_time,
                                             end_time: end_time,
                                             achieved_datetime: achieved_datetime) { (isDone, date, startTime, endTime) in
            
            completion?(isDone, date)
        }

    }
}
