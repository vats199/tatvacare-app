//
//  GEnum.swift
//  SM
//
//  Created by on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

/*
 *******************************
 Goals
 *******************************
 1.Medication
 2.Exercise
 3.Pranayam
 4.Steps
 5.Water intake
 6.Sleep

 *******************************
 Readings
 *******************************
 1.SPO2
 2.FEV1
 3.PEF
 4.Blood Pressure
 5.Heart rate/Resting Heart Rate
 6.Body weight
 7.BMI
 8.Blood glucose
 9.HbA1c
 10.ACR
 11.eGFR
 12.Fibro scan
 13.FIB4 Score
 14.SGOT/ AST
 15.SGPT/ ALT
 16.BMI
 17.Triglyceride s
 18.Total cholesterol
 19.LDL cholesterol
 20.HDL cholesterol
 21.Waist Circumferen ce
 22.Platelet count
 */

enum ReadingType: String {
    
    case SPO2                   = "pulseoxy"
    case PEF                    = "pef"
    case BloodPressure          = "bloodpressure"
    case HeartRate              = "heartrate"
    case BodyWeight             = "bodyweight"
    case BMI                    = "bmi"
    case BloodGlucose           = "blood_glucose"
    case HbA1c                  = "hba1c"
    case ACR                    = "acr"
    case eGFR                   = "egfr"
    case FEV1Lung               = "lung"
    case cat                    = "cat"
    case six_min_walk           = "six_min_walk"
    case fibro_scan             = "fibro_scan"
    case fib4                   = "fib4"
    case sgot                   = "sgot"
    case sgpt                   = "sgpt"
    case triglycerides          = "triglycerides"
    case total_cholesterol      = "total_cholesterol"
    case ldl_cholesterol        = "ldl_cholesterol"
    case hdl_cholesterol        = "hdl_cholesterol"
    case waist_circumference    = "waist_circumference"
    case platelet               = "platelet"
    case serum_creatinine       = "serum_creatinine"
    case fatty_liver_ugs_grade  = "fatty_liver_ugs_grade"
    case random_blood_glucose   = "random_blood_glucose"
    
    //New BCA readings
    case BodyFat                = "body_fat"
    case Hydration              = "hydration"
    case MuscleMass             = "muscle_mass"
    case Protein                = "protein"
    case BoneMass               = "bone_mass"
    case VisceralFat            = "visceral_fat"
    case BaselMetabolicRate     = "basel_metabolic_rate"
    case MetabolicAge           = "metabolic_age"
    case SubcutaneousFat        = "subcutaneous_fat"
    case SkeletalMuscle         = "skeletal_muscle"
    
    //Spirometer readings
    case fev1_fvc_ratio         = "fev1_fvc_ratio"
    case fvc                    = "fvc"
    case aqi                    = "aqi"
    case humidity               = "humidity"
    case temperature            = "temperature"
    
    var image: UIImage {
        return set
    }

    var isSprirometerVital: Bool {
        switch self {
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature: return true
        default: return false
        }
    }
    
