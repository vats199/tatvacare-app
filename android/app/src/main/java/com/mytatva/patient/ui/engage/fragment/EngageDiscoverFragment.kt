package com.mytatva.patient.ui.engage.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.model.CoachMarkPage
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.databinding.EngageFragmentDiscoverBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.adapter.EngageDiscoverFeedAdapter
import com.mytatva.patient.ui.engage.adapter.EngageDiscoverFeedCommentsAdapter
import com.mytatva.patient.ui.engage.adapter.EngageDiscoverTopicAdapter
import com.mytatva.patient.ui.engage.bottomsheet.ReportCommentBottomSheetDialog
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.listOfField
import com.mytatva.patient.utils.openBrowser
import com.mytatva.patient.utils.shareText
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.config.Gravity
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener
import java.util.*
import java.util.concurrent.TimeUnit

class EngageDiscoverFragment : BaseFragment<EngageFragmentDiscoverBinding>() {

    var searchText: String = ""
    var isInsideSearch = false
    var isSearchInit = false

    private var selectedLanguageData: LanguageData? = null
    private val languageList = arrayListOf<LanguageData>()

    val topicList = arrayListOf<TopicsData>()

    private var filterIsShowRecommendedByDoctor: Boolean = false
    val engageDiscoverTopicAdapter by lazy {
        EngageDiscoverTopicAdapter(topicList, object : EngageDiscoverTopicAdapter.AdapterListener {
            override fun onClick(position: Int) {

                //clear all filters and set only topic filter
                /*filterLanguageList.clear()
                filterGenresList.clear()
                filterTopicsList.clear()
                filterContentTypeList.clear()*/

                //update all selected in filter list
                filterTopicsList.clear()
                filterTopicsList.addAll(topicList.filter { it.isSelected })

                //filterTopicData = topicList[position]

                resetPagingData()
                contentList()

            }
        })
    }

    private var postCommentStatusCallback: ((isSuccess: Boolean) -> Unit)? = null
    private val feedList = arrayListOf<ContentData>()
    private val engageDiscoverFeedAdapter by lazy {
        EngageDiscoverFeedAdapter(requireActivity() as BaseActivity,
            navigator,
            session.userId,
            feedList,
            firebaseConfigUtil,
            object : EngageDiscoverFeedAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    if (position >= 0 && position < feedList.size) {

                        analytics.logEvent(analytics.USER_CLICKED_ON_CARD, Bundle().apply {
                            putString(
                                analytics.PARAM_CONTENT_MASTER_ID,
                                feedList[position].content_master_id
                            )
                            putString(analytics.PARAM_CONTENT_TYPE, feedList[position].content_type)
                        }, screenName = AnalyticsScreenNames.DiscoverEngage)

                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            EngageFeedDetailsFragment::class.java
                        )
                            .addBundle(
                                bundleOf(
                                    Pair(
                                        Common.BundleKey.CONTENT_TYPE,
                                        feedList[position].content_type
                                    ),
                                    Pair(
                                        Common.BundleKey.CONTENT_ID,
                                        feedList[position].content_master_id
                                    )
                                )
                            ).start()

                    }
                }

