package com.mytatva.patient.di.component


import com.mytatva.patient.di.PerFragment
import com.mytatva.patient.di.module.FragmentModule
import com.mytatva.patient.ui.address.fragment.AddressConfirmLocationFragment
import com.mytatva.patient.ui.appointment.fragment.AllAppointmentsFragment
import com.mytatva.patient.ui.appointment.fragment.BookAppointmentsFragment
import com.mytatva.patient.ui.auth.fragment.AddAccountDetailsFragment
import com.mytatva.patient.ui.auth.fragment.CreatePasswordFragment
import com.mytatva.patient.ui.auth.fragment.ForgotPasswordFragment
import com.mytatva.patient.ui.auth.fragment.ForgotPasswordPhoneNumberFragment
import com.mytatva.patient.ui.auth.fragment.LoginOtpVerificationFragment
import com.mytatva.patient.ui.auth.fragment.LoginWithOtpFragment
import com.mytatva.patient.ui.auth.fragment.LoginWithPasswordFragment
import com.mytatva.patient.ui.auth.fragment.ProfileSetupSuccessFragment
import com.mytatva.patient.ui.auth.fragment.ScanQRCodeFragment
import com.mytatva.patient.ui.auth.fragment.SearchMedicineFragment
import com.mytatva.patient.ui.auth.fragment.SelectGoalsReadingsFragment
import com.mytatva.patient.ui.auth.fragment.SelectLanguageFragment
import com.mytatva.patient.ui.auth.fragment.SelectLanguageListFragment
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.auth.fragment.SetupDrugsFragment
import com.mytatva.patient.ui.auth.fragment.SetupGoalsReadingsFragment
import com.mytatva.patient.ui.auth.fragment.SetupHeightWeightFragment
import com.mytatva.patient.ui.auth.fragment.SignUpPhoneFragment
import com.mytatva.patient.ui.auth.fragment.SignUpWithOtpFragment
import com.mytatva.patient.ui.auth.fragment.UseBiometricFragment
import com.mytatva.patient.ui.auth.fragment.v1.AddAccountDetailsNewFragment
import com.mytatva.patient.ui.auth.fragment.v1.LoginOrSignupNewFragment
import com.mytatva.patient.ui.auth.fragment.v1.LoginSignupOtpVerificationNewFragment
import com.mytatva.patient.ui.auth.fragment.v1.SelectRoleFragment
import com.mytatva.patient.ui.auth.fragment.v1.VerifyLinkDoctorFragment
import com.mytatva.patient.ui.auth.fragment.v2.ChooseYourConditionV2Fragment
import com.mytatva.patient.ui.auth.fragment.v2.LetsBeginV2Fragment
import com.mytatva.patient.ui.auth.fragment.v2.OTPVerificationFragment
import com.mytatva.patient.ui.auth.fragment.v2.SetUpYourProfileV2Fragment
import com.mytatva.patient.ui.auth.fragment.v2.WalkThroughFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.careplan.PDFViewerFragment
import com.mytatva.patient.ui.careplan.fragment.AddIncidentFragment
import com.mytatva.patient.ui.careplan.fragment.CarePlanFragment
import com.mytatva.patient.ui.careplan.fragment.DietPlanListFragment
import com.mytatva.patient.ui.careplan.fragment.GoalSummaryCommonFragment
import com.mytatva.patient.ui.careplan.fragment.GoalSummaryMedicationFragment
import com.mytatva.patient.ui.careplan.fragment.ReadingSummaryCommonFragment
import com.mytatva.patient.ui.chat.dialog.ChatListFragment
import com.mytatva.patient.ui.chat.fragment.ChatBotFragment
import com.mytatva.patient.ui.common.fragment.BlankFragment
import com.mytatva.patient.ui.common.fragment.SelectItemFragment
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.common.fragment.WebViewPaymentFragment
import com.mytatva.patient.ui.engage.fragment.AnswerCommentsFragment
import com.mytatva.patient.ui.engage.fragment.CommentsFragment
import com.mytatva.patient.ui.engage.fragment.EngageAskAnExpertFragment
import com.mytatva.patient.ui.engage.fragment.EngageDiscoverFragment
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.engage.fragment.EngageFragment
import com.mytatva.patient.ui.engage.fragment.QuestionDetailsFragment
import com.mytatva.patient.ui.exercise.DayDetailsBreathingExerciseCommonFragment
import com.mytatva.patient.ui.exercise.DayDetailsBreathingExerciseCommonNewFragment
import com.mytatva.patient.ui.exercise.ExerciseDescriptionInfoFragment
import com.mytatva.patient.ui.exercise.ExerciseFragment
import com.mytatva.patient.ui.exercise.ExerciseMoreFragment
import com.mytatva.patient.ui.exercise.ExerciseMyPlansFragment
import com.mytatva.patient.ui.exercise.ExerciseMyPlansNewFragment
import com.mytatva.patient.ui.exercise.ExerciseMyRoutineFragment
import com.mytatva.patient.ui.exercise.ExerciseMyRoutineListFragment
import com.mytatva.patient.ui.exercise.ExercisePlanDetailsFragment
import com.mytatva.patient.ui.exercise.ExercisePlanDetailsNewFragment
import com.mytatva.patient.ui.exercise.ExerciseViewAllFragment
import com.mytatva.patient.ui.exercise.PlanBreathingPlayerFragment
import com.mytatva.patient.ui.exercise.PlanDayDetailsFragment
import com.mytatva.patient.ui.exercise.PlanDayDetailsNewFragment
import com.mytatva.patient.ui.goal.fragment.FoodDayInsightFragment
import com.mytatva.patient.ui.goal.fragment.FoodDiaryDayFragment
import com.mytatva.patient.ui.goal.fragment.FoodDiaryMainFragment
import com.mytatva.patient.ui.goal.fragment.FoodDiaryMonthFragment
import com.mytatva.patient.ui.goal.fragment.LogExerciseFragment
import com.mytatva.patient.ui.goal.fragment.LogFoodFragment
import com.mytatva.patient.ui.goal.fragment.LogFoodQuantityHelpFragment
import com.mytatva.patient.ui.goal.fragment.LogFoodSuccessFragment
import com.mytatva.patient.ui.goal.fragment.LogMedicationFragment
import com.mytatva.patient.ui.goal.fragment.LogPranayamFragment
import com.mytatva.patient.ui.goal.fragment.LogSleepFragment
import com.mytatva.patient.ui.goal.fragment.LogStepsFragment
import com.mytatva.patient.ui.goal.fragment.LogWaterIntakeFragment
import com.mytatva.patient.ui.goal.fragment.SelectFoodFragment
import com.mytatva.patient.ui.goal.fragment.UpdateGoalLogsFragment
import com.mytatva.patient.ui.home.RNHomeFragment
import com.mytatva.patient.ui.home.fragment.AppUnderMaintenenceFragment
import com.mytatva.patient.ui.home.fragment.DevicesFragment
import com.mytatva.patient.ui.home.fragment.HomeFragment
import com.mytatva.patient.ui.home.fragment.SearchFragment
import com.mytatva.patient.ui.labtest.fragment.AddEditAddressFragment
import com.mytatva.patient.ui.labtest.fragment.AddPatientDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.BookAppointmentReviewFragment
import com.mytatva.patient.ui.labtest.fragment.HealthPackageListFragment
import com.mytatva.patient.ui.labtest.fragment.LabTestDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.LabTestListFragment
import com.mytatva.patient.ui.labtest.fragment.LabTestListNormalFragment
import com.mytatva.patient.ui.labtest.fragment.LabtestAppointmentBookSuccessFragment
import com.mytatva.patient.ui.labtest.fragment.LabtestCartFragment
import com.mytatva.patient.ui.labtest.fragment.LabtestOrderDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.OrderDetailsOrderSummaryFragment
import com.mytatva.patient.ui.labtest.fragment.OrderDetailsTestFragment
import com.mytatva.patient.ui.labtest.fragment.PatientDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.SelectAddressFragment
import com.mytatva.patient.ui.labtest.fragment.SelectLabtestAppointmentDateTimeFragment
import com.mytatva.patient.ui.labtest.fragment.v1.LabtestCartV1Fragment
import com.mytatva.patient.ui.labtest.fragment.v1.LabtestOrderReviewFragment
import com.mytatva.patient.ui.labtest.fragment.v1.SelectLabtestAppointmentDateTimeFragmentV1
import com.mytatva.patient.ui.menu.fragment.AboutUsFragment
import com.mytatva.patient.ui.menu.fragment.BookmarksFragment
import com.mytatva.patient.ui.menu.fragment.BookmarksViewAllFragment
import com.mytatva.patient.ui.menu.fragment.HelpSupportFAQFragment
import com.mytatva.patient.ui.menu.fragment.HistoryAppointmentFragment
import com.mytatva.patient.ui.menu.fragment.HistoryFragment
import com.mytatva.patient.ui.menu.fragment.HistoryIncidentFragment
import com.mytatva.patient.ui.menu.fragment.HistoryPaymentFragment
import com.mytatva.patient.ui.menu.fragment.HistoryRecordFragment
import com.mytatva.patient.ui.menu.fragment.HistoryTestsFragment
import com.mytatva.patient.ui.menu.fragment.HistoryViewAllPaymentFragment
import com.mytatva.patient.ui.menu.fragment.IncidentDetailsFragment
import com.mytatva.patient.ui.menu.fragment.SearchRecordTitleFragment
import com.mytatva.patient.ui.menu.fragment.UploadRecordFragment
import com.mytatva.patient.ui.mydevices.fragment.BcaReadingDataAnalysisMainFragment
import com.mytatva.patient.ui.mydevices.fragment.BcaReadingDataAnalysisSubFragment
import com.mytatva.patient.ui.mydevices.fragment.MeasureBcaReadingFragment
import com.mytatva.patient.ui.mydevices.fragment.MyDeviceSelectSmartScaleFragment
import com.mytatva.patient.ui.payment.fragment.IndividualServicesFragment
import com.mytatva.patient.ui.payment.fragment.PaymentCouponCodeListFragment
import com.mytatva.patient.ui.payment.fragment.PaymentPlanDetailsFragment
import com.mytatva.patient.ui.payment.fragment.PaymentPlanServiceMainFragment
import com.mytatva.patient.ui.payment.fragment.PaymentPlansFragment
import com.mytatva.patient.ui.payment.fragment.v1.AddAddressFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpMyDevicesFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpOrderReviewFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpPaymentSuccessFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpPurchasedDetailsFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpScheduleAppointmentFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentBCPAppointmentDateTimeFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentDeviceDetailsOrderSummaryFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentPlanDetailsV1Fragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentTrackMyOrdersFragment
import com.mytatva.patient.ui.profile.fragment.AccountSettingsFragment
import com.mytatva.patient.ui.profile.fragment.DeleteMyAccountFragment
import com.mytatva.patient.ui.profile.fragment.DoctorProfileFragment
import com.mytatva.patient.ui.profile.fragment.EditProfileFragment
import com.mytatva.patient.ui.profile.fragment.MyDeviceDetailsFragment
import com.mytatva.patient.ui.profile.fragment.MyDevicesFragment
import com.mytatva.patient.ui.profile.fragment.MyProfileFragment
import com.mytatva.patient.ui.profile.fragment.NotificationSettingsCommonGoalReminderFragment
import com.mytatva.patient.ui.profile.fragment.NotificationSettingsFoodReminderFragment
import com.mytatva.patient.ui.profile.fragment.NotificationSettingsFragment
import com.mytatva.patient.ui.profile.fragment.NotificationSettingsReadingsReminderFragment
import com.mytatva.patient.ui.profile.fragment.NotificationSettingsWaterReminderFragment
import com.mytatva.patient.ui.profile.fragment.NotificationsFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingBMIFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingBloodGlucoseFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingBloodPressureFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingCommonFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingFibScoreFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingFibroScanFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingTotalCholesterolFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingWalkTestFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingsMainFragment
import com.mytatva.patient.ui.spirometer.fragment.SpirometerAllReadingsFragment
import com.mytatva.patient.ui.spirometer.fragment.SpirometerEnterDetailsFragment
import com.mytatva.patient.ui.spirometer.fragment.v1.SpirometerEnterDetailsV1Fragment
import com.mytatva.patient.ui.spirometer.fragment.v1.SpirometerSubAllReadingFragment
import dagger.Subcomponent

