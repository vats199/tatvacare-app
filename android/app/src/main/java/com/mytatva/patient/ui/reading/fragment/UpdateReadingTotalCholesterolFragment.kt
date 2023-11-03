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
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingTotalCholesterolBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_HDL
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_LDL
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_TOTAL_CHOLESTEROL
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_TRIGLYCERIDES
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_HDL
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_LDL
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_TRIGLYCERIDES
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*

class UpdateReadingTotalCholesterolFragment() :
    BaseFragment<ReadingFragmentUpdateReadingTotalCholesterolBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var calDateTime: Calendar = Calendar.getInstance()



    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextDate).checkEmpty()
                        .errorMessage(getString(R.string.validation_select_date)).check()

                    validator.submit(editTextTime).checkEmpty()
                        .errorMessage(getString(R.string.validation_select_time)).check()

                    /*validator.submit(editTextLdl).checkEmpty().errorMessage("Please enter LDL")
                        .check()*/

                    val ldl = editTextLdl.text.toString().trim().toIntOrNull() ?: 0
                    if (binding.editTextLdl.text.toString().trim().isNotBlank()
                        && (ldl > MAX_LDL || ldl < MIN_LDL)
                    ) {
                        throw ApplicationException("Please enter LDL in the range of $MIN_LDL - $MAX_LDL")
                    }

                    /*validator.submit(editTextHdl).checkEmpty().errorMessage("Please enter HDL")
                        .check()*/

                    val hdl = editTextHdl.text.toString().trim().toIntOrNull() ?: 0
                    if (binding.editTextHdl.text.toString().trim().isNotBlank()
                        && (hdl > MAX_HDL || hdl < MIN_HDL)
                    ) {
                        throw ApplicationException("Please enter HDL in the range of $MIN_HDL - $MAX_HDL")
                    }

                    /*validator.submit(editTextTriglyceride).checkEmpty()
                        .errorMessage("Please enter Triglyceride").check()*/

                    val triglyceride =
                        editTextTriglyceride.text.toString().trim().toIntOrNull() ?: 0
                    if (binding.editTextTriglyceride.text.toString().trim().isNotBlank()
                        && (triglyceride > MAX_TRIGLYCERIDES || triglyceride < MIN_TRIGLYCERIDES)
                    ) {
                        throw ApplicationException("Please enter Triglyceride in the range of $MIN_TRIGLYCERIDES - $MAX_TRIGLYCERIDES")
                    }

                    validator.submit(editTextTotalCholesterol).checkEmpty()
                        .errorMessage("Please enter Total Cholesterol").check()

                    val totalCholesterol =
                        editTextTotalCholesterol.text.toString().trim().toIntOrNull() ?: 0
                    if (binding.editTextTotalCholesterol.text.toString().trim().isNotBlank()
                        && (totalCholesterol > ReadingMinMax.MAX_TOTAL_CHOLESTEROL || totalCholesterol < ReadingMinMax.MIN_TOTAL_CHOLESTEROL)
                    ) {
                        throw ApplicationException("Please enter Total Cholesterol in the range of ${ReadingMinMax.MIN_TOTAL_CHOLESTEROL} - ${ReadingMinMax.MAX_TOTAL_CHOLESTEROL}")
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
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ReadingFragmentUpdateReadingTotalCholesterolBinding {
        return ReadingFragmentUpdateReadingTotalCholesterolBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        //analytics.setScreenName(AnalyticsScreenNames.LogReading.plus(goalReadingData?.keys))
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

        // set max length filters
        binding.editTextLdl.filters =
            arrayOf(InputFilter.LengthFilter(MAX_LDL.toString().length))
        binding.editTextHdl.filters =
            arrayOf(InputFilter.LengthFilter(MAX_HDL.toString().length))
        binding.editTextTriglyceride.filters =
            arrayOf(InputFilter.LengthFilter(MAX_TRIGLYCERIDES.toString().length))
        binding.editTextTotalCholesterol.filters =
            arrayOf(InputFilter.LengthFilter(MAX_TOTAL_CHOLESTEROL.toString().length))


        binding.editTextLdl.setText(goalReadingData?.getLdlValue?.toString() ?: "")
        binding.editTextHdl.setText(goalReadingData?.getHdlValue?.toString() ?: "")
        binding.editTextTriglyceride.setText(goalReadingData?.getTriglyceridesValue?.toString()
            ?: "")
        binding.editTextTotalCholesterol.setText(goalReadingData?.getReadingValue?.toString() ?: "")
//        binding.textViewUnitLdl.setText(goalReadingData?.measurements ?: "")
//        binding.textViewUnitHdl.setText(goalReadingData?.measurements ?: "")
//        binding.textViewUnitTriglyceride.setText(goalReadingData?.measurements ?: "")
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
            UpdateReadingsMainFragment.setUpHeaderAndCommonUI(it,
                binding.layoutHeader,
                binding.textViewStandardValue)
        }

        UpdateReadingsMainFragment.setUpSyncDataLayout(binding.layoutSyncData,
            googleFit.hasAllPermissions,
            googleFit,
            (requireActivity() as BaseActivity))

        with(binding) {
            textViewLabelLdl.text = "LDL(${goalReadingData?.measurements})"
            textViewLabelHdl.text = "HDL(${goalReadingData?.measurements})"
            textViewLabelTriglyceride.text = "Triglyceride(${goalReadingData?.measurements})"
            textViewLabelTotalCholesterol.text =
                "Total Cholesterol(${goalReadingData?.measurements})"
        }
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
                ldl_cholesterol = binding.editTextLdl.text.toString().trim()
                hdl_cholesterol = binding.editTextHdl.text.toString().trim()
                triglycerides = binding.editTextTriglyceride.text.toString().trim()
            }
            reading_value = binding.editTextTotalCholesterol.text.toString().trim()
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

                /*analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                    putString(analytics.PARAM_READING_NAME, goalReadingData?.reading_name)
                    putString(analytics.PARAM_READING_ID, goalReadingData?.readings_master_id)
                })*/
                showMessage(responseBody.message)
                Handler(Looper.getMainLooper()).postDelayed({
                    if (isAdded) callbackOnClose.invoke(false)
                }, 1000)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}