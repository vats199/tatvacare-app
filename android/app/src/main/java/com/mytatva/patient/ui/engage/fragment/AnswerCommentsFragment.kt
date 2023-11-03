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
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AnswerCommentData
import com.mytatva.patient.data.pojo.response.AnswerDetailsResData
import com.mytatva.patient.databinding.EngageFragmentAnswerCommentsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.adapter.EngageAskAnExpertAnswerCommentsAdapter
import com.mytatva.patient.ui.engage.bottomsheet.ReportCommentBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class AnswerCommentsFragment : BaseFragment<EngageFragmentAnswerCommentsBinding>() {

    private val answerId by lazy {
        arguments?.getString(Common.BundleKey.ANSWER_ID)
    }

    private val contentMasterId by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_ID)
    }

    private var answerDetailsResData: AnswerDetailsResData? = null

    //pagination paramas
    var page = 1
    internal var isLoading = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null
    private var isMoreDataAvailable = true

    fun resetPagingData() {
        isLoading = false
        page = 1
        previousTotal = 0
        isMoreDataAvailable = true
    }

    var currentClickPos = -1

    private var currentUpdateCommentData: AnswerCommentData? = null
    private val answerCommentsList = arrayListOf<AnswerCommentData>()
    private val engageAskAnExpertAnswerCommentsAdapter by lazy {
        EngageAskAnExpertAnswerCommentsAdapter(
            requireActivity() as BaseActivity,
            navigator,
            session.userId,
            answerCommentsList,
            object : EngageAskAnExpertAnswerCommentsAdapter.AdapterListener {
                override fun onReportClick(position: Int) {
                    currentClickPos = position
                    if (answerCommentsList[position].reported == "Y") {
                        answerCommentsList[position].content_comments_id?.let {
                            //reportAnswerComment(it, "N")
                        }
                    } else if (answerCommentsList[position].reported == "N") {
                        showReportCommentDialog(position)
                    }
                }

                override fun onLikeClick(position: Int) {
                    currentClickPos = position
                    answerCommentsList[position].content_comments_id?.let {
                        answerCommentUpdateLike(it, answerCommentsList[position].liked ?: "")
                    }
                }

                override fun onOptionMenuClick(position: Int) {
                    currentClickPos = position
                    handleOnOptionsClick(position)
                }
            }
        )
    }

    private fun handleOnOptionsClick(listPosition: Int) {
        BottomSheet<String>().showBottomSheetDialog(activity as BaseActivity,
            arrayListOf(getString(R.string.label_edit), getString(R.string.label_delete)), "",
            object : BottomSheetAdapter.ItemListener<String> {
                override fun onItemClick(item: String, position: Int) {
                    if (position == 0) {//edit
                        currentUpdateCommentData = answerCommentsList[listPosition]
                        binding.editTextAddAComment.setText(currentUpdateCommentData?.comment)
                        binding.editTextAddAComment.setSelection(binding.editTextAddAComment.text.toString().length)
                    } else {//delete
                        navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                            dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                                override fun onYesClick() {
                                    answerCommentsList[listPosition].content_comments_id?.let {
                                        answerCommentDelete(it)
                                    }
                                }

                                override fun onNoClick() {

                                }
                            })

                    }
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<String>.MyViewHolder,
                    position: Int,
                    item: String,
                ) {
                    holder.textView.text = item
                }
            })
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
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
    ): EngageFragmentAnswerCommentsBinding {
        return EngageFragmentAnswerCommentsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AnswerDetails)
        setUpRecyclerView()
    }

    override fun bindData() {
        setUpToolbar()
        setViewListeners()

        answerDetail()
        //resetPagingData()
        //answerComments()
    }

    private fun setViewListeners() {
        with(binding) {
            imageViewPostComment.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        linearLayoutManager =
            LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        binding.recyclerViewComments.apply {
            layoutManager = linearLayoutManager
            adapter = engageAskAnExpertAnswerCommentsAdapter
        }

        binding.nestedScrollView.viewTreeObserver.addOnScrollChangedListener {
            val view: View =
                binding.nestedScrollView.getChildAt(binding.nestedScrollView.childCount - 1) as View
            val diff: Int =
                view.bottom - (binding.nestedScrollView.height + binding.nestedScrollView.scrollY)
            if (diff <= 0 && isMoreDataAvailable && !isLoading) {
                // your pagination code
                isLoading = true
                page++
                answerComments()
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = ""
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewPostComment -> {
                if (binding.editTextAddAComment.text.toString().trim().isNotBlank()) {
                    updateAnswerReply()
                }
            }
        }
    }

    private fun showReportCommentDialog(position: Int) {
        requireActivity().supportFragmentManager.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->
                answerCommentsList[position].content_comments_id?.let {
                    reportAnswerComment(it, "Y",
                        reportDesc,
                        reportType)
                }
            }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun answerDetail() {
        val apiRequest = ApiRequest()
        apiRequest.content_comments_id = answerId
        showLoader()
        engageContentViewModel.answerDetail(apiRequest)
    }

    private fun answerComments() {
        val apiRequest = ApiRequest()
        apiRequest.answer_id = answerId
        apiRequest.page = page.toString()
        showLoader()
        engageContentViewModel.answerComments(apiRequest)
    }

    private fun updateAnswerReply() {
        val apiRequest = ApiRequest()
        apiRequest.answer_id = answerId
        apiRequest.content_master_id = contentMasterId
        apiRequest.description = binding.editTextAddAComment.text.toString().trim()
        apiRequest.content_comments_id =
            currentUpdateCommentData?.content_comments_id//to update comment else null
        showLoader()
        engageContentViewModel.updateAnswerReply(apiRequest)
    }

    private fun reportAnswerComment(
        contentCommentsId: String,
        reported: String,
        reportDesc: String? = null,
        reportType: String? = null,
    ) {
        val apiRequest = ApiRequest()
        apiRequest.content_comments_id = contentCommentsId
        apiRequest.reported = reported
        apiRequest.description = reportDesc
        apiRequest.report_type = reportType
        showLoader()
        engageContentViewModel.reportAnswerComment(apiRequest)
    }

    private fun answerCommentUpdateLike(
        contentCommentsId: String,
        isActive: String,
    ) {
        val apiRequest = ApiRequest()
        apiRequest.content_comments_id = contentCommentsId
        apiRequest.is_active = isActive
        //showLoader()
        engageContentViewModel.answerCommentUpdateLike(apiRequest, analytics, screenName = AnalyticsScreenNames.AnswerDetails, isComment = true)
    }

    private fun answerCommentDelete(contentCommentsId: String) {
        val apiRequest = ApiRequest()
        apiRequest.content_comments_id = contentCommentsId
        showLoader()
        engageContentViewModel.answerCommentDelete(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        engageContentViewModel.answerCommentsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                isLoading = false
                if (page == 1) {
                    answerCommentsList.clear()
                }
                responseBody.data?.let { answerCommentsList.addAll(it) }
                engageAskAnExpertAnswerCommentsAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                isLoading = false
                isMoreDataAvailable = false
                false
            })

        engageContentViewModel.answerDetailLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setData(it) }
                resetPagingData()
                answerComments()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        engageContentViewModel.updateAnswerReplyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //set null if called for update comment
                if (currentUpdateCommentData != null) {
                    currentUpdateCommentData = null
                }
                binding.editTextAddAComment.setText("")

                answerDetail()
                /*resetPagingData()
                answerComments()*/
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //reportAnswerCommentLiveData
        engageContentViewModel.reportAnswerCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (answerCommentsList[currentClickPos].reported == "Y") {
                    answerCommentsList[currentClickPos].reported = "N"
                } else if (answerCommentsList[currentClickPos].reported == "N") {
                    answerCommentsList[currentClickPos].reported = "Y"
                }
                engageAskAnExpertAnswerCommentsAdapter.notifyItemChanged(currentClickPos)
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //answerCommentUpdateLikeLiveData
        engageContentViewModel.answerCommentUpdateLikeLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //answerCommentDeleteLiveData
        engageContentViewModel.answerCommentDeleteLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                answerCommentsList.removeAt(currentClickPos)
                engageAskAnExpertAnswerCommentsAdapter.notifyItemRemoved(currentClickPos)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun setData(answerDetailsResData: AnswerDetailsResData) {
        this.answerDetailsResData = answerDetailsResData
        answerDetailsResData.let {
            analytics.logEvent(analytics.USER_VIEW_ANSWER, Bundle().apply {
                putString(analytics.PARAM_CONTENT_COMMENTS_ID, it.answer?.content_comments_id)
            }, screenName = AnalyticsScreenNames.AnswerDetails)
            with(binding) {
                textViewQuestion.text = it.question?.title
                textViewAnsGivenBy.text = it.answer?.ansGivenBy(session.userId)
                textViewTopAns.text = it.answer?.comment
                textViewLabelComments.text = "Comments (${it.answer?.total_comments})"
                textViewTopAnsTime.text = it.answer?.formattedTopAnsTime
            }
        }
    }
}