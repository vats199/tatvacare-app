//
//  ValidationError.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 03/03/21.
//

import Foundation

extension AppError.Enums {
    enum ValidationError {
        case enterValidEmail
        case enterEmail
        case enterPassword
        case enterName
        case enterValidName
        case enterFirstName
        case enterLastName
        case enterValidFirstName
        case enterValidLastName
        case enterCouponCode
        case enterMinName
        case enterMobileNumber
        case selectCategory
        case enterMinMobileNumber
        case enterPincode
        case enterQuery
        case enterValidPincode
        case enterHouseNumber
        case enterFullAddress
        case enterHouseFullAddress
        case enterValidHouseFullAddress
        case enterValidHouseNumber
        case enterStreet
        case selectDob
        case enterCountryCode
        case selectFoodType
        case addFood
        case selectPatient
        case selectAddress
        case enterAddress
        case addCal
        case addValidCal
        case enterMedicineName
        case selectDosage
        case selectDate
        case selectGender
        case selectCondition
        case selectStartDate
        case selectEndDate
        case selectTime
        case invalidSteps
        case selectContainer
        case enterReading
        case invalidSPO2
        case invalidPEF
        case invalidHeartRate
        case invalidHbA1c
        case invalidACR
        case invalideGFR
        case invalidFEV1Lung
        case invalidSixMinWalk
        case invalidPlatelet
        case invalidSerumCreatinine
        case invalidWaistCircumference
        case invalidRandomBloodGlucose
        
        // New BCA devices
        case invalidBodyFat
        case invalidHydration
        case invalidMuscleMass
        case invalidProtein
        case invalidBoneMass
        case invalidVisceralFat
        case invalidBasalMetabolicRate
        case invalidMetabolicAge
        case invalidSubcutaneousFat
        case invalidSkelatalMuscle
        
        case invalidStepsGoal
        case invalidSleepGoal
        case invalidWaterGoal
        case invalidPranayamaGoal
        case invalidExerciseGoal
        case invalidDietGoal
        
        case selectStartDateTime
        case selectEndDateTime
        
        case enterHeight
        case enterValidHeightCm
        case enterValidHeightFt
        
        case enterWeight
        case enterValidWeightKg
        case enterValidWeightLbs
        
        case enterSetWeight
        case enterValidSetWeightKg
        case enterValidSetWeightLbs
        
        case selectSetWeightDays
        case enterFastBlood
        case invalidFastBlood
        case enterPPBlood
        case invalidPPBlood
        
        case invalidBMI
        
        case selectSystolic
        case selectDiastolic
        case invalidSystolic
        case invalidDiastolic
        
        case enterLSM
        case enterValidLSM
        case enterCAP
        case enterValidCAP
        
        case enterSGPT
        case enterValidSGPT
        case enterSGOT
        case enterValidSGOT
        case enterPlatelet
        case enterValidPlatelet
        case enterValidFib4Score
        
        case enterLDL
        case enterValidLDL
        case enterHDL
        case enterValidHDL
        case enterTriglyceride
        case enterValidTriglyceride
        case enterTotalCholesterol
        case enterValidTotalCholesterol
        
        case selectDays
        case selectMedication
        case selectPrescription
        case selectExercise
        case selectLanguage
        case enterConfirmPassword
        case passwordMismatch
        case agreeTermsAndCondition
        case agreeThyroTermsAndCondition
        case selecteMedicalCondition
        case enterMinPassword
        case enterMinNewPassword
        case enterValidPassword
        case enterNewPassword
        case enterCurrentPassword
        case enterAccessCode
        case verifyAccessCode
        case enterOTP
        case validOTP
        case selectAge
        case enterAge
        case selectGoal
        case selectReading
        case selectFavDrinks
        case selectInterest
        case selectCity
        case selectState
        case enterZipCode
        case selectDrink
        case selectSubject
        case enterMessage
        case enterCardNumber
        case enterValidCardNumber
        case enterCardName
        case selectCardExpiry
        case enterCardCvv
        case enterValidCardCvv
        case locationNotFound
        case invalidFileSize
        
        case Selectwhatabout
        case enterQuestion
        case uploadAttachment
        
        case enterDocumentTitle
        case selectTestType
        case enterDescription
        case uploadDocument
        
        case enterAnswer
        
        case PleaseSelectCoach
        case PleaseSelectClinic
        case PleaseSelectDoctor
        case PleaseSelectAppointmentType
        case PleaseSelectTimeSlot
        case AddPrescription
        
        
        
        case custom(errorDescription: String?)
    }
}

