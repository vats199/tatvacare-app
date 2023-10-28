package com.mytatva.patient.ui.chat.dialog

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.freshchat.consumer.sdk.ConversationOptions
import com.freshchat.consumer.sdk.Freshchat
import com.mytatva.patient.R
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.databinding.ChatDialogChatListBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.chat.adapter.ChatListAdapter
import com.mytatva.patient.ui.chat.fragment.ChatBotFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class ChatListFragment : BaseFragment<ChatDialogChatListBinding>() {

    companion object {
        var healthCoachId: String? = null
        var isFirstMessageSentAPICalled = false
    }

    var currentClickPos = -1

    private val healthCoachList = ArrayList<HealthCoachData>()
    private val chatListAdapter by lazy {
        ChatListAdapter(healthCoachList, object : ChatListAdapter.AdapterListener {
            override fun onClick(position: Int) {

                analytics.logEvent(analytics.USER_CHAT_WITH_HC, Bundle().apply {
                    putString(analytics.PARAM_HEALTH_COACH_ID,
                        healthCoachList[position].health_coach_id)
                }, screenName = AnalyticsScreenNames.ChatList)

                if ((requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(PlanFeatures.chat_healthcoach)) {
                    isFirstMessageSentAPICalled = false
                    healthCoachId = healthCoachList[position].health_coach_id

                    currentClickPos = position
                    //healthCoachList[position].health_coach_id?.let { linkHealthCoachChat(it) }

                    val tags: MutableList<String> = ArrayList()
                    healthCoachList[position].tag_name?.let { tags.add(it) }
                    val options = ConversationOptions().filterByTags(tags, "")
                    Freshchat.showConversations(requireActivity().applicationContext, options)
                    //Freshchat.showFAQs(requireActivity().applicationContext)

                }
            }

            override fun onProfileClick(position: Int) {
                healthCoachList[position].health_coach_id?.let {
                    healthCoachDetailsById(it)
                }
            }
        })
    }

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ChatDialogChatListBinding {
        return ChatDialogChatListBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ChatList)

        /* dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
         dialog?.setCancelable(true)
         dialog?.setCanceledOnTouchOutside(false)
         val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
         val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
             requireContext().display
         } else {
             wm.defaultDisplay
         }
         val metrics = DisplayMetrics()
         display?.getMetrics(metrics)
         val width = metrics.widthPixels * 1
         val height = metrics.heightPixels * .9
         val win = dialog?.window
         win!!.setLayout(width.toInt(), height.toInt())*/
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListener()
        //(requireActivity() as TransparentActivity).scheduleStartPostponedTransition(binding.rootChatListBg)

        binding.layoutChatBot.isVisible =
            AppFlagHandler.isToHideChatBot(session.user, firebaseConfigUtil).not()

        /*if ((requireActivity() as BaseActivity)
                .isFeatureAllowedAsPerPlan(PlanFeatures.coach_list, needToShowDialog = false)
        ) {
            //linkedHealthCoachList()
        }*/

        binding.layoutHC.isVisible =
            if (AppFlagHandler.isToHideHomeChatBubbleHC(firebaseConfigUtil).not()) {
                (requireActivity() as BaseActivity)
                    .isFeatureAllowedAsPerPlan(PlanFeatures.coach_list, needToShowDialog = false)
                        && session.user?.hc_list?.isEmpty()?.not() == true
            } else false

    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewChatList.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = chatListAdapter
            }
        }
    }

    private fun setViewListener() {
        binding.apply {
            layoutChatBot.setOnClickListener { onViewClick(it) }
            layoutHC.setOnClickListener { onViewClick(it) }
            imageViewSearch.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutChatBot -> {
                if ((requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(PlanFeatures.chatbot)) {
                    (requireActivity() as BaseActivity).loadActivity(IsolatedFullActivity::class.java,
                        ChatBotFragment::class.java).start()
                }
            }
            R.id.layoutHC -> {
                openHcChat()
            }
            R.id.imageViewSearch -> {

            }
            R.id.imageViewClose -> {
                navigator.goBack()
            }
        }
    }

    private fun openHcChat() {
        /*analytics.logEvent(analytics.USER_CHAT_WITH_HC,
            Bundle().apply {
                putString(analytics.PARAM_HEALTH_COACH_ID, healthCoachList[position].health_coach_id)
            }, screenName = AnalyticsScreenNames.ChatList)*/

        if ((requireActivity() as BaseActivity)
                .isFeatureAllowedAsPerPlan(PlanFeatures.chat_healthcoach)
        ) {
            isFirstMessageSentAPICalled = false

            //healthCoachList[position].health_coach_id?.let { linkHealthCoachChat(it) }

            val tags: MutableList<String> = ArrayList()
            //healthCoachList[position].tag_name?.let { tags.add(it) }
            val options = ConversationOptions().filterByTags(tags, "MyTatva Health Coach")
            Freshchat.showConversations(requireActivity().applicationContext, options)
            //Freshchat.showFAQs(requireActivity().applicationContext)

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun linkedHealthCoachList() {
        val apiRequest = ApiRequest()
        // A for all HCs or C for chat not initiated HCs only
        apiRequest.list_type = "A"
        //showLoader()
        authViewModel.linkedHealthCoachList(apiRequest)
    }

    private fun healthCoachDetailsById(healthCoachId: String) {
        val apiRequest = ApiRequest()
        apiRequest.health_coach_id = healthCoachId
        showLoader()
        authViewModel.healthCoachDetailsById(apiRequest)
    }

    private fun linkHealthCoachChat(healthCoachId: String) {
        val apiRequest = ApiRequest()
        apiRequest.health_coach_id = healthCoachId
        //showLoader()
        authViewModel.linkHealthCoachChat(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.linkedHealthCoachListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            binding.recyclerViewChatList.visibility = View.VISIBLE
            binding.textViewNoData.visibility = View.GONE
            healthCoachList.clear()
            responseBody.data?.let { healthCoachList.addAll(it) }
            chatListAdapter.notifyDataSetChanged()
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException) {
                binding.recyclerViewChatList.visibility = View.GONE
                binding.textViewNoData.visibility = View.VISIBLE
                binding.textViewNoData.text = throwable.message
                false
            } else {
                true
            }
        })

        authViewModel.healthCoachDetailsByIdLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                HealthCoachProfileDialog(it).show(requireActivity().supportFragmentManager,
                    HealthCoachProfileDialog::class.java.simpleName)
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        authViewModel.linkHealthCoachChatLiveData.observe(this, onChange = { responseBody ->
            hideLoader()

            /*val tags: MutableList<String> = ArrayList()
            tags.add(if (currentClickPos == 0) "health_coach_vaibhav" else "health_coach_john")
            val options = ConversationOptions()
                .filterByTags(tags, "Test title")
            Freshchat.showConversations(requireActivity().applicationContext, options)*/

        }, onError = { throwable ->
            hideLoader()
            true
        })

    }

}