/**
 * Created by hlink21 on 31/5/16.
 */

@PerFragment
@Subcomponent(modules = [(FragmentModule::class)])
interface FragmentComponent {
    fun baseFragment(): BaseFragment<*>
    fun inject(loginWithOtpFragment: LoginWithOtpFragment)
    fun inject(homeFragment: HomeFragment)
    fun inject(loginWithPasswordFragment: LoginWithPasswordFragment)
    fun inject(selectLanguageFragment: SelectLanguageFragment)
    fun inject(signUpPhoneFragment: SignUpPhoneFragment)
    fun inject(signUpWithOtpFragment: SignUpWithOtpFragment)
    fun inject(addAccountDetailsFragment: AddAccountDetailsFragment)
    fun inject(setupDrugsFragment: SetupDrugsFragment)
    fun inject(searchMedicineFragment: SearchMedicineFragment)
    fun inject(setupGoalsReadingsFragment: SetupGoalsReadingsFragment)
    fun inject(selectGoalsReadingsFragment: SelectGoalsReadingsFragment)
    fun inject(useBiometricFragment: UseBiometricFragment)
    fun inject(forgotPasswordFragment: ForgotPasswordFragment)
    fun inject(createPasswordFragment: CreatePasswordFragment)
    fun inject(selectYourLocationFragment: SelectYourLocationFragment)
    fun inject(myProfileFragment: MyProfileFragment)
    fun inject(editProfileFragment: EditProfileFragment)
    fun inject(doctorProfileFragment: DoctorProfileFragment)
    fun inject(selectLanguageListFragment: SelectLanguageListFragment)
    fun inject(selectItemFragment: SelectItemFragment)
    fun inject(forgotPasswordPhoneNumberFragment: ForgotPasswordPhoneNumberFragment)
    fun inject(accountSettingsFragment: AccountSettingsFragment)
    fun inject(profileSetupSuccessFragment: ProfileSetupSuccessFragment)
    fun inject(loginOtpVerificationFragment: LoginOtpVerificationFragment)
    fun inject(updateGoalLogsFragment: UpdateGoalLogsFragment)
    fun inject(logMedicationFragment: LogMedicationFragment)
    fun inject(logExerciseFragment: LogExerciseFragment)
    fun inject(logPranayamFragment: LogPranayamFragment)
    fun inject(logStepsFragment: LogStepsFragment)
    fun inject(logWaterIntakeFragment: LogWaterIntakeFragment)
    fun inject(logSleepFragment: LogSleepFragment)
    fun inject(updateReadingsMainFragment: UpdateReadingsMainFragment)
    fun inject(updateReadingCommonFragment: UpdateReadingCommonFragment)
    fun inject(updateReadingBloodPressureFragment: UpdateReadingBloodPressureFragment)
    fun inject(updateReadingBloodGlucoseFragment: UpdateReadingBloodGlucoseFragment)
    fun inject(updateReadingBMIFragment: UpdateReadingBMIFragment)
    fun inject(carePlanFragment: CarePlanFragment)
    fun inject(goalSummaryMedicationFragment: GoalSummaryMedicationFragment)
    fun inject(goalSummaryCommonFragment: GoalSummaryCommonFragment)
    fun inject(readingSummaryCommonFragment: ReadingSummaryCommonFragment)
    fun inject(engageFragment: EngageFragment)
    fun inject(engageDiscoverFragment: EngageDiscoverFragment)
    fun inject(engageFeedDetailsFragment: EngageFeedDetailsFragment)
    fun inject(commentsFragment: CommentsFragment)
    fun inject(historyFragment: HistoryFragment)
    fun inject(historyIncidentFragment: HistoryIncidentFragment)
    fun inject(blankFragment: BlankFragment)
    fun inject(incidentDetailsFragment: IncidentDetailsFragment)
    fun inject(myDevicesFragment: MyDevicesFragment)
    fun inject(addIncidentFragment: AddIncidentFragment)
    fun inject(myDeviceDetailsFragment: MyDeviceDetailsFragment)
    fun inject(bookmarksFragment: BookmarksFragment)
    fun inject(bookmarksViewAllFragment: BookmarksViewAllFragment)
    fun inject(exerciseFragment: ExerciseFragment)
    fun inject(exerciseMoreFragment: ExerciseMoreFragment)
    fun inject(exerciseMyPlansFragment: ExerciseMyPlansFragment)
    fun inject(exercisePlanDetailsFragment: ExercisePlanDetailsFragment)
    fun inject(planBreathingPlayerFragment: PlanBreathingPlayerFragment)
    fun inject(planDayDetailsFragment: PlanDayDetailsFragment)
    fun inject(dayDetailsBreathingExerciseCommonFragment: DayDetailsBreathingExerciseCommonFragment)
    fun inject(foodDiaryMainFragment: FoodDiaryMainFragment)
    fun inject(foodDiaryDayFragment: FoodDiaryDayFragment)
    fun inject(foodDiaryMonthFragment: FoodDiaryMonthFragment)
    fun inject(logFoodFragment: LogFoodFragment)
    fun inject(logFoodQuantityHelpFragment: LogFoodQuantityHelpFragment)
    fun inject(logFoodSuccessFragment: LogFoodSuccessFragment)
    fun inject(foodDayInsightFragment: FoodDayInsightFragment)
    fun inject(notificationsFragment: NotificationsFragment)
    fun inject(historyRecordFragment: HistoryRecordFragment)
    fun inject(uploadRecordFragment: UploadRecordFragment)
    fun inject(helpSupportFAQFragment: HelpSupportFAQFragment)
    fun inject(searchRecordTitleFragment: SearchRecordTitleFragment)
    fun inject(exerciseViewAllFragment: ExerciseViewAllFragment)
    fun inject(setupHeightWeightFragment: SetupHeightWeightFragment)
    fun inject(scanQRCodeFragment: ScanQRCodeFragment)
    fun inject(chatBotFragment: ChatBotFragment)
    fun inject(appUnderMaintenenceFragment: AppUnderMaintenenceFragment)
    fun inject(paymentPlanServiceMainFragment: PaymentPlanServiceMainFragment)
    fun inject(individualServicesFragment: IndividualServicesFragment)
    fun inject(paymentPlansFragment: PaymentPlansFragment)
    fun inject(paymentPlanDetailsFragment: PaymentPlanDetailsFragment)
    fun inject(historyPaymentFragment: HistoryPaymentFragment)
    fun inject(updateReadingWalkTestFragment: UpdateReadingWalkTestFragment)
    fun inject(notificationSettingsFragment: NotificationSettingsFragment)
    fun inject(notificationSettingsFoodReminderFragment: NotificationSettingsFoodReminderFragment)
    fun inject(notificationSettingsWaterReminderFragment: NotificationSettingsWaterReminderFragment)
    fun inject(notificationSettingsCommonGoalReminderFragment: NotificationSettingsCommonGoalReminderFragment)
    fun inject(notificationSettingsReadingsReminderFragment: NotificationSettingsReadingsReminderFragment)
    fun inject(engageAskAnExpertFragment: EngageAskAnExpertFragment)
    fun inject(questionDetailsFragment: QuestionDetailsFragment)
    fun inject(answerCommentsFragment: AnswerCommentsFragment)
    fun inject(devicesFragment: DevicesFragment)
    fun inject(aboutUsFragment: AboutUsFragment)
    fun inject(reactUseInFragment: RNHomeFragment)

