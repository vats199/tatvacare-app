package com.mytatva.patient.ui.menu.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.PaymentHistorySubData
import com.mytatva.patient.databinding.MenuFragmentHistoryViewAllPaymentBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.HistoryPaymentAdapter
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class HistoryViewAllPaymentFragment : BaseFragment<MenuFragmentHistoryViewAllPaymentBinding>() {

    val type by lazy {
        arguments?.getString(Common.BundleKey.TYPE)
    }

    val title by lazy {
        arguments?.getString(Common.BundleKey.TITLE)
    }

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
    ): MenuFragmentHistoryViewAllPaymentBinding {
        return MenuFragmentHistoryViewAllPaymentBinding.inflate(inflater, container, attachToRoot)
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
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = title ?: ""
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {

            /*swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                paymentHistory()
            }*/
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            recyclerViewHistoryPayment.apply {
                layoutManager = linearLayoutManager
                adapter = historyPaymentAdapter
            }

            recyclerViewHistoryPayment.addOnScrollListener(object :
                RecyclerView.OnScrollListener() {
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
            })
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack->{
                navigator.goBack()
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
            page = this@HistoryViewAllPaymentFragment.page.toString()
            type = this@HistoryViewAllPaymentFragment.type
        }
        if (page == 1) {
            //binding.swipeRefreshLayout.isRefreshing = true
            isLoading = true
            paymentList.clear()
        }
        patientPlansViewModel?.allPaymentHistory(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        patientPlansViewModel?.allPaymentHistoryLiveData?.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //binding.swipeRefreshLayout.isRefreshing = false
                with(binding) {
                    recyclerViewHistoryPayment.visibility = View.VISIBLE
                    textViewNoData.visibility = View.GONE
                }
                if (page == 1) {
                    paymentList.clear()
                }
                responseBody.data?.let { paymentList.addAll(it.filter { data ->
                    data.type = this.type?:""
                    true
                }) }
                historyPaymentAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                if (page == 1) {
                    //binding.swipeRefreshLayout.isRefreshing = false
                    with(binding) {
                        recyclerViewHistoryPayment.visibility = View.GONE
                        textViewNoData.visibility = View.VISIBLE
                        textViewNoData.text = throwable.message
                    }

                    paymentList.clear()
                    historyPaymentAdapter.notifyDataSetChanged()
                }
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
}