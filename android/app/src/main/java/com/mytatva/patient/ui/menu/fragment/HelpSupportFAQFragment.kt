package com.mytatva.patient.ui.menu.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.FaqMainData
import com.mytatva.patient.databinding.MenuFragmentHelpSupportFaqBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.chat.fragment.ChatBotFragment
import com.mytatva.patient.ui.menu.adapter.FAQAdapter
import com.mytatva.patient.ui.menu.dialog.HelpDialog
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.openDialer
import com.mytatva.patient.utils.openEmail
import java.util.*
import java.util.concurrent.TimeUnit


class HelpSupportFAQFragment : BaseFragment<MenuFragmentHelpSupportFaqBinding>() {

    private val faqList = arrayListOf<FaqMainData>()
    private val faqAdapter by lazy {
        FAQAdapter(faqList)
    }

    private var page: Int = 1
    private var isMoreDataAvailable = true

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
    ): MenuFragmentHelpSupportFaqBinding {
        return MenuFragmentHelpSupportFaqBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.HelpSupportFaq)
        setUpRecyclerView()
        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_SUPPORT, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.HelpSupportFaq)
    }

    override fun bindData() {
        setUpToolbar()
        getFaqData()
        setUpViewListeners()

        handleUIAsPerVisibilityFlags()
    }

    private fun handleUIAsPerVisibilityFlags() {
        //chat bot
        binding.buttonChatWithUs.isVisible =
            AppFlagHandler.isToHideChatBot(session.user, firebaseConfigUtil).not()

        //leave a query
        binding.buttonLeaveQuery.isVisible =
            AppFlagHandler.isToHideLeaveAQuery(firebaseConfigUtil).not()

        //email
        binding.groupEmailAt.isVisible =
            AppFlagHandler.isToHideEmailAt(firebaseConfigUtil).not()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonLeaveQuery.setOnClickListener { onViewClick(it) }
            buttonChatWithUs.setOnClickListener { onViewClick(it) }
            imageViewEmail.setOnClickListener { onViewClick(it) }
            imageViewContact.setOnClickListener { onViewClick(it) }
            textViewEmail.setOnClickListener { onViewClick(it) }
            textViewContact.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewFAQ.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = faqAdapter
        }

        /*binding.nestedScrollView.viewTreeObserver.addOnScrollChangedListener {
            val view: View =
                binding.nestedScrollView.getChildAt(binding.nestedScrollView.childCount - 1) as View

            val diff: Int =
                view.bottom - (binding.nestedScrollView.height + binding.nestedScrollView.scrollY)

            if (diff == 0 && isMoreDataAvailable) {
                // your pagination code
                page++
                getFaqData()
            }
        }*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.help_support_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonLeaveQuery -> {
                requireActivity().supportFragmentManager.let {
                    HelpDialog().show(it, HelpDialog::class.java.simpleName)
                }
            }
            R.id.buttonChatWithUs -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.chatbot)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        ChatBotFragment::class.java)
                        .start()
                }
            }
            R.id.imageViewEmail,
            R.id.textViewEmail,
            -> {
                requireActivity().openEmail(binding.textViewEmail.text.toString().trim())
            }
            R.id.imageViewContact,
            R.id.textViewContact,
            -> {
                requireActivity().openDialer(binding.textViewContact.text.toString().trim())
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewNotification -> {
                openNotificationScreen()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getFaqData() {
        val apiRequest = ApiRequest()
        apiRequest.page = page.toString()
        authViewModel.getFaqs(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.getFaqsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (page == 1) {
                    faqList.clear()
                }
                responseBody.data?.let { faqList.addAll(it) }
                faqAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                isMoreDataAvailable = false
                false
            })
    }
}