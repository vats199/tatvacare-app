package com.mytatva.patient.ui.menu.fragment

import android.annotation.SuppressLint
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
import com.mytatva.patient.data.pojo.response.IncidentDetailsAllData
import com.mytatva.patient.data.pojo.response.IncidentDetailsData
import com.mytatva.patient.databinding.MenuFragmentIncidentDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.HistoryIncidentDetailsAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames.IncidentDetails

class IncidentDetailsFragment : BaseFragment<MenuFragmentIncidentDetailsBinding>() {

    private val queAnsList = arrayListOf<IncidentDetailsData>()

    private val historyIncidentDetailsAdapter by lazy {
        HistoryIncidentDetailsAdapter(queAnsList)
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    val patientIncidentAddRelId by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_INCIDENT_ADD_REL_ID)
    }
    val incidentTrackingMasterId by lazy {
        arguments?.getString(Common.BundleKey.INCIDENT_TRACKING_MASTER_ID)
    }
    val formattedDateTitle by lazy {
        arguments?.getString(Common.BundleKey.DATE)
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
    ): MenuFragmentIncidentDetailsBinding {
        return MenuFragmentIncidentDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.IncidentDetails)
    }


    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpRecyclerView()
        fetchIncidentList()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewIncidentDetails.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = historyIncidentDetailsAdapter
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = formattedDateTitle ?: ""
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun fetchIncidentList() {
        val apiRequest = ApiRequest().apply {
            /*page = this@IncidentDetailsFragment.page.toString()*/
            incident_tracking_master_id = incidentTrackingMasterId
            patient_incident_add_rel_id = patientIncidentAddRelId
        }
        showLoader()
        goalReadingViewModel.fetchIncidentList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.fetchIncidentListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setData(it)
                    analytics.logEvent(analytics.USER_CLICKED_DETAIL_INCIDENT_PAGE, Bundle().apply {
                        putString(analytics.PARAM_SURVEY_ID, it.question_occurance?.survey_id)
                        putString(analytics.PARAM_OCCUR_INCIDENT_TRACKING_MASTER_ID,
                            it.question_occurance?.incident_tracking_master_id)
                    }, screenName = IncidentDetails)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(incidentDetailsAllData: IncidentDetailsAllData) {
        queAnsList.clear()
        incidentDetailsAllData.ques_ans_list?.let { queAnsList.addAll(it) }
        historyIncidentDetailsAdapter.notifyDataSetChanged()

        incidentDetailsAllData.question_occurance?.let {
            with(binding) {
                textViewLabelDuration.text = /*Html.fromHtml(it.duration_question)*/
                    it.duration_question
                textViewLabelHowDidItImprove.text = /*Html.fromHtml(it.occur_question)*/
                    it.occur_question
                textViewDuration.text = it.duration_answer.plus(" min")
                textViewHowDidItImprove.text = it.occur_answer
            }
        }
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}