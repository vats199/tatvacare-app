//
//  AppConstants.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 23/12/20.
//

import Foundation
import AVKit

var RazorPayTestKey         = ""//"rzp_test_1mVRchh6qQGlTr"
var RazorPayKey             = ""//"rzp_live_TXnspN3YXFlWPW"
var RazorPayLiveKeySecret   = ""//"HJVwj3x4iCyZaKSAXl1dBw4O"

///Firebase flags to hide/show
var isUseFirebaseFlag       = true
var hide_chatbot            = false
var hide_language_page      = false
var hide_engage_page        = false
var hide_leave_query        = false
var hide_email_at           = false

var hide_ask_an_expert_page         = false
var hide_doctor_says                = false
var hide_diagnostic_test            = false
var hide_engage_discover_comments   = false
var hide_incident_survey            = true
var hide_incident_surveyMain        = true
var hide_home_chat_bubble           = false
var hide_home_chat_bubble_hc        = false
var hide_home_bca                   = false
var hide_home_my_device             = false
var is_bcp_with_in_app              = true


//"hide_chatbot_android" //hide_chatbot_ios
//"hide_language_page_android" //hide_language_page_ios
//"hide_engage_page_android" //hide_engage_page_ios


var awsAppConfig = AppConfig()

///instance of AVPlayerViewController as global to avoid duplicate instance
let avPVC = AVPlayerViewController()

///Phone pattern for showing mobile number in this formate
let kPhonePattern = "(###) ###-####"

///Character for replacing phone pattern
let kPhonePatternReplaceChar: Character = "#"

///Array of view controller which is we need to disable pop gesture back funcationality
let kDisablePopBackVCS: [AnyObject] = []

///Get current time zone
var kTimeZone: String {
    return TimeZone.current.identifier
}

var kGlobalPincode = ""

var vOtp = "1234"
    
///Get html string with device data
var kGetAppDetailsString: String {
    """
    <br><br><br>
    ----------------------
    <br>
    Device: \(DeviceManager.shared.modelName)
    <br>
    iOS Version: \(DeviceManager.shared.osVersion)
    <br>
    App Version: \(Bundle.main.displayFullVersion)
    <br>
    ----------------------
    """
}

//MARK: PrefixPostfix
struct PrefixPostfix {
    static let currencySymbol = "$"
    static let durationPostfix = "Min"
    static let currencyName = "Dollar"
    static let distanceUnit = "KM"
    static let percentage = "%"
}
var kDoctorAccessCode                       = ""
var kAccessCode                             = ""
var kContactNo                              = ""
var kAccessFrom: AccessFrom                 = .Doctor
var isRemoteConfigFetchDone                 = false
var kBMISuccessMessage                      = ""
var kDoctorName                             = ""

var isAppBackgroundForGAOnce                    = false
var videoPlayerVCStartTime                  = Date()
let sceneDelegate                           = UIApplication.shared.connectedScenes
        .first!.delegate as! SceneDelegate

var appCurrencySymbol: CurrencySymbol       = .INR

let appDateFormat                           = DateTimeFormaterEnum.ddMMyyyy.rawValue
let appDateTimeFormat                       = DateTimeFormaterEnum.ddMMyyyyhhmma.rawValue
let appTimeFormat                           = DateTimeFormaterEnum.hhmma.rawValue
let kGM                                     = "Good Morning".localized
let kGA                                     = "Good Afternoon".localized
let kGE                                     = "Good Evening".localized
let kTotalOtpTime                           = 60
let kTotalOtpTime2                          = 30
let kOTPCount                               = 6
let kAPI_RELOAD_DELAY_BY                    = 5 ///minute
let kPopupAlpha: CGFloat                    = 0.5 /// 1 is maximum

let kJumpValueWater: CGFloat                = 1 /// 1 is minimum
let kDefaultWaterGlassML: CGFloat           = 250 /// 250 ml

let kMaximumExerciseLog                     = 120 /// minute/ 2 hours
let kJumpValueExercise                      = 5 /// jump exercise

let kMaximumPranayamLog                     = 120 /// minute/ 2 hours
let kJumpValuePranayam                      = 5 /// jump exercise

let kMaximumStepsLog                        = 100000 /// max steps
let kJumpValueSteps                         = 500 /// jump steps


//MARK: -------------------- Reading values min-max --------------------
/// Glucose
var kMinFastBlood                           = 10
var kMaxFastBlood                           = 1000
var kMinPPBlood                             = 10
var kMaxPPBlood                             = 1000

/// BMI
var kMinBMI                                 = 10
var kMaxBMI                                 = 100

/// BP
var kMinBPDiastolic                         = 0
var kMaxBPDiastolic                         = 300
var kMinBPSystolic                          = 0
var kMaxBPSystolic                          = 300

///Platelet
var kMinPlatelet                            = 1000
var kMaxPlatelet                            = 1000000///10,00,000

///SPO2
var kMinSPO2                                = 0
var kMaxSPO2                                = 100

///PEF
var kMinPEF                                 = 60
var kMaxPEF                                 = 800

///HeartRate
var kMinHeartRate                           = 0 ///
var kMaxHeartRate                           = 500 ///

///HbA1C
var kMinHbA1c                               = 1
var kMaxHbA1c                               = 100

///FEV1
var kMinFEV1Lung                            = 0
var kMaxFEV1Lung                            = 7

