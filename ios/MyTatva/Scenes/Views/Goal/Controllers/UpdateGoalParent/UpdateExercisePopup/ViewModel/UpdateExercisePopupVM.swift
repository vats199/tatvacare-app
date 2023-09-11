//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateExercisePopupVM {
    
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
extension UpdateExercisePopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             exercise: UITextField,
                             exercise_duration: String,
                             exerciseListModel: ExerciseListModel,
                             goalListModel: GoalListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if exercise.text!.trim() == ""{
            return AppError.validation(type: .selectExercise)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateExercisePopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 exercise: UITextField,
                 exercise_duration: String,
                 exerciseListModel: ExerciseListModel,
                 goalListModel: GoalListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        exercise: exercise,
                                        exercise_duration: exercise_duration,
                                        exerciseListModel: exerciseListModel,
                                        goalListModel: goalListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.update_goal_logsAPI(goal_id: goalListModel.goalMasterId,
                                             achieved_value: exercise_duration,
                                             patient_sub_goal_id: exerciseListModel.exerciseMasterId,
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
