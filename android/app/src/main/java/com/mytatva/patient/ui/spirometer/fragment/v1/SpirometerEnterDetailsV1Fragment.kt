package com.mytatva.patient.ui.spirometer.fragment.v1

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Ethnicity
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.SpirometerFragmentEnterDetailsV1Binding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.spirometer.bottomsheet.CommonWheelPickerDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.HeightWheelPickerDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.WeightWheelPickerDialog
import com.mytatva.patient.ui.spirometer.fragment.SpirometerAllReadingsFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.apputils.HeightWeightUtils
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import com.mytatva.patient.utils.listOfField
import com.mytatva.patient.utils.spirometer.SpirometerManager
import javax.inject.Inject


class SpirometerEnterDetailsV1Fragment : BaseFragment<SpirometerFragmentEnterDetailsV1Binding>() {

    @Inject
    lateinit var myBluetoothManager: MyBluetoothManager

    val age: Int by lazy {
        session.user?.getAgeValue ?: 0
    }

    val isOpenFromAllReadings: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_OPEN_FROM_ALL_READINGS) ?: false
    }

    private var selectedHeightUnit = HeightUnit.CM
    private val heightUnits = ArrayList(HeightUnit.values().toList())

    private var selectedWeightUnit = WeightUnit.KG
    private val weightUnits = ArrayList(WeightUnit.values().toList())

    var height: String = ""
    var weight: String = ""

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    @Inject
    lateinit var spirometerManager: SpirometerManager

    private fun isValid(): Boolean {
        return try {
            with(binding) {

                validator.submit(editTextHeight).checkEmpty()
                    .errorMessage(getString(R.string.validation_select_height))
                    .check()

                validator.submit(editTextWeight).checkEmpty()
                    .errorMessage(getString(R.string.validation_select_weight))
                    .check()

                validator.submit(editTextEthnicity).checkEmpty()
                    .errorMessage(getString(R.string.validation_select_ethnicity))
                    .check()

            }
            true
        } catch (e: ApplicationException) {
            showAppMessage(e.message, AppMsgStatus.ERROR)
            false
        }
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): SpirometerFragmentEnterDetailsV1Binding {
        return SpirometerFragmentEnterDetailsV1Binding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SpirometerEnterDetails)
        if (SpirometerManager.spiroMeterTestUUID.isNotBlank()) {
            //when spiroMeterTestUUID is not blank that means test finished and come back to this screen
            //show loader until the finish callback is not received,
            //or for 2 seconds for the case when user comes back without finishing the test
            showLoader()
            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded) {
                    hideLoader()
                }
            }, 2500)
        }
    }

    override fun bindData() {
        height = session.user?.height ?: ""
        weight = session.user?.weight ?: ""
        setUpToolbar()
        setUpViewListeners()
        changeListener()
        setDefaultDataAndUI()
        getPatientDetails()
    }

    private fun changeListener() = with(binding) {
        editTextHeight.focusableSelectorBlackGray(inputLayoutHeight)
        editTextWeight.focusableSelectorBlackGray(inputLayoutWeight)
        editTextEthnicity.focusableSelectorBlackGray(inputLayoutEthnicity)
        editTextAge.focusableSelectorBlackGray(inputLayoutAge)
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Enter Details"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    private fun setDefaultDataAndUI() {
        with(binding) {
            setHeightWeightUnitData()
            setUserData()
        }
    }

    private fun setUserData() {
        with(binding) {
            inputLayoutAge.isEnabled = false
            editTextAge.setText(session.user?.patient_age ?: "")

            if (session.user?.ethnicity.isNullOrBlank().not()) {
                inputLayoutEthnicity.isEnabled = false
                selectedEthnicity =
                    Ethnicity.values().first { it.ethnicityKey == session.user?.ethnicity }
//                editTextEthnicity.setText(session.user?.ethnicity ?: "")
                editTextEthnicity.setText(selectedEthnicity?.ethnicityName ?: "")
            }

            radioMale.isEnabled = session.user?.gender != "M"
            radioFemale.isEnabled = session.user?.gender != "F"

            height = session.user?.height?.toDoubleOrNull()?.toInt()?.toString() ?: ""
            if (height/*heightCm*/.isNotEmpty()) {
                if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
                    val heightFeetInch = HeightWeightUtils.convertCmToFeetInches(height/*heightCm*/)
                    editTextHeight.setText(
                        String.format(
                            "%s' %s'' %s",
                            heightFeetInch.first,
                            heightFeetInch.second,
                            selectedHeightUnit.unitName
                        )
                    )
                } else {
                    editTextHeight.setText(
                        String.format(
                            "%s %s",
                            height/*heightCm*/,
                            selectedHeightUnit.unitName
                        )
                    )
                }
            }

            weight = session.user?.weight?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: ""
            if (weight/*weightKg*/.isNotEmpty()) {

                /*if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                    editTextWeight.setText(String.format("%s %s",HeightWeightUtils.convertKgToLbs(weight*//*weightKg*//*),selectedWeightUnit.unitName))
                } else {
                    editTextWeight.setText(String.format("%s %s",weight*//*weightKg*//*,selectedWeightUnit.unitName))
                }*/

                updateWeightAsPerSelectedUnit()

            }
        }
    }

    private fun EditText.focusableSelectorBlackGray(textInputLayout: TextInputLayout) {
        textInputLayout.setHintTextAppearance(R.style.hintAppearance)
        this.doOnTextChanged { text, _, _, _ ->
            if (textInputLayout.isEnabled) {
                if (text?.length!! > 0) {
                    this.isSelected = true
                    textInputLayout.isSelected = true
                    this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
                } else {
                    this.isSelected = false
                    textInputLayout.isSelected = false
                    this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_regular)
                }
            } else {
                textInputLayout.isEnabled = false
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
                this.setTextColor(ContextCompat.getColor(requireContext(), R.color.textGray1))
            }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveAndNext.setOnClickListener { onViewClick(it) }
            editTextHeight.setOnClickListener { onViewClick(it) }
            editTextWeight.setOnClickListener { onViewClick(it) }
            editTextEthnicity.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonSaveAndNext -> {
                if (isValid()) {
                    updatePatientHeightWeight()
                    /*if (myBluetoothManager.isBluetoothEnabled()) {
                        updatePatientHeightWeight()
                    } else {
                        myBluetoothManager.turnOnBluetooth(requireActivity() as BaseActivity)
                    }*/
                }
            }

            R.id.editTextHeight -> {
                showHeightUnitSelection()
            }

            R.id.editTextWeight -> {
                showWeightUnitSelection()
            }

            R.id.editTextEthnicity -> {
                showEthnicitySelection()
            }
        }
    }

    private fun initSpirometerTestFlow() {
        spirometerManager.initStartTestFlow(requireActivity() as AppCompatActivity,
            finishCallback = {
                hideLoader()
                if (isOpenFromAllReadings) {
                    val resultIntent = Intent()
                    requireActivity().setResult(Activity.RESULT_OK, resultIntent)
                    requireActivity().finish()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        SpirometerAllReadingsFragment::class.java
                    )
                        .addBundle(Bundle().apply {
                            putBoolean(Common.BundleKey.IS_TO_UPDATE_SPIRO_READINGS, true)
                        }).byFinishingCurrent()
                        .start()
                }
                /*if (SpirometerManager.isIncentive) {
                    updateIncentiveSpirometerData()
                } else {
                    updateSpirometerData()
                }*/
            })
    }

    private var selectedEthnicity: Ethnicity? = null

    private fun showEthnicitySelection() {
        val ethnicityList = ArrayList(Ethnicity.values().toList())
        CommonWheelPickerDialog.showBottomSheet(
            title = "Select Ethnicity",
            list = ethnicityList.listOfField(Ethnicity::ethnicityName) /*resources.getStringArray(R.array.ethnicity)*/,
            selectedItem = binding.editTextEthnicity.text.toString()
        ) {
            selectedEthnicity = ethnicityList[it]
            binding.editTextEthnicity.setText(
                selectedEthnicity?.ethnicityName
                    ?: ""/*resources.getStringArray(R.array.ethnicity).get(it)*/
            )
        }.show(
            requireActivity().supportFragmentManager,
            CommonWheelPickerDialog::class.java.simpleName
        )

        /*val ethnicityList=ArrayList(Ethnicity.values().toList())
        SelectItemBottomSheetDialog.showBottomSheet<Ethnicity>(
            title = "Select Ethnicity",
            list = ethnicityList,
            selectedItem = null,
            callback = { position: Int ->
                selectedEthnicity = ethnicityList[position]
                binding.editTextEthnicity.setText(ethnicity.ethnicityName)
            }
        ).show(requireActivity().supportFragmentManager,SelectItemBottomSheetDialog::class.java.simpleName)*/

    }

    /**
     * *****************************************************
     * Height/Weight conversions and helper methods
     * *****************************************************
     **/
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

        }
    }

    private fun showHeightUnitSelection() {
        HeightWheelPickerDialog.showBottomSheet(
            selectedItem = height,
            selectedUnit = selectedHeightUnit,
            tabList = heightUnits.listOfField(HeightUnit::unitName).reversed() as ArrayList<String>,
            callback = { it, units ->
                selectedHeightUnit = units
                height = it

                updateHeightValuesAndUI()
            }
        ).show(
            requireActivity().supportFragmentManager,
            HeightWheelPickerDialog::class.java.simpleName
        )
    }

    private fun updateHeightValuesAndUI() {
        with(binding) {
            if (height.isNotBlank()) {
                /*if (selectedHeightUnit == HeightUnit.FEET_INCHES) {
                    val heightFeetInch = HeightWeightUtils.convertCmToFeetInches(height)
                    binding.editTextHeight.setText(String.format("%s'%s''", heightFeetInch.first, heightFeetInch.second))
                } else {
                    binding.editTextHeight.setText(height + " cm")
                }*/

                if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
                    val heightFeetInch = HeightWeightUtils.convertCmToFeetInches(height/*heightCm*/)
                    editTextHeight.setText(
                        String.format(
                            "%s' %s'' %s",
                            heightFeetInch.first,
                            heightFeetInch.second,
                            selectedHeightUnit.unitName
                        )
                    )
                } else {
                    editTextHeight.setText(
                        String.format(
                            "%s %s",
                            height/*heightCm*/,
                            selectedHeightUnit.unitName
                        )
                    )
                }

            }
        }
    }

    private fun showWeightUnitSelection() {
        WeightWheelPickerDialog.showBottomSheet(
            selectedItem = weight,
            selectedUnit = selectedWeightUnit,
            tabList = weightUnits.listOfField(WeightUnit::unitName),
            callback = { it, units ->
                selectedWeightUnit = units
                weight = it
                updateWeightAsPerSelectedUnit()
                /*if (units == WeightUnit.KG){
                    binding.editTextWeight.setText(String.format("%s %s",it,selectedWeightUnit.unitName))
                }else {
                    binding.editTextWeight.setText(String.format("%s %s",HeightWeightUtils.convertKgToLbs(it),selectedWeightUnit.unitName))
                }*/
            }
        ).show(
            requireActivity().supportFragmentManager,
            WeightWheelPickerDialog::class.java.simpleName
        )
    }

    private fun updateWeightAsPerSelectedUnit() {
        HeightWeightUtils.updateWeightValuesAndUIV1(
            binding.editTextWeight,
            weight,
            selectedWeightUnit
        )
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updatePatientHeightWeight() {
        val apiRequest = ApiRequest().apply {

            height = this@SpirometerEnterDetailsV1Fragment.height
            weight = this@SpirometerEnterDetailsV1Fragment.weight

            height_unit = selectedHeightUnit.unitKey
            weight_unit = selectedWeightUnit.unitKey

            /*ethnicity = binding.editTextEthnicity.text.toString().trim()*/
            ethnicity = selectedEthnicity?.ethnicityKey
        }
        showLoader()
        authViewModel.updatePatientHeightWeight(apiRequest)
    }

    private fun updateSpirometerData() {
        val apiRequest = ApiRequest().apply {
            parent_event_id = SpirometerManager.spiroMeterTestUUID
        }
        showLoader()
        goalReadingViewModel.updateSpirometerData(apiRequest)
    }

    private fun updateIncentiveSpirometerData() {
        val apiRequest = ApiRequest().apply {
            parent_event_id = SpirometerManager.spiroMeterTestUUID
        }
        showLoader()
        goalReadingViewModel.updateIncentiveSpirometerData(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.getPatientDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updatePatientHeightWeightLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            /*analytics.logEvent(
                analytics.HEIGHT_WEIGHT_ADDED,
                screenName = AnalyticsScreenNames.SetHeightWeight
            )*/
            initSpirometerTestFlow()
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //updateSpirometerDataLiveData
        goalReadingViewModel.updateSpirometerDataLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            SpirometerManager.spiroMeterTestUUID = ""
            navigator.goBack()
        }, onError = { throwable ->
            hideLoader()
            SpirometerManager.spiroMeterTestUUID = ""
            true
        })

        //updateIncentiveSpirometerDataLiveData
        goalReadingViewModel.updateIncentiveSpirometerDataLiveData.observe(
            this,
            onChange = { responseBody ->
                hideLoader()
                SpirometerManager.spiroMeterTestUUID = ""
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                SpirometerManager.spiroMeterTestUUID = ""
                true
            })

        //getPatientDetailsLiveData
        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (isAdded) {
                    setDefaultDataAndUI()
                }
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }
}