var kMinACR                                 = 0
var kMaxACR                                 = 100

var kMineGFR                                = 0
var kMaxeGFR                                = 150

///SixMinWalk
var kMinSixMinWalkValue                     = 0
var kMaxSixMinWalkValue                     = 1000

let kMaxSixMinWalkDuration                  = 360

///Height in cm
var kMinHeightCm                            = 91
var kMaxHeightCm                            = 272

///Height in ft
var kMinHeightFt                            = 3
var kMaxHeightFt                            = 8

///Height in In
var kMinHeightIn                            = 0
var kMaxHeightIn                            = 11

///Body weight
var kMinBodyWeightKg                        = 1
var kMaxBodyWeightKg                        = 300

var kMaxBodyWeightLbs                       = 300
var kMinBodyWeightLbs                       = 1

///Waist Circumference
var kMaxWaistCircumference                  = 300
var kMinWaistCircumference                  = 20

///LSM for FibroScan
var kMinimumLSM                             = 1
var kMaximumLSM                             = 100

///FIB4 Score
var kMinFIB4Score                           = 0
var kMaxFIB4Score                           = 6

///CAP for FibroScan
var kMinimumCAP                             = 100
var kMaximumCAP                             = 400

///SGPT
var kMinimumSGPT                            = 1
var kMaximumSGPT                            = 2000

///SGOT
var kMinimumSGOT                            = 1
var kMaximumSGOT                            = 2000

///LDL
var kMinimumLDL                             = 1
var kMaximumLDL                             = 4000

///HDL
var kMinimumHDL                             = 1
var kMaximumHDL                             = 4000

///Serum Creatinine
var kMinSerumCreatinine                     = 0.20
var kMaxSerumCreatinine                     = 75.00

///fatty liver
var kMinFattyLiver                          = 0
var kMaxFattyLiver                          = 3

///Triglyceride
var kMinimumTriglyceride                    = 1
var kMaximumTriglyceride                    = 4000

///Triglyceride
var kMinimumTotalCholesterol                = 1
var kMaximumTotalCholesterol                = 4000

var kMinRandomBG                            = 30
var kMaxRandomBG                            = 2500

//BCA device new 10 readings min max
var kMaxBodyFat = 45
var kMinBodyFat = 5

var kMaxHydration = 80
var kMinHydration = 30

var kMaxMuscleMass = 85
var kMinMuscleMass = 10

var kMaxProtein = 30
var kMinProtein = 10

var kMaxBoneMass = 5
var kMinBoneMass = 1

var kMaxVisceralFat = 10.0
var kMinVisceralFat = 1.0

var kMaxBasalMetabolicRate = 2100
var kMinBasalMetabolicRate = 1000

var kMaxMetabolicAge = 100
var kMinMetabolicAge = 1

var kMaxSubcutaneousFat = 40
var kMinSubcutaneousFat = 5

var kMaxSkeletalMuscle = 60
var kMinSkeletalMuscle = 10


//MARK: -------------------- Goal values min-max --------------------
let kMaxSleepGoal                           = 24 /// hours
let kMaxWaterGoal                           = 100 /// glass
let kMaxStepsGoal                           = 100000 /// steps
let kMaxPranayamaGoal                       = 600 /// minutes
let kMaxExerciseGoal                        = 600 /// minutes
let kMaxDietGoal                            = 5000 /// cal
let kMaxFoodDishName                        = 15 ///

let kMaxQuestionChar                        = 124

//In case food not found in search
let kDefaultFoodCalorie                     = 100 ///
let kMaxFoodCalorie                         = 2000 ///
let kMaxReloadAttemp                        = 3 ///

var kUserSessionActive                      = false
var kAppSessionTimeStart                    = Date()

let kMinTestAddress                         = 25 /// cal
var kScreenTimeStart                        = Date()
var kGoalMasterId                           = ""
let kTerms                                  = "https://www.mytatva.in/terms-and-conditions/" //"https://www.mytatva.in/assets/terms-and-conditions.html"//"https://mytatva.in/terms.html"
let kPrivacy                                = "https://www.mytatva.in/privacy-policy/" //"https://mytatva.in/assets/privacy-policy.html"//"http://mytatva.in/privacy.html"

let kThyrocareTermsUse                      = "https://admin.mytatva.in/terms_of_use.html"
//let kThyrocareService                       = "https://www.thyrocare.com/Terms/Service"
//let kThyrocareCancellation                  = "https://www.thyrocare.com/Cancellation"

//https://admin.mytatva.in/terms_of_use.html
//https://admin.mytatvadev.in/terms_of_use.html

//T&C - https://www.mytatva.in/assets/terms-and-conditions.html
//Privacy policy - https://mytatva.in/assets/privacy-policy.html

var kAnimationSpeed: Double                 = 0.3
let kNASH                                   = "NASH"
let kNAFL                                   = "NAFL"
let kSubscription                           = "Subscription"
let KTrial                                  = "Trial"
let KFree                                   = "Free"
let kIndividual                             = "Individual"

let kRoutine                                = "Routine "
let kValidFrom                              = "Valid from "
let kTo                                     = " to "
let kBCA                                    = "BCA"
let kCarePlan                               = "careplan"

let kRent                                   = "Rent"
let kBuy                                    = "Buy"
let kBCP                                    = "bcp"

var isBackVisible                           = false
var kPateintPlanRefID                       = ""
