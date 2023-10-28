package com.mytatva.patient.ui.payment.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.PatientPlanData
import com.mytatva.patient.data.pojo.response.PatientPlanMainData
import com.mytatva.patient.databinding.PaymentFragmentPaymentPlansBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.PaymentPlansAdapter
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class PaymentPlansFragment : BaseFragment<PaymentFragmentPaymentPlansBinding>() {

    companion object {
        var IS_TO_SCROLL_TO_OTHER_PLAN = false
    }

    private val plansList = arrayListOf<PatientPlanData>()
    var resumedTime = Calendar.getInstance().timeInMillis
    private val paymentPlansAdapter by lazy {
        PaymentPlansAdapter(plansList,
            object : PaymentPlansAdapter.AdapterListener {
                override fun onCardOptionsClick(
                    position: Int,
                    action: String,
                ) {
                    openDetails(position, action)
                }
            })
    }

    private fun openDetails(position: Int, action: String) {
        analytics.logEvent(analytics.USER_CLICKED_ON_SUBSCRIPTION_PAGE,
            Bundle().apply {
                putString(analytics.PARAM_PLAN_ID, plansList[position].plan_master_id)
                putString(analytics.PARAM_PLAN_TYPE, plansList[position].plan_type)
                putString(analytics.PARAM_PLAN_EXPIRY_DATE, plansList[position].plan_end_date?:"")
                putString(analytics.PARAM_ACTION, action)
            }, screenName = AnalyticsScreenNames.MyTatvaPlans)


        navigator.loadActivity(IsolatedFullActivity::class.java,
            PaymentPlanDetailsFragment::class.java)
            .addBundle(bundleOf(
                Pair(Common.BundleKey.IS_INDIVIDUAL_PLAN, false),
                Pair(Common.BundleKey.PLAN_ID, plansList[position].plan_master_id),
                Pair(Common.BundleKey.IS_CLICK_ON_BUY,
                    action == Common.AnalyticsEventActions.BUY || action == Common.AnalyticsEventActions.CANCEL)
            )).start()
    }


    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    //pagination paramas
    var page = 1
    internal var isLoading = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null

    fun resetPagingData() {
        isLoading = false
        page = 1
        previousTotal = 0
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentPaymentPlansBinding {
        return PaymentFragmentPaymentPlansBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        /*resumedTime = Calendar.getInstance().timeInMillis*/
        analytics.setScreenName(AnalyticsScreenNames.MyTatvaPlans)

        resetPagingData()
        plansList()
    }

    override fun bindData() {
        setUpRecyclerView()

        /*binding.textViewNoData.setOnClickListener {
            navigator.loadActivity(IsolatedFullActivity::class.java,
                PaymentPlanDetailsFragment::class.java).start()
        }*/
    }

    private fun setUpRecyclerView() {
        with(binding) {
            /*linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)*/
            recyclerViewServices.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = paymentPlansAdapter
            }

            /*recyclerViewServices.addOnScrollListener(object : RecyclerView.OnScrollListener() {
                override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {
                }

                override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                    //pagination
                    val visibleItemCount = recyclerView.childCount
                    val totalItemCount = linearLayoutManager!!.itemCount
                    val pastVisibleItems = linearLayoutManager!!.findFirstVisibleItemPosition()
                    if (isLoading) {
                        if (totalItemCount > previousTotal) {
                            isLoading = false
                            previousTotal = totalItemCount
                        }
                    }
                    if (!isLoading && totalItemCount - visibleItemCount <= pastVisibleItems + 0) {
                        // End has been reached
                        page++
                        plansList()
                        isLoading = true
                    }
                }
            })*/

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun plansList() {
//        val apiRequest = ApiRequest().apply {
//            //page = this@PaymentPlansFragment.page.toString()
//            plan_type = "S"
//        }
//        if (plansList.isEmpty()) {
//            showLoader()
//        }
//        patientPlansViewModel.plansList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
//        patientPlansViewModel.plansListLiveData.observe(this,
//            onChange = { responseBody ->
//                hideLoader()
//                if (isAdded) {
//                    with(binding) {
//                        textViewNoData.visibility = View.GONE
//                        recyclerViewServices.visibility = View.VISIBLE
//                    }
//                    responseBody.data?.let { setPlanList(it) }
//                }
//            },
//            onError = { throwable ->
//                hideLoader()
//                with(binding) {
//                    textViewNoData.visibility = View.VISIBLE
//                    recyclerViewServices.visibility = View.GONE
//                    textViewNoData.text = throwable.message
//                }
//                false
//                /*if (page == 1) {
//                    plansList.clear()
//                    paymentPlansAdapter.notifyDataSetChanged()
//                }
//                page == 1*/
//            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setPlanList(mainList: ArrayList<PatientPlanMainData>) {
        plansList.clear()

        //add user's active plans
        /* mainList.firstOrNull()?.plan_details?.let {
             val activePlans = arrayListOf<PatientPlanData>()
             activePlans.addAll(it.mapIndexed { index, patientPlanData ->
                 if (index == 0) {
                     patientPlanData.headerTitle =
                         mainList.firstOrNull()?.title ?: ""
                 }
                 patientPlanData.isActivePlan = true
                 patientPlanData
             })
             plansList.addAll(activePlans)
         }
         //add all others plans
         if (mainList.size > 1) {
             mainList[1].plan_details?.let {
                 val activePlans = arrayListOf<PatientPlanData>()
                 activePlans.addAll(it.mapIndexed { index, patientPlanData ->
                     if (index == 0 && plansList.isNotEmpty()) {
                         // show title only, if added active plans is not empty
                         patientPlanData.headerTitle = mainList[1].title ?: ""
                     }
                     patientPlanData.isActivePlan = false
                     patientPlanData
                 })
                 plansList.addAll(it)
             }
         }
         paymentPlansAdapter.notifyDataSetChanged()*/


        mainList.forEachIndexed { _, patientPlanMainData ->

            patientPlanMainData.plan_details?.let {
                val subPlanList = arrayListOf<PatientPlanData>()
                subPlanList.addAll(it.mapIndexed { index, patientPlanData ->
                    if (index == 0 /*&& mainList.size > 1*/) {
                        patientPlanData.headerTitle =
                            patientPlanMainData.title ?: ""
                    }
                    //patientPlanData.isActivePlan = true
                    patientPlanData.isActivePlan =
                        patientPlanMainData.title?.contains("My Plan", true) == true
                                || patientPlanMainData.title?.contains("Inactive", true) == true
                    patientPlanData
                })
                plansList.addAll(subPlanList)
            }

        }
        paymentPlansAdapter.notifyDataSetChanged()

        //handle scroll to other section
        if (IS_TO_SCROLL_TO_OTHER_PLAN) {
            IS_TO_SCROLL_TO_OTHER_PLAN = false
            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded) {

                    val otherDataPos = plansList.indexOfFirst { it.headerTitle.contains("Other") }
                    if (otherDataPos >= 0 && otherDataPos < plansList.size) {
                        (binding.recyclerViewServices.layoutManager as LinearLayoutManager?)
                            ?.scrollToPositionWithOffset(otherDataPos, 0)

                        /*val smoothScroller: RecyclerView.SmoothScroller =
                            object : LinearSmoothScroller(context) {
                                override fun getVerticalSnapPreference(): Int {
                                    return LinearSmoothScroller.SNAP_TO_START
                                }
                            }
                        smoothScroller.targetPosition = otherDataPos
                        binding.recyclerViewServices.layoutManager?.startSmoothScroll(smoothScroller)*/

                    }
                }
            }, 400)
        }
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

    /* override fun onPause() {
         super.onPause()
         updateScreenTimeDurationInAnalytics()
     }

     private fun updateScreenTimeDurationInAnalytics() {
         val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
         val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
         analytics.logEvent(analytics.TIME_SPENT_INCIDENT_HISTORY, Bundle().apply {
             putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
         })
     }*/
}