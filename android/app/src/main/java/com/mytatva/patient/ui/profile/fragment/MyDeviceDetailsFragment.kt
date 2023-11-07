package com.mytatva.patient.ui.profile.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.data.Field
import com.google.android.gms.fitness.data.HealthDataTypes
import com.google.android.gms.fitness.data.HealthFields
import com.mytatva.patient.R
import com.mytatva.patient.databinding.ProfileFragmentMyDeviceDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.googleFitInstalled
import com.mytatva.patient.utils.openGoogleFitInStore


class MyDeviceDetailsFragment : BaseFragment<ProfileFragmentMyDeviceDetailsBinding>() {

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ProfileFragmentMyDeviceDetailsBinding {
        return ProfileFragmentMyDeviceDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.MyDeviceDetail)

        setUpView()
    }

    private fun setUpView() {
        with(binding) {
            if (googleFit.hasAllPermissions.not()) {
                // google fit not connected
                if (requireActivity().googleFitInstalled()) {
                    // google fit installed, show to connect
                    buttonSyncForNow.text =
                        getString(R.string.device_details_button_connect_to_google_fit)
                } else {
                    // google fit not installed, show to install
                    buttonSyncForNow.text =
                        getString(R.string.device_details_button_install_google_fit)
                }
            } else {
                // google fit connected
                buttonSyncForNow.text = getString(R.string.device_details_button_disconnect)
            }
        }
    }

    override fun bindData() {
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSyncForNow.setOnClickListener { onViewClick(it) }
            layoutSyncForNow.setOnClickListener { onViewClick(it) }
            textViewSkipForNow.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutSyncForNow,
            R.id.buttonSyncForNow,
            -> {
                if (googleFit.hasAllPermissions.not()) {

                    /*//connect
                    googleFit.initializeFit {
                        (requireActivity() as BaseActivity).updateReadingsGoals(
                            isCalledOnPermissionApproved = true)
                        Handler(Looper.getMainLooper()).postDelayed({
                            navigator.goBack()
                        }, 500)
                    }*/

                    if (requireActivity().googleFitInstalled()) {
                        // google fit installed, connect
                        googleFit.initializeFit {
                            (requireActivity() as BaseActivity).updateReadingsGoals(
                                isCalledOnPermissionApproved = true)
                            Handler(Looper.getMainLooper()).postDelayed({
                                navigator.goBack()
                            }, 500)
                        }
                    } else {
                        // google fit not installed, navigate to store to install
                        requireContext().openGoogleFitInStore()
                    }

                } else {
                    //disconnect
                    googleFit.disconnectWithAlert { isSuccess ->
                        setUpView()
                    }
                }
            }
            R.id.textViewSkipForNow -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    /*private fun updateReadingsGoals() {
        val cal = Calendar.getInstance()
        cal.add(Calendar.DAY_OF_YEAR, -7)

        googleFit.readGoals(cal) { goalsList ->

            googleFit.readReadings(cal) { readingsList ->

                val apiRequest = ApiRequest()
                apiRequest.goal_data = goalsList
                apiRequest.reading_data = readingsList
                goalReadingViewModel.updateReadingsGoals(apiRequest)

            }
        }
    }*/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        /*goalReadingViewModel.updateReadingsGoalsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //showMessage(responseBody.message)
                Log.i("updateReadingsGoals", " :: UPDATE SUCCESS")
            },
            onError = { throwable ->
                hideLoader()
                Log.i("updateReadingsGoals", " :: UPDATE ERROR")
                true
            })*/
    }

    /**
     * fit methods
     */

    fun temp() {
        // Readings ****************

        //Fasting Blood Glucose
        HealthDataTypes.TYPE_BLOOD_GLUCOSE
        HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL
        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_FASTING

        //PP Blood Glucose
        HealthDataTypes.TYPE_BLOOD_GLUCOSE
        HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL
        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_AFTER_MEAL

        //SpO2===
        HealthDataTypes.TYPE_OXYGEN_SATURATION
        HealthFields.FIELD_OXYGEN_SATURATION//
        HealthFields.FIELD_OXYGEN_SATURATION_AVERAGE//

        //Diastolic BP
        HealthDataTypes.TYPE_BLOOD_PRESSURE//
        HealthFields.FIELD_BLOOD_PRESSURE_DIASTOLIC

        //Systolic BP
        HealthDataTypes.TYPE_BLOOD_PRESSURE//
        HealthFields.FIELD_BLOOD_PRESSURE_SYSTOLIC

        //Heart Rate
        DataType.TYPE_HEART_RATE_BPM

        //Weight
        DataType.TYPE_WEIGHT
        Field.FIELD_WEIGHT//

        //Height
        DataType.TYPE_HEIGHT
        Field.FIELD_HEIGHT//

        //FEV1- not available
        //BMI- not available
        //PEF- not available
        //HbA1c- not available
        //CAT- not available
        //ACR- not available
        //eGFR- not available

        // Goals ****************

        //Medication-not available
        //Pranayama-not available

        //Water
        DataType.TYPE_HYDRATION

        //Steps
        DataType.TYPE_STEP_COUNT_CADENCE
        DataType.TYPE_STEP_COUNT_DELTA
        Field.FIELD_STEPS

        //Sleep
        DataType.TYPE_SLEEP_SEGMENT
        Field.FIELD_SLEEP_SEGMENT_TYPE  // not found
    }

}