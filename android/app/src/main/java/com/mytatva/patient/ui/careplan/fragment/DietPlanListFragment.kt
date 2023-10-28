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
import com.mytatva.patient.data.model.*
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.databinding.CarePlanFragmentDietPlanListBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.careplan.adapter.*
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.apputils.PlanFeatureHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import kotlinx.coroutines.*

class DietPlanListFragment : BaseFragment<CarePlanFragmentDietPlanListBinding>() {

    //pagination paramas
    var page = 1

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    var linearLayoutManager: LinearLayoutManager? = null

    var isLastPage: Boolean = false
    internal var isLoading = false

    //diet plans
    private val dietPlanList = arrayListOf<Diet>()
    private val carePlanDietPlanAdapter by lazy {
        CarePlanDietPlanAdapter(dietPlanList, object : CarePlanDietPlanAdapter.AdapterListener {
            override fun onDownloadClick(position: Int, diet: Diet) {
                analytics.logEvent(analytics.USER_CLICKED_ON_DIET_PLAN_CARD,
                    Bundle().apply {
                        putString(analytics.PARAM_DIET_START_DATE, diet.start_date)
                        putString(analytics.PARAM_DIET_END_DATE, diet.valid_till)
                        putString(analytics.PARAM_FEATURE_STATUS, PlanFeatureHandler.FeatureStatus.ACTIVE)
                    }, screenName = AnalyticsScreenNames.CarePlan)


                analytics.logEvent(analytics.DIET_PLAN_DOWNLOAD,
                    Bundle().apply {
                        putString(analytics.PARAM_DIET_START_DATE, diet.start_date)
                        putString(analytics.PARAM_DIET_END_DATE, diet.valid_till)
                    }, screenName = AnalyticsScreenNames.CarePlan)

                if (diet.document_url.isNullOrBlank().not()
                    && diet.document_name.isNullOrBlank().not()
                ) {

                    val fileName = if (diet.file_name.isNullOrBlank())
                        diet.document_title + diet.document_name
                    else
                        diet.file_name

                    downloadHelper.startDownload(diet.document_url!!, fileName,
                        downloadHelper.DIR_DIET_PLAN)
                }
            }
        })
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanFragmentDietPlanListBinding {
        return CarePlanFragmentDietPlanListBinding.inflate(inflater, container, attachToRoot)
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Diet Plan"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }
    override fun bindData() {
        setUpToolbar()
        setUpPrescriptionMedication()
        dietPlanList()
    }

    private fun dietPlanList() {
        val apiRequest = ApiRequest().apply {
            page = this@DietPlanListFragment.page.toString()
        }
        goalReadingViewModel.dietPlanList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //dietPlanListLiveData
        goalReadingViewModel.dietPlanListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            isLoading = false
            setDietPlanData(responseBody.data ?: arrayListOf())
        }, onError = { throwable ->
            isLoading = false
            isLastPage = true
            hideLoader()
            if (page == 1) {
                setDietPlanData(arrayListOf(), throwable.message ?: "")
            }
            false
        })
    }
    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    private fun setUpPrescriptionMedication() {
        with(binding) {
            linearLayoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewDietPlan.apply {
                layoutManager = linearLayoutManager
                adapter = carePlanDietPlanAdapter
            }
            recyclerViewDietPlan.addOnScrollListener(object :
                PaginationScrollListener(linearLayoutManager!!) {
                override fun isLastPage(): Boolean {
                    return isLastPage
                }

                override fun isLoading(): Boolean {
                    return isLoading
                }

                override fun loadMoreItems() {
                    isLoading = true
                    //you have to call load more items to get more data
                    page++
                    dietPlanList()
                }

                override fun isScrolledDown(isScrolledDown: Boolean) {

                }
            })
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setDietPlanData(dietPlanListData: java.util.ArrayList<Diet>, msg: String? = null) {
        with(binding) {
            if (msg.isNullOrBlank().not()) {
                textViewNoDietPlan.isVisible = true
                recyclerViewDietPlan.isVisible = false

                textViewNoDietPlan.text = msg

            } else {
                textViewNoDietPlan.isVisible = false
                recyclerViewDietPlan.isVisible = true
                if(page==1) {
                    dietPlanList.clear()
                }
                dietPlanListData.let { dietPlanList.addAll(it) }
                carePlanDietPlanAdapter.notifyDataSetChanged()
            }
        }
    }
}