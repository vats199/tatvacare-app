package com.mytatva.patient.ui.exercise

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
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.CoachMarkPage
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.ExerciseFilterCommonData
import com.mytatva.patient.data.pojo.response.ExerciseMainData
import com.mytatva.patient.databinding.ExerciseFragmentMoreBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.adapter.ExerciseMoreAdapter
import com.mytatva.patient.ui.exercise.adapter.ExerciseMoreSubAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.listOfField
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.config.Gravity
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener
import java.util.*
import java.util.concurrent.TimeUnit

class ExerciseMoreFragment : BaseFragment<ExerciseFragmentMoreBinding>() {
    var searchText: String = ""
    var isInsideSearch = false
    private val moreExerciseList = arrayListOf<ExerciseMainData>()

    private val exerciseMoreAdapter by lazy {
        ExerciseMoreAdapter(requireActivity() as BaseActivity, session.userId, moreExerciseList,
            object : ExerciseMoreAdapter.AdapterListener {
                override fun onViewMoreClick(position: Int) {

                    if (moreExerciseList.size > position) {
                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            ExerciseViewAllFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.GENRE_ID,
                                    moreExerciseList[position].genre_master_id),
                                Pair(Common.BundleKey.TITLE, moreExerciseList[position].genre)
                            )).start()
                    }

                }
            }, object : ExerciseMoreSubAdapter.AdapterListener {
                override fun onBookmarkClick(mainPosition: Int, position: Int) {
                    currentClickMainPosition = mainPosition
                    currentClickSubContentPosition = position
                    updateBookmarks()
                }

                override fun onLikeClick(mainPosition: Int, position: Int) {
                    currentClickMainPosition = mainPosition
                    currentClickSubContentPosition = position
                    updateLikes()
                }

                override fun onPlayClick(mainPosition: Int, position: Int) {
                    currentClickMainPosition = mainPosition
                    currentClickSubContentPosition = position

                    if (moreExerciseList.isNotEmpty()) {
                        val contentData = moreExerciseList[currentClickMainPosition].content_data
                            ?.get(currentClickSubContentPosition)

                        if (contentData?.media?.isNotEmpty() == true
                            && contentData.media.first().media_url.isNullOrBlank().not()
                        ) {
                            navigator.loadActivity(VideoPlayerActivity::class.java)
                                .addBundle(bundleOf(
                                    Pair(Common.BundleKey.CONTENT_ID,
                                        contentData.content_master_id),
                                    Pair(Common.BundleKey.CONTENT_TYPE,
                                        contentData.content_type),
                                    Pair(Common.BundleKey.MEDIA_URL,
                                        contentData.media.first().media_url),
                                    Pair(Common.BundleKey.POSITION, 0),
                                    Pair(Common.BundleKey.GOAL_MASTER_ID,
                                        contentData.goal_master_id),
                                    Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true)
                                )).start()
                        }
                    }

                }

                override fun onInfoClick(mainPosition: Int, position: Int) {
                    currentClickMainPosition = mainPosition
                    currentClickSubContentPosition = position

                    val contentData = moreExerciseList[currentClickMainPosition].content_data
                        ?.get(currentClickSubContentPosition)
                    /*if (contentData?.description?.isNotBlank() == true) {*/

                    requireActivity().supportFragmentManager?.let {

                        /*ExerciseDescriptionInfoDialog(contentData?.title ?: "",
                            contentData?.description ?: "")
                            .show(it, ExerciseDescriptionInfoDialog::class.java.simpleName)*/

                        navigator.loadActivity(TransparentActivity::class.java,
                            ExerciseDescriptionInfoFragment::class.java)
                            .addBundle(Bundle().apply {
                                putString(Common.BundleKey.TITLE, contentData?.title ?: "")
                                putString(Common.BundleKey.DESCRIPTION, contentData?.description ?: "")
                            }).start()

                    }

                    /*}*/

                }
            })
    }

    var currentClickMainPosition = -1
    var currentClickSubContentPosition = -1

    //pagination params
    var page = 1
    internal var isLoading = false
    var isLastPage: Boolean = false

    //    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null

    fun resetPagingData() {
        isLoading = true
        page = 1
//        previousTotal = 0
        isLastPage = false
    }

    private lateinit var engageContentViewModel: EngageContentViewModel/* by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }*/

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseFragmentMoreBinding {
        return ExerciseFragmentMoreBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        engageContentViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        if (isInsideSearch) {
            resetPagingData()
            exerciseList()
        } else if (isAdded && (requireActivity() is HomeActivity) && (requireActivity() as HomeActivity).binding.layoutExercise.isSelected) {
            analytics.setScreenName(AnalyticsScreenNames.ExerciseMore)
            Handler(Looper.getMainLooper()).postDelayed({
                resetPagingData()
                exerciseList()
            }, 500)

            resumedTime = Calendar.getInstance().timeInMillis
        }
    }

    override fun onPause() {
        super.onPause()
        if (isAdded && (requireActivity() is HomeActivity) && (requireActivity() as HomeActivity).binding.layoutExercise.isSelected) {
            updateScreenTimeDurationInAnalytics()
        }
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.TIME_SPENT_EXPLORE, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.ExerciseMore)*/
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewMore.apply {
                layoutManager = linearLayoutManager
                adapter = exerciseMoreAdapter
            }

            /*recyclerViewMore.addOnScrollListener(object : RecyclerView.OnScrollListener() {
                override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {

                }

                override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                    *//*if (linearLayoutManager?.findFirstCompletelyVisibleItemPosition() == 0) {
                        imageViewScrollUp.visibility = View.GONE
                    } else {
                        imageViewScrollUp.visibility = View.VISIBLE
                    }*//*

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
                        exerciseList()
                        isLoading = true
                    }
                }
            })*/

            recyclerViewMore.addOnScrollListener(object :
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
                    exerciseList()
                }

                override fun isScrolledDown(isScrolledDown: Boolean) {

                }
            })
        }
    }

    private fun setViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                exerciseList()
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    val filterTimeList = ArrayList<ExerciseFilterCommonData>()
    val filterExerciseToolsList = ArrayList<ExerciseFilterCommonData>()
    val filterLevelList = ArrayList<ExerciseFilterCommonData>()
    val filterGenreList = ArrayList<ExerciseFilterCommonData>()

    //filter callback from exercise filter bottom sheet
    fun updateFilters(
        timeList: ArrayList<ExerciseFilterCommonData>,
        exerciseToolsList: ArrayList<ExerciseFilterCommonData>,
        levelList: ArrayList<ExerciseFilterCommonData>,
        genreList: ArrayList<ExerciseFilterCommonData>,
    ) {
        filterTimeList.clear()
        filterTimeList.addAll(timeList)
        filterExerciseToolsList.clear()
        filterExerciseToolsList.addAll(exerciseToolsList)
        filterLevelList.clear()
        filterLevelList.addAll(levelList)
        filterGenreList.clear()
        filterGenreList.addAll(genreList)

        resetPagingData()
        exerciseList()
    }

    var onCoachMarkFinish: (() -> Unit)? = null
    fun showCoachMark(onFinish: () -> Unit) {

        if (moreExerciseList.isNotEmpty()) {

            onCoachMarkFinish = null

            binding.recyclerViewMore.scrollToPosition(0)

            Handler(Looper.getMainLooper()).postDelayed({
                if(isAdded) {
                    var mGuideView: GuideView? = null
                    var builder: GuideView.Builder? = null
                    val targetView = linearLayoutManager?.findViewByPosition(0)
                    builder = GuideView.Builder(requireActivity())
                        .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.EXERCISE_EXPLORE.pageKey))
                        .setButtonText("Finish")
                        .setGravity(Gravity.auto)
                        /*.setDismissType(DismissType.outside)*/
                        .setTargetView(targetView)
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
                }
            }, 200)

        } else {
            onCoachMarkFinish = onFinish
        }
    }

    fun doSearch(searchText: String) {
        resetPagingData()
        this.searchText = searchText
        exerciseList()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun exerciseList() {
        if (page == 1) {
            //moreExerciseList.clear()
            //exerciseMoreAdapter.notifyDataSetChanged()
        }
        val apiRequest = ApiRequestSubData().apply {
            page = this@ExerciseMoreFragment.page.toString()

            // optional filter params
            if (filterTimeList.isNullOrEmpty().not()) {
                show_time = filterTimeList.listOfField(ExerciseFilterCommonData::show_time)
            }
            if (filterExerciseToolsList.isNullOrEmpty().not()) {
                exercise_tools =
                    filterExerciseToolsList.listOfField(ExerciseFilterCommonData::exercise_tools)
            }
            if (filterLevelList.isNullOrEmpty().not()) {
                fitness_level = filterLevelList.listOfField(ExerciseFilterCommonData::fitness_level)
            }
            if (filterGenreList.isNullOrEmpty().not()) {
                genre_ids = filterGenreList.listOfField(ExerciseFilterCommonData::genre_master_id)
            }

            if (isInsideSearch && searchText.isNotBlank()) {
                search = searchText
            }

        }

        binding.swipeRefreshLayout.isRefreshing = page == 1 && isInsideSearch.not()
        if (isAdded) {
            Log.e("API_CALL", "exerciseList: $page")
            engageContentViewModel.exerciseList(apiRequest)
        }
    }

    private fun updateBookmarks() {
        if (moreExerciseList.isNotEmpty()) {
            val contentData = moreExerciseList[currentClickMainPosition].content_data?.get(
                currentClickSubContentPosition)
            val apiRequest = ApiRequest().apply {
                content_master_id = contentData?.content_master_id
                is_active = if (contentData?.bookmarked == "Y") "N" else "Y"
            }
            engageContentViewModel.updateBookmarks(apiRequest, analytics, contentData?.content_type,screenName = AnalyticsScreenNames.ExerciseMore)
        }
    }

    private fun updateLikes() {
        if (moreExerciseList.isNotEmpty()) {
            val contentData = moreExerciseList[currentClickMainPosition].content_data?.get(
                currentClickSubContentPosition)
            val apiRequest = ApiRequest().apply {
                content_master_id = contentData?.content_master_id
                is_active = contentData?.liked
                //if (contentData?.liked == "Y") "N" else "Y"
            }
            engageContentViewModel.updateLikes(apiRequest, analytics, contentData?.content_type,
                screenName = AnalyticsScreenNames.ExerciseMore)
        }
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //exerciseListLiveData
        engageContentViewModel.exerciseListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                isLoading = false
                if (page == 1) {
                    moreExerciseList.clear()
                }
                responseBody.data?.let { moreExerciseList.addAll(it) }
                binding.recyclerViewMore.recycledViewPool.clear()
                exerciseMoreAdapter.notifyDataSetChanged()

                if (moreExerciseList.isNotEmpty()) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        onCoachMarkFinish?.let {
                            showCoachMark(it)
                        }
                    }, 200)
                }

                binding.recyclerViewMore.visibility = View.VISIBLE
                binding.textViewNoData.visibility = View.GONE
            },
            onError = { throwable ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                isLoading = false
                isLastPage = true
                if (page == 1 && throwable is ServerException) {
                    moreExerciseList.clear()
                    //binding.recyclerViewMore.recycledViewPool.clear()
                    exerciseMoreAdapter.notifyDataSetChanged()
                    binding.recyclerViewMore.visibility = View.GONE
                    binding.textViewNoData.visibility = View.VISIBLE
                    binding.textViewNoData.text = throwable.message
                    false
                } else
                    page == 1
            })

        //updateBookmarksLiveData
        engageContentViewModel.updateBookmarksLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickMainPosition != -1 && moreExerciseList.size > currentClickMainPosition
                    && currentClickSubContentPosition != -1
                    && moreExerciseList[currentClickMainPosition].content_data?.size ?: 0 > currentClickSubContentPosition
                ) {

                    if (moreExerciseList[currentClickMainPosition].content_data?.get(
                            currentClickSubContentPosition)?.bookmarked == "Y"
                    )
                        moreExerciseList[currentClickMainPosition].content_data?.get(
                            currentClickSubContentPosition)?.bookmarked = "N"
                    else
                        moreExerciseList[currentClickMainPosition].content_data?.get(
                            currentClickSubContentPosition)?.bookmarked = "Y"

                    //exerciseMoreAdapter.notifyItemChanged(currentClickMainPosition)

                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //updateLikesLiveData
        engageContentViewModel.updateLikesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                /*if (currentClickMainPosition != -1 && moreExerciseList.size > currentClickMainPosition
                    && currentClickSubContentPosition != -1
                    && moreExerciseList[currentClickMainPosition].content_data?.size ?: 0 > currentClickSubContentPosition
                ) {

                    if (moreExerciseList[currentClickMainPosition].content_data?.get(
                            currentClickSubContentPosition)?.liked == "Y"
                    )
                        moreExerciseList[currentClickMainPosition].content_data?.get(
                            currentClickSubContentPosition)?.liked = "N"
                    else
                        moreExerciseList[currentClickMainPosition].content_data?.get(
                            currentClickSubContentPosition)?.liked = "Y"

                    //exerciseMoreAdapter.notifyItemChanged(currentClickMainPosition)

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