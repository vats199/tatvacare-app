package com.mytatva.patient.ui.reading.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.InputFilter
import android.text.InputType
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.model.FattyLiverUSGGrades
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingCommonBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.DecimalDigitsInputFilter
import com.mytatva.patient.utils.apputils.HeightWeightUtils
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.disableFocus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.Calendar

class UpdateReadingCommonFragment(
    /*val reading: Readings,
    val callbackOnClose: (isToGoNext: Boolean) -> Unit,*/
) : BaseFragment<ReadingFragmentUpdateReadingCommonBinding>() {

    // init with initialization
    lateinit var reading: Readings
    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var calDateTime: Calendar = Calendar.getInstance()

    private var fattyLiverUSGGradesList = ArrayList(FattyLiverUSGGrades.values().toList())
    private var selectedFattyLiverGrade: FattyLiverUSGGrades? = null

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

                    validator.submit(editTextReading)
                        .checkEmpty().errorMessage(getString(R.string.validation_enter_reading))
                        .check()

                    /*val readingValue =
                        editTextReading.text.toString().toDoubleOrNull()?.toInt() ?: -1*/
                    val readingValue: Double =
                        editTextReading.text.toString().toDoubleOrNull() ?: -1.0

                    when (reading) {
                        Readings.SPO2 -> {
                            if (readingValue < ReadingMinMax.MIN_SPO2 || readingValue > ReadingMinMax.MAX_SPO2) {
                                throw ApplicationException("Please enter SPO2 in the range of ${ReadingMinMax.MIN_SPO2} - ${ReadingMinMax.MAX_SPO2}")
                            }
                        }

                        Readings.FEV1 -> {
                            if (readingValue < ReadingMinMax.MIN_FEV1 || readingValue > ReadingMinMax.MAX_FEV1) {
                                throw ApplicationException("Please enter FEV1 in the range of ${ReadingMinMax.MIN_FEV1} - ${ReadingMinMax.MAX_FEV1}")
                            }
                        }

                        Readings.PEF -> {
                            if (readingValue < ReadingMinMax.MIN_PEF || readingValue > ReadingMinMax.MAX_PEF) {
                                throw ApplicationException("Please enter PEF in the range of ${ReadingMinMax.MIN_PEF} - ${ReadingMinMax.MAX_PEF}")
                            }
                        }

                        Readings.HeartRate -> {
                            if (readingValue < ReadingMinMax.MIN_HEARTRATE || readingValue > ReadingMinMax.MAX_HEARTRATE) {
                                throw ApplicationException("Please enter Heart Rate in the range of ${ReadingMinMax.MIN_HEARTRATE} - ${ReadingMinMax.MAX_HEARTRATE}")
                            }
                        }

                        Readings.BodyWeight -> {
                            HeightWeightUtils.validateWeightFields(
                                validator,
                                selectedWeightUnit,
                                editTextReading
                            )
                            /*if (readingValue < ReadingMinMax.MIN_BODYWEIGHT_KG || readingValue > ReadingMinMax.MAX_BODYWEIGHT_KG) {
                                throw ApplicationException("Please enter Body Weight in the range of ${ReadingMinMax.MIN_BODYWEIGHT_KG} - ${ReadingMinMax.MAX_BODYWEIGHT_KG}")
                            }*/
                        }

                        Readings.HbA1c -> {
                            if (readingValue < ReadingMinMax.MIN_HBA1C || readingValue > ReadingMinMax.MAX_HBA1C) {
                                throw ApplicationException("Please enter HbA1c in the range of ${ReadingMinMax.MIN_HBA1C} - ${ReadingMinMax.MAX_HBA1C}")
                            }
                        }

                        Readings.ACR -> {
                            if (readingValue > ReadingMinMax.MAX_ACR) {
                                throw ApplicationException("Please enter ACR upto ${ReadingMinMax.MAX_ACR}")
                            }
                        }

                        Readings.eGFR -> {
                            if (readingValue > ReadingMinMax.MAX_eGFR) {
                                throw ApplicationException("Please enter eGFR upto ${ReadingMinMax.MAX_eGFR}")
                            }
                        }
                        //SPO2 -> //0-100 Percent
                        //FEV1 -> //0-10 L
                        //PEF -> // o-800 L/min
                        //HeartRate -> //0-200 BPM
                        //BodyWeight -> //0-300 Kg
                        //HbA1c -> // 0 - 100 percentage
                        //ACR -> //0 - 100 mg/mmol
                        //eGFR -> //0-150 ml/min/1.73m2
                        //blood glucose - as per Jira (ml/min/1.73m²) as per design (1.73m²) 300 max
                        //BMI - 1-40 BMI
                        //Blood pressure - mmHg 0-200
                        Readings.SGOT_AST -> {
                            if (readingValue < ReadingMinMax.MIN_SGOT || readingValue > ReadingMinMax.MAX_SGOT) {
                                throw ApplicationException("Please enter SGOT in the range of ${ReadingMinMax.MIN_SGOT} - ${ReadingMinMax.MAX_SGOT}")
                            }
                        }

                        Readings.SGPT_ALT -> {
                            if (readingValue < ReadingMinMax.MIN_SGPT || readingValue > ReadingMinMax.MAX_SGPT) {
                                throw ApplicationException("Please enter SGPT in the range of ${ReadingMinMax.MIN_SGPT} - ${ReadingMinMax.MAX_SGPT}")
                            }
                        }

                        Readings.Triglycerides -> {
                            if (readingValue < ReadingMinMax.MIN_TRIGLYCERIDES || readingValue > ReadingMinMax.MAX_TRIGLYCERIDES) {
                                throw ApplicationException("Please enter Triglycerides in the range of ${ReadingMinMax.MIN_TRIGLYCERIDES} - ${ReadingMinMax.MAX_TRIGLYCERIDES}")
                            }
                        }

                        Readings.LDL_CHOLESTEROL -> {
                            if (readingValue < ReadingMinMax.MIN_LDL || readingValue > ReadingMinMax.MAX_LDL) {
                                throw ApplicationException("Please enter LDL Cholesterol in the range of ${ReadingMinMax.MIN_LDL} - ${ReadingMinMax.MAX_LDL}")
                            }
                        }

                        Readings.HDL_CHOLESTEROL -> {
                            if (readingValue < ReadingMinMax.MIN_HDL || readingValue > ReadingMinMax.MAX_HDL) {
                                throw ApplicationException("Please enter HDL Cholesterol in the range of ${ReadingMinMax.MIN_HDL} - ${ReadingMinMax.MAX_HDL}")
                            }
                        }

                        Readings.WaistCircumference -> {
                            if (readingValue < ReadingMinMax.MIN_WAIST || readingValue > ReadingMinMax.MAX_WAIST) {
                                throw ApplicationException("Please enter Waist Circumference in the range of ${ReadingMinMax.MIN_WAIST} - ${ReadingMinMax.MAX_WAIST}")
                            }
                        }

                        Readings.PlateletCount -> {
                            if (readingValue < ReadingMinMax.MIN_PLATELET || readingValue > ReadingMinMax.MAX_PLATELET) {
                                throw ApplicationException("Please enter Platelet Count in the range of ${ReadingMinMax.MIN_PLATELET} - ${ReadingMinMax.MAX_PLATELET}")
                            }
                        }

                        Readings.SerumCreatinine -> {
                            if (readingValue < ReadingMinMax.MIN_SERUM_CREATININE || readingValue > ReadingMinMax.MAX_SERUM_CREATININE) {
                                throw ApplicationException("Please enter Serum Creatinine in the range of ${ReadingMinMax.MIN_SERUM_CREATININE} - ${ReadingMinMax.MAX_SERUM_CREATININE}")
                            }
                        }

                        Readings.FattyLiverUSGGrade -> {
                            /*if (readingValue < ReadingMinMax.MIN_PLATELET || readingValue > ReadingMinMax.MAX_PLATELET) {
                                throw ApplicationException("Please enter Platelet Count in the range of ${ReadingMinMax.MIN_PLATELET} - ${ReadingMinMax.MAX_PLATELET}")
                            }*/
                        }

                        Readings.RandomBloodGlucose -> {
                            if (readingValue < ReadingMinMax.MIN_RANDOM_BG || readingValue > ReadingMinMax.MAX_RANDOM_BG) {
                                throw ApplicationException("Please enter Random Blood Glucose in the range of ${ReadingMinMax.MIN_RANDOM_BG} - ${ReadingMinMax.MAX_RANDOM_BG}")
                            }
                        }

                        // new BCA device added readings
                        Readings.BodyFat -> {
                            if (readingValue < ReadingMinMax.MIN_BODY_FAT || readingValue > ReadingMinMax.MAX_BODY_FAT) {
                                throw ApplicationException("Please enter Body Fat in the range of ${ReadingMinMax.MIN_BODY_FAT} - ${ReadingMinMax.MAX_BODY_FAT}")
                            }
                        }

                        Readings.Hydration -> {
                            if (readingValue < ReadingMinMax.MIN_HYDRATION || readingValue > ReadingMinMax.MAX_HYDRATION) {
                                throw ApplicationException("Please enter Hydration in the range of ${ReadingMinMax.MIN_HYDRATION} - ${ReadingMinMax.MAX_HYDRATION}")
                            }
                        }

                        Readings.MuscleMass -> {
                            if (readingValue < ReadingMinMax.MIN_MUSCLE_MASS || readingValue > ReadingMinMax.MAX_MUSCLE_MASS) {
                                throw ApplicationException("Please enter Muscle Mass in the range of ${ReadingMinMax.MIN_MUSCLE_MASS} - ${ReadingMinMax.MAX_MUSCLE_MASS}")
                            }
                        }

                        Readings.Protein -> {
                            if (readingValue < ReadingMinMax.MIN_PROTEIN || readingValue > ReadingMinMax.MAX_PROTEIN) {
                                throw ApplicationException("Please enter Protein in the range of ${ReadingMinMax.MIN_PROTEIN} - ${ReadingMinMax.MAX_PROTEIN}")
                            }
                        }

                        Readings.BoneMass -> {
                            if (readingValue < ReadingMinMax.MIN_BONE_MASS || readingValue > ReadingMinMax.MAX_BONE_MASS) {
                                throw ApplicationException("Please enter Bone Mass in the range of ${ReadingMinMax.MIN_BONE_MASS} - ${ReadingMinMax.MAX_BONE_MASS}")
                            }
                        }

                        Readings.VisceralFat -> {
                            if (readingValue < ReadingMinMax.MIN_VISCERAL_FAT || readingValue > ReadingMinMax.MAX_VISCERAL_FAT) {
                                throw ApplicationException("Please enter Visceral Fat in the range of ${ReadingMinMax.MIN_VISCERAL_FAT} - ${ReadingMinMax.MAX_VISCERAL_FAT}")
                            }
                        }

                        Readings.BasalMetabolicRate -> {
                            if (readingValue < ReadingMinMax.MIN_BASAL_METABOLIC_RATE || readingValue > ReadingMinMax.MAX_BASAL_METABOLIC_RATE) {
                                throw ApplicationException("Please enter Basal Metabolic Rate in the range of ${ReadingMinMax.MIN_BASAL_METABOLIC_RATE} - ${ReadingMinMax.MAX_BASAL_METABOLIC_RATE}")
                            }
                        }

                        Readings.MetabolicAge -> {
                            if (readingValue < ReadingMinMax.MIN_METABOLIC_AGE || readingValue > ReadingMinMax.MAX_METABOLIC_AGE) {
                                throw ApplicationException("Please enter Metabolic Age in the range of ${ReadingMinMax.MIN_METABOLIC_AGE} - ${ReadingMinMax.MAX_METABOLIC_AGE}")
                            }
                        }

                        Readings.SubcutaneousFat -> {
                            if (readingValue < ReadingMinMax.MIN_SUBCUTANEOUS_FAT || readingValue > ReadingMinMax.MAX_SUBCUTANEOUS_FAT) {
                                throw ApplicationException("Please enter Subcutaneous Fat in the range of ${ReadingMinMax.MIN_SUBCUTANEOUS_FAT} - ${ReadingMinMax.MAX_SUBCUTANEOUS_FAT}")
                            }
                        }

                        Readings.SkeletalMuscle -> {
                            if (readingValue < ReadingMinMax.MIN_SKELETAL_MUSCLE || readingValue > ReadingMinMax.MAX_SKELETAL_MUSCLE) {
                                throw ApplicationException("Please enter Skeletal Muscle in the range of ${ReadingMinMax.MIN_SKELETAL_MUSCLE} - ${ReadingMinMax.MAX_SKELETAL_MUSCLE}")
                            }
                        }

                        // new Spirometer device added readings
                        Readings.FVC -> {
                            if (readingValue < ReadingMinMax.MIN_FVC || readingValue > ReadingMinMax.MAX_FVC) {
                                throw ApplicationException("Please enter FVC in the range of ${ReadingMinMax.MIN_FVC} - ${ReadingMinMax.MAX_FVC}")
                            }
                        }

                        Readings.FEV1FVC_RATIO -> {
                            if (readingValue < ReadingMinMax.MIN_FEV1FVC_RATIO || readingValue > ReadingMinMax.MAX_FEV1FVC_RATIO) {
                                throw ApplicationException("Please enter FEV1/FVC ratio in the range of ${ReadingMinMax.MIN_FEV1FVC_RATIO} - ${ReadingMinMax.MAX_FEV1FVC_RATIO}")
                            }
                        }

                        Readings.AQI -> {
                            if (readingValue < ReadingMinMax.MIN_AQI || readingValue > ReadingMinMax.MAX_AQI) {
                                throw ApplicationException("Please enter AQI in the range of ${ReadingMinMax.MIN_AQI} - ${ReadingMinMax.MAX_AQI}")
                            }
                        }

                        Readings.HUMIDITY -> {
                            if (readingValue < ReadingMinMax.MIN_HUMIDITY || readingValue > ReadingMinMax.MAX_HUMIDITY) {
                                throw ApplicationException("Please enter Humidity in the range of ${ReadingMinMax.MIN_HUMIDITY} - ${ReadingMinMax.MAX_HUMIDITY}")
                            }
                        }

                        Readings.TEMPERATURE -> {
                            if (readingValue < ReadingMinMax.MIN_TEMPERATURE || readingValue > ReadingMinMax.MAX_TEMPERATURE) {
                                throw ApplicationException("Please enter Temperature in the range of ${ReadingMinMax.MIN_TEMPERATURE} - ${ReadingMinMax.MAX_TEMPERATURE}")
                            }
                        }

                        else -> {}
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

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ReadingFragmentUpdateReadingCommonBinding {
        return ReadingFragmentUpdateReadingCommonBinding.inflate(inflater, container, attachToRoot)
            .apply {
                root.transitionName = goalReadingData?.keys
            }
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
        setDefaultValues()
    }

    private fun setDefaultValues() {
        updateDate()
        updateTime()

        if (reading == Readings.BodyWeight) {
            setDefaultWeightUnitAndData()
        } else {
            binding.editTextReading.setText(goalReadingData?.getFormattedReadingValue)
        }
    }

    private fun setDefaultWeightUnitAndData() {
        val user = session.user!!
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

        weightUnits.firstOrNull { it.unitKey == user.weight_unit }?.let {
            selectedWeightUnit = it
        }

        //update UI values
        binding.editTextWeightUnit.setText(selectedWeightUnit.unitName)
        val weightKg = goalReadingData?.getFormattedReadingValue ?: ""
        if (weightKg.isNotEmpty()) {
            if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                binding.editTextReading.setText(HeightWeightUtils.convertKgToLbs(weightKg))
            } else {
                binding.editTextReading.setText(weightKg)
            }
        }
    }

    private fun updateDate() {
        binding.editTextDate.setText(
            try {
                DateTimeFormatter.date(calDateTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
            } catch (e: Exception) {
                ""
            }
        )
    }

    private fun updateTime() {
        binding.editTextTime.setText(
            try {
                DateTimeFormatter.date(calDateTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            } catch (e: Exception) {
                ""
            }
        )
    }

    private fun setUpHeader() {
        goalReadingData?.let {
            UpdateReadingsMainFragment.setUpHeaderAndCommonUI(
                it,
                binding.layoutHeader,
                binding.textViewStandardValue
            )

            with(binding) {
                if (reading == Readings.BodyWeight) {
                    editTextWeightUnit.isVisible = true
                    textViewUnit.isVisible = false
                    editTextWeightUnit.setText(it.measurements.toString())
                } else if (reading == Readings.FattyLiverUSGGrade) {
                    textViewUnit.isVisible = false
                } else {
                    editTextWeightUnit.isVisible = false
                    textViewUnit.isVisible = true
                    textViewUnit.setText(it.measurements.toString())
                }
            }
        }

        binding.apply {
            when (reading) {
                Readings.SPO2 -> {
                    //0-100 Percent
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_SPO2.toString().length))
                }

                Readings.FEV1 -> {
                    //0-7 L
                    /*editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_FEV1.toString().length))*/
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_FEV1.toString().length + 3,
                                2
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.PEF -> {
                    // 60-800 L/min
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_PEF.toString().length))
                }

                Readings.HeartRate -> {
                    //0-500 BPM
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_HEARTRATE.toString().length))
                }

                Readings.BodyWeight -> {
                    //1-300 Kg
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                    updateWeightInputFilters()
                }

                Readings.HbA1c -> {
                    //1-100
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_HBA1C.toString().length,
                                1
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.ACR -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_ACR.toString().length))
                }

                Readings.eGFR -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_eGFR.toString().length))
                }

                // new added readings
                Readings.SGOT_AST -> {
                    //1-2000
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_SGOT.toString().length))
                }

                Readings.SGPT_ALT -> {
                    //1-2000
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_SGPT.toString().length))
                }

                Readings.Triglycerides -> {
                    //1-4000
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_TRIGLYCERIDES.toString().length))
                }

                Readings.LDL_CHOLESTEROL -> {
                    //1-4000
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_LDL.toString().length))
                }

                Readings.HDL_CHOLESTEROL -> {
                    //1-4000
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_HDL.toString().length))
                }

                Readings.WaistCircumference -> {
                    //20-300
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_WAIST.toString().length))
                }

                Readings.PlateletCount -> {
                    //1000-1000000
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_PLATELET.toString().length))
                }

                Readings.SerumCreatinine -> {
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_SERUM_CREATININE.toString().length,
                                1
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.FattyLiverUSGGrade -> {
                    editTextReading.filters = arrayOf(InputFilter.LengthFilter(50))
                    editTextReading.inputType = InputType.TYPE_CLASS_TEXT

                    editTextReading.setCompoundDrawablesRelativeWithIntrinsicBounds(
                        0,
                        0,
                        R.drawable.ic_dropdown_gray,
                        0
                    )
                    editTextReading.disableFocus()
                    editTextReading.setOnClickListener {
                        showFattyLiverGradeSelection()
                    }
                }

                Readings.RandomBloodGlucose -> {
                    //30-2500
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_RANDOM_BG.toString().length))
                }
                // BCA device added readings
                Readings.BodyFat -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_BODY_FAT.toString().length))
                }

                Readings.Hydration -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_HYDRATION.toString().length))
                }

                Readings.MuscleMass -> {
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_MUSCLE_MASS.toString().length + 2,
                                1
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.Protein -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_PROTEIN.toString().length))
                }

                Readings.BoneMass -> {
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_BONE_MASS.toString().length + 2,
                                1
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.VisceralFat -> {
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_VISCERAL_FAT.toString().length + 2,
                                1
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.BasalMetabolicRate -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_BASAL_METABOLIC_RATE.toString().length))
                }

                Readings.MetabolicAge -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_METABOLIC_AGE.toString().length))
                }

                Readings.SubcutaneousFat -> {
                    editTextReading.filters =
                        arrayOf(
                            DecimalDigitsInputFilter(
                                ReadingMinMax.MAX_SUBCUTANEOUS_FAT.toString().length + 2,
                                1
                            )
                        )
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.SkeletalMuscle -> {
                    editTextReading.filters =
                        arrayOf(InputFilter.LengthFilter(ReadingMinMax.MAX_SKELETAL_MUSCLE.toString().length))
                }

                // Spirometer added readings
                Readings.FVC -> {
                    editTextReading.filters =
                        arrayOf(DecimalDigitsInputFilter(ReadingMinMax.MAX_FVC.toString().length + 3, 2))
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.FEV1FVC_RATIO -> {
                    editTextReading.filters =
                        arrayOf(DecimalDigitsInputFilter(ReadingMinMax.MAX_FEV1FVC_RATIO.toString().length + 3, 2))
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.AQI -> {
                    editTextReading.filters =
                        arrayOf(DecimalDigitsInputFilter(ReadingMinMax.MAX_AQI.toString().length + 3, 2))
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.HUMIDITY -> {
                    editTextReading.filters =
                        arrayOf(DecimalDigitsInputFilter(ReadingMinMax.MAX_HUMIDITY.toString().length + 3, 2))
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                Readings.TEMPERATURE -> {
                    editTextReading.filters =
                        arrayOf(DecimalDigitsInputFilter(ReadingMinMax.MAX_TEMPERATURE.toString().length + 3, 2))
                    editTextReading.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }

                else -> {}
            }
        }

        UpdateReadingsMainFragment.setUpSyncDataLayout(
            binding.layoutSyncData,
            googleFit.hasAllPermissions,
            googleFit,
            (requireActivity() as BaseActivity)
        )
    }

    private fun showFattyLiverGradeSelection() {
        BottomSheet<FattyLiverUSGGrades>().showBottomSheetDialog(requireActivity(),
            ArrayList(fattyLiverUSGGradesList),
            "",
            object : BottomSheetAdapter.ItemListener<FattyLiverUSGGrades> {
                override fun onItemClick(item: FattyLiverUSGGrades, position: Int) {
                    selectedFattyLiverGrade = item
                    binding.editTextReading.setText(item.title)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<FattyLiverUSGGrades>.MyViewHolder,
                    position: Int,
                    item: FattyLiverUSGGrades,
                ) {
                    holder.textView.text = item.title
                }
            })
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
            editTextReading.filters = arrayOf(DecimalDigitsInputFilter(weightLength + 20, 1))
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            editTextDate.setOnClickListener { onViewClick(it) }
            editTextTime.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }
            editTextWeightUnit.setOnClickListener { onViewClick(it) }
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

                    /*calDateTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                    calDateTime.set(Calendar.MINUTE, minute)
                    calDateTime.set(Calendar.SECOND, 0)
                    updateTime()*/

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

            R.id.editTextWeightUnit -> {
                showWeightUnitSelection()
            }
        }
    }

    private var selectedWeightUnit = WeightUnit.KG
    private val weightUnits = ArrayList(WeightUnit.values().toList())
    private fun showWeightUnitSelection() {
        BottomSheet<WeightUnit>().showBottomSheetDialog(requireActivity(),
            weightUnits,
            "",
            object : BottomSheetAdapter.ItemListener<WeightUnit> {
                override fun onItemClick(item: WeightUnit, position: Int) {
                    if (selectedWeightUnit.unitKey != item.unitKey) {
                        selectedWeightUnit = item
                        binding.editTextWeightUnit.setText(selectedWeightUnit.unitName)
                        updateWeightInputFilters()
                        HeightWeightUtils.updateWeightValuesAndUI(
                            binding.editTextReading,
                            selectedWeightUnit
                        )
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

    /**
     * *****************************************************
     * API request parameters helper methods
     * *****************************************************
     **/
    private fun getWeightRequestParam(): String {
        return if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
            HeightWeightUtils.convertLbsToKg(binding.editTextReading.text.toString())
        } else {
            binding.editTextReading.text.toString().trim()
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

            if (reading == Readings.BodyWeight) {
                weight_unit = selectedWeightUnit.unitKey
                reading_value = getWeightRequestParam()
            } else if (reading == Readings.FattyLiverUSGGrade) {
                reading_value = selectedFattyLiverGrade?.gradeValue.toString()
            } else {
                reading_value = binding.editTextReading.text.toString().trim()
            }
        }
        showLoader()
        goalReadingViewModel.updatePatientReadings(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        authViewModel.getPatientDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        var updateReadingMessage = ""
        goalReadingViewModel.updatePatientReadingsLiveData.observe(this,
            onChange = { responseBody ->
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

                analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                    putString(analytics.PARAM_READING_NAME, goalReadingData?.reading_name)
                    putString(analytics.PARAM_READING_ID, goalReadingData?.readings_master_id)
                }, screenName = AnalyticsScreenNames.LogReading)
                writeToGoogleFit()

                if (reading == Readings.BodyWeight) {
                    updateReadingMessage = responseBody.message
                    getPatientDetails()
                } else {
                    hideLoader()
                    showMessage(responseBody.message)
                    Handler(Looper.getMainLooper())
                        .postDelayed({
                            if (isAdded)
                                callbackOnClose.invoke(false)
                        }, 1000)
                }

            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
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

    private fun writeToGoogleFit() {
        if (googleFit.hasAllPermissions) {
            when (reading) {
                Readings.SPO2 -> {
                    val spo2 = binding.editTextReading.text.toString().trim().toFloatOrNull() ?: 0f
                    if (spo2 > 0) {
                        googleFit.writeSpo2(spo2, calDateTime)
                    }
                }
                /*Readings.HeartRate -> {
                    val heartRate =
                        binding.editTextReading.text.toString().trim().toFloatOrNull() ?: 0f
                    if (heartRate > 0) {
                        googleFit.writeHeartRate(heartRate, calDateTime)
                    }
                }*/
                Readings.BodyWeight -> {
                    val weight = getWeightRequestParam().toFloatOrNull() ?: 0f
                    /*binding.editTextReading.text.toString().trim().toFloatOrNull() ?: 0f*/
                    if (weight > 0) {
                        googleFit.writeBodyWeight(weight, calDateTime)
                    }
                }

                else -> {

                }
            }
        }
    }
}