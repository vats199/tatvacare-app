//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateSleepPopupVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult   = Bindable<Result<String?, AppError>>()
    var achieved_datetime       = Date()
    var startTime               = Date()
    var endTime                 = Date()
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension UpdateSleepPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             startTime: UITextField,
                             endTime: UITextField,
                             goalListModel: GoalListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if startTime.text!.trim() == ""{
            return AppError.validation(type: .selectStartDateTime)
        }
        else if endTime.text!.trim() == ""{
            return AppError.validation(type: .selectEndDateTime)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateSleepPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 startTime: UITextField,
                 endTime: UITextField,
                 goalListModel: GoalListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        startTime: startTime,
                                        endTime: endTime,
                                        goalListModel: goalListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
       
        let start_Time = GFunction.shared.convertDateFormate(dt: startTime.text!,
                                                           inputFormat:  appDateTimeFormat,
                                                           outputFormat: appDateFormat + appTimeFormat,
                                                           status: .NOCONVERSION)
        
        let end_Time = GFunction.shared.convertDateFormate(dt: endTime.text!,
                                                           inputFormat:  appDateTimeFormat,
                                                           outputFormat: appDateFormat + appTimeFormat,
                                                           status: .NOCONVERSION)
        
        let differenceMinutes = Calendar.current.dateComponents([.minute], from: start_Time.1, to: end_Time.1)
        print(differenceMinutes)
        let hours:Double = Double(differenceMinutes.minute ?? 0 * 1) / 60
        
        GlobalAPI.shared.update_goal_logsAPI(goal_id: goalListModel.goalMasterId,
                                             achieved_value: "\(hours)",
                                             patient_sub_goal_id: "",
                                             start_time: startTime.text!,
                                             end_time: endTime.text!,
                                             achieved_datetime: end_Time.0) { [weak self] (isDone, date, startTime, endTime) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.startTime          = startTime
                self.endTime            = endTime
                self.vmResult.value     = .success(nil)
            }
        }
    }
}