    private var set: (UIImage) {
        switch self {
        case .FEV1Lung:
            return (UIImage(named: "reading_lung")!)
        case .SPO2:
            return (UIImage(named: "reading_pulseOxy")!)
        case .BloodPressure:
            return (UIImage(named: "reading_bp")!)
        case .BodyWeight:
            return (UIImage(named: "reading_body_weight")!)
        case .HeartRate:
            return (UIImage(named: "reading_heart_rate")!)
        case .PEF:
            return (UIImage(named: "reading_heart_rate")!)
        case .BMI:
            return (UIImage(named: "reading_heart_rate")!)
        case .BloodGlucose:
            return (UIImage(named: "reading_heart_rate")!)
        case .HbA1c:
            return (UIImage(named: "reading_heart_rate")!)
        case .ACR:
            return (UIImage(named: "reading_heart_rate")!)
        case .eGFR:
            return (UIImage(named: "reading_heart_rate")!)
        case .cat:
            return (UIImage(named: "reading_heart_rate")!)
        case .six_min_walk:
            return (UIImage(named: "reading_heart_rate")!)
        case .fibro_scan:
            return (UIImage(named: "reading_heart_rate")!)
        case .fib4:
            return (UIImage(named: "reading_heart_rate")!)
        case .sgot:
            return (UIImage(named: "reading_heart_rate")!)
        case .sgpt:
            return (UIImage(named: "reading_heart_rate")!)
        case .triglycerides:
            return (UIImage(named: "reading_heart_rate")!)
        case .total_cholesterol:
            return (UIImage(named: "reading_heart_rate")!)
        case .ldl_cholesterol:
            return (UIImage(named: "reading_heart_rate")!)
        case .hdl_cholesterol:
            return (UIImage(named: "reading_heart_rate")!)
        case .waist_circumference:
            return (UIImage(named: "reading_heart_rate")!)
        case .platelet:
            return (UIImage(named: "reading_heart_rate")!)
        case .serum_creatinine:
            return (UIImage(named: "reading_heart_rate")!)
        case .fatty_liver_ugs_grade:
            return (UIImage(named: "reading_heart_rate")!)
        case .random_blood_glucose:
            return (UIImage(named: "reading_heart_rate")!)
        case .BodyFat:
            return (UIImage(named: "reading_heart_rate")!)
        case .Hydration:
            return (UIImage(named: "reading_heart_rate")!)
        case .MuscleMass:
            return (UIImage(named: "reading_heart_rate")!)
        case .Protein:
            return (UIImage(named: "reading_heart_rate")!)
        case .BoneMass:
            return (UIImage(named: "reading_heart_rate")!)
        case .VisceralFat:
            return (UIImage(named: "reading_heart_rate")!)
        case .BaselMetabolicRate:
            return (UIImage(named: "reading_heart_rate")!)
        case .MetabolicAge:
            return (UIImage(named: "reading_heart_rate")!)
        case .SubcutaneousFat:
            return (UIImage(named: "reading_heart_rate")!)
        case .SkeletalMuscle:
            return (UIImage(named: "reading_heart_rate")!)
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature:
            return (UIImage(named: "reading_heart_rate")!)
        }
    }
}

enum GoalType : String {
    case Medication             = "medication"
    case Calories               = "calories"
    case Steps                  = "steps"
    case Exercise               = "exercise"
    case Pranayam               = "pranayam"
    case Sleep                  = "sleep"
    case Water                  = "water"
    case Diet                   = "diet"
    
    var image: UIImage {
        return set.image
    }
    
    var key: String {
        return set.key
    }

    private var set: (image:UIImage, key: String) {
        switch self {
      
        case .Calories:
            return (UIImage(named: "goals_calories")!,
                    "calories")
        case .Steps:
            return (UIImage(named: "goals_steps")!,
                    "steps")
        case .Exercise:
            return (UIImage(named: "goals_exercise")!,
                    "exercise")
        case .Pranayam:
            return (UIImage(named: "goals_pranayam")!,
                    "pranayam")
        case .Sleep:
            return (UIImage(named: "goals_sleep")!,
                    "sleep")
        case .Water:
            return (UIImage(named: "goals_water")!,
                    "water")
        case .Medication:
            return (UIImage(),
                    "medication")
        case .Diet:
            return (UIImage(),
                    "medication")
        }
    }
}

enum FattyLiverGrade: Int, CaseIterable {
    
    case Grade0                 = 0
    case Grade1                 = 1
    case Grade2                 = 2
    case Grade3                 = 3
    
    var getTitle: String {
        return title
    }

    private var title: (String) {
        switch self {

        case .Grade0:
            return "Grade 0 - Normal"
        case .Grade1:
            return "Grade I Fatty Liver"
        case .Grade2:
            return "Grade II Fatty Liver"
        case .Grade3:
            return "Grade III Fatty Liver"
        }
    }
}

