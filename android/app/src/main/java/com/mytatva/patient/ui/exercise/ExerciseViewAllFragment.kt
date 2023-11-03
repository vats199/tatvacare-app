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
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.ExerciseFragmentExerciseViewAllBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.adapter.ExerciseMoreSubAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class ExerciseViewAllFragment : BaseFragment<ExerciseFragmentExerciseViewAllBinding>() {

    val genreId by lazy {
        arguments?.getString(Common.BundleKey.GENRE_ID)
    }

    val title by lazy {
        arguments?.getString(Common.BundleKey.TITLE)
    }


    private val moreExerciseList = arrayListOf<ContentData>()

    private val exerciseMoreAdapter by lazy {
        ExerciseMoreSubAdapter(requireActivity() as BaseActivity, -1, session.userId,
            moreExerciseList, object : ExerciseMoreSubAdapter.AdapterListener {
                override fun onBookmarkClick(mainPosition: Int, position: Int) {
                    currentClickSubContentPosition = position
                    updateBookmarks()
                }

                override fun onLikeClick(mainPosition: Int, position: Int) {
                    currentClickSubContentPosition = position
                    updateLikes()
                }

                override fun onPlayClick(mainPosition: Int, position: Int) {
                    currentClickSubContentPosition = position

                    val contentData = moreExerciseList[currentClickSubContentPosition]

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

                override fun onInfoClick(mainPosition: Int, position: Int) {
                    currentClickSubContentPosition = position

                    val contentData = moreExerciseList[currentClickSubContentPosition]

                    /*requireActivity().supportFragmentManager?.let {
                        ExerciseDescriptionInfoDialog(contentData.title ?: "",
                            contentData.description ?: "")
                            .show(it, ExerciseDescriptionInfoDialog::class.java.simpleName)
                    }*/

                    navigator.loadActivity(TransparentActivity::class.java,
                        ExerciseDescriptionInfoFragment::class.java)
                        .addBundle(Bundle().apply {
                            putString(Common.BundleKey.TITLE, contentData?.title ?: "")
                            putString(Common.BundleKey.DESCRIPTION, contentData?.description ?: "")
                        }).start()
                }
            })
    }

    var currentClickSubContentPosition = -1

    //pagination params
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
    ): ExerciseFragmentExerciseViewAllBinding {
        return ExerciseFragmentExerciseViewAllBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ExerciseViewAll)
        resetPagingData()
        exerciseListByGenreId()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
    }


    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = title ?: ""
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewExercise.apply {
                layoutManager = linearLayoutManager
                adapter = exerciseMoreAdapter
            }

            recyclerViewExercise.addOnScrollListener(object : RecyclerView.OnScrollListener() {
                override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {

                }

                override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                    /*if (linearLayoutManager?.findFirstCompletelyVisibleItemPosition() == 0) {
                        imageViewScrollUp.visibility = View.GONE
                    } else {
                        imageViewScrollUp.visibility = View.VISIBLE
                    }*/

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
                        exerciseListByGenreId()
                        isLoading = true
                    }
                }
            })
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
    private fun exerciseListByGenreId() {
        val apiRequest = ApiRequestSubData().apply {
            page = this@ExerciseViewAllFragment.page.toString()
            genre_master_id = genreId
        }
        showLoader()
        engageContentViewModel.exerciseListByGenreId(apiRequest)
    }

    private fun updateBookmarks() {
        val contentData = moreExerciseList[currentClickSubContentPosition]
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

        engageContentViewModel.updateBookmarks(apiRequest, analytics, contentData.content_type, screenName = AnalyticsScreenNames.ExerciseViewAll)
    }

    private fun updateLikes() {
        val contentData = moreExerciseList[currentClickSubContentPosition]
        val apiRequest = ApiRequest().apply {
            content_master_id = contentData?.content_master_id
            is_active = contentData?.liked
            //if (contentData?.liked == "Y") "N" else "Y"
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

        engageContentViewModel.updateLikes(apiRequest, analytics, contentData.content_type, screenName = AnalyticsScreenNames.ExerciseViewAll)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //exerciseListLiveData
        engageContentViewModel.exerciseListByGenreIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (page == 1) {
                    moreExerciseList.clear()
                }
                responseBody.data?.let { moreExerciseList.addAll(it) }
                exerciseMoreAdapter.notifyDataSetChanged()

                binding.recyclerViewExercise.visibility = View.VISIBLE
                binding.textViewNoData.visibility = View.GONE
            },
            onError = { throwable ->
                hideLoader()
                if (page == 1) {
                    moreExerciseList.clear()
                    exerciseMoreAdapter.notifyDataSetChanged()
                    binding.recyclerViewExercise.visibility = View.GONE
                    binding.textViewNoData.visibility = View.VISIBLE
                    binding.textViewNoData.text = throwable.message
                }
                false
            })

        //updateBookmarksLiveData
        engageContentViewModel.updateBookmarksLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickSubContentPosition != -1 && moreExerciseList.size > currentClickSubContentPosition) {

                    if (moreExerciseList[currentClickSubContentPosition].bookmarked == "Y")
                        moreExerciseList[currentClickSubContentPosition].bookmarked = "N"
                    else
                        moreExerciseList[currentClickSubContentPosition].bookmarked = "Y"

                    //exerciseMoreAdapter.notifyItemChanged(currentClickSubContentPosition)

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
                /*if (currentClickSubContentPosition != -1 && moreExerciseList.size > currentClickSubContentPosition) {

                    if (moreExerciseList[currentClickSubContentPosition].liked == "Y")
                        moreExerciseList[currentClickSubContentPosition].liked = "N"
                    else
                        moreExerciseList[currentClickSubContentPosition].liked = "Y"

                    //exerciseMoreAdapter.notifyItemChanged(currentClickSubContentPosition)

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