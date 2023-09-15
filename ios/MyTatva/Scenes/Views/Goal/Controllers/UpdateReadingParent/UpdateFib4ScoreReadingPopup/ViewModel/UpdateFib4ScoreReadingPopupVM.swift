//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateFib4ScoreReadingPopupVM {
    
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
extension UpdateFib4ScoreReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             SGPT: UITextField,
                             SGOT: UITextField,
                             Platelet: UITextField,
                             reading: UITextField,
                             unit: UITextField,
                             readingListModel: ReadingListModel) -> AppError? {
        
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
//        else if SGPT.text!.trim() == ""{
//            return AppError.validation(type: .enterSGPT)
//        }
        else if SGPT.text!.trim() != "" &&
                    (JSON(SGPT.text!).intValue > kMaximumSGPT ||
                    JSON(SGPT.text!).intValue < kMinimumSGPT) {
            return AppError.validation(type: .enterValidSGPT)
        }
//        else if SGOT.text!.trim() == ""{
//            return AppError.validation(type: .enterSGOT)
//        }
        else if SGOT.text!.trim() != "" &&
                    (JSON(SGOT.text!).intValue > kMaximumSGOT ||
                    JSON(SGOT.text!).intValue < kMinimumSGOT) {
            return AppError.validation(type: .enterValidSGOT)
        }
//        else if Platelet.text!.trim() == ""{
//            return AppError.validation(type: .enterPlatelet)
//        }
        else if Platelet.text!.trim() != "" &&
                    (JSON(Platelet.text!).intValue > kMaxPlatelet ||
                    JSON(Platelet.text!).intValue < kMinPlatelet) {
            return AppError.validation(type: .enterValidPlatelet)
        }
        else if reading.text!.trim() != "" &&
                    (JSON(reading.text!).intValue > kMaxFIB4Score ||
                    JSON(reading.text!).intValue < kMinFIB4Score) {
            return AppError.validation(type: .enterValidFib4Score)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateFib4ScoreReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 SGPT: UITextField,
                 SGOT: UITextField,
                 Platelet: UITextField,
                 reading: UITextField,
                 unit: UITextField,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        SGPT: SGPT,
                                        SGOT: SGOT,
                                        Platelet: Platelet,
                                        reading: reading,
                                        unit: unit,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //reading_value:{height:'10',weight:'10'}
        var reading_value_data              = [String :Any]()
        reading_value_data["sgpt"]          = SGPT.text!
        reading_value_data["sgot"]          = SGOT.text!
        reading_value_data["platelet"]      = Platelet.text!
        
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: reading.text!,
                                                    reading_value_data: reading_value_data,
                                                    isHideMessage: true) { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value     = .success(nil)
            }
        }
    }
}