    /* **********************************************
     * exercise plan new changes fragments - start
     * **********************************************/
    fun inject(exerciseMyPlansNewFragment: ExerciseMyPlansNewFragment)
    fun inject(exercisePlanDetailsNewFragment: ExercisePlanDetailsNewFragment)
    fun inject(planDayDetailsNewFragment: PlanDayDetailsNewFragment)
    fun inject(dayDetailsBreathingExerciseCommonNewFragment: DayDetailsBreathingExerciseCommonNewFragment)
    /* **********************************************
     * exercise plan new changes fragments - end
     * **********************************************/

    fun inject(historyAppointmentFragment: HistoryAppointmentFragment)
    fun inject(allAppointmentsFragment: AllAppointmentsFragment)
    fun inject(bookAppointmentsFragment: BookAppointmentsFragment)
    fun inject(webViewPaymentFragment: WebViewPaymentFragment)
    fun inject(labTestListFragment: LabTestListFragment)
    fun inject(addEditAddressFragment: AddEditAddressFragment)
    fun inject(selectAddressFragment: SelectAddressFragment)
    fun inject(selectLabtestAppointmentDateTimeFragment: SelectLabtestAppointmentDateTimeFragment)
    fun inject(bookAppointmentReviewFragment: BookAppointmentReviewFragment)
    fun inject(labtestAppointmentBookSuccessFragment: LabtestAppointmentBookSuccessFragment)
    fun inject(labtestOrderDetailsFragment: LabtestOrderDetailsFragment)
    fun inject(orderDetailsOrderSummaryFragment: OrderDetailsOrderSummaryFragment)
    fun inject(orderDetailsTestFragment: OrderDetailsTestFragment)
    fun inject(historyTestsFragment: HistoryTestsFragment)
    fun inject(labTestDetailsFragment: LabTestDetailsFragment)
    fun inject(labtestCartFragment: LabtestCartFragment)
    fun inject(patientDetailsFragment: PatientDetailsFragment)
    fun inject(healthPackageListFragment: HealthPackageListFragment)
    fun inject(labTestListNormalFragment: LabTestListNormalFragment)
    fun inject(addPatientDetailsFragment: AddPatientDetailsFragment)
    fun inject(webViewCommonFragment: WebViewCommonFragment)
    fun inject(selectFoodFragment: SelectFoodFragment)
    fun inject(deleteMyAccountFragment: DeleteMyAccountFragment)
    fun inject(searchFragment: SearchFragment)

