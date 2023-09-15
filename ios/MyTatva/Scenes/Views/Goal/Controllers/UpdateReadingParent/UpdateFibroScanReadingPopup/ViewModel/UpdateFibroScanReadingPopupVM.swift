//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateFibroScanReadingPopupVM {
    
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
extension UpdateFibroScanReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             txtLSM: UITextField,
                             txtCAP: UITextField,
                             readingListModel: ReadingListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if txtLSM.text!.trim() == ""{
            return AppError.validation(type: .enterLSM)
        }
        else if JSON(txtLSM.text!).intValue > kMaximumLSM ||
                    JSON(txtLSM.text!).intValue < kMinimumLSM {
            return AppError.validation(type: .enterValidLSM)
        }
        else if txtCAP.text!.trim() == ""{
            return AppError.validation(type: .enterCAP)
        }
        else if JSON(txtCAP.text!).intValue > kMaximumCAP ||
                    JSON(txtCAP.text!).intValue < kMinimumCAP {
            return AppError.validation(type: .enterValidCAP)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateFibroScanReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 txtLSM: UITextField,
                 txtCAP: UITextField,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        txtLSM: txtLSM,
                                        txtCAP: txtCAP,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //reading_value:{diastolic:'10',systolic:'10'}
        var reading_value_data              = [String :Any]()
        reading_value_data["lsm"]           = txtLSM.text!
        reading_value_data["cap"]           = txtCAP.text!
        
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: "",
                                                    reading_value_data: reading_value_data) { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value     = .success(nil)
            }
        }
    }
}
