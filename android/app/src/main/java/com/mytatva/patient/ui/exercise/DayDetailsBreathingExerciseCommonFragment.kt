package com.mytatva.patient.ui.exercise

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ExerciseBreathingDayData
import com.mytatva.patient.databinding.ExerciseFragmentDayDetailsBreathingExerciseCommonBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.adapter.DayDetailsBreathingExerciseAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class DayDetailsBreathingExerciseCommonFragment() :
    BaseFragment<ExerciseFragmentDayDetailsBreathingExerciseCommonBinding>() {

    var exerciseType = Common.ExerciseType.BREATHING

    fun getCurrentScreenName() :String{
        return if (exerciseType == Common.ExerciseType.BREATHING) {
            AnalyticsScreenNames.ExercisePlanDayDetailBreathing
        } else {
            AnalyticsScreenNames.ExercisePlanDayDetailExercise
        }
    }

    var currentClickPosition = -1

    private val list = arrayListOf<ExerciseBreathingDayData>()/*.apply {
        for (i in 0 until tempCount) {
            add(TempDataModel(name = ""))
        }
    }*/


    private val dayDetailsBreathingExerciseAdapter by lazy {
        DayDetailsBreathingExerciseAdapter(requireActivity() as BaseActivity, list,
            object : DayDetailsBreathingExerciseAdapter.AdapterListener {
                override fun onVideoItemClick(position: Int) {
                    currentClickPosition = position

                    val contentData = list[position].content_data

                    if (contentData?.media?.isNotEmpty() == true
                        && contentData.media.first().media_url.isNullOrBlank().not()
                    ) {
                        navigator.loadActivity(VideoPlayerActivity::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.CONTENT_ID, contentData.content_master_id),
                                Pair(Common.BundleKey.CONTENT_TYPE, contentData.content_type),
                                Pair(Common.BundleKey.MEDIA_URL,
                                    contentData.media.first().media_url),
                                Pair(Common.BundleKey.POSITION, 0),
                                Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true)
                            )).start()
                    }

                }

                override fun onLikeClick(position: Int) {
                    currentClickPosition = position
                    updateLikes()
                }

                override fun onBookmarkClick(position: Int) {
                    currentClickPosition = position
                    updateBookmarks()
                }

                override fun onInfoClick(position: Int) {
                    currentClickPosition = position

                    val contentData = list[position]
                    /*requireActivity().supportFragmentManager.let {
                        ExerciseDescriptionInfoDialog(contentData.content_data?.title ?: "",
                            contentData.content_data?.description ?: "")
                            .show(it, ExerciseDescriptionInfoDialog::class.java.simpleName)
                    }*/

                    navigator.loadActivity(TransparentActivity::class.java,
                        ExerciseDescriptionInfoFragment::class.java)
                        .addBundle(Bundle().apply {
                            putString(Common.BundleKey.TITLE, contentData.content_data?.title ?: "")
                            putString(Common.BundleKey.DESCRIPTION,
                                contentData.content_data?.description ?: "")
                        }).start()

                }

            })
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
    ): ExerciseFragmentDayDetailsBreathingExerciseCommonBinding {
        return ExerciseFragmentDayDetailsBreathingExerciseCommonBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis
    override fun onResume() {
        super.onResume()
        analytics.setScreenName(getCurrentScreenName())
        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(
            if (exerciseType == Common.ExerciseType.BREATHING)
                analytics.TIME_SPENT_PLAN_DETAIL_BREATH
            else
                analytics.TIME_SPENT_PLAN_DETAIL_EXC,
            Bundle().apply {
                putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
            }, screenName = getCurrentScreenName())
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewPlans.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = dayDetailsBreathingExerciseAdapter
            }
        }
    }

    private fun setViewListeners() {
        with(binding) {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setData(list: ArrayList<ExerciseBreathingDayData>) {
        if (isAdded) {
            this.list.clear()
            this.list.addAll(list)
            dayDetailsBreathingExerciseAdapter.notifyDataSetChanged()
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateBookmarks() {
        val contentData = list[currentClickPosition].content_data
        val apiRequest = ApiRequest().apply {
            content_master_id = contentData?.content_master_id
            is_active = if (contentData?.bookmarked == "Y") "N" else "Y"
        }

        /*if (feedList[currentClickFeedPosition].liked == "Y") {
            analytics.logEvent(analytics.USER_BOOKMARKED_COMMENT,
                Bundle().apply {
                    putString("content_master_id",
                        feedList[currentClickFeedPosition].content_master_id)
                })
        } else {
            analytics.logEvent(analytics.USER_UN_BOOKMARK_CONTENT,
                Bundle().apply {
                    putString("content_master_id",
                        feedList[currentClickFeedPosition].content_master_id)
                })
        }*/

        engageContentViewModel.updateBookmarks(apiRequest, analytics, contentData?.content_type,
            screenName = getCurrentScreenName())
    }

    private fun updateLikes() {
        val contentData = list[currentClickPosition].content_data
        val apiRequest = ApiRequest().apply {
            content_master_id = contentData?.content_master_id
            is_active = if (contentData?.liked == "Y") "N" else "Y"
        }

        /*if (feedList[currentClickFeedPosition].liked == "Y") {
            analytics.logEvent(analytics.USER_UNLIKED_CONTENT, Bundle().apply {
                putString("content_master_id", feedList[currentClickFeedPosition].content_master_id)
            })
        } else {
            analytics.logEvent(analytics.USER_LIKED_CONTENT, Bundle().apply {
                putString("content_master_id", feedList[currentClickFeedPosition].content_master_id)
            })
        }*/

        engageContentViewModel.updateLikes(apiRequest, analytics, contentData?.content_type,
            screenName = getCurrentScreenName())
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updateBookmarksLiveData
        engageContentViewModel.updateBookmarksLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickPosition != -1 && list.size > currentClickPosition) {

                    if (list[currentClickPosition].content_data?.bookmarked == "Y")
                        list[currentClickPosition].content_data?.bookmarked = "N"
                    else
                        list[currentClickPosition].content_data?.bookmarked = "Y"

                    //dayDetailsBreathingExerciseAdapter.notifyItemChanged(currentClickPosition)

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
                if (currentClickPosition != -1 && list.size > currentClickPosition) {

                    if (list[currentClickPosition].content_data?.liked == "Y")
                        list[currentClickPosition].content_data?.liked = "N"
                    else
                        list[currentClickPosition].content_data?.liked = "Y"

                    //dayDetailsBreathingExerciseAdapter.notifyItemChanged(currentClickPosition)

                }
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