package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.FoodInsightResData
import com.mytatva.patient.data.pojo.response.MacronutritionAnalysis
import com.mytatva.patient.databinding.GoalFragmentLogFoodSuccessBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.FoodCalorieConsumedAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class LogFoodSuccessFragment : BaseFragment<GoalFragmentLogFoodSuccessBinding>() {

    private val foodInsightResData: FoodInsightResData? by lazy {
        arguments?.getParcelable(Common.BundleKey.FOOD_INSIGHT_RES_DATA)
    }

    private val mealType: String by lazy {
        arguments?.getString(Common.BundleKey.MEAL_TYPE) ?: ""
    }

    private val calorieConsumedList = arrayListOf<MacronutritionAnalysis>()

    private val foodCalorieConsumedAdapter by lazy {
        FoodCalorieConsumedAdapter(calorieConsumedList)
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
    ): GoalFragmentLogFoodSuccessBinding {
        return GoalFragmentLogFoodSuccessBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogFoodSuccess)
    }

    override fun bindData() {
        foodInsightResData?.let {
            binding.textViewCalorieConsumed.text =
                "${it.total_calories_consume} of ${it.total_calories_required} Calories Consumed"
        }
        binding.textViewSuccessMessage.text =
            getString(R.string.log_food_success_label_well_done_on_logging_your).plus(" $mealType!")

        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonDone.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        calorieConsumedList.clear()
        foodInsightResData?.macronutrition_analysis?.let { calorieConsumedList.addAll(it) }

        binding.recyclerView.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = foodCalorieConsumedAdapter
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonDone -> {
                navigator.goBack()
            }
            R.id.imageViewClose -> {
                navigator.goBack()
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