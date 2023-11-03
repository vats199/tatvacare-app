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
import com.mytatva.patient.data.pojo.response.BookmarkedContentData
import com.mytatva.patient.databinding.MenuFragmentBookmarksBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.engage.fragment.QuestionDetailsFragment
import com.mytatva.patient.ui.menu.adapter.BookmarksMainAdapter
import com.mytatva.patient.ui.menu.adapter.BookmarksSubAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class BookmarksFragment : BaseFragment<MenuFragmentBookmarksBinding>() {

    private val bookmarksList = arrayListOf<BookmarkedContentData>()

    private val bookmarksMainAdapter by lazy {
        BookmarksMainAdapter(bookmarksList,
            object : BookmarksMainAdapter.AdapterListener {
                override fun onViewAllClick(position: Int) {

                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        BookmarksViewAllFragment::class.java).addBundle(bundleOf(
                        Pair(Common.BundleKey.CONTENT_TYPE, bookmarksList[position].type),
                        Pair(Common.BundleKey.TITLE, bookmarksList[position].display_value)
                    )).start()

                }
            },
            object : BookmarksSubAdapter.AdapterListener {
                override fun onItemClick(mainPosition: Int, position: Int) {

                    if (bookmarksList.size > mainPosition && bookmarksList[mainPosition].data?.size ?: 0 > position) {

                        if (bookmarksList[mainPosition].type == "ExerciseVideo") {

                            val contentData = bookmarksList[mainPosition].data?.get(position)

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
                                        Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true)
                                    )).start()
                            }

                        } else if (bookmarksList[mainPosition].type == "AskAnExpert") {

                            navigator.loadActivity(IsolatedFullActivity::class.java,
                                QuestionDetailsFragment::class.java)
                                .addBundle(bundleOf(
                                    Pair(Common.BundleKey.CONTENT_ID,
                                        bookmarksList[mainPosition].data!![position].content_master_id)
                                )).start()

                        } else {
                            navigator.loadActivity(IsolatedFullActivity::class.java,
                                EngageFeedDetailsFragment::class.java)
                                .addBundle(bundleOf(
                                    Pair(Common.BundleKey.CONTENT_TYPE,
                                        bookmarksList[mainPosition].type),
                                    Pair(Common.BundleKey.CONTENT_ID,
                                        bookmarksList[mainPosition].data!![position].content_master_id)
                                )).start()
                        }

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

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MenuFragmentBookmarksBinding {
        return MenuFragmentBookmarksBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BookmarkList)
        bookmarkContentList()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.bookmarks_title)
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewBookmarks.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = bookmarksMainAdapter
            }
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
    private fun bookmarkContentList() {
        val apiRequest = ApiRequest()
        showLoader()
        engageContentViewModel.bookmarkContentList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //commentListLiveData
        engageContentViewModel.bookmarkContentListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                setData(arrayListOf(), throwable.message ?: "")//set empty
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setData(list: ArrayList<BookmarkedContentData>, message: String = "") {
        bookmarksList.clear()
        bookmarksList.addAll(list)
        bookmarksMainAdapter.notifyDataSetChanged()

        with(binding) {
            if (bookmarksList.isEmpty()) {
                textViewNoData.visibility = View.VISIBLE
                textViewNoData.text = message
                recyclerViewBookmarks.visibility = View.GONE
            } else {
                textViewNoData.visibility = View.GONE
                recyclerViewBookmarks.visibility = View.VISIBLE
            }
        }
    }
}