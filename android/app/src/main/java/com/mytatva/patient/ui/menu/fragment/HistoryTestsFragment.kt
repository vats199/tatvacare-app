package com.mytatva.patient.ui.menu.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.DownloadReportResData
import com.mytatva.patient.data.pojo.response.HistoryTestOrderData
import com.mytatva.patient.databinding.MenuFragmentHistoryTestsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.fragment.LabtestOrderDetailsFragment
import com.mytatva.patient.ui.menu.adapter.HistoryTestsAdapter
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class HistoryTestsFragment : BaseFragment<MenuFragmentHistoryTestsBinding>() {
    var searchText: String = ""
    var isInsideSearch = false
    var isSearchInit = false

    /*private val downloadHelper: DownloadHelper by lazy {
        DownloadHelper(requireActivity())
    }*/

    private val testsList = arrayListOf<HistoryTestOrderData>()
    var resumedTime = Calendar.getInstance().timeInMillis
    private val historyTestsAdapter by lazy {
        HistoryTestsAdapter(testsList, navigator,
            object : HistoryTestsAdapter.AdapterListener {
                override fun onItemClick(position: Int) {
                    if (testsList.isNotEmpty()) {
                        analytics.logEvent(analytics.LABTEST_HISTORY_CARD_CLICKED, Bundle().apply {
                            putString(analytics.PARAM_ORDER_MASTER_ID,
                                testsList[position].order_master_id)
                        }, screenName = AnalyticsScreenNames.HistoryTest)

                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            LabtestOrderDetailsFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.ORDER_MASTER_ID,
                                    testsList[position].order_master_id)
                            )).start()
                    }
                }

                override fun onDownloadReportClick(position: Int) {
                    if (testsList.isNotEmpty()) {
                        selectedPosition = position
                        testsList[position].order_master_id?.let { getDownloadReportUrl(it) }
                    }
                }
            })
    }

    private var selectedPosition: Int = -1

    private var doctorViewModel: DoctorViewModel? = null

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
    ): MenuFragmentHistoryTestsBinding {
        return MenuFragmentHistoryTestsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onDestroy() {
        super.onDestroy()
        //activity?.unregisterReceiver(onComplete)
        //downloadHelper.unregisterReceiver()
    }

    override fun onPause() {
        super.onPause()
        //updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        /* val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
         val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
         analytics.logEvent(analytics.TIME_SPENT_INCIDENT_HISTORY, Bundle().apply {
             putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
         })*/
    }

    //private var isObserved = false
    override fun onCreate(savedInstanceState: Bundle?) {
        /* if (!isObserved) {
             isObserved = true
         }*/
        doctorViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
        observeLiveData()
        //downloadHelper.registerReceiver()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        resumedTime = Calendar.getInstance().timeInMillis
        analytics.setScreenName(AnalyticsScreenNames.HistoryTest)
        Log.d("History", "::test")
        resetPagingData()
        orderHistory()
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                orderHistory()
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            recyclerViewTests.apply {
                layoutManager = linearLayoutManager
                adapter = historyTestsAdapter
            }

            recyclerViewTests.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                        orderHistory()
                        isLoading = true
                    }
                }
            })
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    fun doSearch(searchText: String) {
        isSearchInit=true
        resetPagingData()
        this.searchText = searchText
        orderHistory()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun orderHistory() {
        val apiRequest = ApiRequest().apply {
            page = this@HistoryTestsFragment.page.toString()

            if (isInsideSearch && searchText.isNotBlank()) {
                search = searchText
            }
        }
        if (page == 1 && isInsideSearch.not()) {
            binding.swipeRefreshLayout.isRefreshing = true
            isLoading = true
            testsList.clear()
        }
        doctorViewModel?.orderHistory(apiRequest)
    }

    private fun getDownloadReportUrl(orderMasterId: String) {
        val apiRequest = ApiRequest().apply {
            order_master_id = orderMasterId
        }
        showLoader()
        doctorViewModel?.getDownloadReportUrl(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //orderHistoryLiveData
        doctorViewModel?.orderHistoryLiveData?.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                with(binding) {
                    recyclerViewTests.visibility = View.VISIBLE
                    textViewNoData.visibility = View.GONE
                }
                if (page == 1) {
                    testsList.clear()
                }
                responseBody.data?.let { testsList.addAll(it) }
                historyTestsAdapter.notifyDataSetChanged()
                if (isSearchInit)
                {
                    analytics.logEvent(
                        AnalyticsClient.CLICKED_SEARCH,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_SEARCH_TYPE,
                                analytics.PARAM_SUCCESS
                            )
                            putString(
                                analytics.PARAM_SEARCH_KEYWORD,
                                searchText
                            )
                        })
                }

            },
            onError = { throwable ->
                hideLoader()
                if (page == 1) {
                    binding.swipeRefreshLayout.isRefreshing = false
                    with(binding) {
                        recyclerViewTests.visibility = View.GONE
                        textViewNoData.visibility = View.VISIBLE
                        textViewNoData.text = throwable.message
                    }

                    testsList.clear()
                    historyTestsAdapter.notifyDataSetChanged()
                }
                false
            })

        //getDownloadReportUrlLiveData
        doctorViewModel?.getDownloadReportUrlLiveData?.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { handleOnDownloadReportUrl(it) }
            },
            onError = { throwable ->
                hideLoader()
                isVisible && true
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    private fun handleOnDownloadReportUrl(downloadReportResData: DownloadReportResData) {
        downloadReportResData.let {
            if (it.url.isNullOrBlank().not()) {
                downloadHelper.startDownload(
                    it.url!!,
                    testsList[selectedPosition].name?.plus(".pdf") ?: "report.pdf",
                    downloadHelper.DIR_REPORTS)
            }
        }
    }
}