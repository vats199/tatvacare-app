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
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.RecordData
import com.mytatva.patient.databinding.MenuFragmentHistoryRecordBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.HistoryRecordAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class HistoryRecordFragment : BaseFragment<MenuFragmentHistoryRecordBinding>() {
    var searchText: String = ""
    var isInsideSearch = false

    private val recordList = arrayListOf<RecordData>()
    var resumedTime = Calendar.getInstance().timeInMillis

    private val historyRecordAdapter by lazy {
        HistoryRecordAdapter(navigator, recordList,
            object : HistoryRecordAdapter.AdapterListener {
                override fun onPDFClick(position: Int) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_RECORD, Bundle().apply {
                        putString(
                            analytics.PARAM_PATIENT_RECORDS_ID,
                            recordList[position].patient_records_id
                        )
                    }, screenName = AnalyticsScreenNames.HistoryRecord)
                    recordList[position].document_url?.firstOrNull()?.let {
                        openPdfViewer(it)
                    }
                }

                override fun onImageClick(position: Int) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_RECORD, Bundle().apply {
                        putString(
                            analytics.PARAM_PATIENT_RECORDS_ID,
                            recordList[position].patient_records_id
                        )
                    }, screenName = AnalyticsScreenNames.HistoryRecord)
                    recordList[position].document_url?.firstOrNull()?.let {
                        navigator.showImageViewerDialog(arrayListOf(it))
                    }
                }
            })
    }

    private var authViewModel: AuthViewModel? = null

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
    ): MenuFragmentHistoryRecordBinding {
        return MenuFragmentHistoryRecordBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        authViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
        observeLiveData()
        Log.d("History", "::record on create")
        super.onCreate(savedInstanceState)
    }

    override fun onDestroy() {
        Log.d("History", "::record on destroy")
        super.onDestroy()
    }

    override fun onResume() {
        super.onResume()
        resumedTime = Calendar.getInstance().timeInMillis
        analytics.setScreenName(AnalyticsScreenNames.HistoryRecord)
        Log.d("History", "::record")
        resetPagingData()
        getRecords()
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpViewListeners()

        binding.textViewUpload.isVisible = !isInsideSearch
    }

    private fun setUpViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                getRecords()
            }
            textViewUpload.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            recyclerViewRecords.apply {
                layoutManager = linearLayoutManager
                adapter = historyRecordAdapter
            }

            recyclerViewRecords.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                        getRecords()
                        isLoading = true
                    }
                }
            })
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewUpload -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    UploadRecordFragment::class.java
                ).start()
            }
        }
    }

    fun doSearch(searchText: String) {
        resetPagingData()
        this.searchText = searchText
        getRecords()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getRecords() {
        val apiRequest = ApiRequest().apply {
            page = this@HistoryRecordFragment.page.toString()

            if (isInsideSearch && searchText.isNotBlank()) {
                search = searchText
            }
        }
        if (page == 1 && isInsideSearch.not()) {
            binding.swipeRefreshLayout.isRefreshing = true
            isLoading = true
            recordList.clear()
        }
        authViewModel?.getRecords(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel?.getRecordsLiveData?.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                with(binding) {
                    textViewNoData.visibility = View.GONE
                    recyclerViewRecords.visibility = View.VISIBLE
                }
                if (page == 1) {
                    recordList.clear()
                }
                responseBody.data?.let { recordList.addAll(it) }
                historyRecordAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                if (page == 1) {
                    with(binding) {
                        textViewNoData.visibility = View.VISIBLE
                        recyclerViewRecords.visibility = View.GONE
                        textViewNoData.text = throwable.message
                    }

                    recordList.clear()
                    historyRecordAdapter.notifyDataSetChanged()
                }
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_RECORD_HISTORY, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.HistoryRecord)
    }
}