extension AppError.Enums.ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .enterValidEmail:
            return "Looks like the email address is invalid. Please enter a valid email address."
        case .enterEmail:
            return "Please enter email address"
        case .enterPassword:
            return "Please enter password"
        case .enterName:
            return "Please enter name"
        case .enterFirstName:
            return "Please enter first name"
        case .enterLastName:
            return "Please enter last name"
        case .enterValidFirstName:
            return "Please enter valid first name"
        case .enterValidLastName:
            return "Please enter valid last name"
        case .enterValidName:
            return "Please enter valid name"
        case .enterCouponCode:
            return "Please enter coupon code"
        case .enterMinName:
            return "Please enter minimum of two characters in name"
        case .enterMobileNumber:
            return "Please enter mobile number"
        case .selectCategory:
            return "Please select category"
        case .enterMinMobileNumber:
            return "Invalid mobile number. Please dont add 0 or +91 before Phone number"
        case .selectDob:
            return "Please enter DOB"
        case .enterCountryCode:
            return "Please select country code"
        case .selectFoodType:
            return "Please select food type"
        case .addFood:
            return "Please add food dish"
        case .selectPatient:
            return "Please select patient"
        case .selectAddress:
            return "Please select address"
        case .enterAddress:
            return "Please enter address"
        case .addCal:
            return "Please enter calorie"
        case .addValidCal:
            return "Please enter calories upto \(kMaxFoodCalorie)"
        case .selectLanguage:
            return "Please select language"
        case .enterConfirmPassword:
            return "Please enter confirm password"
        case .passwordMismatch:
            return "Password and confirm password do not match"
        case .enterMinPassword:
            return "Please enter minimum of \(Validations.Password.Minimum.rawValue) characters for password"
        case .enterMinNewPassword:
            return "Please enter minimum of \(Validations.Password.Minimum.rawValue) characters for new password"
        case .enterValidPassword:
            return "Please enter password with minimum \(Validations.Password.Minimum.rawValue) and maximum \(Validations.Password.Maximum.rawValue) characters long with at least one uppercase letter, one lowercase letter, one number and one special character"
        case .enterNewPassword:
            return "Please enter password"
        case .enterCurrentPassword:
            return "Please enter current password"
        case .enterAccessCode:
            return "Please enter access code"
        case .verifyAccessCode:
            return "Please verify access code first"
        case .enterOTP:
            return "Please enter OTP"
        case .validOTP:
            return "Invalid entry.Please re-enter OTP"
        case .agreeTermsAndCondition:
            return "Please agree to the terms and conditions"
        case .agreeThyroTermsAndCondition:
            return "Please agree to the terms and conditions"
        case .selecteMedicalCondition:
            return "Please select at least one medical condition"
        case .custom(let errorDescription): return errorDescription
        case .selectAge:
            return "Please select age"
        case .enterAge:
            return "Please enter age"
        case .selectGoal:
            return "Please add goal"
        case .selectReading:
            return "Please add reading"
        case .selectCity:
            return "Please select city"
        case .selectState:
            return "Please select state"
        case .enterZipCode:
            return "Please enter zipcode"
        case .selectFavDrinks:
            return "Please select favourite drink"
        case .selectDrink:
            return "Please select drink"
        case .selectInterest:
            return "Please select interest"
        case .selectSubject:
            return "Please select subject"
        case .enterMessage:
            return "Please enter message"
        case .enterCardNumber:
            return "Please enter card number"
        case .enterValidCardNumber:
            return "Please enter valid card number"
        case .enterCardName:
            return "Please enter card holder name"
        case .selectCardExpiry:
            return "Please select expiry date"
        case .enterCardCvv:
            return "Please enter CVV"
        case .enterValidCardCvv:
            return "Please enter valid CVV"
        case .enterMedicineName:
            return "Please enter medicine name"
        case .selectDosage:
            return "Please select dosage"
        case .selectDate:
            return "Please select date"
        case .selectGender:
            return "Please select gender"
        case .selectCondition:
            return "Please select condition"
        case .selectStartDate:
            return "Please select start date"
        case .selectEndDate:
            return "Please select end date"
        case .selectTime:
            return "Please select time"
        case .invalidSteps:
            return "Please enter steps less than \(kMaximumStepsLog)"
        case .selectContainer:
            return "Please select container"
        case .enterReading:
            return "Please enter reading"
        case .invalidSPO2:
            return "Please enter SPO2 in the range of \(kMinSPO2) - \(kMaxSPO2)"
        case .invalidPEF:
            return "Please enter PEF in the range of \(kMinPEF) - \(kMaxPEF)"
        case .invalidHeartRate:
            return "Please enter Heart Rate in the range of \(kMinHeartRate) - \(kMaxHeartRate)"
        case .invalidHbA1c:
            return "Please enter HbA1c in the range of \(kMinHbA1c) - \(kMaxHbA1c)"
        case .invalidACR:
            return "Please enter ACR upto \(kMaxACR)"
        case .invalideGFR:
            return "Please enter eGFR upto \(kMaxeGFR)"
        case .invalidFEV1Lung:
            return "Please enter FEV1 in the range of \(kMinFEV1Lung) - \(kMaxFEV1Lung)"
        case .invalidSixMinWalk:
            return "Please enter value in the range of \(kMinSixMinWalkValue) - \(kMaxSixMinWalkValue)"
        case .invalidPlatelet:
            return "Please enter Platelet in the range of \(kMinPlatelet) - \(kMaxPlatelet)"
            
        case .invalidSerumCreatinine:
            return "Please enter Serum Creatinine in the range of \(kMinSerumCreatinine) - \(kMaxSerumCreatinine)"

        case .invalidWaistCircumference:
            return "Please enter Waist Circumference in the range of \(kMinWaistCircumference) - \(kMaxWaistCircumference)"
        case .invalidRandomBloodGlucose:
            return "Please enter Random Blood Glucose in the range of \(kMinRandomBG) - \(kMaxRandomBG)"
            
        case .selectStartDateTime:
            return "Please select start date and time"
        case .enterHeight:
            return "Please enter height"
        case .enterValidHeightCm:
            return "Please enter height between \(kMinHeightCm) - \(kMaxHeightCm)"
        case .enterValidHeightFt:
            return "Please enter height between \(kMinHeightFt) - \(kMaxHeightFt)"
        case .enterWeight:
            return "Please enter weight"
        case .enterValidWeightKg:
            return "Please enter Body Weight in the range of \(kMinBodyWeightKg) - \(kMaxBodyWeightKg)"
        case .enterValidWeightLbs:
            return "Please enter Body Weight in the range of \(kMinBodyWeightLbs) - \(kMaxBodyWeightLbs)"
        case .enterSetWeight:
            return "Please enter target weight"
        case .enterValidSetWeightKg:
            return "Please enter Target Weight in the range of \(kMinBodyWeightKg) - \(kMaxBodyWeightKg)"
        case .enterValidSetWeightLbs:
            return "Please enter Target Weight in the range of \(kMinBodyWeightLbs) - \(kMaxBodyWeightLbs)"
        case .selectSetWeightDays:
            return "Please select target duration"
        case .enterFastBlood:
            return "Please enter fast blood glucose"
        case .invalidFastBlood:
            return "Please enter fast blood glucose in the range of \(kMinFastBlood) - \(kMaxFastBlood)"
        case .enterPPBlood:
            return "Please enter PP blood glucose"
        case .invalidPPBlood:
            return "Please enter PP blood glucose in the range of \(kMinPPBlood) - \(kMaxPPBlood)"
        case .invalidBMI:
            return "BMI should be in the range of \(kMinBMI) - \(kMaxBMI)"
        case .selectDiastolic:
            return "Please enter diastolic"
        case .selectSystolic:
            return "Please enter systolic"
        case .invalidDiastolic:
            return "Please enter diastolic in the range of \(kMinBPDiastolic) - \(kMaxBPDiastolic)"
        case .invalidSystolic:
            return "Please enter systolic in the range of \(kMinBPSystolic) - \(kMaxBPSystolic)"
        case .enterLSM:
            return "Please enter LSM"
        case .enterValidLSM:
            return "Please enter LSM in the range of \(kMinimumLSM) - \(kMaximumLSM)"
        case .enterCAP:
            return "Please enter CAP"
        case .enterValidCAP:
            return "Please enter CAP in the range of \(kMinimumCAP) - \(kMaximumCAP)"
        case .enterSGPT:
            return "Please enter SGPT"
        case .enterValidSGPT:
            return "Please enter SGPT in the range of \(kMinimumSGPT) - \(kMaximumSGPT)"
        case .enterSGOT:
            return "Please enter SGOT"
        case .enterValidSGOT:
            return "Please enter SGOT in the range of \(kMinimumSGOT) - \(kMaximumSGOT)"
        case .enterPlatelet:
            return "Please enter Platelet"
        case .enterValidPlatelet:
            return "Please enter Platelet in the range of \(kMinPlatelet) - \(kMaxPlatelet)"
        case .enterValidFib4Score:
            return "FIB4 Score should be in the range of \(kMinFIB4Score) - \(kMaxFIB4Score)"
        case .enterLDL:
            return "Please enter LDL"
        case .enterValidLDL:
            return "Please enter LDL in the range of \(kMinimumLDL) - \(kMaximumLDL)"
        case .enterHDL:
            return "Please enter HDL"
        case .enterValidHDL:
            return "Please enter HDL in the range of \(kMinimumHDL) - \(kMaximumHDL)"
        case .enterTriglyceride:
            return "Please enter Triglyceride"
        case .enterValidTriglyceride:
            return "Please enter Triglyceride in the range of \(kMinimumTriglyceride) - \(kMaximumTriglyceride)"
        case .enterTotalCholesterol:
            return "Please enter Total Cholesterol"
        case .enterValidTotalCholesterol:
            return "Please enter Total Cholesterol in the range of \(kMinimumTotalCholesterol) - \(kMaximumTotalCholesterol)"
            
        case .selectEndDateTime:
            return "Please select end date and time"
            
        case .selectDays:
            return "Please select days"
        case .selectMedication:
            return "Please add medication"
        case .selectPrescription:
            return "Please add prescription image"
        case .selectExercise:
            return "Please select exercise"
        case .locationNotFound:
            return "Location data not found"
        case .invalidFileSize:
            return "Please use file size upto \(Validations.MaxCharacterLimit.imageKbSize.rawValue / 1000) mb"
        
        case .invalidStepsGoal:
            return "Please enter value less than \(kMaxStepsGoal)"
        case .invalidSleepGoal:
            return "Please enter value less than \(kMaxSleepGoal)"
        case .invalidWaterGoal:
            return "Please enter value less than \(kMaxWaterGoal)"
        case .invalidPranayamaGoal:
            return "Please enter value less than \(kMaxPranayamaGoal)"
        case .invalidExerciseGoal:
            return "Please enter value less than \(kMaxExerciseGoal)"
        case .Selectwhatabout:
            return "Please select what this is about"
        case .enterQuestion:
            return "Please enter question"
        case .invalidDietGoal:
            return "Please enter value less than \(kMaxDietGoal)"
        case .enterDocumentTitle:
            return "Please add a record."
        case .selectTestType:
            return "Please select medical record type"
