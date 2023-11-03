package com.mytatva.patient.ui.profile.fragment

import android.annotation.SuppressLint
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.firebase.dynamiclinks.PendingDynamicLinkData
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.NotificationData
import com.mytatva.patient.databinding.ProfileFragmentNotificationsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.profile.adapter.NotificationsAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink

class NotificationsFragment : BaseFragment<ProfileFragmentNotificationsBinding>() {

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

    private val notificationList = arrayListOf<NotificationData>()
    private val notificationsAdapter by lazy {
        NotificationsAdapter(notificationList,
            object : NotificationsAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    if (notificationList[position].deep_link.isNullOrBlank().not()) {
                        Uri.parse(notificationList[position].deep_link)?.let {
                            /*val decodedString =
                            URLEncodeDecode.decode(notificationList[position].deep_link)*/
                            handleDeepLinkNavigation(it/*Uri.parse(decodedString)*/)
                        }
                    } else if (notificationList[position].data?.custom?.notification
                            ?.flag.isNullOrBlank().not()
                    ) {
                        navigator.loadActivity(HomeActivity::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.NOTIFICATION,
                                    notificationList[position].data?.custom?.notification)
                            )).start()
                    }
                }
            })
    }

    private fun handleDeepLinkNavigation(uri: Uri) {
        showLoader()
        FirebaseDynamicLinks.getInstance()
            .getDynamicLink(uri)
            .addOnSuccessListener(requireActivity()) { pendingDynamicLinkData: PendingDynamicLinkData? ->
                hideLoader()
                // Get deep link from result (may be null if no link is found)
                var deepLink: Uri? = null
                if (pendingDynamicLinkData != null) {
                    deepLink = pendingDynamicLinkData.link
                    if (deepLink?.queryParameterNames?.contains(FirebaseLink.Params.OPERATION) == true) {
                        when (deepLink.getQueryParameter(FirebaseLink.Params.OPERATION)) {
                            FirebaseLink.Operation.CONTENT -> {
                                val contentMasterId =
                                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                                if (contentMasterId?.isNotBlank() == true) {
                                    navigator.loadActivity(IsolatedFullActivity::class.java,
                                        EngageFeedDetailsFragment::class.java)
                                        .addBundle(Bundle().apply {
                                            putString(Common.BundleKey.CONTENT_ID, contentMasterId)
                                        }).start()
                                }
                            }
                            FirebaseLink.Operation.SCREEN_NAV -> {
                                (requireActivity() as BaseActivity).handleScreenNavigation(deepLink)
                            }
                        }
                    }
                }
            }.addOnFailureListener(requireActivity()) { e: Exception? ->
                hideLoader()
                Log.w("addOnFailureListener", "getDynamicLink:onFailure")
            }

    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ProfileFragmentNotificationsBinding {
        return ProfileFragmentNotificationsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.NotificationList)
        setUpRecyclerView()
    }

    override fun bindData() {
        setUpToolbar()

        resetPagingData()
        getNotification()
    }

    private fun setUpRecyclerView() {
        linearLayoutManager =
            LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        binding.recyclerView.apply {
            layoutManager = linearLayoutManager
            adapter = notificationsAdapter
        }
        binding.recyclerView.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                    getNotification()
                    isLoading = true
                }
            }
        })
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.notifications_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun updateUnreadCount(unreadCount: String?) {
        with(binding.layoutHeader) {
            if (unreadCount?.toIntOrNull() ?: 0 > 0) {
                textViewNotificationCount.visibility = View.VISIBLE
                textViewNotificationCount.text = unreadCount
            } else {
                textViewNotificationCount.visibility = View.GONE
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
    private fun getNotification() {
        val apiRequest = ApiRequest()
        apiRequest.page = page.toString()
        showLoader()
        authViewModel.getNotification(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.getNotificationLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    if (page == 1) {
                        notificationList.clear()
                        updateUnreadCount(responseBody.data.unread_counts)
                    }
                    responseBody.data.list?.let { it1 -> notificationList.addAll(it1) }
                    notificationsAdapter.notifyDataSetChanged()
                    with(binding) {
                        if (notificationList.isEmpty()) {
                            textViewNoData.visibility = View.VISIBLE
                            recyclerView.visibility = View.GONE
                        } else {
                            textViewNoData.visibility = View.GONE
                            recyclerView.visibility = View.VISIBLE
                        }
                    }
                }
            },
            onError = { throwable ->
                hideLoader()
                if (page == 1) {
                    notificationList.clear()
                    notificationsAdapter.notifyDataSetChanged()
                    with(binding) {
                        textViewNoData.visibility = View.VISIBLE
                        recyclerView.visibility = View.GONE
                        textViewNoData.text = throwable.message
                    }
                }
                false
            })
    }
}