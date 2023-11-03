package com.mytatva.patient.ui.engage.fragment

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
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CommentsData
import com.mytatva.patient.databinding.EngageFragmentCommentsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.adapter.CommentsAdapter
import com.mytatva.patient.ui.engage.bottomsheet.ReportCommentBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class CommentsFragment : BaseFragment<EngageFragmentCommentsBinding>() {

    private val commentList = arrayListOf<CommentsData>()

    private val commentsAdapter by lazy {
        CommentsAdapter(session.userId, commentList,
            object : CommentsAdapter.AdapterListener {
                override fun onReportClick(position: Int) {
                    if (commentList[position].reported == "Y") {
                        reportComment(
                            commentId = commentList[position].content_comments_id ?: "",
                            reported = "N"
                        )
                    } else {
                        showReportCommentDialog(position)
                    }
                }

                override fun onDeleteClick(position: Int) {
                    commentList[position].content_comments_id?.let { removeComment(it) }
                }
            })
    }

    private fun showReportCommentDialog(position: Int) {
        activity?.supportFragmentManager?.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->
                commentList[position].content_comments_id?.let { it1 ->
                    reportComment(it1,
                        reported = "Y",
                        reportType,
                        reportDesc)
                }
            }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
        }
    }

    val contentMasterId by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_ID)
    }

    val contentType by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_TYPE)
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

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageFragmentCommentsBinding {
        return EngageFragmentCommentsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.CommentList)
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setViewListeners()
        resetPagingData()
        commentList()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Comments(0)"
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            val linearLayoutManager =
                LinearLayoutManager(activity, RecyclerView.VERTICAL, false)
            recyclerViewComments.apply {
                layoutManager = linearLayoutManager
                adapter = commentsAdapter
            }

            recyclerViewComments.addOnScrollListener(object : RecyclerView.OnScrollListener() {
                override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {

                }

                override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                    if (linearLayoutManager.findFirstCompletelyVisibleItemPosition() == 0) {
                        imageViewScrollUp.visibility = View.GONE
                    } else {
                        imageViewScrollUp.visibility = View.VISIBLE
                    }

                    //pagination
                    val visibleItemCount = recyclerView.childCount
                    val totalItemCount = linearLayoutManager.itemCount
                    val pastVisibleItems = linearLayoutManager.findFirstVisibleItemPosition()
                    if (isLoading) {
                        if (totalItemCount > previousTotal) {
                            isLoading = false
                            previousTotal = totalItemCount
                        }
                    }
                    if (!isLoading && totalItemCount - visibleItemCount <= pastVisibleItems + 0) {
                        // End has been reached
                        page++
                        commentList()
                        isLoading = true
                    }
                }
            })
        }
    }

    private fun setViewListeners() {
        with(binding) {
            textViewSend.setOnClickListener { onViewClick(it) }
            imageViewScrollUp.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewScrollUp -> {
                binding.recyclerViewComments.scrollToPosition(0)
            }
            R.id.textViewSend -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.commenting_on_articles)) {
                    if (binding.editTextComment.text.toString().trim().isNotBlank()) {
                        updateComment(binding.editTextComment.text.toString().trim())
                    }
                } else {
                    binding.editTextComment.setText("")
                }
            }
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
    private fun commentList() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            page = this@CommentsFragment.page.toString()
            show = "all"
        }
        engageContentViewModel.commentList(apiRequest)
    }

    private fun updateComment(commentStr: String) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            /*content_comments_id = ""*/
            comment = commentStr
        }
        engageContentViewModel.updateComment(apiRequest)
    }

    var reportedStatus = "N"
    private fun reportComment(
        commentId: String,
        reported: String,
        reportType: String? = null,
        commentDesc: String? = null,
    ) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            content_comments_id = commentId
            reportedStatus = reported
            this.reported = reported
            if (commentDesc.isNullOrBlank().not()) {
                description = commentDesc
            }
            //S - Spam, I - Inappropriate, F - False information
            report_type = reportType
        }
        hideLoader()
        engageContentViewModel.reportComment(apiRequest)
    }

    private fun removeComment(commentId: String) {
        val apiRequest = ApiRequest().apply {
            content_comments_id = commentId
        }
        showLoader()
        engageContentViewModel.removeComment(apiRequest, screenName = AnalyticsScreenNames.CommentList)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //commentListLiveData
        engageContentViewModel.commentListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                if (page == 1)
                    commentList.clear()
                responseBody.data?.comment_data?.let { commentList.addAll(it) }
                commentsAdapter.notifyDataSetChanged()

                binding.layoutHeader.textViewToolbarTitle.text =
                    "Comments(${responseBody.data?.total ?: "0"})"
            },
            onError = { throwable ->
                hideLoader()
                if (page == 1) {
                    commentList.clear()
                    commentsAdapter.notifyDataSetChanged()
                    true
                } else {
                    false
                }

            })

        //updateCommentLiveData
        engageContentViewModel.updateCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.editTextComment.setText("")
                resetPagingData()
                commentList()

                analytics.logEvent(analytics.USER_COMMENTED, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
                    putString(analytics.PARAM_CONTENT_TYPE, contentType)
                }, screenName = AnalyticsScreenNames.CommentList)
            },
            onError = { throwable ->
                hideLoader()
                //binding.editTextComment.setText("")
                true
            })

        //reportCommentLiveData
        engageContentViewModel.reportCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                resetPagingData()
                commentList()

                analytics.logEvent(
                    if (reportedStatus == "Y")
                        analytics.USER_REPORTED_COMMENT
                    else analytics.USER_UN_REPORTED_COMMENT,
                    Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
                        putString(analytics.PARAM_CONTENT_TYPE, contentType)
                    }, screenName = AnalyticsScreenNames.ReportComment)

            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //deleteCommentLiveData
        engageContentViewModel.removeCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                resetPagingData()
                commentList()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}