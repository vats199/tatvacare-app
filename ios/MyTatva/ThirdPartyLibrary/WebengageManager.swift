//
//  WebengageManager.swift
//  MyTatva
//
//  Created by Human on 27/10/21.
//

import Foundation
@_exported import WebEngage
@_exported import WebEngage.WEGMobileBridge

enum ScreenName: String {
    case Home
    case CarePlan
    case DiscoverEngage
    case AskAnExpert
    case QuestionDetails
    case ExerciseVideo
    case ExercisePlan
    case DietPlan
    case ExerciseMore
    case ContentDetailPhotoGallery
    case ContentDetailNormalVideo
    case ContentDetailKolVideo
    case ContentDetailBlog
    case ContentDetailWebinar
    case ExercisePlanDetail
    case ExercisePlanDayDetail
    case RequestCallBack
    case FoodDiaryDay
    case FoodDiaryMonth
    case FoodDiaryDayInsight
    case LogFood
    case LogFoodSuccess
    case HelpSupportFaq
    case FaqQuery
    case NotificationList
    case HistoryIncident
    case IncidentDetails
    case HistoryRecord
    case UploadRecord
    case BreathingVideo
    case CommentList
    case AddIncident
    case MyAccount
    case MyProfile
    case EditProfile
    case MyDevices
    case MyDeviceDetail
    case LogGoal//{NameFromAPI(param-goal key)}
    case LogReading//{param reading key}
    case GoalChart//{goal key}
    case ReadingChart//{reading key}
    case LoginWithPhone
    case LoginWithPassword
    case LoginOtp
    case SelectLanguage
    case LanguageList
    case SignUpWithPhone
    case SignUpOtp
    case AddAccountDetails
    case BookmarkList
    case ReportComment
    case AllBookmark
    case UseBiometric
    case SetUpDrugs
    case SearchDrugs
    case SetUpGoalsReadings
    case SelectGoals
    case SelectReadings
    case SelectLocation
    case DoctorProfile
    case ForgotPasswordPhone
    case ForgotPasswordOtp
    case CreatePassword
    case CreateProfileFlow // for deeplink flow of profile completion
    case CatSurvey
    case SetHeightWeight
    case BookAppointment
    case AppointmentList
    case AppointmentHistory
    case ChatBot
    case ChatList
    case AddAddress
    case AddPatientDetails
    case BookLabtestAppointmentReview
    case HealthPackageList
    case BookLabtestAppointmentSuccess
    case LabtestCart
    case LabtestDetails
    case LabtestList
    case AllTestPackageList
    case LabtestOrderDetails
    case SelectPatient
    case SelectAddress
    case SelectLabtestAppointmentDateTime
    case MyTatvaPlans
    case MyTatvaPlanDetail
    case MyTatvaIndividualPlan
    case MyTatvaIndividualPlanDetail
    
    case Menu
    case ExerciseViewAll
    case ExercisePlanDayDetailExercise
    case ExercisePlanDayDetailBreathing
    case VideoPlayer
    case SearchFood
    case ProfileCompleteSuccess
    case AccountDelete
    case NotificationSettings
    case AnswerDetails
    case PostQuestion
    case SubmitAnswer
    case RegisterSuccess
    case HistoryTest
    case HistoryPayment
    case AppointmentConfirmed
    case none
    case LoginSignup = "LoginSignup"
    case SelectRole = "SelectRole"
    case LinkDoctor = "LinkDoctor"
    
    case DoYouHaveDevice
    case ConnectDevice    
    case LearnToConnectSmartScale
    case SearchSelectSmartScale
    case MeasureSmartScaleReadings
    case SmartScaleReadingAnalysis
    
    case Walkthrough
    
    case BcpList
    case BcpDetails
    case BcpPurchasedDetails
    case BcpDeviceDetails
    case BcpHcServices
    case BcpHcServiceSelectTimeSlot
    case BcpPurchaseSuccess
    case BcpOrderReview
    case SelectAddressBottomSheet
    case ConnectDeviceInfo
    case ExerciseFeedback
    case ExerciseMyRoutine
    
}

