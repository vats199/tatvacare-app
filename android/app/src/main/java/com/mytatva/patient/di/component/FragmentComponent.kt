package com.mytatva.patient.di.component


import com.mytatva.patient.di.PerFragment
import com.mytatva.patient.di.module.FragmentModule
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
import com.mytatva.patient.ui.common.fragment.BlankFragment
import com.mytatva.patient.ui.common.fragment.SelectItemFragment
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.common.fragment.WebViewPaymentFragment
import com.mytatva.patient.ui.home.RNHomeFragment
import com.mytatva.patient.ui.home.fragment.AppUnderMaintenenceFragment
import com.mytatva.patient.ui.home.fragment.DevicesFragment
import com.mytatva.patient.ui.home.fragment.HomeFragment
import com.mytatva.patient.ui.mydevices.fragment.BcaReadingDataAnalysisMainFragment
import com.mytatva.patient.ui.mydevices.fragment.BcaReadingDataAnalysisSubFragment
import com.mytatva.patient.ui.mydevices.fragment.MeasureBcaReadingFragment
import com.mytatva.patient.ui.mydevices.fragment.MyDeviceSelectSmartScaleFragment
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
    fun inject(selectGoalsReadingsFragment: SelectGoalsReadingsFragment)
    fun inject(useBiometricFragment: UseBiometricFragment)
    fun inject(forgotPasswordFragment: ForgotPasswordFragment)
    fun inject(createPasswordFragment: CreatePasswordFragment)
    fun inject(selectYourLocationFragment: SelectYourLocationFragment)
    fun inject(selectLanguageListFragment: SelectLanguageListFragment)
    fun inject(selectItemFragment: SelectItemFragment)
    fun inject(forgotPasswordPhoneNumberFragment: ForgotPasswordPhoneNumberFragment)
    fun inject(profileSetupSuccessFragment: ProfileSetupSuccessFragment)
    fun inject(loginOtpVerificationFragment: LoginOtpVerificationFragment)
    fun inject(blankFragment: BlankFragment)
    fun inject(setupHeightWeightFragment: SetupHeightWeightFragment)
    fun inject(scanQRCodeFragment: ScanQRCodeFragment)
    fun inject(appUnderMaintenenceFragment: AppUnderMaintenenceFragment)
    fun inject(devicesFragment: DevicesFragment)
    fun inject(reactUseInFragment: RNHomeFragment)


    fun inject(webViewPaymentFragment: WebViewPaymentFragment)
    fun inject(webViewCommonFragment: WebViewCommonFragment)

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


    // spirometer
    fun inject(spirometerEnterDetailsFragment: SpirometerEnterDetailsFragment)
    fun inject(spirometerAllReadingsFragment: SpirometerAllReadingsFragment)
    fun inject(letsBeginV2Fragment: LetsBeginV2Fragment)
    fun inject(setUpYourProfileV2Fragment: SetUpYourProfileV2Fragment)
    fun inject(chooseYourConditionV2Fragment: ChooseYourConditionV2Fragment)
    fun inject(spirometerEnterDetailsV1Fragment: SpirometerEnterDetailsV1Fragment)
    fun inject(spirometerSubAllReadingFragment: SpirometerSubAllReadingFragment)
}
