package com.mytatva.patient.ui.auth.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.text.Editable
import android.text.InputFilter
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.ActivityLevels
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BmrDisclaimerData
import com.mytatva.patient.data.pojo.response.WeightGoalMonthsData
import com.mytatva.patient.databinding.AuthFragmentSetupHeightWeightBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.adapter.ChooseActivityLevelAdapter
import com.mytatva.patient.ui.base.BaseActivity
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
import kotlinx.coroutines.*
import java.util.*
import java.util.concurrent.TimeUnit


class SetupHeightWeightFragment : BaseFragment<AuthFragmentSetupHeightWeightBinding>() {

    var resumedTime = Calendar.getInstance().timeInMillis
    private fun isValid(isForUpdate: Boolean = false): Boolean {
        return try {
            with(binding) {

                HeightWeightUtils.validateHeightFields(validator,
                    selectedHeightUnit,
                    editTextHeightFeet,
                    editTextHeightInches,
                    editTextHeight)

                HeightWeightUtils.validateWeightFields(validator,
                    selectedWeightUnit,
                    editTextWeight,
                    editTextWeightGoal)

                if (isForUpdate) {
                    validator.submit(editTextWeightGoalDays).checkEmpty()
                        .errorMessage(getString(R.string.validation_empty_target_duration)).check()
                }
            }
            true
        } catch (e: ApplicationException) {
            showMessage(e.message)
            false
        }
    }

    private val activityLevels: ArrayList<ActivityLevels> =
        ArrayList(ActivityLevels.values().toList())

    private val chooseActivityLevelAdapter by lazy {
        ChooseActivityLevelAdapter(activityLevels) {
            callCheckBmrDisclaimerAPI()
        }
    }

    /**
     * isToSkipTextChange - a flag to skip the text change event for height & weight edittexts
     * when changing values automatic in unit conversion
     */
    private var isToSkipTextChange = false

    private var selectedHeightUnit = HeightUnit.CM
    private val heightUnits = ArrayList(HeightUnit.values().toList())
    //private var selectedHeightUnitKey = HeightUnit.CM.unitKey
    //private val heightUnits = ArrayList<UnitData>()

    private var selectedWeightUnit = WeightUnit.KG
    private val weightUnits = ArrayList(WeightUnit.values().toList())
    //private var selectedWeightUnitKey = WeightUnit.KG.unitKey
    //private val weightUnits = ArrayList<UnitData>()

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    private var selectedWeightGoalMonthsData: WeightGoalMonthsData? = null

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSetupHeightWeightBinding {
        return AuthFragmentSetupHeightWeightBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        resumedTime = Calendar.getInstance().timeInMillis
        analytics.setScreenName(AnalyticsScreenNames.SetHeightWeight)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setDefaultDataAndUI()
        setViewListeners()
        setUpRecyclerView()
        if (activity is IsolatedFullActivity) {
            binding.textViewSkipForNow.visibility = View.GONE
            getPatientDetails()
            //for update time
            setUserData()
        }
    }

    private fun setDefaultDataAndUI() {
        with(binding) {
            setHeightWeightUnitData()
            updateHeightInputFilters()
            updateWeightInputFilters()
        }
    }

    private fun updateHeightInputFilters() {
        binding.editTextHeightInches.filters =
            arrayOf(InputFilterMinMax(0, 11), InputFilter.LengthFilter(2))
    }

    private fun updateWeightInputFilters() {
        with(binding) {
            val weightLength = if (selectedWeightUnit == WeightUnit.LBS) {
                ReadingMinMax.MAX_BODYWEIGHT_LBS.toString().length
            } else {
                ReadingMinMax.MAX_BODYWEIGHT_KG.toString().length
            }
            editTextWeight.filters = arrayOf(DecimalDigitsInputFilter(weightLength+20, 1))
            editTextWeightGoal.filters = arrayOf(DecimalDigitsInputFilter(weightLength+20, 1))
        }
    }

