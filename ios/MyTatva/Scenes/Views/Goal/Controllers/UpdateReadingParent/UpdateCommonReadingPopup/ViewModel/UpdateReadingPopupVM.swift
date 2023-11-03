//
//  ForgotPasswordViewModel.swift
//
//

import Foundation

class UpdateReadingPopupVM {
    
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
extension UpdateReadingPopupVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(date: UITextField,
                             time: UITextField,
                             reading: String,
                             weightKg: String,
                             weightLbs: String? = "",
                             unit: UITextField,
                             weightUnit: String,
                             readingType: ReadingType,
                             readingListModel: ReadingListModel) -> AppError? {
        
        if date.text!.trim() == ""{
            return AppError.validation(type: .selectDate)
        }
        else if time.text!.trim() == ""{
            return AppError.validation(type: .selectTime)
        }
        else if reading.trim() == ""{
            return AppError.validation(type: .enterReading)
        }
        
        switch readingType {
        case .SPO2:
            
            if JSON(reading).intValue > kMaxSPO2 ||
                JSON(reading).intValue < kMinSPO2 {
                return AppError.validation(type: .invalidSPO2)
            }
            
            return nil
        case .PEF:
            if JSON(reading).intValue > kMaxPEF ||
                JSON(reading).intValue < kMinPEF {
                return AppError.validation(type: .invalidPEF)
            }
            
            return nil
        case .BloodPressure:
            return nil
        case .HeartRate:
            if JSON(reading).intValue > kMaxHeartRate ||
                JSON(reading).intValue < kMinHeartRate {
                return AppError.validation(type: .invalidHeartRate)
            }
            
            return nil
        case .BodyWeight:
            let weightUnitVal   = WeightUnit.init(rawValue: weightUnit) ?? .kg
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
            return nil
        case .BMI:
            return nil
        case .BloodGlucose:
            return nil
        case .HbA1c:
            if JSON(reading).intValue > kMaxHbA1c ||
                JSON(reading).intValue < kMinHbA1c {
                return AppError.validation(type: .invalidHbA1c)
            }
            
            return nil
        case .ACR:
            if JSON(reading).intValue > kMaxACR {
                return AppError.validation(type: .invalidACR)
            }
            
            return nil
        case .eGFR:
            if JSON(reading).intValue > kMaxeGFR {
                return AppError.validation(type: .invalideGFR)
            }
            
            return nil
        case .FEV1Lung:
            if JSON(reading).doubleValue > JSON(kMaxFEV1Lung).doubleValue ||
                JSON(reading).doubleValue < JSON(kMinFEV1Lung).doubleValue {
                return AppError.validation(type: .invalidFEV1Lung)
            }
            
            return nil
            
        case .six_min_walk:
            if JSON(reading).intValue == 0 {
                return AppError.validation(type: .enterReading)
            }
            if JSON(reading).intValue > kMaxSixMinWalkValue ||
                JSON(reading).intValue < kMinSixMinWalkValue {
                return AppError.validation(type: .invalidFEV1Lung)
            }
            
            return nil
            
        case .cat:
            return nil
            //cat pending
        case .fibro_scan:
            return nil
        case .fib4:
            return nil
        case .sgot:
            if JSON(reading).intValue > kMaximumSGOT ||
                JSON(reading).intValue < kMinimumSGOT {
                return AppError.validation(type: .enterValidSGOT)
            }
            return nil
        case .sgpt:
            if JSON(reading).intValue > kMaximumSGPT ||
                JSON(reading).intValue < kMinimumSGPT {
                return AppError.validation(type: .enterValidSGPT)
            }
            return nil
        case .triglycerides:
            if JSON(reading).intValue > kMaximumTriglyceride ||
                JSON(reading).intValue < kMinimumTriglyceride {
                return AppError.validation(type: .enterValidTriglyceride)
            }
            return nil
        case .total_cholesterol:
            return nil
        case .ldl_cholesterol:
            if JSON(reading).intValue > kMaximumLDL ||
                JSON(reading).intValue < kMinimumLDL {
                return AppError.validation(type: .enterValidLDL)
            }
            return nil
        case .hdl_cholesterol:
            if JSON(reading).intValue > kMaximumHDL ||
                JSON(reading).intValue < kMinimumHDL {
                return AppError.validation(type: .enterValidHDL)
            }
            return nil
        case .waist_circumference:
            if JSON(reading).intValue > kMaxWaistCircumference ||
                JSON(reading).intValue < kMinWaistCircumference {
                return AppError.validation(type: .invalidWaistCircumference)
            }
            return nil
        case .platelet:
            if JSON(reading).intValue > kMaxPlatelet ||
                JSON(reading).intValue < kMinPlatelet {
                return AppError.validation(type: .invalidPlatelet)
            }
            return nil
        case .serum_creatinine:
            if JSON(reading).doubleValue > kMaxSerumCreatinine ||
                JSON(reading).doubleValue < kMinSerumCreatinine {
                return AppError.validation(type: .invalidSerumCreatinine)
            }
            return nil
        case .fatty_liver_ugs_grade:
            return nil
        case .random_blood_glucose:
            if JSON(reading).intValue > kMaxRandomBG ||
                JSON(reading).intValue < kMinRandomBG {
                return AppError.validation(type: .invalidRandomBloodGlucose)
            }
            return nil
        case .BodyFat:
            if JSON(reading).intValue > kMaxBodyFat ||
                JSON(reading).intValue < kMinBodyFat {
                return AppError.validation(type: .invalidBodyFat)
            }
        case .Hydration:
            if JSON(reading).intValue > kMaxHydration ||
                JSON(reading).intValue < kMinHydration {
                return AppError.validation(type: .invalidHydration)
            }
        case .MuscleMass:
            if JSON(reading).doubleValue > Double(kMaxMuscleMass) ||
                JSON(reading).doubleValue < Double(kMinMuscleMass) {
                return AppError.validation(type: .invalidMuscleMass)
            }
        case .Protein:
            if JSON(reading).intValue > kMaxProtein ||
                JSON(reading).intValue < kMinProtein {
                return AppError.validation(type: .invalidProtein)
            }
        case .BoneMass:
            if JSON(reading).doubleValue > Double(kMaxBoneMass) ||
                JSON(reading).doubleValue < Double(kMinBoneMass) {
                return AppError.validation(type: .invalidBoneMass)
            }
        case .VisceralFat:
            if JSON(reading).doubleValue > Double(kMaxVisceralFat) ||
                JSON(reading).doubleValue < Double(kMinVisceralFat) {
                return AppError.validation(type: .invalidVisceralFat)
            }
        case .BaselMetabolicRate:
            if JSON(reading).intValue > kMaxBasalMetabolicRate ||
                JSON(reading).intValue < kMinBasalMetabolicRate {
                return AppError.validation(type: .invalidBasalMetabolicRate)
            }
        case .MetabolicAge:
            if JSON(reading).intValue > kMaxMetabolicAge ||
                JSON(reading).intValue < kMinMetabolicAge {
                return AppError.validation(type: .invalidMetabolicAge)
            }
        case .SubcutaneousFat:
            if JSON(reading).doubleValue > Double(kMaxSubcutaneousFat) ||
                JSON(reading).doubleValue < Double(kMinSubcutaneousFat) {
                return AppError.validation(type: .invalidSubcutaneousFat)
            }
        case .SkeletalMuscle:
            if JSON(reading).intValue > kMaxSkeletalMuscle ||
                JSON(reading).intValue < kMinSkeletalMuscle {
                return AppError.validation(type: .invalidSkelatalMuscle)
            }
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature,.sedentary_time:
            break
        case .calories_burned:
            if JSON(reading).intValue < kMinCaloriesBurned || JSON(reading).intValue > kMaxCaloriesBurned {
                return AppError.validation(type: .invalidCaloriesBurned)
            }
            break
        }
        return nil
    }
}

// MARK: Web Services
extension UpdateReadingPopupVM {
    
    func apiCall(vc: UIViewController,
                 date: UITextField,
                 time: UITextField,
                 reading: String,
                 weightKg: String,
                 weightLbs: String? = "",
                 unit: UITextField,
                 weightUnit: String,
                 readingType: ReadingType,
                 readingListModel: ReadingListModel) {
        
        // Check validation
        if let error = self.isValidView(date: date,
                                        time: time,
                                        reading: reading,
                                        weightKg: weightKg,
                                        weightLbs: weightLbs,
                                        unit: unit,
                                        weightUnit: weightUnit,
                                        readingType: readingType,
                                        readingListModel: readingListModel) {
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        var readingValue = reading
        if weightKg.trim() != "" {
            readingValue = weightKg
        }
        
        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: date.text! + time.text!,
                                                    reading_value: readingValue,
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
