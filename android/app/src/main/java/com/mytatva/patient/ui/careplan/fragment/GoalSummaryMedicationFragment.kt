package com.mytatva.patient.ui.careplan.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.ChartDurations
import com.mytatva.patient.data.pojo.response.ChartRecordData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.MedicationSummaryData
import com.mytatva.patient.databinding.CarePlanFragmentGoalSummaryMedicationBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.careplan.adapter.GoalSummaryMedicationAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor


class GoalSummaryMedicationFragment() :
    BaseFragment<CarePlanFragmentGoalSummaryMedicationBinding>() {

    lateinit var callbackOnUpdate: () -> Unit

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    val medicationSummaryList = arrayListOf<MedicationSummaryData>()

    /* private val medicationList = arrayListOf(
         TempDataModel(subList = arrayListOf(TempDataModel(), TempDataModel(),
             TempDataModel(), TempDataModel(), TempDataModel())),
         TempDataModel(subList = arrayListOf(TempDataModel(),
             TempDataModel(), TempDataModel(), TempDataModel(),
             TempDataModel(), TempDataModel(), TempDataModel(),
             TempDataModel())),
         TempDataModel(subList = arrayListOf(TempDataModel(), TempDataModel(), TempDataModel(),
             TempDataModel(), TempDataModel(), TempDataModel())),
         TempDataModel(subList = arrayListOf(TempDataModel(),
             TempDataModel(),
             TempDataModel(),
             TempDataModel()))
     )*/

    var chartDuration = ChartDurations.SEVEN_DAYS
    var goalReadingData: GoalReadingData? = null

    var chartRecordData: ChartRecordData? = null
    private val goalsChartData = arrayListOf<GoalReadingData>()

    private val goalSummaryMedicationAdapter by lazy {
        GoalSummaryMedicationAdapter(medicationSummaryList)
    }

    private val getAverageGoalLabel: String
        get() {
            return goalReadingData?.getStandardGoalLabel("") ?: ""
            //goalReadingData?.getGoalAverageLabel(requireContext()) ?: ""
        }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanFragmentGoalSummaryMedicationBinding {
        return CarePlanFragmentGoalSummaryMedicationBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        //analytics.setScreenName(AnalyticsScreenNames.GoalChart.plus(goalReadingData?.keys))
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()
        setHeaderData()
    }

    fun toggleLoader(isShow: Boolean) {
        if (isAdded && binding.progressBar != null) {
            binding.progressBar.isVisible = isShow && medicationSummaryList.isEmpty()
                    && binding.textViewNoData.isVisible.not()
            /*binding.textViewNoData.isVisible = binding.progressBar.isVisible.not()*/
        }
    }

    private fun setHeaderData() {
        with(binding) {
            goalReadingData?.let {
                val CHART_COLOR = goalReadingData?.color_code.parseAsColor()
                imageViewIcon.loadUrlIcon(it.image_url ?: "", false)
                textViewTitle.setTextColor(CHART_COLOR)
                textViewTitle.text = it.goal_name

                textViewAverageGoal.text = getAverageGoalLabel
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewMedication.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = goalSummaryMedicationAdapter
        }
    }

    private fun setViewListeners() {
        binding.apply {
            buttonUpdate.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonUpdate -> {
                callbackOnUpdate.invoke()
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun callAPI() {

    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {

    }

    @SuppressLint("NotifyDataSetChanged")
    fun setMedicationSummaryData(
        medicationSummaryList: List<MedicationSummaryData>?,
        throwable: Throwable? = null,
    ) {
        if (isAdded) {
            binding.progressBar.isVisible = false
            this.medicationSummaryList.clear()
            if (medicationSummaryList.isNullOrEmpty()) {
                binding.textViewNoData.visibility = View.VISIBLE
                if (throwable is ServerException) {
                    binding.textViewNoData.text = throwable.message
                } else {
                    throwable?.message?.let { showMessage(it) }
                }
            } else {
                binding.textViewNoData.visibility = View.GONE
                medicationSummaryList.let { this.medicationSummaryList.addAll(it) }
            }
            goalSummaryMedicationAdapter.notifyDataSetChanged()
        }
    }

}