    fun inject(updateReadingFibroScanFragment: UpdateReadingFibroScanFragment)
    fun inject(updateReadingTotalCholesterolFragment: UpdateReadingTotalCholesterolFragment)
    fun inject(updateReadingFibScoreFragment: UpdateReadingFibScoreFragment)
    fun inject(chatListFragment: ChatListFragment)
    fun inject(exerciseDescriptionInfoFragment: ExerciseDescriptionInfoFragment)
    fun inject(historyViewAllPaymentFragment: HistoryViewAllPaymentFragment)
    fun inject(pdfViewerFragment: PDFViewerFragment)
    fun inject(exerciseMyRoutineFragment: ExerciseMyRoutineFragment)
    fun inject(exerciseMyRoutineListFragment: ExerciseMyRoutineListFragment)
    fun inject(dietPlanListFragment: DietPlanListFragment)

    // auth v1 -  auth flow revamp may sprint 1, 2023
    fun inject(loginOrSignupNewFragment: LoginOrSignupNewFragment)
    fun inject(loginSignupOtpVerificationNewFragment: LoginSignupOtpVerificationNewFragment)
    fun inject(selectRoleFragment: SelectRoleFragment)
    fun inject(verifyLinkDoctorFragment: VerifyLinkDoctorFragment)
    fun inject(addAccountDetailsNewFragment: AddAccountDetailsNewFragment)

