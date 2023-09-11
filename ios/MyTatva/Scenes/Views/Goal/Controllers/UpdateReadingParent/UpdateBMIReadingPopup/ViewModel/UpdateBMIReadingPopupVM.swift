//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateBMIReadingPopupVM {
    
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
extension UpdateBMIReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(vc: UIViewController,
                             date: UITextField,
                             time: UITextField,
                             heightUnit: String,
                             weightUnit: String,
                             heightCm: String,
                             heightFt: String? = "",
                             heightIn: String? = "",
                             weightKg: String,
                             weightLbs: String? = "",
                             reading: UITextField,
                             readingListModel: ReadingListModel) -> AppError? {
        
        let heightUnitVal   = HeightUnit.init(rawValue: heightUnit) ?? .cm
        let weightUnitVal   = WeightUnit.init(rawValue: weightUnit) ?? .kg
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if heightCm.trim() == ""{
            return AppError.validation(type: .enterHeight)
        }
        if heightCm.trim() == ""{
            return AppError.validation(type: .enterHeight)
        }
        switch heightUnitVal {
            
        case .cm:
            if JSON(heightCm).intValue > kMaxHeightCm || JSON(heightCm).intValue < kMinHeightCm{
                return AppError.validation(type: .enterValidHeightCm)
            }
            break
        case .feet_inch:
            if (JSON(heightFt!).intValue >= kMaxHeightFt && JSON(heightIn!).intValue > 0)
                || JSON(heightFt!).intValue < kMinHeightFt{
                return AppError.validation(type: .enterValidHeightFt)
            }
            else if heightIn!.trim() == ""{
                return AppError.validation(type: .enterHeight)
            }
            break
        }
        
        if weightKg.trim() == ""{
            return AppError.validation(type: .enterWeight)
        }
        switch weightUnitVal {
        case .kg:
            if JSON(weightKg).doubleValue > JSON(kMaxBodyWeightKg).doubleValue ||
                        JSON(weightKg).doubleValue < JSON(kMinBodyWeightKg).doubleValue {
                return AppError.validation(type: .enterValidWeightKg)
            }
            break
        case .lbs:
            if JSON(weightLbs!).doubleValue > JSON(kMaxBodyWeightLbs).doubleValue ||
                        JSON(weightLbs!).doubleValue < JSON(kMinBodyWeightLbs).doubleValue {
                return AppError.validation(type: .enterValidWeightLbs)
            }
            break
        }
        if reading.text!.trim() == ""{
            return AppError.validation(type: .enterReading)
        }
        else if JSON(reading.text!).doubleValue > JSON(kMaxBMI).doubleValue ||
                    JSON(reading.text!).doubleValue < JSON(kMinBMI).doubleValue {
            return AppError.validation(type: .invalidBMI)
        }
        
        return nil
    }
}

// MARK: Web Services
extension UpdateBMIReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 heightUnit: String,
                 weightUnit: String,
                 heightCm: String,
                 heightFt: String? = "",
                 heightIn: String? = "",
                 weightKg: String,
                 weightLbs: String? = "",
                 reading: UITextField,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(vc: vc,
                                        date: date,
                                        time: time,
                                        heightUnit: heightUnit,
                                        weightUnit: weightUnit,
                                        heightCm: heightCm,
                                        heightFt: heightFt,
                                        heightIn: heightIn,
                                        weightKg: weightKg,
                                        weightLbs: weightLbs,
                                        reading: reading,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        //reading_value:{height:'10',weight:'10'}
        var reading_value_data              = [String :Any]()
        reading_value_data["height"]        = heightCm
        reading_value_data["weight"]        = weightKg
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: reading.text!,
                                                    reading_value_data: reading_value_data,
                                                    height_unit: heightUnit,
                                                    weight_unit: weightUnit,
                                                    isHideMessage: true) { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {
                self.achieved_datetime  = date
                self.vmResult.value     = .success(nil)
            }
        }
    }
}