enum SelectionType: String {
    case sevenDays        = "7D"
    case fifteenDays      = "15D"
    case thirtyDays       = "30D"
    case nintyDays        = "90D"
    case oneYear          = "1Y"
    //case allTime          = "All time"
}

enum FibroScanType: String {
    case LSM
    case CAP
}

enum GenderType: String {
    case Male
    case Female
    case Other
}

enum RelationType: String {
    case WithSelf   = "Self"
    case Spouse
    case Parent
    case Sibling
    case Child
    case Other
}

enum AddressType: String {
    case Home
    case Work
    case Other
}

enum UserSettingFlag: String {
    case hide_engage_page//Tab, Search, coachmark
    case chat_bot//Home chat-bubble, FAQ
    case language_page//Auth
    case hide_leave_query//FAQ
    case hide_email_at//FAQ
    case hide_ask_an_expert_page//Engage, Search, coachmark
    case hide_doctor_says//Home
    case hide_diagnostic_test//Home, Menu, History, Search
    case hide_engage_discover_comments//Engage list, Engage details
    case hide_incident_survey//careplan, history
    case hide_home_chat_bubble//Home chat bubble
    case hide_home_chat_bubble_hc //Home chat bubble hc section
    case hide_home_my_device //Hide My device section from Home
    case hide_home_bca // Hide BCA list
    case is_bcp_with_in_app // BCP payment through inapp
}

//There will be 5 types of content: Article/blog, Photo gallery, KOL videos, Normal videos, webinar and panel discussion.

//BlogArticle
//Photo
//KOLVideo
//Video
//Webinar
enum EngageContentType: String {
    case BlogArticle        = "BlogArticle"
    case Photo              = "Photo"
    case KOLVideo           = "KOLVideo"
    case Video              = "Video"
    case Webinar            = "Webinar"
    case ExerciseVideo      = "ExerciseVideo"
}

enum DiscoverEngageFilterType: String {
    case Languages
    case Genres
    case Topics
    case ContentTypes
    case question_type
}

//var test = SimpleEnum.big("initial")
//test.adjust()

enum CMSPage : String {
    case Terms
    case Privacy
    case About
    case Faq
}

enum ProfileCard: String {
    case Profile
    case Location
    case Address
}

enum FeatureStatus: String {
    case active
    case inactive
}

enum OTPType : String {
    case login
    case forgotPassword
    case signup
}

//operation
enum DeepLinkType : String {
    case content
    case signup_link_doctor
    case screen_nav
}

enum DateTimeFormaterEnum: String {
    case yyyymmdd                   = "yyyy-MM-dd"
    case ddMMMYYYYhhmma             = "dd MMM, yyyy hh:mm a"
    case ddMMMYYYYDothhmma          = "dd MMM yyyy • hh:mm a"
    case ddMMyyyy                   = "dd/MM/yyyy"
    case ddMMyyyyhhmma              = "dd/MM/yyyy hh:mm a"
    case hhmma                      = "hh:mm a"
    case ddmm_yyyy                  = "dd MMM, yyyy"
    case dd_mmm_yyyy                = "dd-MMM-yyyy"
    case dd_mm_yyyy                 = "dd-MM-yyyy"
    case dd_mm_yyyy_HHmm            = "dd-MM-yyyy HH:mm"
    case dd_mm_yyyy_hhmma           = "dd-MM-yyyy hh:mm a"
    case bcaReport                  = "dd-mm-yyyy HH:mm"
//    case MMM_d_Y  = "MMM d, yyyy"
    case HHmmss                     = "HH:mm:ss"
//    case hhmma    = "hh:mma"
    case HHmm                       = "HH:mm"
    case hhmm                       = "hh:mm"
//    case dmmyyyy  = "d/MM/yyyy"
//    case hhmmA    = "hh:mm a"
    case UTCFormat                  = "yyyy-MM-dd HH:mm:ss"
//    case ddmm_yyyy = "dd MMM, yyyy"
//    case WeekDayhhmma = "EEE,hh:mma"
    
