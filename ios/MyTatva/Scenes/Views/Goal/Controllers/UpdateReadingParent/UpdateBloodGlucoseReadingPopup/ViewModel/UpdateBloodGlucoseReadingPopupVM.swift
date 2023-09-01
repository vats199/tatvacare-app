//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateBloodGlucoseReadingPopupVM {
    
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
extension UpdateBloodGlucoseReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             txtFastBlood: UITextField,
                             txtFastBloodUnit: UITextField,
                             txtPPBlood: UITextField,
                             txtPPBloodUnit: UITextField,
                             readingListModel: ReadingListModel) -> AppError? {
        
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if txtFastBlood.text!.trim() == ""{
            return AppError.validation(type: .enterFastBlood)
        }
        else if JSON(txtFastBlood.text!).intValue > kMaxFastBlood || JSON(txtFastBlood.text!).intValue < kMinFastBlood {
            return AppError.validation(type: .invalidFastBlood)
        }
        else if txtPPBlood.text!.trim() == ""{
            return AppError.validation(type: .enterPPBlood)
        }
        else if JSON(txtPPBlood.text!).intValue > kMaxPPBlood || JSON(txtPPBlood.text!).intValue < kMinPPBlood {
            return AppError.validation(type: .invalidPPBlood)
        }
        
        
        
        return nil
    }
}

// MARK: Web Services
extension UpdateBloodGlucoseReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 txtFastBlood: UITextField,
                 txtFastBloodUnit: UITextField,
                 txtPPBlood: UITextField,
                 txtPPBloodUnit: UITextField,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        txtFastBlood: txtFastBlood,
                                        txtFastBloodUnit: txtFastBloodUnit,
                                        txtPPBlood: txtPPBlood,
                                        txtPPBloodUnit: txtPPBloodUnit,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
       
        
        //blood_glucose send data like reading_value:{fast:'10',pp:'10'}
        var reading_value_data              = [String :Any]()
        reading_value_data["fast"]          = txtFastBlood.text!
        reading_value_data["pp"]            = txtPPBlood.text!
        
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
