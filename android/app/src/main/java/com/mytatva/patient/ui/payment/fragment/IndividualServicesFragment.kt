package com.mytatva.patient.ui.payment.fragment

import android.annotation.SuppressLint
import android.os.Bundle
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
import com.mytatva.patient.databinding.PaymentFragmentIndividiualServicesBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.IndividualServiceAdapter
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class IndividualServicesFragment : BaseFragment<PaymentFragmentIndividiualServicesBinding>() {

    private val servicesList = arrayListOf<PatientPlanData>()
    var resumedTime = Calendar.getInstance().timeInMillis
    private val individualServiceAdapter by lazy {
        IndividualServiceAdapter(servicesList,
            object : IndividualServiceAdapter.AdapterListener {
                override fun onBuyClick(position: Int, isClickOnBuyButton: Boolean) {
                    openDetails(position, isClickOnBuyButton)
                }
            })
    }

    private fun openDetails(position: Int, isClickOnBuyButton: Boolean) {
        navigator.loadActivity(IsolatedFullActivity::class.java,
            PaymentPlanDetailsFragment::class.java)
            .addBundle(bundleOf(
                Pair(Common.BundleKey.IS_INDIVIDUAL_PLAN, true),
                Pair(Common.BundleKey.PLAN_ID, servicesList[position].plan_master_id),
                Pair(Common.BundleKey.IS_CLICK_ON_BUY, isClickOnBuyButton)
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
    ): PaymentFragmentIndividiualServicesBinding {
        return PaymentFragmentIndividiualServicesBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        /*resumedTime = Calendar.getInstance().timeInMillis*/
        analytics.setScreenName(AnalyticsScreenNames.MyTatvaIndividualPlan)

        resetPagingData()
        plansList()
    }

    override fun bindData() {
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            recyclerViewServices.apply {
                layoutManager = linearLayoutManager
                adapter = individualServiceAdapter
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
//            //page = this@IndividualServicesFragment.page.toString()
//            plan_type = "I"
//        }
//        patientPlansViewModel.plansList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
//        patientPlansViewModel.plansListLiveData.observe(this,
//            onChange = { responseBody ->
//                hideLoader()
//                responseBody.data?.let { setPlanList(it) }
//                with(binding) {
//                    textViewNoData.visibility = View.GONE
//                    recyclerViewServices.visibility = View.VISIBLE
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
//                    servicesList.clear()
//                    individualServiceAdapter.notifyDataSetChanged()
//                }
//                page == 1*/
//            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setPlanList(mainList: ArrayList<PatientPlanMainData>) {
        servicesList.clear()

        //add user's active plans
        /*mainList.firstOrNull()?.plan_details?.let {
            val activePlans = arrayListOf<PatientPlanData>()
            activePlans.addAll(it.mapIndexed { index, patientPlanData ->
                if (index == 0) {
                    patientPlanData.headerTitle =
                        mainList.firstOrNull()?.title ?: ""
                }
                patientPlanData.isActivePlan = true
                patientPlanData
            })
            servicesList.addAll(activePlans)
        }
        //add all others plans
        if (mainList.size > 1) {
            mainList[1].plan_details?.let {
                val activePlans = arrayListOf<PatientPlanData>()
                activePlans.addAll(it.mapIndexed { index, patientPlanData ->
                    if (index == 0 && servicesList.isNotEmpty()) {
                        // show title only, if added active plans is not empty
                        patientPlanData.headerTitle = mainList[1].title ?: ""
                    }
                    patientPlanData.isActivePlan = false
                    patientPlanData
                })
                servicesList.addAll(it)
            }
        }*/

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
                servicesList.addAll(subPlanList)
            }

        }
        individualServiceAdapter.notifyDataSetChanged()
    }

}