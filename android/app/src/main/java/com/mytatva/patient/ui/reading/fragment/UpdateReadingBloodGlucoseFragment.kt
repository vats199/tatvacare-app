package com.mytatva.patient.ui.reading.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.InputFilter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingBloodGlucoseBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_BLOOD_GLUCOSE
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_BLOOD_GLUCOSE
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*

class UpdateReadingBloodGlucoseFragment() :
    BaseFragment<ReadingFragmentUpdateReadingBloodGlucoseBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var calDateTime: Calendar = Calendar.getInstance()



    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextDate)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_date))
                        .check()

                    validator.submit(editTextTime)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_time))
                        .check()

                    validator.submit(editTextFastBloodGlucose)
                        .checkEmpty().errorMessage(getString(R.string.validation_enter_fast_blood_glucose))
                        .check()

                    val fast = editTextFastBloodGlucose.text.toString().trim().toIntOrNull() ?: 0
                    if (fast > MAX_BLOOD_GLUCOSE || fast < MIN_BLOOD_GLUCOSE) {
                        throw ApplicationException("Please enter fast blood glucose in the range of $MIN_BLOOD_GLUCOSE - $MAX_BLOOD_GLUCOSE")
                    }

                    validator.submit(editTextPPBloodGlucose)
                        .checkEmpty().errorMessage(getString(R.string.validation_enter_pp_blood_glucose))
                        .check()

                    val PP = editTextPPBloodGlucose.text.toString().trim().toIntOrNull() ?: 0
                    if (PP > MAX_BLOOD_GLUCOSE || PP < MIN_BLOOD_GLUCOSE) {
                        throw ApplicationException("Please enter PP blood glucose in the range of $MIN_BLOOD_GLUCOSE - $MAX_BLOOD_GLUCOSE")
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    var isGoToNext = false
    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ReadingFragmentUpdateReadingBloodGlucoseBinding {
        return ReadingFragmentUpdateReadingBloodGlucoseBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogReading.plus(goalReadingData?.keys))
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
        setUpHeader()
        setDefaultValues()
    }

    private fun setDefaultValues() {
        updateDate()
        updateTime()
        binding.editTextFastBloodGlucose.filters=arrayOf(InputFilter.LengthFilter(MAX_BLOOD_GLUCOSE.toString().length))
        binding.editTextPPBloodGlucose.filters=arrayOf(InputFilter.LengthFilter(MAX_BLOOD_GLUCOSE.toString().length))
        binding.editTextFastBloodGlucose.setText(goalReadingData?.getFastBgValue?.toString() ?: "")
        binding.editTextPPBloodGlucose.setText(goalReadingData?.getPPBgValue?.toString() ?: "")
        binding.textViewUnit.setText(goalReadingData?.measurements ?: "")
        binding.textViewUnit2.setText(goalReadingData?.measurements ?: "")
    }

    private fun updateDate() {
        binding.editTextDate.setText(try {
            DateTimeFormatter.date(calDateTime.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        } catch (e: Exception) {
            ""
        })
    }

    private fun updateTime() {
        binding.editTextTime.setText(try {
            DateTimeFormatter.date(calDateTime.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
        } catch (e: Exception) {
            ""
        })
    }

    private fun setUpHeader() {
        goalReadingData?.let {
            UpdateReadingsMainFragment.setUpHeaderAndCommonUI(it, binding.layoutHeader,binding.textViewStandardValue)
        }

        UpdateReadingsMainFragment.setUpSyncDataLayout(binding.layoutSyncData,
            googleFit.hasAllPermissions,
            googleFit,
            (requireActivity() as BaseActivity))
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            editTextDate.setOnClickListener { onViewClick(it) }
            editTextTime.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                callbackOnClose.invoke(false)
            }
            R.id.editTextDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    calDateTime.set(year, month, dayOfMonth)
                    updateDate()
                    binding.editTextTime.setText("")
                }, 0L, Calendar.getInstance().timeInMillis)
            }
            R.id.editTextTime -> {
                navigator.pickTime({ _, hourOfDay, minute ->
                    val calTemp = Calendar.getInstance()
                    calTemp.timeInMillis = calDateTime.timeInMillis
                    calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                    calTemp.set(Calendar.MINUTE, minute)
                    calTemp.set(Calendar.SECOND, 0)

                    if (Calendar.getInstance().before(calTemp)) {
                        showMessage(getString(R.string.validation_valid_time))
                    } else {
                        calDateTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        calDateTime.set(Calendar.MINUTE, minute)
                        calDateTime.set(Calendar.SECOND, 0)
                        updateTime()
                    }
                }, false)
            }
            R.id.buttonCancel -> {
                callbackOnClose.invoke(false)
            }
            R.id.buttonUpdate -> {
                if (isValid) {
                    updatePatientReadings()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updatePatientReadings() {
        val apiRequest = ApiRequest().apply {
            reading_id = goalReadingData?.readings_master_id
            reading_datetime = DateTimeFormatter.date(calDateTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            reading_value_data = ApiRequestSubData().apply {
                fast = binding.editTextFastBloodGlucose.text.toString().trim()
                pp = binding.editTextPPBloodGlucose.text.toString().trim()
            }
        }
        showLoader()
        goalReadingViewModel.updatePatientReadings(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.updatePatientReadingsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

                writeToGoogleFit()
                analytics.logEvent(analytics.USER_UPDATED_READING,Bundle().apply {
                    putString(analytics.PARAM_READING_NAME,goalReadingData?.reading_name)
                    putString(analytics.PARAM_READING_ID,goalReadingData?.readings_master_id)
                }, screenName = AnalyticsScreenNames.LogReading)
                showMessage(responseBody.message)
                Handler(Looper.getMainLooper())
                    .postDelayed({
                        if (isAdded)
                            callbackOnClose.invoke(false)
                    }, 1000)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun writeToGoogleFit() {
        if (googleFit.hasAllPermissions) {
            val bgLevelFast =
                binding.editTextFastBloodGlucose.text.toString().trim().toFloatOrNull() ?: 0f
            val bgLevelPP =
                binding.editTextPPBloodGlucose.text.toString().trim().toFloatOrNull() ?: 0f
            if (bgLevelFast > 0 && bgLevelPP > 0) {
                googleFit.writeBloodGlucose(bgLevelFast, bgLevelPP, calDateTime)
            }
        }
    }
}