    case ddMMMyyyy                  = "dd MMM yyyy"
    case yyyyMMddTHHmmssZ           = "yyyy-MM-dd'T'HH:mm:ssZ"
    case yyyyMMddTHHmmsssZ          = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case MMyyyy                     = "MM/yyyy"
    case MMMyyyy                    = "MMMM yyyy"
    case MMMM                       = "MMMM"
    case MMMMDD                     = "MMMM dd"
    case MMMDD                      = "MMM dd"
    case DD                         = "dd"
    case EEEEddMMMMyyyy             = "EEEE, dd MMMM yyyy"
    case EEEEddMMMM                 = "EEEE, dd MMMM"
    case EEEddMMMM                  = "EEE, dd MMM, yyyy"
    case EEEEddMMMyyyy              = "EEEE, dd MMM, yyyy"
    
    case HHmma                      = "HH:mm a"
}


enum Validations {
    
    enum RegexType : String {
        case AlpabetsAndSpace                       = "^[A-Za-z ]{0,700}$"//"[\\p{L} ]{0,350}$"////*
//        case AlpabetsDotQuoteSpace                  = "^[A-Za-z0-9 \'.\\[\\\\\\]]*$"//"^.*[a-zA-Z0-9.' ]+.*$"
        case AlphaNumeric                           = "^[A-Za-z0-9 ]*$"
        case OnlyNumber                             = "^[0-9]*$"
        case OnlyNonZeroNumber                      = "^[1-9][0-9]*$"
        case Amount                                 = "^[0-9.]*$"
        case UserId                                 = "^[a-z][a-z0-9._]*$"
        case AllowDecimal                           = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        case VIN                                    = "^[A-HJ-NPR-Z0-9]{0,50}$"//"^[A-HJ-NPR-Z0-9]*$"
        case Inch                                   = "^[1-9][0-1]*$"
        case Password                               = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d)[a-zA-Z\\d|#@$!%*?&.]{6,}$"
        case Allow700                               = "[\\p{L}\\d -.,_/]{0,350}$"//"^[A-Za-z0-9-.,_/ ]{0,700}$"
        case AllowAmount                            = "^([1-9][0-9]{0,4}(\\.)?[0-9]{0,2})?$"
        case HbA1c                                  = "^([1-9][0-9]{0,1}(\\.)?[0-9]{0,1})?$"
    }
    
    enum PhoneNumber : Int {
        //case Minimum                                = 6
        case Maximum                                = 10
    }
    
    enum Password : Int {
        case Minimum                                = 8
        case Maximum                                = 30
    }
    
    enum MaxCharacterLimit: Int {
        case Name                                   = 50
        case VIN                                    = 17
        case Pincode                                 = 6
        case Notes                                  = 100
        case Ticket                                 = 250
        case Feedback                               = 350
        case Odometer                               = 7
        case FuelCost                               = 10
        case Email                                  = 254
        case Search                                 = 20
        case StandardName                           = 255
        case ComRegNumber                           = 25
        case Inch                                   = 2
        case card                                   = 16
        case cvv                                    = 3
        case imageKbSize                            = 6000
        case feet                                   = 1
    }
   
}

enum HeightUnit: String {
    case cm
    case feet_inch
}

enum WeightUnit: String {
    case kg
    case lbs
}

enum CurrencySymbol : String {
    case USD      = "$"
    case INR      = "₹"
}

var customModalPresentationStyle : UIModalPresentationStyle {
    return .fullScreen
}

enum DriverStatus : String {
    case Pending
    case Active
}

enum WeekDay : String {
  
    case Sunday         = "Sun"
    case Monday         = "Mon"
    case Tuesday        = "Tue"
    case Wednesday      = "Wed"
    case Thursday       = "Thu"
    case Friday         = "Fri"
    case Saturday       = "Sat"
}

enum BookmarkType : String{
    case Articles      = "Articles"
    case Videos        = "Videos"
    case Photos        = "Photos"
}

enum AccessFrom: String {
    case Doctor
    case LinkPatient
}


