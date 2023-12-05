package com.mytatva.patient.utils.firebaseanalytics

object AnalyticsScreenNames {
    const val Home = "Home"
    const val CarePlan = "CarePlan"
    const val DiscoverEngage = "DiscoverEngage"
    const val ExercisePlan = "ExercisePlan"
    const val ExerciseMore = "ExerciseMore"
    const val ContentDetailPhotoGallery = "ContentDetailPhotoGallery"
    const val ContentDetailNormalVideo = "ContentDetailNormalVideo"
    const val ContentDetailKolVideo = "ContentDetailKolVideo"
    const val ContentDetailBlog = "ContentDetailBlog"
    const val ContentDetailWebinar = "ContentDetailWebinar"
    const val ExercisePlanDetail = "ExercisePlanDetail"
    const val ExercisePlanDayDetail = "ExercisePlanDayDetail"
    const val FoodDiaryDay = "FoodDiaryDay"
    const val FoodDiaryMonth = "FoodDiaryMonth"
    const val FoodDiaryDayInsight = "FoodDiaryDayInsight"
    const val LogFood = "LogFood"
    const val LogFoodSuccess = "LogFoodSuccess"
    const val HelpSupportFaq = "HelpSupportFaq"
    const val NotificationList = "NotificationList"
    const val HistoryIncident = "HistoryIncident"
    const val IncidentDetails = "IncidentDetails"
    const val HistoryRecord = "HistoryRecord"
    const val UploadRecord = "UploadRecord"
    const val BreathingVideo = "BreathingVideo"
    const val CommentList = "CommentList"
    const val AddIncident = "AddIncident"
    const val MyAccount = "MyAccount"
    const val MyProfile = "MyProfile"
    const val EditProfile = "EditProfile"
    const val MyDevices = "MyDevices"
    const val MyDeviceDetail = "MyDeviceDetail"
    const val LoginWithPhone = "LoginWithPhone"
    const val LoginWithPassword = "LoginWithPassword"
    const val LoginOtp = "LoginOtp"
    const val SelectLanguage = "SelectLanguage"
    const val LanguageList = "LanguageList"
    const val SignUpWithPhone = "SignUpWithPhone"
    const val SignUpOtp = "SignUpOtp"
    const val AddAccountDetails = "AddAccountDetails"
    const val UseBiometric = "UseBiometric"
    const val SetUpDrugs = "SetUpDrugs"
    const val SearchDrugs = "SearchDrugs"
    const val SetUpGoalsReadings = "SetUpGoalsReadings"
    const val SelectGoals = "SelectGoals"
    const val SelectReadings = "SelectReadings"
    const val SelectLocation = "SelectLocation"
    const val DoctorProfile = "DoctorProfile"
    const val ForgotPasswordPhone = "ForgotPasswordPhone"
    const val ForgotPasswordOtp = "ForgotPasswordOtp"
    const val CreatePassword = "CreatePassword"
    const val RequestCallBack = "RequestCallBack"
    const val LogGoal = "LogGoal" //LogGoal{NameFromAPI(param-goal key)}
    const val LogReading = "LogReading" //LogReading{param reading key}
    const val SetHeightWeight = "SetHeightWeight"
    const val GenAI = "genAi"

    //const val GoalChart = "GoalChart" //GoalChart{goal key} // no need already inside care plan
    const val ReadingChart = "ReadingChart" //ReadingChart{reading key}
    const val ReportComment = "ReportComment"
    const val BookmarkList = "BookmarkList"
    const val AllBookmark = "AllBookmark"
    const val FaqQuery = "FaqQuery"


    //Screen names for deep link navigation only
    const val CreateProfileFlow = "CreateProfileFlow" // when setup profile flow will going to open
    const val CatSurvey = "CatSurvey"

    const val AskAnExpert = "AskAnExpert"
    const val QuestionDetails = "QuestionDetails"


    /* Book Appointment Module */
    const val BookAppointment = "BookAppointment"
    const val AppointmentList = "AppointmentList"
    const val AppointmentHistory = "AppointmentHistory"

    /* ChatBot */
    const val ChatBot = "ChatBot"
    const val ChatList = "ChatList"

    /* Labtest */
    const val AddAddress = "AddAddress"
    const val AddPatientDetails = "AddPatientDetails"
    const val BookLabtestAppointmentReview = "BookLabtestAppointmentReview"
    const val HealthPackageList = "HealthPackageList"
    const val BookLabtestAppointmentSuccess = "BookLabtestAppointmentSuccess"
    const val LabtestCart = "LabtestCart"
    const val LabtestDetails = "LabtestDetails"
    const val LabtestList = "LabtestList"
    const val AllTestPackageList = "AllTestPackageList"
    const val LabtestOrderDetails = "LabtestOrderDetails"
    const val SelectPatient = "SelectPatient"
    const val SelectAddress = "SelectAddress"
    const val SelectLabtestAppointmentDateTime = "SelectLabtestAppointmentDateTime"

