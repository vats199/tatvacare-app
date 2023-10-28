package com.mytatva.patient.ui.payment.fragment.v1

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
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpMainData
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.databinding.PaymentFragmentCareplanListingBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.PaymentCarePlanListingAdapter
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.enableShadow
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class PaymentCarePlanListingFragment : BaseFragment<PaymentFragmentCareplanListingBinding>() {

    companion object {
        var IS_TO_SCROLL_TO_OTHER_PLAN = false
    }

    private val plansList = arrayListOf<BcpPlanData>()
    private val paymentCarePlanListingAdapter by lazy {
        PaymentCarePlanListingAdapter(plansList,
            object : PaymentCarePlanListingAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    analytics.logEvent(
                        analytics.USER_TAPS_ON_CARE_PLAN_CARD,
                        Bundle().apply {
                            putString(analytics.PARAM_PLAN_ID, plansList[position].plan_master_id)
                            putString(analytics.PARAM_PLAN_TYPE, plansList[position].plan_type)
                            putString(analytics.PARAM_CARD_NUMBER, (position + 1).toString())
                        },
                        screenName = AnalyticsScreenNames.BcpList
                    )

                    if (plansList[position].plan_type == Common.MyTatvaPlanType.INDIVIDUAL
                        && plansList[position].patient_plan_rel_id.isNullOrBlank().not()
                    ) {
                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            BcpPurchasedDetailsFragment::class.java
                        ).addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.PATIENT_PLAN_REL_ID,
                                    plansList[position].patient_plan_rel_id
                                ),
                            )
                        ).start()
                    } else {
                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            PaymentPlanDetailsV1Fragment::class.java
                        ).addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.PLAN_ID, plansList[position].plan_master_id),
                                Pair(Common.BundleKey.PLAN_TYPE, plansList[position].plan_type),
                                Pair(
                                    Common.BundleKey.PATIENT_PLAN_REL_ID,
                                    plansList[position].patient_plan_rel_id
                                ),
                                Pair(Common.BundleKey.ENABLE_RENT_BUY, plansList[position].enable_rent_buy),
                            )
                        ).start()
                    }
                }
            })
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentCareplanListingBinding {
        return PaymentFragmentCareplanListingBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpList)
        plansList()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text = getString(R.string.payment_care_plan_listing_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewCarePlanListing.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = paymentCarePlanListingAdapter
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun plansList() {
        val apiRequest = ApiRequest().apply {
            //page = this@PaymentPlansFragment.page.toString()
            //plan_type = "I"
        }
        if (plansList.isEmpty()) {
            showLoader()
        }
        patientPlansViewModel.plansList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        patientPlansViewModel.plansListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (isAdded) {
                    with(binding) {
                        /*textViewNoData.visibility = View.GONE
                        recyclerViewServices.visibility = View.VISIBLE*/
                    }
                    responseBody.data?.let { setPlanList(it) }
                }
            },
            onError = { throwable ->
                hideLoader()
                with(binding) {
                    /*textViewNoData.visibility = View.VISIBLE
                    recyclerViewServices.visibility = View.GONE
                    textViewNoData.text = throwable.message*/
                }
                false
                /*if (page == 1) {
                    plansList.clear()
                    paymentPlansAdapter.notifyDataSetChanged()
                }
                page == 1*/
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

    @SuppressLint("NotifyDataSetChanged")
    private fun setPlanList(mainList: java.util.ArrayList<BcpMainData>) {
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

            patientPlanMainData.plans?.let {
                val subPlanList = arrayListOf<BcpPlanData>()
                subPlanList.addAll(it.mapIndexed { index, bcpPlanData ->
                    if (index == 0 /*&& mainList.size > 1*/) {
                        bcpPlanData.headerTitle =
                            patientPlanMainData.title ?: ""
                    }

                    /*bcpPlanData.isActivePlan =
                        patientPlanMainData.title?.contains("My Plan", true) == true
                                || patientPlanMainData.title?.contains("Inactive", true) == true*/

                    //set active flag as per key now instead of title in BCP, as keys is introduced from backend as,
                    //current_plan, inactive_plans & all_plans
                    bcpPlanData.isActivePlan =
                        patientPlanMainData.key?.contains("current_plan", true) == true
                                || patientPlanMainData.key?.contains("inactive_plans", true) == true

                    bcpPlanData
                })
                plansList.addAll(subPlanList)
            }

        }
        // when no any plan purchased
        paymentCarePlanListingAdapter.isToHideHeaders = mainList.firstOrNull { it.key=="current_plan" }?.plans.isNullOrEmpty()
        paymentCarePlanListingAdapter.notifyDataSetChanged()

        //handle scroll to other section
        if (IS_TO_SCROLL_TO_OTHER_PLAN) {
            IS_TO_SCROLL_TO_OTHER_PLAN = false
            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded) {

                    val otherDataPos = plansList.indexOfFirst { it.headerTitle.contains("All") }
                    if (otherDataPos >= 0 && otherDataPos < plansList.size) {
                        (binding.recyclerViewCarePlanListing.layoutManager as LinearLayoutManager?)
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


}