    // bca
    fun inject(myDeviceSelectSmartScaleFragment: MyDeviceSelectSmartScaleFragment)
    fun inject(measureBcaReadingFragment: MeasureBcaReadingFragment)
    fun inject(myDeviceVitalsReadingDetailsFragment: BcaReadingDataAnalysisSubFragment)
    fun inject(bcaReadingDataAnalysisMainFragment: BcaReadingDataAnalysisMainFragment)

    // bcp

    fun inject(walkThroughFragment: WalkThroughFragment)
    fun inject(otpVerificationFragment: OTPVerificationFragment)

    fun inject(bcpOrderReviewFragment: BcpOrderReviewFragment)
    fun inject(paymentCarePlanListingFragment: PaymentCarePlanListingFragment)
    fun inject(bcpPaymentSuccessFragment: BcpPaymentSuccessFragment)
    fun inject(paymentTrackMyOrdersFragment: PaymentTrackMyOrdersFragment)
    fun inject(addAddressFragment: AddAddressFragment)
    fun inject(paymentDeviceDetailsOrderSummaryFragment: PaymentDeviceDetailsOrderSummaryFragment)
    fun inject(bcpPurchasedDetailsFragment: BcpPurchasedDetailsFragment)
    fun inject(bcpScheduleAppointmentFragment: BcpScheduleAppointmentFragment)
    fun inject(paymentPlanDetailsV1Fragment: PaymentPlanDetailsV1Fragment)
    fun inject(bcpMyDevicesFragment: BcpMyDevicesFragment)
    fun inject(labtestOrderReviewFragment: LabtestOrderReviewFragment)
    fun inject(labtestCartV1Fragment: LabtestCartV1Fragment)
    fun inject(paymentBCPAppointmentDateTimeFragment: PaymentBCPAppointmentDateTimeFragment)

    // spirometer
    fun inject(spirometerEnterDetailsFragment: SpirometerEnterDetailsFragment)
    fun inject(spirometerAllReadingsFragment: SpirometerAllReadingsFragment)

    fun inject(selectLabtestAppointmentDateTimeFragmentV1: SelectLabtestAppointmentDateTimeFragmentV1)
    fun inject(letsBeginV2Fragment: LetsBeginV2Fragment)
    fun inject(setUpYourProfileV2Fragment: SetUpYourProfileV2Fragment)
    fun inject(chooseYourConditionV2Fragment: ChooseYourConditionV2Fragment)
    fun inject(spirometerEnterDetailsV1Fragment: SpirometerEnterDetailsV1Fragment)
    fun inject(spirometerSubAllReadingFragment: SpirometerSubAllReadingFragment)
    fun inject(paymentCouponCodeListFragment: PaymentCouponCodeListFragment)
    fun inject(addressConfirmLocationFragment: AddressConfirmLocationFragment)
}
