package com.mytatva.patient.ui.reading.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.InputFilter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.core.widget.addTextChangedListener
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingBmiBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_BMI
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_BMI
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.DecimalDigitsInputFilter
import com.mytatva.patient.utils.apputils.HeightWeightUtils
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.disableFocus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.inputfilter.InputFilterMinMax
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*

class UpdateReadingBMIFragment :
    BaseFragment<ReadingFragmentUpdateReadingBmiBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var calDateTime: Calendar = Calendar.getInstance()
    var calculatedBMI: String? = null


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

                    HeightWeightUtils.validateHeightFields(validator,
                        selectedHeightUnit,
                        editTextHeightFeet,
                        editTextHeightInches,
                        editTextHeight)

                    HeightWeightUtils.validateWeightFields(validator,
                        selectedWeightUnit,
                        editTextWeight)

                    validator.submit(editTextBMI)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_bmi))
                        .check()

                    val bmi: Double = editTextBMI.text.toString().toDoubleOrNull() ?: 0.0
                    if (bmi < MIN_BMI || bmi > MAX_BMI) {
                        throw  ApplicationException("BMI should be in the range of $MIN_BMI - $MAX_BMI")
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

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private var selectedHeightUnit = HeightUnit.CM
    private val heightUnits = ArrayList(HeightUnit.values().toList())
    private var selectedWeightUnit = WeightUnit.KG
    private val weightUnits = ArrayList(WeightUnit.values().toList())

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ReadingFragmentUpdateReadingBmiBinding {
        return ReadingFragmentUpdateReadingBmiBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogReading.plus(goalReadingData?.keys))
    }

    override fun bindData() {
        setViewListeners()
        setUpHeader()
        //setWeightDisabled()
        setDefaultValues()
    }

    private fun setDefaultValues() {
        updateDate()
        updateTime()

        with(binding) {

            // set default max length
            editTextHeight.filters =
                arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_HEIGHT_CM.toString().length))
            editTextHeightFeet.filters =
                arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_HEIGHT_FEET.toString().length))
            editTextHeightInches.filters =
                arrayOf(InputFilterMinMax(0, 11), InputFilter.LengthFilter(2))
            updateWeightInputFilters()
            // =========================

            // set unit data as per selected unit
            setHeightWeightUnitData()
            /*editTextHeightUnit.setText(selectedHeightUnit.unitName)
            editTextWeightUnit.setText(selectedWeightUnit.unitName)*/

            textViewUnit.setText(goalReadingData?.measurements ?: "")


            // set height value as per unit
            val height = goalReadingData?.getHeightValue ?: session.user?.getHeightValue ?: 0
            if (height > 0) {
                val heightCm = height.toString()
                if (heightCm.isNotEmpty()) {
                    if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
                        val heightFeetInch = HeightWeightUtils.convertCmToFeetInches(heightCm)
                        editTextHeightFeet.setText(heightFeetInch.first)
                        editTextHeightInches.setText(heightFeetInch.second)
                    } else {
                        editTextHeight.setText(heightCm)
                    }
                }
            }

            // set height disabled if it's already set previously
            if (editTextHeight.text.toString().trim().isNotBlank()
                || (editTextHeightFeet.text.toString().trim().isNotBlank()
                        && editTextHeightInches.text.toString().trim().isNotBlank())
            ) {
                setHeightDisabled()
            }

            // set weight value as per unit
            val weightKg = goalReadingData?.getWeightValue?.formatToDecimalPoint(1) ?: ""
            if (weightKg.isNotEmpty()) {
                if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                    editTextWeight.setText(HeightWeightUtils.convertKgToLbs(weightKg))
                } else {
                    editTextWeight.setText(weightKg)
                }
            }

        }
    }

    private fun updateWeightInputFilters() {
        with(binding) {
            /*editTextWeight.filters =
                if (selectedWeightUnit == WeightUnit.LBS)
                    arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_BODYWEIGHT_LBS.toString().length))
                else
                    arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_BODYWEIGHT_KG.toString().length))*/

            val weightLength = if (selectedWeightUnit == WeightUnit.LBS) {
                ReadingMinMax.MAX_BODYWEIGHT_LBS.toString().length
            } else {
                ReadingMinMax.MAX_BODYWEIGHT_KG.toString().length
            }
            editTextWeight.filters = arrayOf(DecimalDigitsInputFilter(weightLength + 20, 1))
        }
    }

    private fun setHeightWeightUnitData() {
        session.user?.let { user ->

            // set units list as per data from user
            heightUnits.forEachIndexed { index, heightUnit ->
                when (heightUnit) {
                    HeightUnit.CM -> {
                        user.heightCmUnitData.unit_title?.let { unitTitle ->
                            heightUnits[index].unitName = unitTitle
                        }
                    }
                    HeightUnit.FEET_INCHES -> {
                        user.heightFeetInchUnitData.unit_title?.let { unitTitle ->
                            heightUnits[index].unitName = unitTitle
                        }
                    }
                }
            }

            weightUnits.forEachIndexed { index, weightUnit ->
                when (weightUnit) {
                    WeightUnit.KG -> {
                        user.weightKgUnitData.unit_title?.let { unitTitle ->
                            weightUnits[index].unitName = unitTitle
                        }
                    }
                    WeightUnit.LBS -> {
                        user.weightLbsUnitData.unit_title?.let { unitTitle ->
                            weightUnits[index].unitName = unitTitle
                        }
                    }
                }
            }

            heightUnits.firstOrNull { it.unitKey == user.height_unit }?.let {
                selectedHeightUnit = it
            }
            weightUnits.firstOrNull { it.unitKey == user.weight_unit }?.let {
                selectedWeightUnit = it
            }

            updateHeightValuesAndUI()
            updateWeightAsPerSelectedUnit()

            /*if (user.height_unit == HeightUnit.FEET_INCHES.unitKey) {
                selectedHeightUnit = HeightUnit.FEET_INCHES
                selectedHeightUnit.unitName =
                    user.heightFeetInchUnitData.unit_title ?: selectedHeightUnit.unitName
            } else {
                selectedHeightUnit = HeightUnit.CM
                selectedHeightUnit.unitName =
                    user.heightCmUnitData.unit_title ?: selectedHeightUnit.unitName
            }

            if (user.weight_unit == WeightUnit.LBS.unitKey) {
                selectedWeightUnit = WeightUnit.LBS
                selectedWeightUnit.unitName =
                    user.weightLbsUnitData.unit_title ?: selectedWeightUnit.unitName
            } else {
                selectedWeightUnit = WeightUnit.KG
                selectedWeightUnit.unitName =
                    user.weightKgUnitData.unit_title ?: selectedWeightUnit.unitName
            }*/

        }
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
            googleFit.hasAllPermissions, googleFit, (requireActivity() as BaseActivity))
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            editTextDate.setOnClickListener { onViewClick(it) }
            editTextTime.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }
            editTextHeightUnit.setOnClickListener { onViewClick(it) }
            editTextWeightUnit.setOnClickListener { onViewClick(it) }

            editTextHeight.addTextChangedListener {
                calculateBMI()
            }
            editTextWeight.addTextChangedListener {
                calculateBMI()
            }
        }
    }

    private fun calculateBMI() {
        with(binding) {

            if (heightFieldIsNotBlank() && editTextWeight.text.toString().trim().isNotBlank()) {

                val heightCm = if ((selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey)) {
                    HeightWeightUtils.convertFeetInchesToCm(
                        editTextHeightFeet.text.toString(),
                        editTextHeightInches.text.toString()).toDouble()
                } else {
                    editTextHeight.text.toString().trim().toDouble()
                }

                // if weight is in lbs then convert it to kg and then calculate BMI
                val weightKg = if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                    HeightWeightUtils.convertLbsToKg(editTextWeight.text.toString()).toDouble()
                } else {
                    editTextWeight.text.toString().trim().toDouble()
                }

                val heightMeter = heightCm / 100

                try {
                    val BMI = weightKg / (heightMeter * heightMeter)
                    if (BMI.equals(Double.NaN)
                        || BMI.equals(Double.POSITIVE_INFINITY)
                        || BMI.equals(Double.NEGATIVE_INFINITY)
                    ) {
                        clearBMI()
                    } else {
                        calculatedBMI = BMI.formatToDecimalPoint(1)
                        binding.editTextBMI.setText(calculatedBMI)
                    }
                } catch (e: ArithmeticException) {
                    clearBMI()
                }

            } else {
                clearBMI()
            }
        }
    }

    private fun heightFieldIsNotBlank(): Boolean {
        return if (selectedHeightUnit.unitKey == HeightUnit.CM.unitKey) {
            binding.editTextHeight.text.toString().trim().isNotEmpty()
        } else {
            binding.editTextHeightFeet.text.toString().trim().isNotEmpty() &&
                    binding.editTextHeightInches.text.toString().trim().isNotEmpty()
        }
    }

    private fun clearBMI() {
        calculatedBMI = null
        binding.editTextBMI.setText("")
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
            R.id.editTextHeightUnit -> {
                showHeightUnitSelection()
            }
            R.id.editTextWeightUnit -> {
                showWeightUnitSelection()
            }
        }
    }

    private fun showHeightUnitSelection() {
        BottomSheet<HeightUnit>().showBottomSheetDialog(requireActivity(),
            heightUnits,
            "",
            object : BottomSheetAdapter.ItemListener<HeightUnit> {
                override fun onItemClick(item: HeightUnit, position: Int) {
                    if (selectedHeightUnit.unitKey != item.unitKey) {
                        selectedHeightUnit = item
                        updateHeightValuesAndUI()
                    }
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<HeightUnit>.MyViewHolder,
                    position: Int,
                    item: HeightUnit,
                ) {
                    holder.textView.text = item.unitName
                }
            })
    }

    private fun updateHeightValuesAndUI() {
        with(binding) {
            editTextHeightUnit.setText(selectedHeightUnit.unitName)

            if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
                editTextHeight.isVisible = false
                editTextHeightFeet.isVisible = true
                editTextHeightInches.isVisible = true

                if (editTextHeight.text.toString().trim().isBlank()) {
                    editTextHeightFeet.setText("")
                    editTextHeightInches.setText("")
                } else {
                    val pairFeetInches =
                        HeightWeightUtils.convertCmToFeetInches(editTextHeight.text.toString())
                    editTextHeightFeet.setText(pairFeetInches.first)
                    editTextHeightInches.setText(pairFeetInches.second)
                }
            } else {
                editTextHeight.isVisible = true
                editTextHeightFeet.isVisible = false
                editTextHeightInches.isVisible = false

                if (editTextHeightFeet.text.toString().trim().isBlank()
                    || editTextHeightInches.text.toString().trim().isBlank()
                ) {
                    editTextHeight.setText("")
                } else {
                    val heightCm = HeightWeightUtils.convertFeetInchesToCm(
                        editTextHeightFeet.text.toString(),
                        editTextHeightInches.text.toString())
                    editTextHeight.setText(heightCm)
                }
            }
        }
    }

    private fun showWeightUnitSelection() {
        BottomSheet<WeightUnit>().showBottomSheetDialog(requireActivity(),
            weightUnits,
            "",
            object : BottomSheetAdapter.ItemListener<WeightUnit> {
                override fun onItemClick(item: WeightUnit, position: Int) {
                    if (selectedWeightUnit.unitKey != item.unitKey) {
                        selectedWeightUnit = item
                        updateWeightInputFilters()
                        updateWeightAsPerSelectedUnit()
                    }
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<WeightUnit>.MyViewHolder,
                    position: Int,
                    item: WeightUnit,
                ) {
                    holder.textView.text = item.unitName
                }
            })
    }

    private fun updateWeightAsPerSelectedUnit() {
        binding.editTextWeightUnit.setText(selectedWeightUnit.unitName)
        HeightWeightUtils.updateWeightValuesAndUI(binding.editTextWeight, selectedWeightUnit)
    }

    private fun setHeightDisabled() {
        with(binding) {
            editTextHeight.setTextColor(requireContext().resources.getColor(R.color.gray4, null))
            editTextHeight.setBackgroundResource(R.drawable.bg_textview_solid_lightgray_stroke_gray)
            editTextHeight.disableFocus()

            editTextHeightFeet.setTextColor(requireContext().resources.getColor(R.color.gray4,
                null))
            editTextHeightFeet.setBackgroundResource(R.drawable.bg_textview_solid_lightgray_stroke_gray)
            editTextHeightFeet.disableFocus()

            editTextHeightInches.setTextColor(requireContext().resources.getColor(R.color.gray4,
                null))
            editTextHeightInches.setBackgroundResource(R.drawable.bg_textview_solid_lightgray_stroke_gray)
            editTextHeightInches.disableFocus()
        }
    }

    /**
     * *****************************************************
     * API request parameters helper methods
     * *****************************************************
     **/
    private fun getHeightRequestParam(): String {
        return if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
            HeightWeightUtils.convertFeetInchesToCm(
                binding.editTextHeightFeet.text.toString(),
                binding.editTextHeightInches.text.toString())
        } else {
            binding.editTextHeight.text.toString().trim()
        }
    }

    private fun getWeightRequestParam(): String {
        return if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
            HeightWeightUtils.convertLbsToKg(binding.editTextWeight.text.toString())
        } else {
            binding.editTextWeight.text.toString().trim()
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
            reading_datetime = DateTimeFormatter.date(calDateTime?.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            reading_value_data = ApiRequestSubData().apply {
                height = getHeightRequestParam()
                weight = getWeightRequestParam()
            }
            reading_value = calculatedBMI

            height_unit = selectedHeightUnit.unitKey
            weight_unit = selectedWeightUnit.unitKey
        }
        showLoader()
        goalReadingViewModel.updatePatientReadings(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        //showLoader()
        authViewModel.getPatientDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        var updateReadingMessage=""
        goalReadingViewModel.updatePatientReadingsLiveData.observe(this,
            onChange = { responseBody ->
                //hideLoader()

                getPatientDetails()
                analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                    putString(analytics.PARAM_READING_NAME, goalReadingData?.reading_name)
                    putString(analytics.PARAM_READING_ID, goalReadingData?.readings_master_id)
                }, screenName = AnalyticsScreenNames.LogReading)
                updateReadingMessage = responseBody.message
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

                showMessage(updateReadingMessage)
                Handler(Looper.getMainLooper())
                    .postDelayed({
                        if (isAdded)
                            callbackOnClose.invoke(false)
                    }, 1000)
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }
}