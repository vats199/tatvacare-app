//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateWalkDistancePopupVM {
    
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
extension UpdateWalkDistancePopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(date: UITextField,
                             time: UITextField,
                             reading: UITextField,
                             unit: UITextField,
                             readingType: ReadingType,
                             readingListModel: ReadingListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if reading.text!.trim() == ""{
            return AppError.validation(type: .enterReading)
        }
        else if Int(reading.text!) == 0 {
            return AppError.validation(type: .enterReading)
        }
        else if JSON(reading.text!).intValue > kMaxSixMinWalkValue ||
                    JSON(reading.text!).intValue < kMinSixMinWalkValue {
            return AppError.validation(type: .invalidSixMinWalk)
        }
        return nil
    }
}

// MARK: Web Services
extension UpdateWalkDistancePopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 reading: UITextField,
                 unit: UITextField,
                 readingType: ReadingType,
                 duration: Int,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(date: date,
                                        time: time,
                                        reading: reading,
                                        unit: unit,
                                        readingType: readingType,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: reading.text!,
                                                    duration: "\(duration)") { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value     = .success(nil)
            }
        }
    }
}