    /* MyTatva Plans */
    const val MyTatvaPlans = "MyTatvaPlans"

    /* MyTatva Plans new added screens 2023 MAR Sprint 1 - start*/
    const val MyTatvaPlanDetail = "MyTatvaPlanDetail"
    const val MyTatvaIndividualPlan = "MyTatvaIndividualPlan"
    const val MyTatvaIndividualPlanDetail = "MyTatvaIndividualPlanDetail"
    /* MyTatva Plans new added screens 2023 MAR Sprint 1 - end*/

    /*  */
    const val Menu = "Menu"
    const val ExerciseViewAll = "ExerciseViewAll"
    const val ExercisePlanDayDetailExercise = "ExercisePlanDayDetailExercise"
    const val ExercisePlanDayDetailBreathing = "ExercisePlanDayDetailBreathing"
    const val VideoPlayer = "VideoPlayer"
    const val SearchFood = "SearchFood"
    const val ProfileCompleteSuccess = "ProfileCompleteSuccess"
    const val AccountDelete = "AccountDelete"
    const val NotificationSettings = "NotificationSettings"
    const val AnswerDetails = "AnswerDetails"
    const val PostQuestion = "PostQuestion"
    const val SubmitAnswer = "SubmitAnswer"
    const val RegisterSuccess = "RegisterSuccess"
    const val HistoryTest = "HistoryTest"
    const val AppointmentConfirmed = "AppointmentConfirmed"

    /* Sprint MAR1 added screen names */
    const val HistoryPayment = "HistoryPayment"

//    const val VideoPlayer="VideoPlayer"

    //const val AskAnExpert = "AskAnExpert"
    //const val AskAnExpert = "AskAnExpert"

    /* Sprint May1 2023 added screen names start*/
    const val LoginSignup = "LoginSignup"
    const val SelectRole = "SelectRole"
    const val LinkDoctor = "LinkDoctor"
    /* Sprint May1 2023 added screen names end*/

    /* BCA leftover point Sprint May3 2023 added screen names start*/
    const val DoYouHaveDevice = "DoYouHaveDevice"
    const val ConnectDevice = "ConnectDevice"
    const val LearnToConnectSmartScale = "LearnToConnectSmartScale"
    const val SearchSelectSmartScale = "SearchSelectSmartScale"
    const val MeasureSmartScaleReadings = "MeasureSmartScaleReadings"
    const val SmartScaleReadingAnalysis = "SmartScaleReadingAnalysis"
    /* BCA leftover point Sprint May3 2023 added screen names end*/

    const val Walkthrough = "Walkthrough"

    /* BCP added screen names start*/
    const val BcpList = "BcpList"
    const val BcpDetails = "BcpDetails"
    const val SelectAddressBottomSheet = "SelectAddressBottomSheet"
    const val BcpPurchasedDetails = "BcpPurchasedDetails"
    const val BcpDeviceDetails = "BcpDeviceDetails"
    const val BcpHcServices = "BcpHcServices"
    const val BcpHcServiceSelectTimeSlot = "BcpHcServiceSelectTimeSlot"
    const val BcpPurchaseSuccess = "BcpPurchaseSuccess"
    const val BcpOrderReview = "BcpOrderReview"
    const val ConnectDeviceInfo = "ConnectDeviceInfo"
    /* BCP added screen names end*/

    /* Spirometer added screen names start*/
    const val SpirometerEnterDetails = "SpirometerEnterDetails"
    const val SpirometerAllReadings = "SpirometerAllReadings"
    const val SelectTestType = "SelectTestType"
    /* Spirometer added screen names end*/

    /* Exercise revamp added screen names start*/
    const val ExerciseMyRoutine = "ExerciseMyRoutine"
    const val ExerciseFeedback = "ExerciseFeedback"
    /* Exercise revamp added screen names end*/

    /*Discount Coupon Code List screen names start*/
    const val CouponCodeList = "CouponCodeList"
    const val AppliedCouponCodeSuccess = "AppliedCouponCodeSuccess"
    /*Discount Coupon Code List screen names ends*/

    /* GEO Location added screen name start*/
    const val LocationPermission = "LocationPermission"
    const val EnterLocationPinCode = "EnterLocationPinCode"
    const val ConfirmLocationMap = "ConfirmLocationMap"
    const val EnterAddress = "EnterAddress"
    /* GEO Location added screen name end*/
}