//            return "Please select test type"
        case .enterDescription:
            return "Please enter description"
        case .uploadDocument:
            return "Please upload document"
        case .uploadAttachment:
            return "Please upload attachment"
        case .enterAnswer:
            return "Please enter answer"
        case .PleaseSelectCoach:
            return "Please select health coach"
        case .PleaseSelectClinic:
            return "Please select clinic"
        case .PleaseSelectDoctor:
            return "Please select doctor"
        case .PleaseSelectAppointmentType:
            return "Please select appointment type"
        case .PleaseSelectTimeSlot:
            return "Please select time slot"
        case .enterPincode:
            return "Please enter pincode"
        case .enterQuery:
            return "Please enter query"
        case .enterValidPincode:
            return "Please enter valid pincode"
        case .enterHouseNumber:
            return "Please enter house number and building"
        case .enterFullAddress:
            return "Please enter full address"
        case .enterValidHouseNumber:
            return "Please enter minimum of \(kMinTestAddress) characters for house number and building"
        case .enterValidHouseFullAddress:
            return "Please enter minimum of \(kMinTestAddress) characters for full address"
        case .enterStreet:
            return "Please enter street name"
        case .AddPrescription:
            return "Please add your prescription and medications."
            
            
        case .invalidBodyFat:
            return "Please enter Body Fat in the range of \(kMinBodyFat) - \(kMaxBodyFat)"
        case .invalidHydration:
            return "Please enter Hydration in the range of \(kMinHydration) - \(kMaxHydration)"
        case .invalidMuscleMass:
            return "Please enter Muscle Mass in the range of \(kMinMuscleMass) - \(kMaxMuscleMass)"
        case .invalidProtein:
            return "Please enter Protein in the range of \(kMinProtein) - \(kMaxProtein)"
        case .invalidBoneMass:
            return "Please enter Bone Mass in the range of \(kMinBoneMass) - \(kMaxBoneMass)"
        case .invalidVisceralFat:
            return "Please enter Visceral Fat in the range of \(kMinVisceralFat) - \(kMaxVisceralFat)"
        case .invalidBasalMetabolicRate:
            return "Please enter Basal Metabolic Rate in the range of \(kMinBasalMetabolicRate) - \(kMaxBasalMetabolicRate)"
        case .invalidMetabolicAge:
            return "Please enter Metabolic Age in the range of \(kMinMetabolicAge) - \(kMaxMetabolicAge)"
        case .invalidSubcutaneousFat:
            return "Please enter Subcutaneous Fat in the range of \(kMinSubcutaneousFat) - \(kMaxSubcutaneousFat)"
        case .invalidSkelatalMuscle:
            return "Please enter Skeletal Muscle in the range of \(kMinSkeletalMuscle) - \(kMaxSkeletalMuscle)"
        
        case .enterHouseFullAddress:
            return "Please enter house number and building"
        }
    }
}
