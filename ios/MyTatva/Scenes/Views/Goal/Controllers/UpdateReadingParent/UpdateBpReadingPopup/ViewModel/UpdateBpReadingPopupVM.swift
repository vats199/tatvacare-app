//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateBpReadingPopupVM {
    
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
extension UpdateBpReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             txtDiastolic: UITextField,
                             txtSystolic: UITextField,
                             readingListModel: ReadingListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if txtSystolic.text!.trim() == ""{
            return AppError.validation(type: .selectSystolic)
        }
        else if JSON(txtSystolic.text!).intValue > kMaxBPSystolic ||
                    JSON(txtSystolic.text!).intValue < kMinBPSystolic {
            return AppError.validation(type: .invalidSystolic)
        }
        else if txtDiastolic.text!.trim() == ""{
            return AppError.validation(type: .selectDiastolic)
        }
        else if JSON(txtDiastolic.text!).intValue > kMaxBPDiastolic ||
                    JSON(txtDiastolic.text!).intValue < kMinBPDiastolic {
            return AppError.validation(type: .invalidDiastolic)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateBpReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 txtDiastolic: UITextField,
                 txtSystolic: UITextField,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        txtDiastolic: txtDiastolic,
                                        txtSystolic: txtSystolic,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //reading_value:{diastolic:'10',systolic:'10'}
        var reading_value_data              = [String :Any]()
        reading_value_data["diastolic"]     = txtDiastolic.text!
        reading_value_data["systolic"]      = txtSystolic.text!
        
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: "",
                                                    reading_value_data: reading_value_data) { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value = .success(nil)
            }
        }
    }
}
