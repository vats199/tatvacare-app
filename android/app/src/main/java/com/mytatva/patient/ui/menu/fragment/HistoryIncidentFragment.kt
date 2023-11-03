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
import com.mytatva.patient.data.pojo.response.IncidentDetailsMainData
import com.mytatva.patient.databinding.MenuFragmentHistoryIncidentBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.HistoryIncidentAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class HistoryIncidentFragment : BaseFragment<MenuFragmentHistoryIncidentBinding>() {

    private val commentList = arrayListOf<IncidentDetailsMainData>()
    var resumedTime = Calendar.getInstance().timeInMillis
    private val historyIncidentAdapter by lazy {
        HistoryIncidentAdapter(commentList,
            object : HistoryIncidentAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    if (commentList.isNotEmpty()) {
                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            IncidentDetailsFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.PATIENT_INCIDENT_ADD_REL_ID,
                                    commentList[position].patient_incident_add_rel_id),
                                Pair(Common.BundleKey.INCIDENT_TRACKING_MASTER_ID,
                                    commentList[position].incident_tracking_master_id),
                                Pair(Common.BundleKey.DATE,
                                    commentList[position].formattedDate)
                            )).start()
                    }
                }
            })
    }

    private var goalReadingViewModel: GoalReadingViewModel? = null

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
    ): MenuFragmentHistoryIncidentBinding {
        return MenuFragmentHistoryIncidentBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        goalReadingViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        resumedTime = Calendar.getInstance().timeInMillis
        analytics.setScreenName(AnalyticsScreenNames.HistoryIncident)
        Log.d("History", "::incident")

        resetPagingData()
        getIncidentDurationOccuranceList()
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                getIncidentDurationOccuranceList()
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            recyclerViewIncident.apply {
                layoutManager = linearLayoutManager
                adapter = historyIncidentAdapter
            }

            recyclerViewIncident.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                        getIncidentDurationOccuranceList()
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

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getIncidentDurationOccuranceList() {
        val apiRequest = ApiRequest().apply {
            page = this@HistoryIncidentFragment.page.toString()
        }
        if (page == 1) {
            isLoading = true
            binding.swipeRefreshLayout.isRefreshing = true
            commentList.clear()
        }
        goalReadingViewModel?.getIncidentDurationOccuranceList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        goalReadingViewModel?.getIncidentDurationOccuranceListLiveData?.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                with(binding) {
                    recyclerViewIncident.visibility = View.VISIBLE
                    textViewNoData.visibility = View.GONE
                }
                if (page == 1) {
                    commentList.clear()
                }

                responseBody.data?.let { commentList.addAll(it) }
                historyIncidentAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                if (page == 1) {
                    commentList.clear()
                    historyIncidentAdapter.notifyDataSetChanged()

                    with(binding) {
                        recyclerViewIncident.visibility = View.GONE
                        textViewNoData.visibility = View.VISIBLE
                        textViewNoData.text = throwable.message
                    }
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
        analytics.logEvent(analytics.TIME_SPENT_INCIDENT_HISTORY, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.HistoryIncident)
    }
}