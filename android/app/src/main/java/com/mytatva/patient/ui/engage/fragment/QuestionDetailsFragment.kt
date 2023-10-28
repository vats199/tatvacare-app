package com.mytatva.patient.ui.engage.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.flexbox.FlexDirection
import com.google.android.flexbox.FlexboxLayoutManager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AnswerData
import com.mytatva.patient.data.pojo.response.Documents
import com.mytatva.patient.data.pojo.response.QuestionsData
import com.mytatva.patient.data.pojo.response.Topics
import com.mytatva.patient.databinding.EngageFragmentQuestionDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.adapter.EngageAskAnExpertAnswersAdapter
import com.mytatva.patient.ui.engage.adapter.EngageAskAnExpertDocumentsAdapter
import com.mytatva.patient.ui.engage.adapter.EngageAskAnExpertTopicsAdapter
import com.mytatva.patient.ui.engage.bottomsheet.ReportCommentBottomSheetDialog
import com.mytatva.patient.ui.engage.dialog.PostQuestionDialog
import com.mytatva.patient.ui.engage.dialog.SubmitAnswerDialog
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.kFormat

class QuestionDetailsFragment : BaseFragment<EngageFragmentQuestionDetailsBinding>() {

    private val contentMasterId by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_ID)
    }

    //pagination params
    var page = 1
    internal var isLoading = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null

    private var isMoreDataAvailable = true
    private var topAnsId: String? = null

    fun resetPagingData() {
        isLoading = false
        page = 1
        previousTotal = 0
        isMoreDataAvailable = true
    }

    private val answerList = arrayListOf<AnswerData>()
    private val engageAskAnExpertAnswersAdapter by lazy {
        EngageAskAnExpertAnswersAdapter(
            mainPosition = -1,
            activity = requireActivity() as BaseActivity,
            navigator = navigator,
            userId = session.userId,
            list = answerList,
            adapterListener = object : EngageAskAnExpertAnswersAdapter.AdapterListener {
                override fun onReportAnsClick(mainPosition: Int, position: Int) {
                    currentClickAnswerPosition = position

                    if (answerList[position].reported == "Y") {
                        answerList[position].content_comments_id?.let {
                            //reportAnswerComment(it, "N")
                        }
                    } else if (answerList[position].reported == "N") {
                        showReportCommentDialog(position)
                    }
                }

                override fun onReadFullAnsOrCommentClick(mainPosition: Int, position: Int) {
                    currentClickAnswerPosition = position
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        AnswerCommentsFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.ANSWER_ID,
                                answerList[position].content_comments_id),
                            Pair(Common.BundleKey.CONTENT_ID, contentMasterId)
                        )).start()
                }

                override fun onLikeAnswerClick(mainPosition: Int, position: Int) {
                    currentClickAnswerPosition = position
                    answerList[position].content_comments_id?.let {
                        answerCommentUpdateLike(it, answerList[position].liked ?: "")
                    }
                }

                override fun onAnswerOptionClick(mainPosition: Int, position: Int) {
                    currentClickAnswerPosition = position
                    openOptionMenu(position)
                }
            },
        )
    }

    private var questionsData: QuestionsData? = null
    private val documentList = arrayListOf<Documents>()
    val engageAskAnExpertDocumentsAdapter by lazy {
        EngageAskAnExpertDocumentsAdapter(-1,
            requireActivity() as BaseActivity, navigator, session.userId,
            documentList)
    }

    private val topicsList = arrayListOf<Topics>()
    val engageAskAnExpertTopicsAdapter by lazy {
        EngageAskAnExpertTopicsAdapter(
            requireActivity() as BaseActivity, navigator, session.userId,
            topicsList)
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
    ): EngageFragmentQuestionDetailsBinding {
        return EngageFragmentQuestionDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.QuestionDetails)
    }

    override fun bindData() {
        setUpToolbar()
        setViewListeners()
        setUpRecyclerView()
        questionDetail()
    }

    private fun setViewListeners() {
        with(binding) {
            textViewAnswerThis.setOnClickListener { onViewClick(it) }
            imageViewBookmark.setOnClickListener { onViewClick(it) }
            imageViewReportQuestion.setOnClickListener { onViewClick(it) }
            imageViewLikeAnswer.setOnClickListener { onViewClick(it) }
            imageViewReportAnswer.setOnClickListener { onViewClick(it) }
            layoutTopAnswer.setOnClickListener { onViewClick(it) }
            imageViewComment.setOnClickListener { onViewClick(it) }
            imageViewOptionMenuQuestion.setOnClickListener { onViewClick(it) }
            imageViewOptionMenuTopAns.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewDocuments.apply {
            layoutManager =
                LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
            adapter = engageAskAnExpertDocumentsAdapter
        }

        val flexboxLayoutManager = FlexboxLayoutManager(requireActivity())
        flexboxLayoutManager.flexDirection = FlexDirection.ROW
        binding.recyclerViewTopics.apply {
            layoutManager = flexboxLayoutManager
            adapter = engageAskAnExpertTopicsAdapter
        }

        linearLayoutManager =
            LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        binding.recyclerViewAnswers.apply {
            layoutManager = linearLayoutManager
            adapter = engageAskAnExpertAnswersAdapter
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
                answersList()
            }
        }

        /*binding.recyclerViewAnswers.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                    answersList()
                    isLoading = true
                }
            }
        })*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = ""
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewOptionMenuQuestion -> {
                openOptionMenu(-1, true)
            }
            R.id.imageViewOptionMenuTopAns -> {
                openOptionMenu(-1)
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.textViewAnswerThis -> {
                showSubmitAnswerDialog()
            }
            R.id.imageViewBookmark -> {
                questionsData?.let {
                    if (it.bookmarked == "Y") {
                        questionsData?.bookmarked = "N"
                    } else {
                        questionsData?.bookmarked = "Y"
                    }
                    binding.imageViewBookmark.isSelected = it.bookmarked == "Y"
                    updateBookmarks()
                }
            }
            R.id.imageViewReportQuestion -> {
                if (questionsData?.reported == "Y") {
                    //contentReport("N")
                } else if (questionsData?.reported == "N") {
                    showReportQuestionDialog()
                }
            }
            R.id.imageViewLikeAnswer -> {
                questionsData?.top_answer?.content_comments_id?.let {
                    if (questionsData?.top_answer?.liked == "Y") {
                        questionsData?.top_answer?.liked = "N"
                        questionsData?.top_answer?.likeCount =
                            (questionsData?.top_answer?.likeCount ?: 0) - 1
                    } else {
                        questionsData?.top_answer?.liked = "Y"
                        questionsData?.top_answer?.likeCount =
                            (questionsData?.top_answer?.likeCount ?: 0) + 1
                    }
                    binding.textViewLikeCount.text = questionsData?.top_answer?.likeCount.kFormat()
                    binding.imageViewLikeAnswer.isSelected = questionsData?.top_answer?.liked == "Y"
                    answerCommentUpdateLike(it, questionsData?.top_answer?.liked ?: "")
                }
            }
            R.id.imageViewReportAnswer -> {
                if (questionsData?.top_answer?.reported == "Y") {
                    questionsData?.top_answer?.content_comments_id?.let {
                        //reportAnswerComment(it, "N")
                    }
                } else if (questionsData?.top_answer?.reported == "N") {
                    showReportCommentDialog()
                }
            }
            R.id.layoutTopAnswer,
            R.id.imageViewComment,
            -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    AnswerCommentsFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.ANSWER_ID,
                            questionsData?.top_answer?.content_comments_id),
                        Pair(Common.BundleKey.CONTENT_ID, contentMasterId)
                    )).start()
            }
        }
    }

    private fun openOptionMenu(answerPosition: Int, isQuestion: Boolean = false) {
        if (isQuestion) {
            BottomSheet<String>().showBottomSheetDialog(activity as BaseActivity,
                arrayListOf(getString(R.string.label_delete)), "",
                object : BottomSheetAdapter.ItemListener<String> {
                    override fun onItemClick(item: String, position: Int) {
                        if (position == 0) {//delete
                            navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                                dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                                    override fun onYesClick() {
                                        if (isQuestion) {//question delete
                                            questionsData?.content_master_id?.let {
                                                questionDelete(it)
                                            }
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
        } else {
            BottomSheet<String>().showBottomSheetDialog(activity as BaseActivity,
                arrayListOf(getString(R.string.label_edit), getString(R.string.label_delete)), "",
                object : BottomSheetAdapter.ItemListener<String> {
                    override fun onItemClick(item: String, position: Int) {
                        if (position == 0) {//edit
                            if (isQuestion) {//question edit
                                showUpdateQuestionDialog()
                            } else if (answerPosition != -1) {//recent answer edit
                                showSubmitAnswerDialog(answerList[currentClickAnswerPosition])
                            } else {//top answer edit
                                showSubmitAnswerDialog(questionsData?.top_answer)
                            }
                        } else {//delete

                            navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                                dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                                    override fun onYesClick() {

                                        if (isQuestion) {//question delete
                                            questionsData?.content_master_id?.let {
                                                questionDelete(it)
                                            }
                                        } else if (answerPosition != -1) {//recent answer delete
                                            isTopAnswerOption = false
                                            answerList[currentClickAnswerPosition].content_comments_id?.let {
                                                answerDelete(it)
                                            }
                                        } else {//top answer delete
                                            isTopAnswerOption = true
                                            questionsData?.top_answer?.content_comments_id?.let {
                                                answerDelete(it)
                                            }
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
    }

    private fun showUpdateQuestionDialog() {
        PostQuestionDialog(questionsData).apply {
            callback = {
                questionDetail()
            }
        }.show(requireActivity().supportFragmentManager,
            PostQuestionDialog::class.java.simpleName)
    }

    private fun showSubmitAnswerDialog(answerData: AnswerData? = null) {
        SubmitAnswerDialog(contentMasterId = contentMasterId,
            question = questionsData?.title,
            answerData = answerData)
            .setCallback {
                questionDetail()
            }.show(requireActivity().supportFragmentManager,
                SubmitAnswerDialog::class.java.simpleName)
    }

    private var currentClickAnswerPosition = -1
    private var isTopAnswerOption = false
    private fun showReportCommentDialog(position: Int = -1) {
        requireActivity().supportFragmentManager.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->
                if (position == -1) {
                    // for top answer report
                    isTopAnswerOption = true
                    questionsData?.top_answer?.content_comments_id?.let { it1 ->
                        reportAnswerComment(it1,
                            reported = "Y",
                            reportDesc,
                            reportType)
                    }
                } else {
                    // answer report from answer list
                    isTopAnswerOption = false
                    answerList[position].content_comments_id?.let { it1 ->
                        reportAnswerComment(it1,
                            reported = "Y",
                            reportDesc,
                            reportType)
                    }
                }
            }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
        }
    }

    private fun showReportQuestionDialog() {
        requireActivity().supportFragmentManager.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->
                contentReport("Y", reportType, reportDesc)
            }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun answersList() {
        val apiRequest = ApiRequest()
        apiRequest.page = page.toString()
        apiRequest.content_master_id = contentMasterId
        apiRequest.top_answer_id = topAnsId
        showLoader()
        engageContentViewModel.answersList(apiRequest)
    }

    private fun questionDetail() {
        val apiRequest = ApiRequest()
        apiRequest.content_master_id = contentMasterId
        showLoader()
        engageContentViewModel.questionDetail(apiRequest)
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

    private fun contentReport(
        reported: String,
        reportType: String? = null,
        description: String? = null,
    ) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            this.description = description
            report_type = reportType
            this.reported = reported
        }
        showLoader()
        engageContentViewModel.contentReport(apiRequest)
    }

    private fun answerCommentUpdateLike(
        contentCommentsId: String,
        isActive: String,
    ) {
        val apiRequest = ApiRequest()
        apiRequest.content_comments_id = contentCommentsId
        apiRequest.is_active = isActive
        //showLoader()
        engageContentViewModel.answerCommentUpdateLike(apiRequest, analytics, screenName = AnalyticsScreenNames.QuestionDetails)
    }

    private fun questionDelete(contentMasterId: String) {
        val apiRequest = ApiRequest()
        apiRequest.content_master_id = contentMasterId
        showLoader()
        engageContentViewModel.questionDelete(apiRequest)
    }

    private fun answerDelete(contentCommentsId: String) {
        val apiRequest = ApiRequest()
        apiRequest.content_comments_id = contentCommentsId
        showLoader()
        engageContentViewModel.answerDelete(apiRequest)
    }

    private fun updateBookmarks() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            is_active = questionsData?.bookmarked
        }
        engageContentViewModel.updateBookmarksQuestion(apiRequest, analytics, screenName = AnalyticsScreenNames.QuestionDetails)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        engageContentViewModel.answersListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                isLoading = false
                if (page == 1) {
                    answerList.clear()
                }
                responseBody.data?.let { answerList.addAll(it) }
                engageAskAnExpertAnswersAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                isLoading = false
                isMoreDataAvailable = false
                page == 1
            })

        engageContentViewModel.questionDetailLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setData(it)
                    topAnsId = it.top_answer?.content_comments_id
                }
                resetPagingData()
                answersList()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //reportAnswerCommentLiveData
        engageContentViewModel.reportAnswerCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (isTopAnswerOption) {

                    if (questionsData?.top_answer?.reported == "Y") {
                        questionsData?.top_answer?.reported = "N"
                    } else {
                        questionsData?.top_answer?.reported = "Y"
                    }
                    binding.imageViewReportAnswer.isSelected =
                        questionsData?.top_answer?.reported == "Y"

                } else if (currentClickAnswerPosition != -1) {

                    if (answerList[currentClickAnswerPosition].reported == "Y") {
                        answerList[currentClickAnswerPosition].reported = "N"
                    } else {
                        answerList[currentClickAnswerPosition].reported = "Y"
                    }
                    engageAskAnExpertAnswersAdapter.notifyItemChanged(currentClickAnswerPosition)

                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //contentReportLiveData
        engageContentViewModel.contentReportLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (questionsData?.reported == "Y") {
                    questionsData?.reported = "N"
                } else {
                    questionsData?.reported = "Y"
                }
                binding.imageViewReportQuestion.isSelected = questionsData?.reported == "Y"
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

        //questionDeleteLiveData
        engageContentViewModel.questionDeleteLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //answerDeleteLiveData
        engageContentViewModel.answerDeleteLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                /*if (isTopAnswerOption) {
                    questionDetail()
                } else {
                    answerList.removeAt(currentClickAnswerPosition)
                    engageAskAnExpertAnswersAdapter.notifyItemRemoved(currentClickAnswerPosition)
                }*/
                questionDetail()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //updateBookmarksQuestionLiveData
        engageContentViewModel.updateBookmarksQuestionLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(questionsData: QuestionsData) {
        if (isAdded) {
            this.questionsData = questionsData
            questionsData.let {
                analytics.logEvent(analytics.USER_VIEW_QUESTION, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_MASTER_ID, it.content_master_id)
                }, screenName = AnalyticsScreenNames.QuestionDetails)
                with(binding) {

                    textViewQuestion.text = it.title
                    textViewQuestionTime.text = it.formattedQuestionTime

                    imageViewBookmark.isSelected = it.bookmarked == "Y"
                    imageViewReportQuestion.isSelected = it.reported == "Y"

                    imageViewLikeAnswer.isSelected = it.top_answer?.liked == "Y"
                    imageViewReportAnswer.isSelected = it.top_answer?.reported == "Y"

                    textViewLikeCount.text = it.top_answer?.likeCount.kFormat()
                    textViewCommentCount.text = it.top_answer?.commentCount.kFormat()

                    imageViewReportQuestion.isVisible = it.updated_by != session.userId
                    imageViewOptionMenuQuestion.isVisible = it.updated_by == session.userId
                    imageViewOptionMenuTopAns.isVisible =
                        it.top_answer?.patient_id == session.userId
                    imageViewReportAnswer.isVisible =
                        it.top_answer?.patient_id != session.userId

                    if (it.top_answer?.user_type == Common.AnswerUserType.PATIENT
                        || it.top_answer?.user_type == Common.AnswerUserType.ADMIN
                    ) {
                        textViewTagDoctorOrHc.isVisible = false
                    } else {
                        textViewTagDoctorOrHc.isVisible = true
                        textViewTagDoctorOrHc.text = it.top_answer?.user_title ?: ""
                    }
                    /*when (it.top_answer?.user_type ?: "") {
                        Common.AnswerUserType.ADMIN -> {
                            textViewTagDoctorOrHc.isVisible = true
                            textViewTagDoctorOrHc.text = it.top_answer?.user_title ?: ""
                        }
                        Common.AnswerUserType.HEALTHCOACH -> {
                            textViewTagDoctorOrHc.isVisible = true
                            textViewTagDoctorOrHc.text = it.top_answer?.user_title ?: ""
                        }
                        Common.AnswerUserType.PATIENT -> {
                            textViewTagDoctorOrHc.isVisible = false
                        }
                        else -> {
                            textViewTagDoctorOrHc.isVisible = false
                        }
                    }*/

                    textViewAnsGivenBy.text =
                        it.top_answer?.ansGivenBy(session.userId)?.plus(" (Top Answer)")
                    textViewTopAnsTime.text = it.formattedTopAnsTime
                    textViewTopAns.text = it.top_answer?.comment
                    textViewAnsCount.text = it.total_answers.plus(" Answers")

                    layoutTopAnswer.isVisible = !it.top_answer?.content_comments_id.isNullOrBlank()

                    //docs
                    documentList.clear()
                    it.documents?.let { it1 -> documentList.addAll(it1) }
                    engageAskAnExpertDocumentsAdapter.notifyDataSetChanged()

                    //topics
                    topicsList.clear()
                    it.topics?.let { it1 -> topicsList.addAll(it1) }
                    engageAskAnExpertTopicsAdapter.notifyDataSetChanged()
                }
            }
        }
    }
}