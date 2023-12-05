package com.mytatva.patient.di.component

import android.app.Application
import android.content.Context
import android.content.res.Resources
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.repository.AuthRepository
import com.mytatva.patient.data.repository.GoalReadingRepository
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.module.ApplicationModule
import com.mytatva.patient.di.module.NetModule
import com.mytatva.patient.di.module.ServiceModule
import com.mytatva.patient.di.module.ViewModelModule
import com.mytatva.patient.ui.auth.bottomsheet.SelectDaysBottomSheetDialog
import com.mytatva.patient.ui.auth.bottomsheet.SelectMedicalConditionBottomSheetDialog
import com.mytatva.patient.ui.auth.bottomsheet.SuggestedDosageBottomSheetDialog
import com.mytatva.patient.ui.auth.bottomsheet.v1.SelectRelationTypeBottomSheetDialog
import com.mytatva.patient.ui.auth.bottomsheet.v2.LoginWithOtpBottomSheet
import com.mytatva.patient.ui.auth.dialog.AccountCreateSuccessDialog
import com.mytatva.patient.ui.auth.dialog.AccountSetupProfileDialog
import com.mytatva.patient.ui.common.dialog.SelectItemBottomSheetDialog
import com.mytatva.patient.ui.common.dialog.WebViewCommonDialog
import com.mytatva.patient.ui.home.dialog.CorrectAnswerResultDialog
import com.mytatva.patient.ui.home.dialog.LocationUpdateBottomSheetDialog
import com.mytatva.patient.ui.home.dialog.ReadingInfoDialog
import com.mytatva.patient.ui.mydevices.bottomsheet.ConnectSmartScaleBottomSheetDialog
import com.mytatva.patient.ui.mydevices.bottomsheet.DeviceInfoConnectBottomSheetDialog
import com.mytatva.patient.ui.mydevices.bottomsheet.DoYouHaveDeviceBottomSheetDialog
import com.mytatva.patient.ui.mydevices.bottomsheet.LearnHowToConnectBottomSheetDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.CommonWheelPickerDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.HeightWheelPickerDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.TestTypeBottomSheetDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.WeightWheelPickerDialog
import com.mytatva.patient.ui.spirometer.dialog.EnterTargetVolumeDialog
import com.mytatva.patient.utils.DownloadHelper
import com.mytatva.patient.utils.Validator
import com.mytatva.patient.utils.coachmarks.CoachMarksUtil
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.googlefit.GoogleFit
import com.mytatva.patient.utils.lifetron.LSBleManager
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import com.mytatva.patient.utils.spirometer.SpirometerManager
import com.mytatva.patient.utils.surveysparrow.SurveyUtil
import dagger.BindsInstance
import dagger.Component
import java.io.File
import java.util.*
import javax.inject.Named
import javax.inject.Singleton

/**
 * Created by hlink21 on 9/5/16.
 */
@Singleton
@Component(modules = [ApplicationModule::class, ViewModelModule::class, NetModule::class, ServiceModule::class])
interface ApplicationComponent {

    fun context(): Context

    @Named("cache")
    fun provideCacheDir(): File

    fun provideResources(): Resources

    fun provideCurrentLocale(): Locale

    fun provideViewModelFactory(): ViewModelProvider.Factory

    fun provideUserRepository(): AuthRepository

    fun provideGoalReadingRepository(): GoalReadingRepository

    fun provideValidator(): Validator

    fun firebaseAnalyticsClient(): AnalyticsClient

    fun provideAppPreferences(): AppPreferences

    fun provideSession(): Session

    fun googleFit(): GoogleFit

    fun lsBleManager(): LSBleManager

    fun bluetoothManager(): MyBluetoothManager

    fun spirometerManager(): SpirometerManager

    fun downloadHelper(): DownloadHelper

    fun surveyUtil(): SurveyUtil

    fun coachMarksUtil(): CoachMarksUtil

    fun inject(myTatvaApp: MyTatvaApp)

    // bottom sheet dialogs
    fun inject(selectMedicalConditionBottomSheetDialog: SelectMedicalConditionBottomSheetDialog)
    fun inject(selectDaysBottomSheetDialog: SelectDaysBottomSheetDialog)
    fun inject(suggestedDosageBottomSheetDialog: SuggestedDosageBottomSheetDialog)
    fun inject(selectRelationTypeBottomSheetDialog: SelectRelationTypeBottomSheetDialog)

    // dialogs
    fun inject(accountCreateSuccessDialog: AccountCreateSuccessDialog)
    fun inject(accountSetupProfileDialog: AccountSetupProfileDialog)
    fun inject(correctAnswerResultDialog: CorrectAnswerResultDialog)

    //fun inject(chatListDialog: ChatListDialog)
    fun inject(readingInfoDialog: ReadingInfoDialog)
    fun inject(webViewCommonDialog: WebViewCommonDialog)
    fun inject(connectSmartScaleBottomSheetDialog: ConnectSmartScaleBottomSheetDialog)
    fun inject(learnHowToConnectBottomSheetDialog: LearnHowToConnectBottomSheetDialog)
    fun inject(doYouHaveDeviceBottomSheetDialog: DoYouHaveDeviceBottomSheetDialog)
    fun inject(loginWithOtpBottomsheet: LoginWithOtpBottomSheet)
    fun inject(testTypeBottomSheetDialog: TestTypeBottomSheetDialog)
    fun inject(enterTargetVolumeDialog: EnterTargetVolumeDialog)
    fun inject(deviceInfoConnectBottomSheetDialog: DeviceInfoConnectBottomSheetDialog)
    fun inject(commonWheelPickerDialog: CommonWheelPickerDialog)
    fun inject(heightWheelPickerDialog: HeightWheelPickerDialog)
    fun inject(weightWheelPickerDialog: WeightWheelPickerDialog)
    fun inject(selectItemBottomSheetDialog: SelectItemBottomSheetDialog)
    fun inject(locationUpdateBottomSheetDialog: LocationUpdateBottomSheetDialog)

    @Component.Builder
    interface ApplicationComponentBuilder {

        @BindsInstance
        fun apiKey(@Named("api-key") apiKey: String): ApplicationComponentBuilder

        @BindsInstance
        fun application(application: Application): ApplicationComponentBuilder

        fun build(): ApplicationComponent
    }

}
