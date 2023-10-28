package com.mytatva.patient.ui.engage.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AnswerData
import com.mytatva.patient.data.pojo.response.QuestionTypeData
import com.mytatva.patient.data.pojo.response.QuestionsData
import com.mytatva.patient.data.pojo.response.TopicsData
import com.mytatva.patient.databinding.EngageFragmentAskAnExpertBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.adapter.EngageAskAnExpertAdapter
import com.mytatva.patient.ui.engage.adapter.EngageAskAnExpertAnswersAdapter
import com.mytatva.patient.ui.engage.adapter.EngageDiscoverTopicAdapter
import com.mytatva.patient.ui.engage.bottomsheet.ReportCommentBottomSheetDialog
import com.mytatva.patient.ui.engage.dialog.PostQuestionDialog
import com.mytatva.patient.ui.engage.dialog.SubmitAnswerDialog
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.listOfField
import java.util.*

class EngageAskAnExpertFragment : BaseFragment<EngageFragmentAskAnExpertBinding>() {

    var searchText: String = ""
    var isInsideSearch = false
    val topicList = arrayListOf<TopicsData>()

    private var filterIsShowRecommendedByDoctor: Boolean = false
    val engageDiscoverTopicAdapter by lazy {
        EngageDiscoverTopicAdapter(topicList,
            object : EngageDiscoverTopicAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    //update all selected in filter list
                    filterTopicsList.clear()
                    filterTopicsList.addAll(topicList.filter { it.isSelected })

                    resetPagingData()
                    questionList()
                }
            })
    }

    var currentClickQuePos = -1
    var currentClickAnsPos = -1

    private val questionsList = arrayListOf<QuestionsData>()
    private val engageAskAnExpertAdapter by lazy {
        EngageAskAnExpertAdapter(requireActivity() as BaseActivity,
            navigator,
            session.userId,
            questionsList,
            object : EngageAskAnExpertAdapter.AdapterListener {
                override fun openQuestionDetails(position: Int) {
                    currentClickQuePos = position
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        QuestionDetailsFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.CONTENT_ID,
                                questionsList[position].content_master_id)
                        )).start()
                }

                override fun onBookmarkClick(position: Int) {
                    currentClickQuePos = position
                    updateBookmarks()
                }

                override fun onReportQuestionClick(position: Int) {
                    currentClickQuePos = position
                    showReportQuestionDialog()
                }

                override fun onClickAnswerThis(position: Int) {
                    currentClickQuePos = position
                    showSubmitAnswerDialog(position)
                }

                override fun onReportAnsClick(position: Int) {
                    currentClickQuePos = position
                    if (questionsList[position].top_answer?.reported == "Y") {
                        /*questionsList[position].top_answer?.content_comments_id?.let {
                            reportAnswerComment(it, reported = "N")
                        }*/
                    } else if (questionsList[position].top_answer?.reported == "N") {
                        showReportCommentDialog(position, -1)
                    }
                }

                override fun onReadFullAnsOrCommentClick(position: Int) {
                    currentClickQuePos = position
                    questionsList[position].top_answer?.content_comments_id?.let {
                        handleOnCommentClick(questionsList[position].content_master_id ?: "", it)
                    }
                }

                override fun onLikeAnsClick(position: Int) {
                    currentClickQuePos = position
                    questionsList[position].top_answer?.content_comments_id?.let {
                        answerCommentUpdateLike(it, questionsList[position].top_answer?.liked ?: "")
                    }
                }

                override fun onOptionMenuClick(position: Int, isQuestion: Boolean) {
                    currentClickQuePos = position
                    handleOnOptionMenuClick(position, -1, isQuestion)
                }

            }, object : EngageAskAnExpertAnswersAdapter.AdapterListener {
                override fun onReportAnsClick(mainPosition: Int, position: Int) {
                    currentClickQuePos = mainPosition
                    currentClickAnsPos = position

                    if (questionsList[mainPosition].recent_answers?.get(position)?.reported == "Y") {
                        /*questionsList[mainPosition].recent_answers?.get(position)?.content_comments_id?.let {
                            reportAnswerComment(it, reported = "N")
                        }*/
                    } else if (questionsList[mainPosition].recent_answers?.get(position)?.reported == "N") {
                        showReportCommentDialog(mainPosition, position)
                    }
                }

                override fun onReadFullAnsOrCommentClick(mainPosition: Int, position: Int) {
                    currentClickQuePos = mainPosition
                    currentClickAnsPos = position
                    questionsList[mainPosition].recent_answers?.get(position)?.content_comments_id?.let {
                        handleOnCommentClick(questionsList[mainPosition].content_master_id ?: "",
                            it)
                    }
                }

                override fun onLikeAnswerClick(mainPosition: Int, position: Int) {
                    currentClickQuePos = mainPosition
                    currentClickAnsPos = position

                    questionsList[mainPosition].recent_answers?.get(position)?.content_comments_id?.let {
                        answerCommentUpdateLike(it,
                            questionsList[mainPosition].recent_answers?.get(position)?.liked ?: "")
                    }

                }

                override fun onAnswerOptionClick(mainPosition: Int, position: Int) {
                    currentClickQuePos = mainPosition
                    currentClickAnsPos = position
                    handleOnOptionMenuClick(mainPosition, position)
                }
            })
    }

    private fun handleOnOptionMenuClick(
        mainPosition: Int,
        subPosition: Int,
        isQuestion: Boolean = false,
    ) {
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
                                            questionsList[mainPosition].content_master_id?.let {
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
                                showUpdateQuestionDialog(mainPosition)
                            } else if (subPosition != -1) {//recent answer edit
                                showSubmitAnswerDialog(mainPosition,
                                    questionsList[mainPosition].recent_answers?.get(subPosition))
                            } else {//top answer edit
                                showSubmitAnswerDialog(mainPosition,
                                    questionsList[mainPosition].top_answer)
                            }
                        } else {//delete

                            navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                                dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                                    override fun onYesClick() {
                                        if (isQuestion) {//question delete
                                            questionsList[mainPosition].content_master_id?.let {
                                                questionDelete(it)
                                            }
                                        } else if (subPosition != -1) {//recent answer delete
                                            isTopAnswerAction = false
                                            questionsList[mainPosition].recent_answers?.get(
                                                subPosition)?.content_comments_id?.let {
                                                answerDelete(it)
                                            }
                                        } else {//top answer delete
                                            isTopAnswerAction = true
                                            questionsList[mainPosition].top_answer?.content_comments_id?.let {
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

    private fun showUpdateQuestionDialog(mainPosition: Int) {
        PostQuestionDialog(questionsList[mainPosition]).apply {
            //topicList.clear()
            //topicList.addAll(ArrayList(this@EngageAskAnExpertFragment.topicList).copyList())
            callback = {
                resetPagingData()
                questionList()
            }
        }.show(requireActivity().supportFragmentManager,
            PostQuestionDialog::class.java.simpleName)
    }

    private fun handleOnCommentClick(contentMasterId: String, answerId: String) {
        navigator.loadActivity(IsolatedFullActivity::class.java, AnswerCommentsFragment::class.java)
            .addBundle(bundleOf(
                Pair(Common.BundleKey.ANSWER_ID, answerId),
                Pair(Common.BundleKey.CONTENT_ID, contentMasterId)
            )).start()
    }

    private fun showSubmitAnswerDialog(
        position: Int,
        answerData: AnswerData? = null,// for edit answer
    ) {
        SubmitAnswerDialog(
            contentMasterId = questionsList[position].content_master_id,
            question = questionsList[position].title,
            answerData = answerData)
            .setCallback {
                questionsList[position] = it
                engageAskAnExpertAdapter.notifyItemChanged(position)
            }.show(requireActivity().supportFragmentManager,
                SubmitAnswerDialog::class.java.simpleName)
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

        isLastPage = false
    }

    private lateinit var engageContentViewModel: EngageContentViewModel/* by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }*/

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    // filter params
    //var filterTopicData: TopicsData? = null


    companion object {
        val filterTopicsList = ArrayList<TopicsData>()
        val filterQuestionTypeList = ArrayList<QuestionTypeData>()
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageFragmentAskAnExpertBinding {
        return EngageFragmentAskAnExpertBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        engageContentViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
        observeLiveData()
    }

    override fun onShow() {
        super.onShow()
    }

    var resumedTime = Calendar.getInstance().timeInMillis
    override fun onResume() {
        super.onResume()
        if (isAdded && (requireActivity() is HomeActivity) && (requireActivity() as HomeActivity).binding.layoutMyCircle.isSelected) {
            analytics.setScreenName(AnalyticsScreenNames.AskAnExpert)
        }
        resumedTime = Calendar.getInstance().timeInMillis
        Handler(Looper.getMainLooper()).postDelayed({
            resetPagingData()
            questionList()
        }, 250)
    }

    override fun onPause() {
        super.onPause()
        /*if (isAdded && (requireActivity() is HomeActivity) && (requireActivity() as HomeActivity).binding.layoutMyCircle.isSelected) {
            updateScreenTimeDurationInAnalytics()
        }*/
    }

    /*private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.USER_TIME_SPENT_ASK_EXPERT, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.AskAnExpert)
    }*/

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()
        topicList()

        with(binding) {
            if (isInsideSearch) {
                recyclerViewTopics.visibility = View.GONE
                textViewPostQuestion.visibility = View.GONE
            } else {
                recyclerViewTopics.visibility = View.VISIBLE
                textViewPostQuestion.visibility = View.VISIBLE
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewTopics.apply {
                layoutManager =
                    LinearLayoutManager(requireActivity(), RecyclerView.HORIZONTAL, false)
                adapter = engageDiscoverTopicAdapter
            }

            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewAskAnExpert.apply {
                layoutManager = linearLayoutManager
                adapter = engageAskAnExpertAdapter
            }

            recyclerViewAskAnExpert.addOnScrollListener(object :
                PaginationScrollListener(linearLayoutManager!!) {
                override fun isLastPage(): Boolean {
                    return isLastPage
                }

                override fun isLoading(): Boolean {
                    return isLoading
                }

                override fun loadMoreItems() {
                    isLoading = true
                    //you have to call load more items to get more data
                    page++
                    questionList()
                }

                override fun isScrolledDown(isScrolledDown: Boolean) {
                    if (isScrolledDown && imageViewScrollUp.visibility != View.VISIBLE) {
                        imageViewScrollUp.visibility = View.VISIBLE
                    } else if (isScrolledDown.not() && imageViewScrollUp.visibility != View.GONE) {
                        imageViewScrollUp.visibility = View.GONE
                    }
                }
            })
        }
    }

    var isLastPage: Boolean = false
    //var isLoading: Boolean = false

    private fun setViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                questionList()
                if (topicList.isEmpty()) {
                    topicList()
                }
            }
            imageViewScrollUp.setOnClickListener { onViewClick(it) }
            textViewPostQuestion.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewScrollUp -> {
                binding.recyclerViewAskAnExpert.scrollToPosition(0)
            }
            R.id.textViewPostQuestion -> {
                PostQuestionDialog().apply {
                    //topicList.clear()
                    //topicList.addAll(ArrayList(this@EngageAskAnExpertFragment.topicList).copyList())
                    callback = {
                        resetPagingData()
                        questionList()
                    }
                }.show(requireActivity().supportFragmentManager,
                    PostQuestionDialog::class.java.simpleName)
            }
        }
    }

    //filter callback from filter bottom sheet
    @SuppressLint("NotifyDataSetChanged")
    fun updateFilters(
        topicsList: ArrayList<TopicsData>,
        contentTypeList: ArrayList<QuestionTypeData>,
        isShowRecommendedByDoctor: Boolean,
    ) {
        filterQuestionTypeList.clear()
        filterQuestionTypeList.addAll(contentTypeList)

        filterTopicsList.clear()
        filterTopicsList.addAll(topicsList)

        filterIsShowRecommendedByDoctor = isShowRecommendedByDoctor

        topicList.forEachIndexed { index, topicsData ->
            topicList[index].isSelected =
                filterTopicsList.any { it.topic_master_id == topicList[index].topic_master_id }
        }
        engageDiscoverTopicAdapter.notifyDataSetChanged()

        resetPagingData()
        questionList()
    }

    //private var currentClickAnswerPosition = -1
    private var isTopAnswerAction = false
    private fun showReportCommentDialog(mainPos: Int, subPos: Int) {
        requireActivity().supportFragmentManager.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->
                if (subPos == -1) {
                    // for top answer report
                    isTopAnswerAction = true
                    questionsList[mainPos].top_answer?.content_comments_id?.let { it1 ->
                        reportAnswerComment(it1,
                            reported = "Y",
                            reportDesc,
                            reportType)
                    }
                } else {
                    // answer report from answer list
                    isTopAnswerAction = false
                    questionsList[mainPos].recent_answers?.get(subPos)?.content_comments_id?.let { it1 ->
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

        if (questionsList[currentClickQuePos].reported == "Y") {
            /*questionsList[currentClickQuePos].content_master_id?.let { it1 ->
                contentReport(it1, "N")
            }*/
        } else if (questionsList[currentClickQuePos].reported == "N") {
            requireActivity().supportFragmentManager.let {
                ReportCommentBottomSheetDialog { reportType, reportDesc ->
                    questionsList[currentClickQuePos].content_master_id?.let { it1 ->
                        contentReport(it1, "Y", reportType, reportDesc)
                    }
                }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
            }
        }

    }

    fun doSearch(searchText: String) {
        resetPagingData()
        this.searchText = searchText
        questionList()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun topicList() {
        /*val apiRequest = ApiRequest()
        engageContentViewModel.topicList(apiRequest)*/
    }

    private fun questionList() {
        val apiRequest = ApiRequest().apply {
            page = this@EngageAskAnExpertFragment.page.toString()
            if (filterTopicsList.isNullOrEmpty().not()) {
                topic_ids = filterTopicsList.listOfField(TopicsData::topic_master_id)
            }

            if (filterQuestionTypeList.isNullOrEmpty().not()) {
                question_types = filterQuestionTypeList.listOfField(QuestionTypeData::value)
            }

            //filter_by_words = ""
            //ask_by_you = "N"

            if (isInsideSearch && searchText.isNotBlank()) {
                search = searchText
            }
        }
        //showLoader()
        engageContentViewModel.questionList(apiRequest)
    }

    private fun contentReport(
        contentMasterId: String,
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
        engageContentViewModel.answerCommentUpdateLike(apiRequest, analytics, screenName = AnalyticsScreenNames.AskAnExpert)
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
            content_master_id = questionsList[currentClickQuePos].content_master_id
            is_active = questionsList[currentClickQuePos].bookmarked
        }
        engageContentViewModel.updateBookmarksQuestion(apiRequest, analytics, screenName = AnalyticsScreenNames.AskAnExpert)
    }

    private var retryTopicListCounter = 0

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        /*//topicListLiveData
        engageContentViewModel.topicListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                topicList.clear()
                responseBody.data?.let { topicList.addAll(it) }
                engageDiscoverTopicAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                if (retryTopicListCounter < 3) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        topicList()
                    }, 100)
                    retryTopicListCounter++
                    topicList()
                }
                false
            })*/

        //questionListLiveData
        engageContentViewModel.questionListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                isLoading = false
                if (page == 1) {
                    questionsList.clear()
                }
                responseBody.data?.let { questionsList.addAll(it) }
                engageAskAnExpertAdapter.notifyDataSetChanged()

                /*if (feedList.isNotEmpty()) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        onCoachMarkFinish?.let {
                            showCoachMark(it)
                        }
                    }, 200)
                }*/

                with(binding) {
                    textViewNoData.visibility = View.GONE
                    recyclerViewAskAnExpert.visibility = View.VISIBLE
                }
            },
            onError = { throwable ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                isLoading = false
                isLastPage = true
                if (page == 1 && throwable is ServerException
                    && throwable.message?.contains("timeout")?.not() == true
                ) {
                    questionsList.clear()
                    engageAskAnExpertAdapter.notifyDataSetChanged()
                    with(binding) {
                        textViewNoData.text = throwable.message
                        textViewNoData.visibility = View.VISIBLE
                        recyclerViewAskAnExpert.visibility = View.GONE
                    }
                }
                false
            })

        //contentReportLiveData
        engageContentViewModel.contentReportLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickQuePos != -1) {
                    if (questionsList[currentClickQuePos].reported == "Y") {
                        questionsList[currentClickQuePos].reported = "N"
                    } else {
                        questionsList[currentClickQuePos].reported = "Y"
                    }
                    engageAskAnExpertAdapter.notifyItemChanged(currentClickQuePos)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //reportAnswerCommentLiveData
        engageContentViewModel.reportAnswerCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (isTopAnswerAction) {

                    if (questionsList[currentClickQuePos].top_answer?.reported == "Y") {
                        questionsList[currentClickQuePos].top_answer?.reported = "N"
                    } else {
                        questionsList[currentClickQuePos].top_answer?.reported = "Y"
                    }
                    engageAskAnExpertAdapter.notifyItemChanged(currentClickQuePos)

                } else if (currentClickAnsPos != -1) {

                    if (questionsList[currentClickQuePos].recent_answers?.get(currentClickAnsPos)?.reported == "Y") {
                        questionsList[currentClickQuePos].recent_answers?.get(currentClickAnsPos)?.reported =
                            "N"
                    } else {
                        questionsList[currentClickQuePos].recent_answers?.get(currentClickAnsPos)?.reported =
                            "Y"
                    }
                    engageAskAnExpertAdapter.notifyItemChanged(currentClickQuePos)

                }
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
                questionsList.removeAt(currentClickQuePos)
                engageAskAnExpertAdapter.notifyItemRemoved(currentClickQuePos)
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //answerDeleteLiveData
        engageContentViewModel.answerDeleteLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                resetPagingData()
                questionList()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //updateBookmarksQuestionLiveData
        engageContentViewModel.updateBookmarksQuestionLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                /*if (currentClickFeedPosition != -1 && feedList.size > currentClickFeedPosition) {
                    if (feedList[currentClickFeedPosition].bookmarked == "Y")
                        feedList[currentClickFeedPosition].bookmarked = "N"
                    else
                        feedList[currentClickFeedPosition].bookmarked = "Y"
                }*/
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