    private fun setHeightWeightUnitData() {
        session.user?.let { user ->

            /*//set height/weight unit lists for dropdown
            heightUnits.clear()
            user.unit_data?.filter {
                it.unit_key == HeightUnit.FEET_INCHES.unitKey ||
                        it.unit_key == HeightUnit.CM.unitKey
            }?.let { heightUnits.addAll(it) }

            weightUnits.clear()
            user.unit_data?.filter {
                it.unit_key == WeightUnit.LBS.unitKey ||
                        it.unit_key == WeightUnit.KG.unitKey
            }?.let { weightUnits.addAll(it) }

            //set selected height/weight unit keys
            user.height_unit?.let {
                selectedHeightUnitKey = it
            }
            user.weight_unit?.let {
                selectedWeightUnitKey = it
            }

            with(binding) {
                //set last selected units in fields
                editTextHeightUnit.setText(heightUnits.firstOrNull {
                    it.unit_key == selectedHeightUnitKey
                }?.unit_title ?: "")
                editTextWeightUnit.setText(weightUnits.firstOrNull {
                    it.unit_key == selectedWeightUnitKey
                }?.unit_title ?: "")
            }*/

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

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewChooseActivityLevel.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = chooseActivityLevelAdapter
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setUserData() {
        with(binding) {
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


            //setup bmr data
            session.user?.bmr_details?.let { bmrDetails ->

                val weightGoalKg =
                    bmrDetails.goal_weight?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: ""
                if (weightGoalKg.isNotEmpty()) {
                    if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                        editTextWeightGoal.setText(HeightWeightUtils.convertKgToLbs(weightGoalKg))
                    } else {
                        editTextWeightGoal.setText(weightGoalKg)
                    }
                }


                editTextWeightGoalDays.setText(bmrDetails.months)

                selectedWeightGoalMonthsData =
                    WeightGoalMonthsData(bmrDetails.rate, bmrDetails.type, bmrDetails.months)

                chooseActivityLevelAdapter.selectedPosition =
                    if (activityLevels.any { bmrDetails.activity_level == it.activityKey }) {
                        activityLevels.indexOfFirst { it.activityKey == bmrDetails.activity_level }
                    } else {
                        0
                    }
                chooseActivityLevelAdapter.notifyDataSetChanged()

            }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            /*editTextHeight.addTextChangedListener {
                clearSelectedGoalMonths()
                callCheckBmrDisclaimerAPI()
            }
            editTextHeightFeet.addTextChangedListener {
                clearSelectedGoalMonths()
                callCheckBmrDisclaimerAPI()
            }
            editTextHeightInches.addTextChangedListener {
                clearSelectedGoalMonths()
                callCheckBmrDisclaimerAPI()
            }
            editTextWeight.addTextChangedListener {
                clearSelectedGoalMonths()
                callCheckBmrDisclaimerAPI()
            }
            editTextWeightGoal.addTextChangedListener {
                clearSelectedGoalMonths()
                callCheckBmrDisclaimerAPI()
            }*/

            val textWatcher = object : TextWatcher {
                override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                }

                override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                }

                override fun afterTextChanged(p0: Editable?) {
                    if (isToSkipTextChange) {
                        isToSkipTextChange = false
                    } else {
                        clearSelectedGoalMonths()
                        callCheckBmrDisclaimerAPI()
                    }
                }
            }

            editTextHeight.addTextChangedListener(textWatcher)
            editTextHeightFeet.addTextChangedListener(textWatcher)
            editTextHeightInches.addTextChangedListener(textWatcher)
            editTextWeight.addTextChangedListener(textWatcher)
            editTextWeightGoal.addTextChangedListener(textWatcher)


            imageViewBack.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }
            textViewSkipForNow.setOnClickListener { onViewClick(it) }
            editTextWeightGoalDays.setOnClickListener { onViewClick(it) }
            editTextHeightUnit.setOnClickListener { onViewClick(it) }
            editTextWeightUnit.setOnClickListener { onViewClick(it) }
        }
    }

    private fun clearSelectedGoalMonths() {
        binding.editTextWeightGoalDays.setText("")
        selectedWeightGoalMonthsData = null
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.editTextWeightGoalDays -> {
                if (isValid()) {
                    calculateBmrMonths()
                }
            }
            R.id.textViewSkipForNow -> {
                handleAuthNavigation()
            }
            R.id.imageViewBack -> {
                navigator.goBack()
            }
            R.id.buttonUpdate -> {
                if (isValid(true)) {
                    updatePatientHeightWeight()
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
                groupHeightFeetInchesEditText.isVisible = true

                if (editTextHeight.text.toString().trim().isBlank()) {
                    isToSkipTextChange = true
                    editTextHeightFeet.setText("")
                    isToSkipTextChange = true
                    editTextHeightInches.setText("")
                } else {
                    val pairFeetInches =
                        HeightWeightUtils.convertCmToFeetInches(editTextHeight.text.toString())
                    isToSkipTextChange = true
                    editTextHeightFeet.setText(pairFeetInches.first)
                    isToSkipTextChange = true
                    editTextHeightInches.setText(pairFeetInches.second)
                }
            } else {
                editTextHeight.isVisible = true
                groupHeightFeetInchesEditText.isVisible = false

                if (editTextHeightFeet.text.toString().trim()
                        .isBlank() || editTextHeightInches.text.toString().trim().isBlank()
                ) {
                    isToSkipTextChange = true
                    editTextHeight.setText("")
                } else {
                    val heightCm =
                        HeightWeightUtils.convertFeetInchesToCm(editTextHeightFeet.text.toString(),
                            editTextHeightInches.text.toString())
                    isToSkipTextChange = true
                    editTextHeight.setText(heightCm)
                }
            }
        }
    }

    /*private fun getHeightUnitTitle(): String {
        return heightUnits.firstOrNull { it.unit_key==selectedHeightUnitKey }?.unit_title?:""
    }

    private fun getWeightUnitTitle(): String {
        return weightUnits.firstOrNull { it.unit_key==selectedWeightUnitKey }?.unit_title?:""
    }*/

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
        isToSkipTextChange = true
        HeightWeightUtils.updateWeightValuesAndUI(binding.editTextWeight, selectedWeightUnit)
        isToSkipTextChange = true
        HeightWeightUtils.updateWeightValuesAndUI(binding.editTextWeightGoal, selectedWeightUnit)
    }

    /*private fun updateWeightValuesAndUI() {
        with(binding) {
            editTextWeightUnit.setText(selectedWeightUnit.unitName)

            if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {

                if (editTextWeight.text.toString().trim().isNotBlank()) {
                    val weightLbs = HeightWeightUtils.convertKgToLbs(editTextWeight.text.toString())
                    editTextWeight.setText(weightLbs)
                }

                if (editTextWeightGoal.text.toString().trim().isNotBlank()) {
                    val weightLbs =
                        HeightWeightUtils.convertKgToLbs(editTextWeightGoal.text.toString())
                    editTextWeightGoal.setText(weightLbs)
                }

            } else {

                if (editTextWeight.text.toString().trim().isNotBlank()) {
                    val weightKg = HeightWeightUtils.convertLbsToKg(editTextWeight.text.toString())
                    editTextWeight.setText(weightKg)
                }

                if (editTextWeightGoal.text.toString().trim().isNotBlank()) {
                    val weightKg =
                        HeightWeightUtils.convertLbsToKg(editTextWeightGoal.text.toString())
                    editTextWeightGoal.setText(weightKg)
                }

            }

        }
    }*/

    private fun handleAuthNavigation() {
        navigator.loadActivity(AuthActivity::class.java, SetupGoalsReadingsFragment::class.java)
            //.byFinishingCurrent()
            .start()
    }

    var callApiJob: Job? = null
    private fun callCheckBmrDisclaimerAPI() {
        callApiJob?.cancel()
        callApiJob = GlobalScope.launch(Dispatchers.Main) {
            delay(200)
            if (isAdded) {
                if (checkHeightFieldIsNotEmpty() && checkWeightFieldIsNotEmpty()) {
                    checkBmrDisclaimer()
                } else {
                    // hide disclaimers
                    setDisclaimers(null)
                }
            }
        }
    }

    private fun checkHeightFieldIsNotEmpty(): Boolean {
        return if (selectedHeightUnit.unitKey == HeightUnit.CM.unitKey) {
            binding.editTextHeight.text.toString().trim().isNotEmpty()
        } else {
            binding.editTextHeightFeet.text.toString().trim()
                .isNotEmpty() && binding.editTextHeightInches.text.toString().trim().isNotEmpty()
        }
    }

    private fun checkWeightFieldIsNotEmpty(): Boolean =
        binding.editTextWeight.text.toString().trim()
            .isNotEmpty() && binding.editTextWeightGoal.text.toString().trim().isNotEmpty()

    /**
     * *****************************************************
     * API request parameters helper methods
     * *****************************************************
     **/
    private fun getHeightRequestParam(): String {
        return if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {
            HeightWeightUtils.convertFeetInchesToCm(binding.editTextHeightFeet.text.toString(),
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

    private fun getGoalWeightRequestParam(): String {
        return if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
            HeightWeightUtils.convertLbsToKg(binding.editTextWeightGoal.text.toString())
        } else {
            binding.editTextWeightGoal.text.toString().trim()
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
        }
        showLoader()
        authViewModel.updatePatientHeightWeight(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        authViewModel.getPatientDetails(apiRequest)
    }

    private fun calculateBmrMonths() {
        val apiRequest = ApiRequest().apply {
            /*current_weight = binding.editTextWeight.text.toString().trim()
            goal_weight = binding.editTextWeightGoal.text.toString().trim()
            height = binding.editTextHeight.text.toString().trim()*/
            current_weight = getWeightRequestParam()
            goal_weight = getGoalWeightRequestParam()
            height = getHeightRequestParam()
        }
        showLoader()
        goalReadingViewModel.calculateBmrMonths(apiRequest)
    }

    private fun calculateBmrCalories() {
        val apiRequest = ApiRequest().apply {
            /*current_weight = binding.editTextWeight.text.toString().trim()
            goal_weight = binding.editTextWeightGoal.text.toString().trim()
            height = binding.editTextHeight.text.toString().trim()*/
            current_weight = getWeightRequestParam()
            goal_weight = getGoalWeightRequestParam()
            height = getHeightRequestParam()

            height_unit = selectedHeightUnit.unitKey
            weight_unit = selectedWeightUnit.unitKey

            rate = selectedWeightGoalMonthsData?.rate
            type = selectedWeightGoalMonthsData?.type
            months = selectedWeightGoalMonthsData?.months
            activity_level = activityLevels[chooseActivityLevelAdapter.selectedPosition].activityKey
        }
        showLoader()
        goalReadingViewModel.calculateBmrCalories(apiRequest)
    }

    private fun checkBmrDisclaimer() {
        val apiRequest = ApiRequest().apply {
            current_weight = getWeightRequestParam()
            goal_weight = getGoalWeightRequestParam()
            height = getHeightRequestParam()
            rate = selectedWeightGoalMonthsData?.rate
            type = selectedWeightGoalMonthsData?.type
            months = selectedWeightGoalMonthsData?.months
            activity_level = activityLevels[chooseActivityLevelAdapter.selectedPosition].activityKey
        }

        //showLoader()
        goalReadingViewModel.checkBmrDisclaimer(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updatePatientHeightWeightLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            calculateBmrCalories()
            //showMessage(responseBody.message)
            analytics.logEvent(analytics.HEIGHT_WEIGHT_ADDED, screenName = AnalyticsScreenNames.SetHeightWeight)
        }, onError = { throwable ->
            hideLoader()
            true
        })

        authViewModel.getPatientDetailsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            setUserData()
        }, onError = { throwable ->
            hideLoader()
            false
        })

        goalReadingViewModel.calculateBmrMonthsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let { showBottomSheetSelection(it) }
        }, onError = { throwable ->
            hideLoader()
            false
        })

        goalReadingViewModel.calculateBmrCaloriesLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            if (activity is IsolatedFullActivity) {
                navigator.goBack()
            } else {
                //auth flow
                handleAuthNavigation()
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //checkBmrDisclaimerLiveData
        goalReadingViewModel.checkBmrDisclaimerLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            setDisclaimers(responseBody.data)
        }, onError = { throwable ->
            hideLoader()
            setDisclaimers(null)
            false
        })
    }

    private fun showBottomSheetSelection(list: ArrayList<WeightGoalMonthsData>) {
        BottomSheet<WeightGoalMonthsData>().showBottomSheetDialog(activity as BaseActivity,
            list,
            "",
            object : BottomSheetAdapter.ItemListener<WeightGoalMonthsData> {
                override fun onItemClick(item: WeightGoalMonthsData, position: Int) {
                    selectedWeightGoalMonthsData = item
                    binding.editTextWeightGoalDays.setText(item.months)
                    callCheckBmrDisclaimerAPI()
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<WeightGoalMonthsData>.MyViewHolder,
                    position: Int,
                    item: WeightGoalMonthsData,
                ) {
                    holder.textView.text = item.months
                }
            })
    }

    private fun setDisclaimers(bmrDisclaimerData: BmrDisclaimerData?) {
        with(binding) {
            textViewDisclaimerBMI.isVisible = bmrDisclaimerData?.bmi?.isNotBlank() ?: false
            textViewDisclaimerBMR.isVisible = bmrDisclaimerData?.calories?.isNotBlank() ?: false
            if (bmrDisclaimerData != null) {
                textViewDisclaimerBMI.text = bmrDisclaimerData.bmi
                textViewDisclaimerBMR.text = bmrDisclaimerData.calories
            } else {
                textViewDisclaimerBMI.text = ""
                textViewDisclaimerBMR.text = ""
            }
        }
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.TIME_SPENT_UPDATE_HEIGHT_WEIGHT, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.SetHeightWeight)*/
    }
}