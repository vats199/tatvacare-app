package com.mytatva.patient.ui.reading.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.InputFilter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingFibScoreBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_PLATELET
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_SGOT
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_SGPT
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_PLATELET
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_SGOT
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_SGPT
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*
import kotlin.math.sqrt

class UpdateReadingFibScoreFragment :
    BaseFragment<ReadingFragmentUpdateReadingFibScoreBinding>() {

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

                    /*validator.submit(editTextSgpt).checkEmpty()
                        .errorMessage("Please enter SGPT")
                        .check()*/

                    val sgpt = editTextSgpt.text.toString().trim().toIntOrNull() ?: 0
                    if (editTextSgpt.text.toString().trim()
                            .isNotBlank() && (sgpt > MAX_SGPT || sgpt < MIN_SGPT)
                    ) {
                        throw ApplicationException("Please enter SGPT in the range of $MIN_SGPT - $MAX_SGPT")
                    }

                    /*validator.submit(editTextSgot).checkEmpty()
                        .errorMessage("Please enter SGOT")
                        .check()*/

                    val sgot = editTextSgot.text.toString().trim().toIntOrNull() ?: 0
                    if (editTextSgot.text.toString().trim()
                            .isNotBlank() && (sgot > MAX_SGOT || sgot < MIN_SGOT)
                    ) {
                        throw ApplicationException("Please enter SGOT in the range of $MIN_SGOT - $MAX_SGOT")
                    }

                    /*validator.submit(editTextPlatelet).checkEmpty()
                        .errorMessage("Please enter Platelet")
                        .check()*/

                    val platelet = editTextPlatelet.text.toString().trim().toIntOrNull() ?: 0
                    if (editTextPlatelet.text.toString().trim()
                            .isNotBlank() && (platelet > MAX_PLATELET || platelet < MIN_PLATELET)
                    ) {
                        throw ApplicationException("Please enter Platelet in the range of $MIN_PLATELET - $MAX_PLATELET")
                    }

                    val fibScore: Double = editTextReading.text.toString().toDoubleOrNull() ?: 0.0
                    if (fibScore < ReadingMinMax.MIN_FIB4SCORE || fibScore > ReadingMinMax.MAX_FIB4SCORE) {
                        throw  ApplicationException("FIB4 Score should be in the range of ${ReadingMinMax.MIN_FIB4SCORE} - ${ReadingMinMax.MAX_FIB4SCORE}")
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
    ): ReadingFragmentUpdateReadingFibScoreBinding {
        return ReadingFragmentUpdateReadingFibScoreBinding.inflate(inflater,
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

        binding.textViewLabelSgpt.text = "SGPT(U/L)"
        binding.textViewLabelSgot.text = "SGOT(U/L)"
        binding.textViewLabelPlatelet.text = "Platelet(platelets/liter)"

        binding.editTextSgpt.filters =
            arrayOf(InputFilter.LengthFilter(MAX_SGPT.toString().length))
        binding.editTextSgot.filters =
            arrayOf(InputFilter.LengthFilter(MAX_SGOT.toString().length))
        binding.editTextPlatelet.filters =
            arrayOf(InputFilter.LengthFilter(MAX_PLATELET.toString().length))

        binding.editTextSgpt.setText(goalReadingData?.getSgptValue?.toString() ?: "")
        binding.editTextSgot.setText(goalReadingData?.getSgotValue?.toString() ?: "")
        binding.editTextPlatelet.setText(goalReadingData?.getPlateletValue?.toString() ?: "")
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
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            editTextDate.setOnClickListener { onViewClick(it) }
            editTextTime.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }

            editTextSgpt.addTextChangedListener {
                calculateFibScore()
            }
            editTextSgot.addTextChangedListener {
                calculateFibScore()
            }
            editTextPlatelet.addTextChangedListener {
                calculateFibScore()
            }
        }
    }

    private var calculatedFibScore: String? = null
    private fun calculateFibScore() {
        with(binding) {
            if (editTextSgpt.text.toString().trim().isNotBlank() && editTextSgot.text.toString()
                    .trim().isNotBlank() && editTextPlatelet.text.toString().trim().isNotBlank()
            ) {
                val sgpt = editTextSgpt.text.toString().trim().toDouble()
                val sgot = editTextSgot.text.toString().trim().toDouble()
                val platelet = editTextPlatelet.text.toString().trim().toDouble()
                val age = session.user?.getAgeValue ?: 0

                //(age * sgot) / (platelet * sqr root of sgpt)
                try {
                    val fibScore = (age * sgot) / (platelet * sqrt(sgpt))
                    if (fibScore.equals(Double.NaN) || fibScore.equals(Double.POSITIVE_INFINITY) || fibScore.equals(Double.NEGATIVE_INFINITY)) {
                        clearFibScore()
                    } else {
                        calculatedFibScore = fibScore.formatToDecimalPoint(2)
                        binding.editTextReading.setText(calculatedFibScore)
                    }
                } catch (e: ArithmeticException) {
                    clearFibScore()
                }

            } else {
                clearFibScore()
            }
        }
    }

    private fun clearFibScore() {
        calculatedFibScore = null
        binding.editTextReading.setText("")
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
//                if (binding.editTextSgot.text.toString().trim().isNotBlank()) {
                    sgot = binding.editTextSgot.text.toString().trim()
//                }
//                if (binding.editTextSgpt.text.toString().trim().isNotBlank()) {
                    sgpt = binding.editTextSgpt.text.toString().trim()
//                }
//                if (binding.editTextPlatelet.text.toString().trim().isNotBlank()) {
                    platelet = binding.editTextPlatelet.text.toString().trim()
//                }
            }
            reading_value = calculatedFibScore
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