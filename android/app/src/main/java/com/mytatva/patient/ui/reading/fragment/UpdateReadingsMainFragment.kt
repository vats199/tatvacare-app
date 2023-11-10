package com.mytatva.patient.ui.reading.fragment

import android.content.res.ColorStateList
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatTextView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingCommonLayoutHeaderBinding
import com.mytatva.patient.databinding.ReadingCommonLayoutSyncDataBinding
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingMainBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.BlankFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.profile.fragment.MyDeviceDetailsFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.googlefit.GoogleFit
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class UpdateReadingsMainFragment : BaseFragment<ReadingFragmentUpdateReadingMainBinding>() {

    companion object {
        /**
         * setUpHeader - to set data in all popup screens header
         * @param goalReadingData - specific goal data
         * @param layoutHeader - header view reference
         */
        fun setUpHeaderAndCommonUI(
            goalReadingData: GoalReadingData,
            layoutHeader: ReadingCommonLayoutHeaderBinding,
            textViewStandardValue: AppCompatTextView,
        ) {
            layoutHeader.apply {
                goalReadingData.let {
                    imageViewIcon.loadUrlIcon(it.image_url ?: "", false)
                    imageViewIcon.imageTintList =
                        ColorStateList.valueOf(it.color_code.parseAsColor())
                    imageViewIcon.backgroundTintList =
                        ColorStateList.valueOf(it.background_color.parseAsColor())
                    textViewTitle.text = it.reading_name
                    textViewStandardValue.text = it.getStandardReadingLabel("")
                }
            }
        }

        fun setUpSyncDataLayout(
            layout: ReadingCommonLayoutSyncDataBinding,
            hasAllPermissions: Boolean,
            googleFit: GoogleFit,
            baseActivity: BaseActivity,
        ) {
            layout.apply {
                if (hasAllPermissions) {
                    textViewConnectMsg.text = "Connected"
                } else {
                    textViewConnectMsg.text = "Connect to Google Fit to start syncing data"
                }

                textViewConnectMsg.setOnClickListener {
                    /*if (googleFit.hasAllPermissions.not()) {
                        googleFit.initializeFit {
                            baseActivity.updateReadingsGoals(isCalledOnPermissionApproved = true)
                        }
                    } else {
                        googleFit.disconnectWithAlert {
                            if (it) {
                                textViewConnectMsg.text = "Connect to Google Fit to start syncing data"
                            }
                        }
                    }*/
                    baseActivity.loadActivity(
                        IsolatedFullActivity::class.java,
                        MyDeviceDetailsFragment::class.java
                    )
                        .start()
                }
            }
        }
    }

    var currentPosition = 0
    private val readingsList = arrayListOf<GoalReadingData>()

    private val callback: ((shouldGoNext: Boolean) -> Unit) = { shouldGoNext ->
        if (shouldGoNext) {
            // if shouldGoNext is true then open next popup else exit
            if (binding.viewPager.currentItem < viewPagerAdapter?.count!! - 1) {
                binding.viewPager.currentItem = binding.viewPager.currentItem + 1
            } else {
                navigator.goBack()
            }
        } else {
            navigator.goBack()
        }
    }

    private var viewPagerAdapter: ViewPagerAdapter? = null


    private val updateReadingSPO2Fragment = UpdateReadingCommonFragment().apply {
        reading = Readings.SPO2
        callbackOnClose = callback
    }
    private val updateReadingFEV1Fragment = UpdateReadingCommonFragment().apply {
        reading = Readings.FEV1
        callbackOnClose = callback
    }
    private val updateReadingPEFFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.PEF
        callbackOnClose = callback
    }
    private val updateReadingHeartRateFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.HeartRate
        callbackOnClose = callback
    }
    private val updateReadingBodyWeightFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.BodyWeight
        callbackOnClose = callback
    }
    private val updateReadingHbA1cFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.HbA1c
        callbackOnClose = callback
    }
    private val updateReadingACRFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.ACR
        callbackOnClose = callback
    }
    private val updateReadingEgfrFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.eGFR
        callbackOnClose = callback
    }
    private val updateReadingBloodPressureFragment = UpdateReadingBloodPressureFragment().apply {
        callbackOnClose = callback
    }
    private val updateReadingBloodGlucoseFragment = UpdateReadingBloodGlucoseFragment().apply {
        callbackOnClose = callback
    }
    private val updateReadingBMIFragment = UpdateReadingBMIFragment().apply {
        callbackOnClose = callback
    }
    private val updateReadingWalkTestFragment = UpdateReadingWalkTestFragment().apply {
        callbackOnClose = callback
    }

    // added new readings
    private val updateReadingFibroScanFragment = UpdateReadingFibroScanFragment().apply {
        callbackOnClose = callback
    }
    private val updateReadingFIB4ScoreFragment = UpdateReadingFibScoreFragment().apply {
        callbackOnClose = callback
    }
    private val updateReadingTotalCholesterolFragment =
        UpdateReadingTotalCholesterolFragment().apply {
            callbackOnClose = callback
        }
    private val updateReadingSgotFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.SGOT_AST
        callbackOnClose = callback
    }
    private val updateReadingSgptFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.SGPT_ALT
        callbackOnClose = callback
    }
    private val updateReadingTriglyceridesFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.Triglycerides
        callbackOnClose = callback
    }
    private val updateReadingLdlCholesterolFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.LDL_CHOLESTEROL
        callbackOnClose = callback
    }
    private val updateReadingHdlCholesterolFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.HDL_CHOLESTEROL
        callbackOnClose = callback
    }
    private val updateReadingWaistCircumferenceFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.WaistCircumference
        callbackOnClose = callback
    }
    private val updateReadingPlateletCountFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.PlateletCount
        callbackOnClose = callback
    }

    // new added - Sprint April1 2023
    private val updateReadingSerumCreatinineFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.SerumCreatinine
        callbackOnClose = callback
    }
    private val updateReadingFattyLiverUsgGradeFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.FattyLiverUSGGrade
        callbackOnClose = callback
    }

    // new added - Sprint April2 2023
    private val updateReadingRandomBloodGlucoseFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.RandomBloodGlucose
        callbackOnClose = callback
    }

    // BCA device added readings
    private val updateReadingBodyFatFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.BodyFat
        callbackOnClose = callback
    }
    private val updateReadingHydrationFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.Hydration
        callbackOnClose = callback
    }
    private val updateReadingMuscleMassFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.MuscleMass
        callbackOnClose = callback
    }
    private val updateReadingProteinFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.Protein
        callbackOnClose = callback
    }
    private val updateReadingBoneMassFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.BoneMass
        callbackOnClose = callback
    }
    private val updateReadingVisceralFatFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.VisceralFat
        callbackOnClose = callback
    }
    private val updateReadingBasalMetabolicRateFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.BasalMetabolicRate
        callbackOnClose = callback
    }
    private val updateReadingMetabolicAgeFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.MetabolicAge
        callbackOnClose = callback
    }
    private val updateReadingSubcutaneousFatFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.SubcutaneousFat
        callbackOnClose = callback
    }
    private val updateReadingSkeletalMuscleFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.SkeletalMuscle
        callbackOnClose = callback
    }

    // Spirometer added readings
    private val updateReadingFvcFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.FVC
        callbackOnClose = callback
    }
    private val updateReadingFevFvcRatioFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.FEV1FVC_RATIO
        callbackOnClose = callback
    }
    private val updateReadingAqiFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.AQI
        callbackOnClose = callback
    }
    private val updateReadingHumidityFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.HUMIDITY
        callbackOnClose = callback
    }
    private val updateReadingTemperatureFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.TEMPERATURE
        callbackOnClose = callback
    }
    private val updateReadingCaloriesBurnedFragment = UpdateReadingCommonFragment().apply {
        reading = Readings.CaloriesBurned
        callbackOnClose = callback
    }
    private val updateReadingSedentaryTimeFragment = UpdateReadingSedentaryTimeFragment().apply {
        callbackOnClose = callback
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ReadingFragmentUpdateReadingMainBinding {
        return ReadingFragmentUpdateReadingMainBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        getArgumentsData()
        setUpViewPager()
        setViewListeners()
    }

    private fun getArgumentsData() {
        arguments?.let {
            currentPosition = it.getInt(Common.BundleKey.POSITION)
            readingsList.clear()
            it.getParcelableArrayList<GoalReadingData>(Common.BundleKey.READING_LIST)?.let { it1 ->
                readingsList.addAll(it1)
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
            addFragmentsAsPerReadingsList()
            viewPager.adapter = viewPagerAdapter
            viewPager.offscreenPageLimit = 2//readingsList.size
            viewPager.pageMargin = resources.getDimension(R.dimen.dp_30).toInt()
            viewPager.currentItem = currentPosition
        }

        analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_INSIGHTS,
            Bundle().apply {
                putString(
                    analytics.PARAM_HEALTH_MARKER_NAME,
                    readingsList[currentPosition].reading_name
                )
                putString(
                    analytics.PARAM_HEALTH_MARKER_COLOUR,
                    readingsList[currentPosition].color_code
                )
                putString(
                    analytics.PARAM_HEALTH_MARKER_VALUE,
                    readingsList[currentPosition].reading_value
                )
            }
        )

        analytics.setScreenName(AnalyticsScreenNames.LogReading.plus(readingsList[currentPosition].keys))
    }

    private fun addFragmentsAsPerReadingsList() {
        // add popup screens as per goals list and set goal data to specific page
        readingsList.forEach {
            when (it.keys) {
                Readings.SPO2.readingKey -> {
                    updateReadingSPO2Fragment.goalReadingData = it

                    viewPagerAdapter?.addFrag(updateReadingSPO2Fragment)
                }

                Readings.FEV1.readingKey -> {
                    updateReadingFEV1Fragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingFEV1Fragment)
                }

                Readings.PEF.readingKey -> {
                    updateReadingPEFFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingPEFFragment)
                }

                Readings.BloodPressure.readingKey -> {
                    updateReadingBloodPressureFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBloodPressureFragment)
                }

                Readings.HeartRate.readingKey -> {
                    updateReadingHeartRateFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingHeartRateFragment)
                }

                Readings.BodyWeight.readingKey -> {
                    updateReadingBodyWeightFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBodyWeightFragment)
                }

                Readings.BMI.readingKey -> {
                    updateReadingBMIFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBMIFragment)
                }

                Readings.BloodGlucose.readingKey -> {
                    updateReadingBloodGlucoseFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBloodGlucoseFragment)
                }

                Readings.HbA1c.readingKey -> {
                    updateReadingHbA1cFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingHbA1cFragment)
                }

                Readings.ACR.readingKey -> {
                    updateReadingACRFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingACRFragment)
                }

                Readings.eGFR.readingKey -> {
                    updateReadingEgfrFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingEgfrFragment)
                }

                Readings.SIX_MIN_WALK.readingKey -> {
                    updateReadingWalkTestFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingWalkTestFragment)
                }
                // pass empty CAT to handle position
                Readings.CAT.readingKey -> {
                    viewPagerAdapter?.addFrag(BlankFragment())
                }
                // new added readings
                Readings.FibroScan.readingKey -> {
                    updateReadingFibroScanFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingFibroScanFragment)
                }

                Readings.FIB4Score.readingKey -> {
                    updateReadingFIB4ScoreFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingFIB4ScoreFragment)
                }

                Readings.TotalCholesterol.readingKey -> {
                    updateReadingTotalCholesterolFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingTotalCholesterolFragment)
                }

                Readings.SGOT_AST.readingKey -> {
                    updateReadingSgotFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingSgotFragment)
                }

                Readings.SGPT_ALT.readingKey -> {
                    updateReadingSgptFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingSgptFragment)
                }

                Readings.Triglycerides.readingKey -> {
                    updateReadingTriglyceridesFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingTriglyceridesFragment)
                }

                Readings.LDL_CHOLESTEROL.readingKey -> {
                    updateReadingLdlCholesterolFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingLdlCholesterolFragment)
                }

                Readings.HDL_CHOLESTEROL.readingKey -> {
                    updateReadingHdlCholesterolFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingHdlCholesterolFragment)
                }

                Readings.WaistCircumference.readingKey -> {
                    updateReadingWaistCircumferenceFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingWaistCircumferenceFragment)
                }

                Readings.PlateletCount.readingKey -> {
                    updateReadingPlateletCountFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingPlateletCountFragment)
                }
                //
                Readings.SerumCreatinine.readingKey -> {
                    updateReadingSerumCreatinineFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingSerumCreatinineFragment)
                }

                Readings.FattyLiverUSGGrade.readingKey -> {
                    updateReadingFattyLiverUsgGradeFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingFattyLiverUsgGradeFragment)
                }
                //
                Readings.RandomBloodGlucose.readingKey -> {
                    updateReadingRandomBloodGlucoseFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingRandomBloodGlucoseFragment)
                }

                // BCA device added readings
                Readings.BodyFat.readingKey -> {
                    updateReadingBodyFatFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBodyFatFragment)
                }

                Readings.Hydration.readingKey -> {
                    updateReadingHydrationFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingHydrationFragment)
                }

                Readings.MuscleMass.readingKey -> {
                    updateReadingMuscleMassFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingMuscleMassFragment)
                }

                Readings.Protein.readingKey -> {
                    updateReadingProteinFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingProteinFragment)
                }

                Readings.BoneMass.readingKey -> {
                    updateReadingBoneMassFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBoneMassFragment)
                }

                Readings.VisceralFat.readingKey -> {
                    updateReadingVisceralFatFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingVisceralFatFragment)
                }

                Readings.BasalMetabolicRate.readingKey -> {
                    updateReadingBasalMetabolicRateFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingBasalMetabolicRateFragment)
                }

                Readings.MetabolicAge.readingKey -> {
                    updateReadingMetabolicAgeFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingMetabolicAgeFragment)
                }

                Readings.SubcutaneousFat.readingKey -> {
                    updateReadingSubcutaneousFatFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingSubcutaneousFatFragment)
                }

                Readings.SkeletalMuscle.readingKey -> {
                    updateReadingSkeletalMuscleFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingSkeletalMuscleFragment)
                }

                // Spirometer added readings
                Readings.FVC.readingKey -> {
                    updateReadingFvcFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingFvcFragment)
                }

                Readings.FEV1FVC_RATIO.readingKey -> {
                    updateReadingFevFvcRatioFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingFevFvcRatioFragment)
                }

                Readings.AQI.readingKey -> {
                    updateReadingAqiFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingAqiFragment)
                }

                Readings.HUMIDITY.readingKey -> {
                    updateReadingHumidityFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingHumidityFragment)
                }

                Readings.TEMPERATURE.readingKey -> {
                    updateReadingTemperatureFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingTemperatureFragment)
                }

                Readings.CaloriesBurned.readingKey -> {
                    updateReadingCaloriesBurnedFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingCaloriesBurnedFragment)
                }

                Readings.SedentaryTime.readingKey -> {
                    updateReadingSedentaryTimeFragment.goalReadingData = it
                    viewPagerAdapter?.addFrag(updateReadingSedentaryTimeFragment)
                }

                else -> {
                    // to handle custom added widgets in list
                    viewPagerAdapter?.addFrag(BlankFragment())
                }
            }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewPrev.setOnClickListener { onViewClick(it) }
            imageViewNext.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewPrev -> {
                with(binding) {
                    if (viewPager.currentItem > 0) {
                        viewPager.currentItem = viewPager.currentItem - 1
                    }
                }
            }

            R.id.imageViewNext -> {
                with(binding) {
                    if (viewPager.currentItem < viewPagerAdapter?.count?.minus(1) ?: 0) {
                        viewPager.currentItem = viewPager.currentItem + 1
                    } else {
                        navigator.goBack()
                    }
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {

    }

}