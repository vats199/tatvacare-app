package com.mytatva.patient.ui.auth.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.AuthFragmentSelectGoalsReadingsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.auth.adapter.SelectGoalsReadingsAdapter
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.SafeClickListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class SelectGoalsReadingsFragment : BaseFragment<AuthFragmentSelectGoalsReadingsBinding>() {

    private val isGoal by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_GOAL) ?: false
    }
    var resumedTime = Calendar.getInstance().timeInMillis

    // already selected goals and readings
    private val selectedGoalList: ArrayList<GoalReadingData> by lazy {
        arguments?.getParcelableArrayList(Common.BundleKey.SELECTED_GOAL) ?: arrayListOf()
    }
    private val selectedReadingList: ArrayList<GoalReadingData> by lazy {
        arguments?.getParcelableArrayList(Common.BundleKey.SELECTED_READING) ?: arrayListOf()
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val goalsReadingList = arrayListOf<GoalReadingData>()

    private val selectGoalsReadingsAdapter by lazy {
        SelectGoalsReadingsAdapter(analytics, goalsReadingList)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSelectGoalsReadingsBinding {
        return AuthFragmentSelectGoalsReadingsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        resumedTime = Calendar.getInstance().timeInMillis
        if (isGoal) {
            analytics.setScreenName(AnalyticsScreenNames.SelectGoals)
        } else {
            analytics.setScreenName(AnalyticsScreenNames.SelectReadings)
        }
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()

        if (isGoal) {
            callGoalList()
        } else {
            callReadingList()
        }
    }

    private fun setUpRecyclerView() {
        selectGoalsReadingsAdapter.isGoal = isGoal
        binding.recyclerViewGoals.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = selectGoalsReadingsAdapter
        }
    }

    private fun setViewListeners() {
        binding.apply {
            layoutHeader.apply {
                textViewToolbarTitle.text =
                    if (isGoal) getString(R.string.select_goal_reading_title_goal)
                    else getString(R.string.select_goal_reading_title_reading)
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }
            //buttonSubmit.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener(SafeClickListener { onViewClick(it) })
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonSubmit -> {
                val intent = Intent()
                /*val arrayList = goalsReadingList.filter { it.isSelected }.toList() as ArrayList*/
                if (isGoal) {
                    intent.putExtra(
                        Common.BundleKey.SELECTED_GOAL,
                        /*goalsReadingList[selectGoalsReadingsAdapter.selectedPos]*/
                        ArrayList(goalsReadingList.filter { it.isSelected }.toList()
                            .map {
                                it.isSelected = false
                                it
                            })
                    )
                } else {
                    intent.putExtra(
                        Common.BundleKey.SELECTED_READING,
                        /*goalsReadingList[selectGoalsReadingsAdapter.selectedPos]*/
                        ArrayList(goalsReadingList.filter { it.isSelected }.toList()
                            .map {
                                it.isSelected = false
                                it
                            })
                    )
                }
                requireActivity().setResult(Activity.RESULT_OK, intent)
                requireActivity().finish()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun callGoalList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel.goalList(apiRequest)
    }

    private fun callReadingList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel.readingList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.goalListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                goalsReadingList.clear()
                responseBody.data?.let { goalsReadingList.addAll(it) }

                // set selected if already in selected list
                /*if (selectedGoalList.isNotEmpty()) {*/
                goalsReadingList.forEachIndexed { index, goalReadingData ->
                    goalsReadingList[index].isSelected =
                        selectedGoalList.any { it.goal_master_id == goalReadingData.goal_master_id }
                                || goalsReadingList[index].mandatory == "Y"

                    // set goal_value if updated from already selected list
                    if (selectedGoalList.any { it.goal_master_id == goalReadingData.goal_master_id }) {
                        goalsReadingList[index].goal_value =
                            selectedGoalList.first { it.goal_master_id == goalReadingData.goal_master_id }.goal_value
                    }
                }
                /*}*/

                selectGoalsReadingsAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.readingListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                goalsReadingList.clear()
                responseBody.data?.let { goalsReadingList.addAll(it) }

                // set selected if already in selected list
                /*if (selectedReadingList.isNotEmpty()) {*/
                goalsReadingList.forEachIndexed { index, goalReadingData ->
                    goalsReadingList[index].isSelected =
                        selectedReadingList.any { it.readings_master_id == goalReadingData.readings_master_id }
                                || goalsReadingList[index].mandatory == "Y"
                }
                /*}*/

                selectGoalsReadingsAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(
            if (isGoal) analytics.TIME_SPENT_ADD_GOALS else analytics.TIME_SPENT_ADD_READINGS,
            Bundle().apply {
                putString(
                    analytics.PARAM_DURATION_SECOND,
                    diffInSec.toString()
                )
            },
            screenName = if (isGoal) AnalyticsScreenNames.SelectGoals
            else AnalyticsScreenNames.SelectReadings
        )
    }
}