enum ScreenSection: String {
    case DiagnosticTest = "DiagnosticTest"
    case Prescription = "Prescription"
    case Records = "Records"
    case QuizPoll = "QuizPoll"
    case none
}

/*
 Screen Name
 
 Home
 CarePlan
 Engage
 ExercisePlan
 ExerciseMore
 ContentDetailPhotoGallery
 ContentDetailNormalVideo
 ContentDetailKolVideo
 ContentDetailBlog
 ContentDetailWebinar
 ExercisePlanDetail
 ExercisePlanDayDetail
 FoodDiaryDay
 FoodDiaryMonth
 FoodDiaryDayInsight
 LogFood
 LogFoodSuccess
 HelpSupportFaq
 NotificationList
 HistoryIncident
 IncidentDetails
 HistoryRecord
 UploadRecord
 BreathingVideo
 CommentList
 AddIncident
 MyAccount
 MyProfile
 EditProfile
 MyDevices
 MyDeviceDetail
 LogGoal{NameFromAPI(param-goal key)}
 LogReading{param reading key}
 GoalChart{goal key}
 ReadingChart{reading key}
 LoginWithPhone
 LoginWithPassword
 LoginOtp
 SelectLanguage
 LanguageList
 SignUpWithPhone
 SignUpOtp
 AddAccountDetails
 UseBiometric
 SetUpDrugs
 SearchDrugs
 SetUpGoalsReadings
 SelectGoals
 SelectReadings
 SelectLocation
 DoctorProfile
 ForgotPasswordPhone
 ForgotPasswordOtp
 CreatePassword
 
 */
class WebengageManager: NSObject {
    
    static let shared : WebengageManager = WebengageManager()
    
    let weUser: WEGUser = WebEngage.sharedInstance().user
    let weAnalytics: WEGAnalytics = WebEngage.sharedInstance().analytics
    let weObject = WEGMobileBridge()
    
    func initiate(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            if UserModel.shared.patientId != nil {
                LocationManager.shared.getLocation()
                
                self.weUser.login(UserModel.shared.patientId)
                self.weUser.setEmail(UserModel.shared.email)
                self.weUser.setPhone(UserModel.shared.countryCode + UserModel.shared.contactNo)
                self.weUser.setGender(UserModel.shared.gender == "M" ? "Male" : "Female")
                self.weUser.setFirstName(UserModel.shared.name)
                self.weUser.setBirthDateString(UserModel.shared.dob)
                if let arr = UserModel.shared.medicalConditionName, arr.count > 0 {
                    self.weUser.setAttribute("indication", withStringValue: arr.first!.medicalConditionName)
                }
                
                if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
                    self.weUser.setAttribute("dr_name", withStringValue: doc[0].name!)
                    self.weUser.setAttribute("dr_phone", withStringValue: doc[0].contactNo!)
                    
                }
                
                self.weUser.setAttribute("language", withStringValue: UserModel.shared.languageName)
                self.weUser.setAttribute("severity", withStringValue: UserModel.shared.severityName)
                
                if LocationManager.shared.isLocationServiceEnabled(showAlert: false) {
                    self.setUserLocation()
                }
                
                //------For Analytics
                Analytics.setUserID(UserModel.shared.patientId)
                Analytics.setSessionTimeoutInterval(60)
                
                //------FreshDeskManager initiate
                FreshDeskManager.shared.initFreshchatSDK()
            }
        }
    }
    
    func setUserLocation() {
        self.weUser.setUserLocationWithLatitude(NSNumber(value: LocationManager.shared.getUserLocation().coordinate.latitude), andLongitude: NSNumber(value: LocationManager.shared.getUserLocation().coordinate.longitude))
    }
    
    func navigateScreenEvent(screen: ScreenName, postFix: String? = nil){
        var name = screen.rawValue
        if let val = postFix {
            name += val
        }
        WebengageManager.shared.weAnalytics.navigatingToScreen(withName: name)
        
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: name])
        
        debugPrint("Screen log ======================>" ,  name)
    }
}
