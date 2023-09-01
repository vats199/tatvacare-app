//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdatePranayamPopupVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult   = Bindable<Result<String?, AppError>>()
    var achieved_datetime       = Date()
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension UpdatePranayamPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             pranayam_duration: String,
                             goalListModel: GoalListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdatePranayamPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 pranayam_duration: String,
                 goalListModel: GoalListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        pranayam_duration: pranayam_duration,
                                        goalListModel: goalListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.update_goal_logsAPI(goal_id: goalListModel.goalMasterId,
                                             achieved_value: pranayam_duration,
                                             patient_sub_goal_id: "",
                                             start_time: "",
                                             end_time: "",
                                             achieved_datetime: date.text! + time.text!) { [weak self] (isDone, date, startTime, endTime) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value = .success(nil)
            }
        }
        
//        GlobalAPI.shared.forgotPasswordAPI(email: email) { (isDone) in
//            if isDone {
//                self.forgotPasswordResult.value = .success(nil)
//            }
//        }
    }
}