                override fun onViewAllCommentsClick(position: Int) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        CommentsFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.CONTENT_ID,
                                    feedList[position].content_master_id
                                ),
                                Pair(Common.BundleKey.CONTENT_TYPE, feedList[position].content_type)
                            )
                        )
                        .start()
                }

                override fun onLikeClick(position: Int) {
                    currentClickFeedPosition = position
                    updateLikes()
                }

                override fun onBookmarkClick(position: Int) {
                    currentClickFeedPosition = position
                    updateBookmarks()
                }

                override fun onShareClick(position: Int) {
                    feedList[position].getShareText.let {
                        analytics.logEvent(analytics.USER_SHARED_CONTENT, Bundle().apply {
                            putString(
                                analytics.PARAM_CONTENT_MASTER_ID,
                                feedList[position].content_master_id
                            )
                            putString(analytics.PARAM_CONTENT_TYPE, feedList[position].content_type)
                        })
                        requireActivity().shareText(it)
                    }
                }

                override fun onPostCommentClick(
                    position: Int,
                    comment: String,
                    postCommentStatusCallback: (isSuccess: Boolean) -> Unit,
                ) {
                    hideKeyBoard()
                    this@EngageDiscoverFragment.postCommentStatusCallback =
                        postCommentStatusCallback
                    currentClickFeedPosition = position
                    feedList[position].content_master_id?.let {
                        updateComment(it, comment)
                    }
                }

                override fun onBookSeatClick(position: Int) {
                    requireActivity().openBrowser(URLFactory.AppUrls.WEBINAR_BOOK_SEAT)
                }
            },
            object : EngageDiscoverFeedCommentsAdapter.AdapterListener {
                override fun onReportClick(mainItemPosition: Int, position: Int) {
                    currentClickFeedPosition = mainItemPosition
                    currentClickFeedCommentPosition = position

                    if (feedList[mainItemPosition].comment?.comment_data!![position].reported == "Y") {

                        reportComment(
                            contentMasterId = feedList[mainItemPosition].content_master_id
                                ?: "",
                            commentId = feedList[mainItemPosition].comment?.comment_data!![position].content_comments_id
                                ?: "",
                            reported = "N"
                        )

                    } else {
                        showReportCommentDialog(mainItemPosition, position)
                    }
                }

                override fun onDeleteClick(mainItemPosition: Int, position: Int) {
                    feedList[mainItemPosition].comment?.comment_data!![position].content_comments_id?.let {

                        currentClickFeedPosition = mainItemPosition
                        currentClickFeedCommentPosition = position

                        removeComment(it)

                    }
                }
            })
    }

    var currentClickFeedPosition = -1
    var currentClickFeedCommentPosition = -1

    private fun showReportCommentDialog(mainItemPosition: Int, position: Int) {
        activity?.supportFragmentManager?.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->

                feedList[mainItemPosition].comment?.comment_data?.let { commentList ->
                    if (commentList.isNotEmpty()) {
                        reportComment(
                            contentMasterId = feedList[mainItemPosition].content_master_id
                                ?: "",
                            commentId = feedList[mainItemPosition].comment?.comment_data!![position].content_comments_id
                                ?: "",
                            reported = "Y",
                            reportType,
                            reportDesc
                        )
                    }
                }

            }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
        }
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

    private var engageContentViewModel: EngageContentViewModel? = null/* by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }*/

    private var authViewModel: AuthViewModel? = null/* by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }*/

    // filter params
    //var filterTopicData: TopicsData? = null


    companion object {
        val filterLanguageList = ArrayList<LanguageData>()
        val filterGenresList = ArrayList<GenreData>()
        val filterTopicsList = ArrayList<TopicsData>()
        val filterContentTypeList = ArrayList<ContentTypeData>()
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageFragmentDiscoverBinding {
        return EngageFragmentDiscoverBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        engageContentViewModel =
            ViewModelProvider(this, viewModelFactory)[EngageContentViewModel::class.java]
        authViewModel = ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
        observeLiveData()
    }

    override fun onShow() {
        super.onShow()
    }

    var resumedTime = Calendar.getInstance().timeInMillis
    override fun onResume() {
        super.onResume()
        if (isAdded && (requireActivity() is HomeActivity) && (requireActivity() as HomeActivity).binding.layoutMyCircle.isSelected) {
            analytics.setScreenName(AnalyticsScreenNames.DiscoverEngage)
        }
        resumedTime = Calendar.getInstance().timeInMillis

        Handler(Looper.getMainLooper()).postDelayed({
            resetPagingData()
            if (selectedLanguageData == null) {
                contentLanguageList()
            } else {
                contentList()
            }
        }, 250)
    }

    override fun onPause() {
        super.onPause()
        if (isAdded && (requireActivity() is HomeActivity) && (requireActivity() as HomeActivity).binding.layoutMyCircle.isSelected) {
            updateScreenTimeDurationInAnalytics()
        }
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.USER_TIME_SPENT_ENGAGE, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.DiscoverEngage)*/
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()
        topicList()

        with(binding) {
            if (isInsideSearch) {
                recyclerViewTopics.visibility = View.GONE
                layoutSelectLanguage.visibility = View.GONE
            } else {
                recyclerViewTopics.visibility = View.VISIBLE
                if (isFeatureAllowedAsPerPlan(
                        PlanFeatures.engage_article_selection_of_language,
                        needToShowDialog = false
                    )
                ) {
                    layoutSelectLanguage.visibility = View.VISIBLE
                } else {
                    layoutSelectLanguage.visibility = View.GONE
                }
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {

            /*val listener = object : RecyclerView.OnItemTouchListener {
                override fun onInterceptTouchEvent(rv: RecyclerView, e: MotionEvent): Boolean {
                    val action = e.action
                    if (recyclerViewTopics.canScrollHorizontally(RecyclerView.FOCUS_FORWARD)) {
                        when (action) {
                            MotionEvent.ACTION_MOVE -> rv.parent
                                .requestDisallowInterceptTouchEvent(true)
                        }
                        return false
                    }
                    else {
                        when (action) {
                            MotionEvent.ACTION_MOVE -> rv.parent
                                .requestDisallowInterceptTouchEvent(false)
                        }
                        recyclerViewTopics.removeOnItemTouchListener(this)
                        return true
                    }
                }
                override fun onTouchEvent(rv: RecyclerView, e: MotionEvent) {}
                override fun onRequestDisallowInterceptTouchEvent(disallowIntercept: Boolean) {}
            }
            recyclerViewTopics.addOnItemTouchListener(listener)*/

            recyclerViewTopics.apply {
                layoutManager =
                    LinearLayoutManager(requireActivity(), RecyclerView.HORIZONTAL, false)
                adapter = engageDiscoverTopicAdapter
            }

            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewFeed.apply {
                layoutManager = linearLayoutManager
                adapter = engageDiscoverFeedAdapter
            }

            //linearLayoutManager?.findViewByPosition(0)

            /*recyclerViewFeed.addOnScrollListener(object : RecyclerView.OnScrollListener() {
                override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {

                }

                override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                    if (linearLayoutManager?.findFirstCompletelyVisibleItemPosition() == 0) {
                        imageViewScrollUp.visibility = View.GONE
                    } else {
                        imageViewScrollUp.visibility = View.VISIBLE
                    }

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
                    if (!isLoading && totalItemCount - visibleItemCount <= pastVisibleItems + 1) {
                        // End has been reached
                        page++
                        isLoading = true
                        contentList()
                    }
                }
            })*/

            recyclerViewFeed.addOnScrollListener(object :
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
                    contentList()
                }

                override fun isScrolledDown(isScrolledDown: Boolean) {
                    if (isScrolledDown && imageViewScrollUp.visibility != View.VISIBLE) {
                        /*TransitionManager.beginDelayedTransition(root, ChangeBounds().apply {
                            interpolator = AccelerateDecelerateInterpolator()
                            duration = 1000
                        })*/
                        imageViewScrollUp.visibility = View.VISIBLE
                    } else if (isScrolledDown.not() && imageViewScrollUp.visibility != View.GONE) {
                        /*TransitionManager.beginDelayedTransition(root, ChangeBounds().apply {
                            interpolator = AccelerateDecelerateInterpolator()
                            duration = 1000
                        })*/
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
                contentList()
                if (topicList.isEmpty()) {
                    topicList()
                }
            }
            imageViewScrollUp.setOnClickListener { onViewClick(it) }
            textViewLanguage.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewScrollUp -> {
                binding.recyclerViewFeed.scrollToPosition(0)
            }

            R.id.textViewLanguage -> {
                BottomSheet<LanguageData>().showBottomSheetDialog(requireActivity(),
                    languageList,
                    "",
                    object : BottomSheetAdapter.ItemListener<LanguageData> {
                        override fun onItemClick(item: LanguageData, position: Int) {
                            selectedLanguageData = item
                            updateLanguageLabelAndCallAPI()
                        }

                        override fun onBindViewHolder(
                            holder: BottomSheetAdapter<LanguageData>.MyViewHolder,
                            position: Int,
                            item: LanguageData,
                        ) {
                            holder.textView.text = item.language_name
                        }
                    })
            }
        }
    }

    //filter callback from filter bottom sheet
    @SuppressLint("NotifyDataSetChanged")
    fun updateFilters(
        languageList: ArrayList<LanguageData>,
        genresList: ArrayList<GenreData>,
        topicsList: ArrayList<TopicsData>,
        contentTypeList: ArrayList<ContentTypeData>,
        isShowRecommendedByDoctor: Boolean,
    ) {

        //clear common filter topic data, when any other filter applied
        /*filterTopicData = null
        engageDiscoverTopicAdapter.selectedPos = -1
        engageDiscoverTopicAdapter.notifyDataSetChanged()*/

        filterLanguageList.clear()
        filterLanguageList.addAll(languageList)
        filterGenresList.clear()
        filterGenresList.addAll(genresList)
        filterContentTypeList.clear()
        filterContentTypeList.addAll(contentTypeList)

        filterTopicsList.clear()
        filterTopicsList.addAll(topicsList)

        filterIsShowRecommendedByDoctor = isShowRecommendedByDoctor

        topicList.forEachIndexed { index, topicsData ->
            topicList[index].isSelected =
                filterTopicsList.any { it.topic_master_id == topicList[index].topic_master_id }
        }
        engageDiscoverTopicAdapter.notifyDataSetChanged()

        resetPagingData()
        contentList()
    }

    var onCoachMarkFinish: (() -> Unit)? = null
    fun showCoachMark(onFinish: () -> Unit) {

        if (feedList.isNotEmpty()) {

            onCoachMarkFinish = null

            binding.recyclerViewFeed.scrollToPosition(0)

            Handler(Looper.getMainLooper()).postDelayed({
                var mGuideView: GuideView? = null
                var builder: GuideView.Builder? = null
                val targetView = linearLayoutManager?.findViewByPosition(0)
                builder = GuideView.Builder(requireActivity())
                    .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.ENGAGE_DISCOVER.pageKey))
                    .setButtonText("Next").setGravity(Gravity.auto)
                    /*.setDismissType(DismissType.outside)*/.setTargetView(targetView)
                    .setGuideListener(object : GuideListener {
                        override fun onDismiss(view: View?) {
                        }

                        override fun onSkip() {
                            showSkipCoachMarkMessage()
                        }

                        override fun onNext(view: View) {
                            when (view.id) {
                                targetView?.id -> {
                                    onFinish.invoke()
                                }
                            }

                        }
                    })

                mGuideView = builder?.build()
                mGuideView?.show()

            }, 200)

        } else {
            onCoachMarkFinish = onFinish
        }
    }

    fun doSearch(searchText: String) {
        isSearchInit = true
        resetPagingData()
        this.searchText = searchText
        contentList()
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


    private fun contentList() {
        val apiRequest = ApiRequestSubData().apply {
            page = this@EngageDiscoverFragment.page.toString()

            /*if (filterTopicData?.topic_master_id.isNullOrBlank().not()) {
                *//*topic_ids = arrayListOf(filterTopicData?.topic_master_id ?: "")*//*
                filterTopicsList.clear()
                filterTopicsList.add(filterTopicData!!)
            }*/

            // optional filter params
            /*if (filterLanguageList.isNullOrEmpty().not()) {
                languages_id = filterLanguageList.listOfField(LanguageData::languages_id)
            }*/
            selectedLanguageData?.languages_id?.let {
                languages_id = arrayListOf(it)
            }

            if (filterGenresList.isNullOrEmpty().not()) {
                genre_ids = filterGenresList.listOfField(GenreData::genre_master_id)
            }
            if (filterTopicsList.isNullOrEmpty().not()) {
                topic_ids = filterTopicsList.listOfField(TopicsData::topic_master_id)
            }
            if (filterContentTypeList.isNullOrEmpty().not()) {
                content_types = filterContentTypeList.listOfField(ContentTypeData::keys)
            }

            //if (filterIsShowRecommendedByDoctor) {
            recommended_health_doctor = filterIsShowRecommendedByDoctor
            //}

            if (isInsideSearch && searchText.isNotBlank()) {
                search = searchText
            }

        }
        if (isAdded) {
            Log.d("API_CALL", "contentList: $page")
            if (page == 1 && isInsideSearch.not()) {
                binding.swipeRefreshLayout.isRefreshing = true
            }
            engageContentViewModel?.contentList(apiRequest)
        }
    }

    private fun updateBookmarks() {
        val apiRequest = ApiRequest().apply {
            content_master_id = feedList[currentClickFeedPosition].content_master_id
            is_active = if (feedList[currentClickFeedPosition].bookmarked == "Y") "N" else "Y"
        }
        engageContentViewModel?.updateBookmarks(
            apiRequest,
            analytics,
            feedList[currentClickFeedPosition].content_type,
            screenName = AnalyticsScreenNames.DiscoverEngage
        )
    }

    private fun updateLikes() {
        val apiRequest = ApiRequest().apply {
            content_master_id = feedList[currentClickFeedPosition].content_master_id
            is_active = feedList[currentClickFeedPosition].liked
            //if (feedList[currentClickFeedPosition].liked == "Y") "N" else "Y"
        }
        engageContentViewModel?.updateLikes(
            apiRequest,
            analytics,
            feedList[currentClickFeedPosition].content_type,
            screenName = AnalyticsScreenNames.DiscoverEngage
        )
    }

    private fun reportComment(
        contentMasterId: String,
        commentId: String,
        reported: String,
        reportType: String? = null,
        commentDesc: String? = null,
    ) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            content_comments_id = commentId
            this.reported = reported
            if (commentDesc.isNullOrBlank().not()) {
                description = commentDesc
            }
            //S - Spam, I - Inappropriate, F - False information
            report_type = reportType
        }
        engageContentViewModel?.reportComment(apiRequest)
    }

    private fun updateComment(contentMasterId: String, commentStr: String) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            /*content_comments_id = ""*/
            comment = commentStr
        }
        showLoader()
        engageContentViewModel?.updateComment(apiRequest)
    }

    private fun removeComment(commentId: String) {
        val apiRequest = ApiRequest().apply {
            content_comments_id = commentId
        }
        showLoader()
        engageContentViewModel?.removeComment(
            apiRequest,
            screenName = AnalyticsScreenNames.DiscoverEngage
        )
    }

    private fun contentLanguageList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel?.contentLanguageList(apiRequest)
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

        //contentListLiveData
        engageContentViewModel?.contentListLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            binding.swipeRefreshLayout.isRefreshing = false
            isLoading = false
            if (page == 1) {
                feedList.clear()
            }
            responseBody.data?.let { feedList.addAll(it) }
            engageDiscoverFeedAdapter.notifyDataSetChanged()

            if (feedList.isNotEmpty()) {
                //binding.recyclerViewFeed.scrollToPosition(0)
                Handler(Looper.getMainLooper()).postDelayed({
                    onCoachMarkFinish?.let {
                        showCoachMark(it)
                    }
                }, 200)
            }

            with(binding) {
                textViewNoData.visibility = View.GONE
                recyclerViewFeed.visibility = View.VISIBLE
            }

            if (isSearchInit) {
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

        }, onError = { throwable ->
            hideLoader()
            binding.swipeRefreshLayout.isRefreshing = false
            isLoading = false
            isLastPage = true
            if (page == 1 && throwable is ServerException && throwable.message?.contains("timeout")
                    ?.not() == true
            ) {
                feedList.clear()
                engageDiscoverFeedAdapter.notifyDataSetChanged()
                with(binding) {
                    textViewNoData.text = throwable.message
                    textViewNoData.visibility = View.VISIBLE
                    recyclerViewFeed.visibility = View.GONE
                }
            }
            false
        })

        //updateBookmarksLiveData
        engageContentViewModel?.updateBookmarksLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            if (currentClickFeedPosition != -1 && feedList.size > currentClickFeedPosition) {
                if (feedList[currentClickFeedPosition].bookmarked == "Y") feedList[currentClickFeedPosition].bookmarked =
                    "N"
                else feedList[currentClickFeedPosition].bookmarked = "Y"

                //engageDiscoverFeedAdapter.notifyItemChanged(currentClickFeedPosition)
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //updateLikesLiveData
        engageContentViewModel?.updateLikesLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            /*if (currentClickFeedPosition != -1 && feedList.size > currentClickFeedPosition) {
                if (feedList[currentClickFeedPosition].liked == "Y")
                    feedList[currentClickFeedPosition].liked = "N"
                else
                    feedList[currentClickFeedPosition].liked = "Y"

                //engageDiscoverFeedAdapter.notifyItemChanged(currentClickFeedPosition)
            }*/
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //reportCommentLiveData
        engageContentViewModel?.reportCommentLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            onReportCommentSuccess()
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //updateCommentLiveData
        engageContentViewModel?.updateCommentLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            // update comment data in feed item
            if (currentClickFeedPosition != -1 && feedList.size > currentClickFeedPosition) {
                feedList[currentClickFeedPosition].comment?.comment_data?.clear()
                responseBody.data?.comment?.comment_data?.let {
                    if (feedList[currentClickFeedPosition].comment?.comment_data.isNullOrEmpty()) {
                        feedList[currentClickFeedPosition].comment?.comment_data = ArrayList()
                    }
                    feedList[currentClickFeedPosition].comment?.comment_data?.addAll(it)
                }
                feedList[currentClickFeedPosition].comment?.total =
                    responseBody.data?.comment?.total

                engageDiscoverFeedAdapter.notifyItemChanged(
                    currentClickFeedPosition,
                    "updateComment"
                )

                analytics.logEvent(analytics.USER_COMMENTED, Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        feedList[currentClickFeedPosition].content_master_id
                    )
                    putString(
                        analytics.PARAM_CONTENT_TYPE,
                        feedList[currentClickFeedPosition].content_type
                    )
                }, screenName = AnalyticsScreenNames.DiscoverEngage)
                postCommentStatusCallback?.invoke(true)
            }
        }, onError = { throwable ->
            hideLoader()
            postCommentStatusCallback?.invoke(false)
            true
        })

        //removeCommentLiveData
        engageContentViewModel?.removeCommentLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let { onRemoveCommentSuccess(it) }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //contentLanguageListLiveData
        authViewModel?.contentLanguageListLiveData?.observe(this, onChange = { responseBody ->
            hideLoader()
            languageList.clear()
            responseBody.data?.let { languageList.addAll(it) }
            selectedLanguageData = languageList.firstOrNull()
            updateLanguageLabelAndCallAPI()
        }, onError = { throwable ->
            hideLoader()
            updateLanguageLabelAndCallAPI()
            false
        })
    }

    private fun updateLanguageLabelAndCallAPI() {
        with(binding) {
            textViewLanguage.text = selectedLanguageData?.language_name ?: ""
        }
        resetPagingData()
        contentList()
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    private fun onReportCommentSuccess() {
        try {
            var reportedStatus = ""
            if (currentClickFeedPosition != -1 && currentClickFeedCommentPosition != -1) {
                reportedStatus =
                    if (feedList[currentClickFeedPosition].comment?.comment_data!![currentClickFeedCommentPosition].reported == "Y") "N"
                    else "Y"

                feedList[currentClickFeedPosition].comment?.comment_data!![currentClickFeedCommentPosition].reported =
                    reportedStatus

                engageDiscoverFeedAdapter.notifyItemChanged(currentClickFeedPosition)

                if (currentClickFeedPosition != -1 && feedList.size > currentClickFeedPosition) {
                    analytics.logEvent(
                        if (reportedStatus == "Y") analytics.USER_REPORTED_COMMENT
                        else analytics.USER_UN_REPORTED_COMMENT, Bundle().apply {
                            putString(
                                analytics.PARAM_CONTENT_MASTER_ID,
                                feedList[currentClickFeedPosition].content_master_id
                            )
                            putString(
                                analytics.PARAM_CONTENT_TYPE,
                                feedList[currentClickFeedPosition].content_type
                            )
                        }, screenName = AnalyticsScreenNames.ReportComment
                    )
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun onRemoveCommentSuccess(contentData: ContentData) {
        try {
            if (currentClickFeedPosition != -1 && currentClickFeedCommentPosition != -1) {
                feedList[currentClickFeedPosition].comment?.comment_data?.clear()
                contentData?.comment?.comment_data?.let {
                    feedList[currentClickFeedPosition].comment?.comment_data?.addAll(it)
                }
                feedList[currentClickFeedPosition].comment?.total = contentData.comment?.total
                engageDiscoverFeedAdapter.notifyItemChanged(currentClickFeedPosition)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}