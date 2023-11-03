package com.mytatva.patient.ui.spirometer.fragment

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.InputFilter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.SpirometerFragmentEnterDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.DecimalDigitsInputFilter
import com.mytatva.patient.utils.apputils.HeightWeightUtils
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.inputfilter.InputFilterMinMax
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import com.mytatva.patient.utils.spirometer.SpirometerManager
import javax.inject.Inject


class SpirometerEnterDetailsFragment : BaseFragment<SpirometerFragmentEnterDetailsBinding>() {

    @Inject
    lateinit var myBluetoothManager: MyBluetoothManager

    val age: Int by lazy {
        session.user?.getAgeValue ?: 0
    }

    val height: Int by lazy {
        session.user?.getHeightValue ?: 0
    }

    val weight: Int by lazy {
        session.user?.getWeightValue ?: 0
    }

    val isOpenFromAllReadings: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_OPEN_FROM_ALL_READINGS) ?: false
    }

    private var selectedHeightUnit = HeightUnit.CM
    private val heightUnits = ArrayList(HeightUnit.values().toList())

    private var selectedWeightUnit = WeightUnit.KG
    private val weightUnits = ArrayList(WeightUnit.values().toList())

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

                HeightWeightUtils.validateHeightFields(
                    validator,
                    selectedHeightUnit,
                    editTextHeightFeet,
                    editTextHeightInches,
                    editTextHeight
                )

                HeightWeightUtils.validateWeightFields(
                    validator, selectedWeightUnit, editTextWeight
                )

                validator.submit(editTextEthnicity).checkEmpty()
                    .errorMessage(getString(R.string.validation_select_ethnicity)).check()

            }
            true
        } catch (e: ApplicationException) {
            showMessage(e.message)
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
    ): SpirometerFragmentEnterDetailsBinding {
        return SpirometerFragmentEnterDetailsBinding.inflate(layoutInflater)
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
            },2500)
        }
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setDefaultDataAndUI()
        getPatientDetails()
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
            updateHeightInputFilters()
            updateWeightInputFilters()
            setUserData()
        }
    }

    private fun setUserData() {
        with(binding) {
            editTextAge.setText(session.user?.patient_age ?: "")
            if(session.user?.ethnicity.isNullOrBlank().not()) {
                editTextEthnicity.setText(session.user?.ethnicity ?: "")
                editTextEthnicity.isEnabled = false
            }

            radioMale.isChecked = session.user?.gender == "M"
            radioFemale.isChecked = session.user?.gender == "F"

            val heightCm = session.user?.height?.toDoubleOrNull()?.toInt()?.toString() ?: ""
            if (heightCm.isNotEmpty()) {
                if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
                    val heightFeetInch = HeightWeightUtils.convertCmToFeetInches(heightCm)
                    editTextHeightFeet.setText(heightFeetInch.first)
                    editTextHeightInches.setText(heightFeetInch.second)
                } else {
                    editTextHeight.setText(heightCm)
                }
            }

            val weightKg = session.user?.weight?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: ""
            if (weightKg.isNotEmpty()) {
                if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                    editTextWeight.setText(HeightWeightUtils.convertKgToLbs(weightKg))
                } else {
                    editTextWeight.setText(weightKg)
                }
            }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveAndNext.setOnClickListener { onViewClick(it) }
            editTextHeightUnit.setOnClickListener { onViewClick(it) }
            editTextWeightUnit.setOnClickListener { onViewClick(it) }
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

            R.id.editTextHeightUnit -> {
                showHeightUnitSelection()
            }

            R.id.editTextWeightUnit -> {
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
                if(isOpenFromAllReadings) {
                    val resultIntent = Intent()
                    requireActivity().setResult(Activity.RESULT_OK,resultIntent)
                    requireActivity().finish()
                } else {
                    navigator.loadActivity(IsolatedFullActivity::class.java,SpirometerAllReadingsFragment::class.java)
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

    /*private fun initStartTestFlow() {
        locationManager.startLocationUpdates { location, exception ->
            location?.let {
                locationManager.stopFetchLocationUpdates()

                //StartSpirometryTest.setLatLon(it.latitude.toString(),it.longitude.toString(),requireActivity())
                TestTypeBottomSheetDialog()
                    .setCallback { isIncentive ->
                        startTest(isIncentive)
                    }.show(childFragmentManager, null)

            }
            exception?.let {
                // location will not be updated
            }
        }
    }

    private fun startTest(incentive: Boolean) {

        val uuID = UUID.randomUUID().toString()
        Log.d("AlveoAir", "initAlveoAir: $uuID")
        if (incentive) {//incentive

            EnterTargetVolumeDialog().setCallback { targetVolume ->

                    StartSpirometryTest().startIncentive(
                        requireActivity(),
                        BuildConfig.SPIROMETER_CLIENT_ID,
                        BuildConfig.SPIROMETER_SERVER_KEY,
                        BuildConfig.SPIROMETER_ACCOUNT_ID,
                        session.userId *//*"af282574-edc0-11ed-1ab2-211e1aed"*//*,
                        session.user?.name,
                        session.user?.getGenderCodeForSpirometer *//*"MALE"*//*,
                        age,
                        "NORTH_INDIAN",//session.user?.ethnicity,
                        height.toFloat() *//*180f*//*, // height(CM)
                        weight.toFloat() *//*75f*//*, // weight(KG)
                        uuID,
                        targetVolume
                    )

                }.show(
                    requireActivity().supportFragmentManager,
                    EnterTargetVolumeDialog::class.java.simpleName
                )

        } else {//standard
            StartSpirometryTest().startStandard(
                requireActivity(),
                BuildConfig.SPIROMETER_CLIENT_ID,
                BuildConfig.SPIROMETER_SERVER_KEY,
                BuildConfig.SPIROMETER_ACCOUNT_ID,
                session.userId, //"af282574-edc0-11ed-1ab2-022e1vbc",
                session.user?.name,
                session.user?.getGenderCodeForSpirometer*//*"MALE"*//*,
                age,
                "NORTH_INDIAN",//session.user?.ethnicity,
                height.toFloat(), // height(CM)
                weight.toFloat(), // weight(KG)
                uuID
            )
        }
    }*/

    private fun showEthnicitySelection() {
        BottomSheet<String>().showBottomSheetDialog(requireActivity(),
            ArrayList(resources.getStringArray(R.array.ethnicity).toList()),
            "",
            object : BottomSheetAdapter.ItemListener<String> {
                override fun onItemClick(item: String, position: Int) {
                    binding.editTextEthnicity.setText(item)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<String>.MyViewHolder,
                    position: Int,
                    item: String,
                ) {
                    holder.textView.text = item
                }
            })
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

    private fun updateHeightInputFilters() {
        binding.editTextHeightInches.filters =
            arrayOf(InputFilterMinMax(0, 11), InputFilter.LengthFilter(2))
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
                groupHeightFeetInchesEditText.isVisible = true

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
                groupHeightFeetInchesEditText.isVisible = false

                if (editTextHeightFeet.text.toString().trim()
                        .isBlank() || editTextHeightInches.text.toString().trim().isBlank()
                ) {
                    editTextHeight.setText("")
                } else {
                    val heightCm = HeightWeightUtils.convertFeetInchesToCm(
                        editTextHeightFeet.text.toString(), editTextHeightInches.text.toString()
                    )
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

                        //update weight and weight goal values
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

    private fun updateWeightInputFilters() {
        with(binding) {
            val weightLength = if (selectedWeightUnit == WeightUnit.LBS) {
                ReadingMinMax.MAX_BODYWEIGHT_LBS.toString().length
            } else {
                ReadingMinMax.MAX_BODYWEIGHT_KG.toString().length
            }
            editTextWeight.filters = arrayOf(DecimalDigitsInputFilter(weightLength + 20, 1))
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
                binding.editTextHeightInches.text.toString()
            )
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
    private fun updatePatientHeightWeight() {
        val apiRequest = ApiRequest().apply {
            /*height = binding.editTextHeight.text.toString().trim()
            weight = binding.editTextWeight.text.toString().trim()*/
            height = getHeightRequestParam()
            weight = getWeightRequestParam()

            height_unit = selectedHeightUnit.unitKey
            weight_unit = selectedWeightUnit.unitKey

            ethnicity = binding.editTextEthnicity.text.toString().trim()
        }
        showLoader()
        authViewModel.updatePatientHeightWeight(apiRequest)
    }

    /*private fun updateSpirometerData() {
        val apiRequest = ApiRequest().apply {
            parent_event_id = SpirometerManager.spiroMeterTestUUID
            if (MyTatvaApp.IS_SPIRO_PROD.not()) {
                dev = "true"
            }
        }
        showLoader()
        goalReadingViewModel.updateSpirometerData(apiRequest)
    }

    private fun updateIncentiveSpirometerData() {
        val apiRequest = ApiRequest().apply {
            parent_event_id = SpirometerManager.spiroMeterTestUUID
            if (MyTatvaApp.IS_SPIRO_PROD.not()) {
                dev = "true"
            }
        }
        showLoader()
        goalReadingViewModel.updateIncentiveSpirometerData(apiRequest)
    }*/

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
        authViewModel.updatePatientHeightWeightLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            analytics.logEvent(
                analytics.HEIGHT_WEIGHT_ADDED,
                Bundle().apply {
                    putString(analytics.PARAM_ETHNICITY, binding.editTextEthnicity.text.toString().trim())
                },
                screenName = AnalyticsScreenNames.SpirometerEnterDetails
            )
            initSpirometerTestFlow()
        }, onError = { throwable ->
            hideLoader()
            true
        })

        /*//updateSpirometerDataLiveData
        goalReadingViewModel.updateSpirometerDataLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            analytics.logEvent(
                analytics.HEALTH_MARKERS_POPULATED, Bundle().apply {
                    putString(analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER)
                    putString(analytics.PARAM_TEST_TYPE, "Standard")
                }, screenName = AnalyticsScreenNames.SpirometerEnterDetails
            )
            SpirometerManager.spiroMeterTestUUID = ""
            navigator.goBack()
        }, onError = { throwable ->
            hideLoader()
            SpirometerManager.spiroMeterTestUUID = ""
            true
        })

        //updateIncentiveSpirometerDataLiveData
        goalReadingViewModel.updateIncentiveSpirometerDataLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            analytics.logEvent(
                analytics.HEALTH_MARKERS_POPULATED, Bundle().apply {
                    putString(analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER)
                    putString(analytics.PARAM_TEST_TYPE, "Incentive")
                }, screenName = AnalyticsScreenNames.SpirometerEnterDetails
            )
            SpirometerManager.spiroMeterTestUUID = ""
            navigator.goBack()
        }, onError = { throwable ->
            hideLoader()
            SpirometerManager.spiroMeterTestUUID = ""
            true
        })*/

        //getPatientDetailsLiveData
        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                // hideLoader()
                if (isAdded) {
                    setDefaultDataAndUI()
                }
            },
            onError = { throwable ->
                // hideLoader()
                false
            })
    }
}