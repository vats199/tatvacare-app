package com.mytatva.patient.ui.menu.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.PaymentHistoryData
import com.mytatva.patient.data.pojo.response.PaymentHistorySubData
import com.mytatva.patient.databinding.MenuFragmentHistoryPaymentBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.HistoryPaymentAdapter
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class HistoryPaymentFragment : BaseFragment<MenuFragmentHistoryPaymentBinding>() {

    private val paymentList = arrayListOf<PaymentHistorySubData>()
    private val historyPaymentAdapter by lazy {
        HistoryPaymentAdapter(paymentList,
            object : HistoryPaymentAdapter.AdapterListener {
                override fun onGetInvoiceClick(position: Int) {
                    downloadInvoice(paymentList[position])
                }
            })
    }

    private fun downloadInvoice(paymentHistoryData: PaymentHistorySubData) {
        paymentHistoryData.invoice_url?.let {
            downloadHelper.startDownload(it,
                downloadHelper.getFileNameForInvoice(),
                downloadHelper.DIR_INVOICE)
        }
    }

    private val labTestPaymentList = arrayListOf<PaymentHistorySubData>()
    private val historyLabtestPaymentAdapter by lazy {
        HistoryPaymentAdapter(labTestPaymentList,
            object : HistoryPaymentAdapter.AdapterListener {
                override fun onGetInvoiceClick(position: Int) {
                    downloadInvoice(labTestPaymentList[position])
                }
            })
    }

    private var patientPlansViewModel: PatientPlansViewModel? = null

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
    ): MenuFragmentHistoryPaymentBinding {
        return MenuFragmentHistoryPaymentBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        patientPlansViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        Log.d("History", "::payment")
        analytics.setScreenName(AnalyticsScreenNames.HistoryPayment)
        resetPagingData()
        paymentHistory()
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewViewAllMyTatvaPlans.setOnClickListener { onViewClick(it) }
            textViewViewAllDiagnosticTest.setOnClickListener { onViewClick(it) }
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                paymentHistory()
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            /*linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)*/
            recyclerViewPaymentHistoryPlans.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = historyPaymentAdapter
            }

            recyclerViewPaymentHistoryTest.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = historyLabtestPaymentAdapter
            }

            /*recyclerViewPayment.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                        paymentHistory()
                        isLoading = true
                    }
                }
            })*/
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewViewAllMyTatvaPlans -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    HistoryViewAllPaymentFragment::class.java)
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.TYPE, Common.PaymentHistoryType.PLAN)
                        putString(Common.BundleKey.TITLE, "MyTatva Plans")
                    }).start()
            }
            R.id.textViewViewAllDiagnosticTest -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    HistoryViewAllPaymentFragment::class.java)
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.TYPE, Common.PaymentHistoryType.TEST)
                        putString(Common.BundleKey.TITLE, "Diagnostic Test")
                    }).start()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun paymentHistory() {
        val apiRequest = ApiRequest().apply {
            //page = this@HistoryPaymentFragment.page.toString()
        }
        /*if (page == 1) {
            binding.swipeRefreshLayout.isRefreshing = true
            isLoading = true
            paymentList.clear()
        }*/
        binding.swipeRefreshLayout.isRefreshing = true
        patientPlansViewModel?.paymentHistory(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        patientPlansViewModel?.paymentHistoryLiveData?.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                /*with(binding) {
                    recyclerViewPaymentHistoryPlans.visibility = View.VISIBLE
                    textViewNoData.visibility = View.GONE
                }
                if (page == 1) {
                    paymentList.clear()
                }*/

                setData(responseBody.data)


            },
            onError = { throwable ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                setData(null, throwable.message ?:"")
                /*if (page == 1) {
                    binding.swipeRefreshLayout.isRefreshing = false
                    with(binding) {
                        recyclerViewPaymentHistoryPlans.visibility = View.GONE
                        textViewNoData.visibility = View.VISIBLE
                        textViewNoData.text = throwable.message
                    }

                    paymentList.clear()
                    historyPaymentAdapter.notifyDataSetChanged()
                }*/
                false
            })
    }


    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setData(paymentHistoryData: PaymentHistoryData?, msg: String = "") {
        paymentList.clear()
        paymentHistoryData?.plan_payment?.let {
            paymentList.addAll(it.filter { data ->
                data.type = Common.PaymentHistoryType.PLAN
                true
            })
        }
        historyPaymentAdapter.notifyDataSetChanged()

        labTestPaymentList.clear()
        paymentHistoryData?.test_payment?.let {
            labTestPaymentList.addAll(it.filter { data ->
                data.type = Common.PaymentHistoryType.TEST
                true
            })
        }
        historyLabtestPaymentAdapter.notifyDataSetChanged()

        with(binding) {
            if (paymentList.isEmpty() && labTestPaymentList.isEmpty()) {
                groupPlan.isVisible = false
                groupTest.isVisible = false
                textViewNoData.isVisible = true
                textViewNoData.text = msg
            } else {
                textViewNoData.isVisible = false
                groupPlan.isVisible = paymentList.isNotEmpty()
                groupTest.isVisible = labTestPaymentList.isNotEmpty()
            }
        }

    }
}