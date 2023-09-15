//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateWaterPopupVM {
    
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
extension UpdateWaterPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             quantity: String,
                             container: UITextField,
                             goalListModel: GoalListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if container.text!.trim() == ""{
            return AppError.validation(type: .selectContainer)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateWaterPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 quantity: String,
                 container: UITextField,
                 goalListModel: GoalListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        quantity: quantity,
                                        container: container,
                                        goalListModel: goalListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.update_goal_logsAPI(goal_id: goalListModel.goalMasterId,
                                             achieved_value: quantity,
                                             patient_sub_goal_id: "",
                                             start_time: "",
                                             end_time: "",
                                             achieved_datetime: date.text! + time.text!) { [weak self] (isDone, date, startTime, endTime) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value     = .success(nil)
            }
        }
        
    }
}
