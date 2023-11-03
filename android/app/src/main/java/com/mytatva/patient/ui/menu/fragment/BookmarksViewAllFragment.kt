package com.mytatva.patient.ui.menu.fragment

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
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.MenuFragmentBookmarksViewAllBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.engage.fragment.QuestionDetailsFragment
import com.mytatva.patient.ui.menu.adapter.BookmarksSubAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class BookmarksViewAllFragment : BaseFragment<MenuFragmentBookmarksViewAllBinding>() {

    val type by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_TYPE)
    }

    val title by lazy {
        arguments?.getString(Common.BundleKey.TITLE)
    }

    private val bookmarksList = arrayListOf<ContentData>()

    private val bookmarksSubAdapter by lazy {
        BookmarksSubAdapter(bookmarksList, 0,
            object : BookmarksSubAdapter.AdapterListener {
                override fun onItemClick(mainPosition: Int, position: Int) {

                    val contentData = bookmarksList[position]

                    if (type == "ExerciseVideo") {
                        if (contentData.media?.isNotEmpty() == true
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
                                    Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true)
                                )).start()
                        }

                    } else if (type == "AskAnExpert") {

                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            QuestionDetailsFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.CONTENT_ID, contentData.content_master_id)
                            )).start()

                    } else {

                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            EngageFeedDetailsFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.CONTENT_TYPE, type),
                                Pair(Common.BundleKey.CONTENT_ID,
                                    contentData.content_master_id)
                            )).start()

                    }

                }
            })
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
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
    ): MenuFragmentBookmarksViewAllBinding {
        return MenuFragmentBookmarksViewAllBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AllBookmark)

        resetPagingData()
        bookmarkContentListByType()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = title ?: getString(R.string.bookmarks_title)
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            recyclerViewBookmarks.apply {
                layoutManager = linearLayoutManager
                adapter = bookmarksSubAdapter
            }

            recyclerViewBookmarks.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                        bookmarkContentListByType()
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
    private fun bookmarkContentListByType() {
        val apiRequest = ApiRequest()
        apiRequest.type = type
        apiRequest.page = page.toString()
        showLoader()
        engageContentViewModel.bookmarkContentListByType(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        engageContentViewModel.bookmarkContentListByTypeLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setBookmarkContentData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                if (page == 1) {
                    bookmarksList.clear()
                    bookmarksSubAdapter.notifyDataSetChanged()
                    with(binding) {
                        textViewNoData.visibility = View.VISIBLE
                        recyclerViewBookmarks.visibility = View.GONE
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
    @SuppressLint("NotifyDataSetChanged")
    private fun setBookmarkContentData(list: ArrayList<ContentData>) {
        if (page == 1) {
            bookmarksList.clear()
        }
        bookmarksList.addAll(list)
        bookmarksSubAdapter.notifyDataSetChanged()

        with(binding) {
            if (bookmarksList.isNotEmpty()) {
                textViewNoData.visibility = View.GONE
                recyclerViewBookmarks.visibility = View.VISIBLE
            }
        }
    }
}