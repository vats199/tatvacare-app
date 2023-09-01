//
//
//

import Foundation

class UpdateTotalCholesterolReadingPopupVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    var achieved_datetime  = Date()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension UpdateTotalCholesterolReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             txtLDL: UITextField,
                             txtHDL: UITextField,
                             txtTriglyceride: UITextField,
                             txtTotalCholesterol: UITextField,
                             readingListModel: ReadingListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
//        else if txtLDL.text!.trim() == ""{
//            return AppError.validation(type: .enterLDL)
//        }
        else if txtLDL.text!.trim() != "" &&
                    (JSON(txtLDL.text!).intValue > kMaximumLDL ||
                    JSON(txtLDL.text!).intValue < kMinimumLDL) {
            return AppError.validation(type: .enterValidLDL)
        }
//        else if txtHDL.text!.trim() == ""{
//            return AppError.validation(type: .enterHDL)
//        }
        else if txtHDL.text!.trim() != "" &&
                    (JSON(txtHDL.text!).intValue > kMaximumHDL ||
                    JSON(txtHDL.text!).intValue < kMinimumHDL) {
            return AppError.validation(type: .enterValidHDL)
        }
//        else if txtTriglyceride.text!.trim() == ""{
//            return AppError.validation(type: .enterTriglyceride)
//        }
        else if txtTriglyceride.text!.trim() != "" &&
                    (JSON(txtTriglyceride.text!).intValue > kMaximumTriglyceride ||
                    JSON(txtTriglyceride.text!).intValue < kMinimumTriglyceride) {
            return AppError.validation(type: .enterValidTriglyceride)
        }
        else if txtTotalCholesterol.text!.trim() == ""{
            return AppError.validation(type: .enterTotalCholesterol)
        }
        else if txtTotalCholesterol.text!.trim() != "" &&
                    (JSON(txtTotalCholesterol.text!).intValue > kMaximumTotalCholesterol ||
                    JSON(txtTotalCholesterol.text!).intValue < kMinimumTotalCholesterol) {
            return AppError.validation(type: .enterValidTotalCholesterol)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateTotalCholesterolReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 txtLDL: UITextField,
                 txtHDL: UITextField,
                 txtTriglyceride: UITextField,
                 txtTotalCholesterol: UITextField,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        txtLDL: txtLDL,
                                        txtHDL: txtHDL,
                                        txtTriglyceride: txtTriglyceride,
                                        txtTotalCholesterol: txtTotalCholesterol,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //reading_value:{diastolic:'10',systolic:'10'}
        var reading_value_data                      = [String :Any]()
        reading_value_data["ldl_cholesterol"]       = txtLDL.text!
        reading_value_data["hdl_cholesterol"]       = txtHDL.text!
        reading_value_data["triglycerides"]         = txtTriglyceride.text!
        
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: txtTotalCholesterol.text!,
                                                    reading_value_data: reading_value_data) { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value     = .success(nil)
            }
        }
    }
}
