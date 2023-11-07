package com.mytatva.patient.ui.chat.dialog

/*
class ChatListDialog : BaseDialogFragment<ChatDialogChatListBinding>() {

    companion object {
        var healthCoachId: String? = null
        var isFirstMessageSentAPICalled = false
    }

    var currentClickPos = -1

    private val healthCoachList = ArrayList<HealthCoachData>()
    private val chatListAdapter by lazy {
        ChatListAdapter(healthCoachList, object : ChatListAdapter.AdapterListener {
            override fun onClick(position: Int) {

                analytics.logEvent(analytics.USER_CHAT_WITH_HC,
                    Bundle().apply {
                        putString(analytics.PARAM_HEALTH_COACH_ID,
                            healthCoachList[position].health_coach_id)
                    },screenName = AnalyticsScreenNames.ChatList)

                if ((requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(PlanFeatures.chat_healthcoach)) {
                    isFirstMessageSentAPICalled = false
                    healthCoachId = healthCoachList[position].health_coach_id

                    currentClickPos = position
                    //healthCoachList[position].health_coach_id?.let { linkHealthCoachChat(it) }

                    val tags: MutableList<String> = ArrayList()
                    healthCoachList[position].tag_name?.let { tags.add(it) }
                    val options = ConversationOptions()
                        .filterByTags(tags, "")
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
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
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

        dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
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
        win!!.setLayout(width.toInt(), height.toInt())
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListener()

        if ((requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(PlanFeatures.coach_list)) {
            linkedHealthCoachList()
        }
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
            imageViewSearch.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutChatBot -> {
                if ((requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(PlanFeatures.chatbot)) {
                    (requireActivity() as BaseActivity)
                        .loadActivity(IsolatedFullActivity::class.java, ChatBotFragment::class.java)
                        .start()
                }
            }
            R.id.imageViewSearch -> {

            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }

    */
/**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **//*

    private fun linkedHealthCoachList() {
        val apiRequest = ApiRequest()
        // A for all HCs or C for chat not initiated HCs only
        apiRequest.list_type = "A"
        showLoader()
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

    */
/**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **//*

    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.linkedHealthCoachListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                healthCoachList.clear()
                responseBody.data?.let { healthCoachList.addAll(it) }
                chatListAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.healthCoachDetailsByIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    HealthCoachProfileDialog(it)
                        .show(requireActivity().supportFragmentManager,
                            HealthCoachProfileDialog::class.java.simpleName)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.linkHealthCoachChatLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                */
/*val tags: MutableList<String> = ArrayList()
                tags.add(if (currentClickPos == 0) "health_coach_vaibhav" else "health_coach_john")
                val options = ConversationOptions()
                    .filterByTags(tags, "Test title")
                Freshchat.showConversations(requireActivity().applicationContext, options)*//*


            },
            onError = { throwable ->
                hideLoader()
                true
            })

    }

}*/
