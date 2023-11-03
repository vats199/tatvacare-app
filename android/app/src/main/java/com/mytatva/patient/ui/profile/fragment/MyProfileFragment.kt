package com.mytatva.patient.ui.profile.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.transition.AutoTransition
import androidx.transition.TransitionManager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.DoctorData
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.data.pojo.response.LanguageData
import com.mytatva.patient.databinding.ProfileFragmentMyProfileBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.SelectLanguageListFragment
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.chat.adapter.ChatListAdapter
import com.mytatva.patient.ui.chat.dialog.HealthCoachProfileDialog
import com.mytatva.patient.ui.profile.adapter.MyProfileConsultingDoctorAdapter
import com.mytatva.patient.ui.profile.adapter.MyProfileIndicationAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.loadCircle
import java.util.*


class MyProfileFragment : BaseFragment<ProfileFragmentMyProfileBinding>() {

    var selectedLanguage: LanguageData? = null
    var isEditAddress = false

    var resumedTime = Calendar.getInstance().timeInMillis

    private val indicationList = arrayListOf<TempDataModel>()

    private val myProfileIndicationAdapter by lazy {
        MyProfileIndicationAdapter(indicationList)
    }

    private val consultingDoctorList = arrayListOf<DoctorData>()
    private val myProfileConsultingDoctorAdapter by lazy {
        MyProfileConsultingDoctorAdapter(consultingDoctorList,
            object : MyProfileConsultingDoctorAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        DoctorProfileFragment::class.java)
                        .start()
                }
            })
    }


    var currentClickHCPos = -1
    private val healthCoachList = ArrayList<HealthCoachData>()
    private val chatListAdapter by lazy {
        ChatListAdapter(healthCoachList, object : ChatListAdapter.AdapterListener {
            override fun onClick(position: Int) {

                /*analytics.logEvent(analytics.USER_CHAT_WITH_HC,
                    Bundle().apply {
                        putString(analytics.PARAM_HEALTH_COACH_ID,
                            healthCoachList[position].health_coach_id)
                    }, screenName = AnalyticsScreenNames.MyProfile)

                if ((requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(PlanFeatures.chat_healthcoach)) {
                    ChatListFragment.isFirstMessageSentAPICalled = false
                    ChatListFragment.healthCoachId = healthCoachList[position].health_coach_id

                    currentClickHCPos = position
                    //healthCoachList[position].health_coach_id?.let { linkHealthCoachChat(it) }

                    val tags: MutableList<String> = ArrayList()
                    healthCoachList[position].tag_name?.let { tags.add(it) }
                    val options = ConversationOptions()
                        .filterByTags(tags, "")
                    Freshchat.showConversations(requireActivity().applicationContext, options)
                    //Freshchat.showFAQs(requireActivity().applicationContext)

                }*/

            }

            override fun onProfileClick(position: Int) {
                healthCoachList[position].health_coach_id?.let {
                    healthCoachDetailsById(it)
                }
            }
        })
    }

    override fun onPause() {
        super.onPause()
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
    ): ProfileFragmentMyProfileBinding {
        return ProfileFragmentMyProfileBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.MyProfile)
        resumedTime = Calendar.getInstance().timeInMillis
        analytics.logEvent(analytics.USER_PROFILE_VIEW, screenName = AnalyticsScreenNames.MyProfile)
        setUserData()
        getPatientDetails()
    }

    override fun bindData() {
        if (MyTatvaApp.IS_TO_USE_FIREBASE_FLAGS.not()) {
            getNoLoginSettingFlags()
        }
        updateLanguageUI()

        setUpToolbar()
        setViewListeners()
        setUpRecyclerView()

        if ((requireActivity() as BaseActivity)
                .isFeatureAllowedAsPerPlan(PlanFeatures.coach_list, needToShowDialog = false)
        ) {
            linkedHealthCoachList()
        }
    }

    private fun updateLanguageUI() {
        binding.textViewLanguage.isVisible =
            AppFlagHandler.isToHideLanguagePage(appPreferences, firebaseConfigUtil).not()
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setUserData() {
        with(binding) {
            session.user?.let {
//                if (EditProfileFragment.isProfilePicUpdated) {
                imageViewProfile.loadCircle(it.profile_pic ?: "")
//                }

                textViewName.text = it.name
//                textViewLanguage.text = it.languages_id
                textViewPersonInfo.text =
                    it.patient_age.plus(" Years, ").plus(if (it.gender == "M") "Male" else "Female")
                textViewCall.text = it.country_code + " " + it.contact_no
                textViewEmail.text = it.email

                if (it.city.isNullOrBlank().not() && it.state.isNullOrBlank().not()) {
                    textViewLocationCityState.text = it.city.plus(", ").plus(it.state)
                } else {
                    textViewLocationCityState.text = ""
                }

                editTextAddress.setText(it.address ?: "")
                textViewAddress.text = it.address ?: ""

                indicationList.clear()
                it.medical_condition_name?.firstOrNull()?.medical_condition_name?.let { name ->
                    indicationList.add(TempDataModel(name = name))
                }
                myProfileIndicationAdapter.notifyDataSetChanged()

                //doctor list
                consultingDoctorList.clear()
                it.patient_link_doctor_details?.let { it1 -> consultingDoctorList.addAll(it1) }
                myProfileConsultingDoctorAdapter.notifyDataSetChanged()
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewIndication.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = myProfileIndicationAdapter
        }

        binding.recyclerViewDoctor.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = myProfileConsultingDoctorAdapter
        }

        binding.recyclerViewHealthCoach.apply {
            layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            adapter = chatListAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.my_profile_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            textViewLanguage.setOnClickListener { onViewClick(it) }
            imageViewEditProfile.setOnClickListener { onViewClick(it) }
            imageViewProfile.setOnClickListener { onViewClick(it) }
            textViewSaveAddress.setOnClickListener { onViewClick(it) }
            textViewEditLocation.setOnClickListener { onViewClick(it) }
            textViewEditIndication.setOnClickListener { onViewClick(it) }
            textViewAddNewDoctor.setOnClickListener { onViewClick(it) }
        }
    }

    enum class NavigationCard {
        Profile, EditProfile, Location, Address
    }

    private fun logNavigationEvent(cardItem: NavigationCard) {
        analytics.logEvent(analytics.PROFILE_NAVIGATION,
            Bundle().apply {
                putString(analytics.PARAM_CARDS, cardItem.name)
            }, screenName = AnalyticsScreenNames.MyProfile)
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewProfile -> {
                //logNavigationEvent(NavigationCard.Profile)
                navigator.showImageViewerDialog(arrayListOf(session.user?.profile_pic ?: ""))
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewNotification -> {
                openNotificationScreen()
            }
            R.id.textViewLanguage -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectLanguageListFragment::class.java
                ).forResult(Common.RequestCode.REQUEST_SELECT_LANGUAGE).start()
            }
            R.id.imageViewEditProfile -> {
                logNavigationEvent(NavigationCard.EditProfile)
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    EditProfileFragment::class.java
                ).addSharedElements(arrayListOf(
                    androidx.core.util.Pair(binding.imageViewProfile,
                        binding.imageViewProfile.transitionName),
                    /*androidx.core.util.Pair(binding.textViewName,
                        binding.textViewName.transitionName),
                    androidx.core.util.Pair(binding.textViewEmail,
                        binding.textViewEmail.transitionName)*/
                )).start()
            }
            R.id.textViewEditLocation -> {
                logNavigationEvent(NavigationCard.Location)
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SelectYourLocationFragment::class.java).start()
            }
            R.id.textViewSaveAddress -> {
                with(binding) {
                    if (isEditAddress) {
                        if (editTextAddress.text.toString().trim().isBlank()) {
                            showMessage(getString(R.string.validation_enter_address))
                        } else {
                            updateProfile()
                        }
                    } else {
                        logNavigationEvent(NavigationCard.Address)
                        TransitionManager.beginDelayedTransition(root,
                            AutoTransition().setDuration(100))
                        isEditAddress = true
                        textViewSaveAddress.text = getString(R.string.my_profile_label_save)
                        editTextAddress.visibility = View.VISIBLE
                        textViewAddress.visibility = View.GONE
                        editTextAddress.requestFocus()
                        editTextAddress.setSelection(editTextAddress.text.toString().length)
                        showKeyBoard()
                    }
                }
            }
            R.id.textViewEditIndication -> {
            }
            R.id.textViewAddNewDoctor -> {
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == Common.RequestCode.REQUEST_SELECT_LANGUAGE) {
            if (data != null && resultCode == Activity.RESULT_OK) {
                selectedLanguage = data.getParcelableExtra(Common.BundleKey.LANGUAGE_DATA)
                binding.textViewLanguage.text = selectedLanguage?.language_name ?: ""
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateProfile() {
        //showLoader()
        val apiRequest = ApiRequest().apply {
            address = binding.editTextAddress.text.toString().trim()
        }
        authViewModel.updateProfile(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        authViewModel.getPatientDetails(apiRequest)
    }

    /*private fun patientLinkedDrDetails() {
        showLoader()
        val apiRequest = ApiRequest().apply {
            address = binding.editTextAddress.text.toString().trim()
        }
        authViewModel.patientLinkedDrDetails(apiRequest)
    }*/

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

    private fun getNoLoginSettingFlags() {
        val apiRequest = ApiRequest()
        authViewModel.getNoLoginSettingFlags(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updateProfileLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                /*navigator.showAlertDialog(responseBody.message,
                    dialogOkListener = object : BaseActivity.DialogOkListener {
                        override fun onClick() {

                        }
                    })*/
                onAddressUpdated()
                showMessage(responseBody.message)
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setUserData()
            },
            onError = { throwable ->
                hideLoader()
                false
            })

        authViewModel.linkedHealthCoachListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                healthCoachList.clear()
                responseBody.data?.let { healthCoachList.addAll(it) }
                chatListAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                false
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

        authViewModel.getNoLoginSettingFlagsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                appPreferences.setIsToHideLanguagePage(it.language_page == "N")
                updateLanguageUI()
            }
        }, onError = { throwable ->
            hideLoader()
            false
        })
    }

    private fun onAddressUpdated() {
        binding.apply {
            TransitionManager.beginDelayedTransition(root,
                AutoTransition().setDuration(100))
            hideKeyBoard()
            isEditAddress = false
            textViewSaveAddress.text = getString(R.string.my_profile_label_edit)
            textViewAddress.text = session.user?.address//editTextAddress.text.toString().trim()
            editTextAddress.clearFocus()
            editTextAddress.visibility = View.GONE
            textViewAddress.visibility = View.VISIBLE
        }
    }
}