package com.mytatva.patient.ui.profile.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.EverydayRemind
import com.mytatva.patient.data.pojo.response.NotificationReminderOtherResData
import com.mytatva.patient.data.pojo.response.OtherReminderDetails
import com.mytatva.patient.databinding.ProfileFragmentNotificationSettingsCommonGoalReminderBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.NotificationSettingCommonGoalReminderAdapter
import com.mytatva.patient.ui.profile.adapter.NotificationSettingReminderCommonOptionAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel


class NotificationSettingsCommonGoalReminderFragment :
    BaseFragment<ProfileFragmentNotificationSettingsCommonGoalReminderBinding>() {

    private val isValid: Boolean
        get() {
            try {
                if (notificationSettingReminderCommonOptionAdapter.selectedPos == -1) {
                    reminderList.forEachIndexed { index, otherReminderDetails ->
                        if (otherReminderDetails.value.isNullOrBlank()) {
                            when (otherReminderDetails.value_type) {
                                Common.ReminderValueType.DAYS -> {
                                    throw ApplicationException(getString(R.string.validation_select_days_of_week))
                                }
                                Common.ReminderValueType.FREQUENCY -> {
                                    throw ApplicationException(getString(R.string.validation_select_frequency))
                                }
                                Common.ReminderValueType.TIME -> {
                                    throw ApplicationException(getString(R.string.validation_select_time_of_the_day))
                                }
                            }
                        }
                    }
                }
                return true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                return false
            }
        }

    private val goal: Goals by lazy {
        arguments?.getSerializable(Common.BundleKey.GOALS) as Goals
    }

    private val isReminderOn: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_REMINDER_ON) ?: false
    }

    private val notificationMasterId: String? by lazy {
        arguments?.getString(Common.BundleKey.NOTIFICATION_MASTER_ID)
    }

    private val reminderList =
        arrayListOf<OtherReminderDetails>()
    private val notificationSettingCommonGoalReminderAdapter by lazy {
        NotificationSettingCommonGoalReminderAdapter(reminderList, navigator,
            object : NotificationSettingCommonGoalReminderAdapter.AdapterListener {
                override fun onEditClick(position: Int) {

                }
            })
    }

    private val commonOptionList = arrayListOf<EverydayRemind>()
    private val notificationSettingReminderCommonOptionAdapter by lazy {
        NotificationSettingReminderCommonOptionAdapter(commonOptionList, navigator,
            object : NotificationSettingReminderCommonOptionAdapter.AdapterListener {
                @SuppressLint("NotifyDataSetChanged")
                override fun onCommonOptionClick(isSelected: Boolean) {
                    notificationSettingCommonGoalReminderAdapter.isEditOptionEnabled = !isSelected
                    notificationSettingCommonGoalReminderAdapter.notifyDataSetChanged()
                }
            })
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
    ): ProfileFragmentNotificationSettingsCommonGoalReminderBinding {
        return ProfileFragmentNotificationSettingsCommonGoalReminderBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        //analytics.setScreenName(AnalyticsScreenNames.MyAccount)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpUI()
        setUpToolbar()
        setUpRecyclerView()
        //notificationDetailsCommon()
        setUpViewClickListener()
        getDaysList()
    }

    private fun setUpViewClickListener() {
        with(binding) {
            buttonSave.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpUI() {
        with(binding) {
            when (goal) {
                Goals.Exercise -> {
                    layoutHeader.textViewToolbarTitle.text = getString(R.string.notification_setting_label_exercise_reminder)
                    textViewLabelTitle.text =
                        getString(R.string.notification_setting_label_exercise_title_1)
                    textViewLabelDescription.text =
                        getString(R.string.notification_setting_label_exercise_title_2)
                    textViewGoalName.text = getString(R.string.notification_setting_label_exercise)
                }
                Goals.Pranayam -> {
                    layoutHeader.textViewToolbarTitle.text = getString(R.string.notification_setting_label_breathing_reminder)
                    textViewLabelTitle.text =
                        getString(R.string.notification_setting_label_breathing_title_1)
                    textViewLabelDescription.text =
                        getString(R.string.notification_setting_label_breathing_title_2)
                    textViewGoalName.text = getString(R.string.notification_setting_label_breathing_exercise)
                }
                Goals.Sleep -> {
                    layoutHeader.textViewToolbarTitle.text = getString(R.string.notification_setting_label_sleep_reminder)
                    textViewLabelTitle.text =
                        getString(R.string.notification_setting_label_sleep_title_1)
                    textViewLabelDescription.text =
                        getString(R.string.notification_setting_label_sleep_title_2)
                    textViewGoalName.text = getString(R.string.notification_setting_label_sleep)
                }
                Goals.Steps -> {
                    layoutHeader.textViewToolbarTitle.text = getString(R.string.notification_setting_label_exercise_reminder)
                    textViewLabelTitle.text =
                        getString(R.string.notification_setting_label_steps_title_1)
                    textViewLabelDescription.text =
                        getString(R.string.notification_setting_label_steps_title_2)
                    textViewGoalName.text = getString(R.string.notification_setting_label_steps)
                }

                else -> {}
            }

            binding.buttonSave.isEnabled = isReminderOn
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewWaterReminder.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = notificationSettingCommonGoalReminderAdapter
            }
            recyclerViewReminderCommon.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = notificationSettingReminderCommonOptionAdapter
            }
        }
    }

    override fun onPause() {
        super.onPause()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
//            textViewToolbarTitle.text = "Drink Water Reminder"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            checkBoxOnOff.visibility = View.VISIBLE
            checkBoxOnOff.isChecked = isReminderOn
            checkBoxOnOff.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.checkBoxOnOff -> {
                with(binding) {
                    buttonSave.isEnabled = layoutHeader.checkBoxOnOff.isChecked
                    notificationMasterId?.let {
                        updateNotificationReminder(it,
                            if (layoutHeader.checkBoxOnOff.isChecked) "Y" else "N")
                    }
                }
            }
            R.id.buttonSave -> {
                if (isValid) {
                    //call save API
                    updateNotificationDetails()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun notificationDetailsCommon() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
        }
        showLoader()
        authViewModel.notificationDetailsCommon(apiRequest)
    }

    private fun updateNotificationReminder(notificationMasterId: String, isActive: String) {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            is_active = isActive
        }
        showLoader()
        authViewModel.updateNotificationReminder(apiRequest, analytics)
    }

    private fun getDaysList() {
        val apiRequest = ApiRequest()
        //showLoader()
        authViewModel.getDaysList(apiRequest)
    }

    private fun updateNotificationDetails() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            goal_type = goal.goalKey

            days_of_week =
                reminderList.firstOrNull { it.value_type == Common.ReminderValueType.DAYS }?.value
            day_time =
                reminderList.firstOrNull { it.value_type == Common.ReminderValueType.TIME }?.value
            frequency =
                reminderList.firstOrNull { it.value_type == Common.ReminderValueType.FREQUENCY }?.value

            remind_everyday = commonOptionList.firstOrNull()?.remind_everyday
            remind_everyday_time = commonOptionList.firstOrNull()?.remind_everyday_time
        }
        showLoader()
        authViewModel.updateNotificationDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.notificationDetailsCommonLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setDetails(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                false
            })

        authViewModel.updateNotificationReminderLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
            },
            onError = { throwable ->
                hideLoader()
                false
            })

        authViewModel.getDaysListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { it1 ->
                    notificationSettingCommonGoalReminderAdapter.daysList.clear()
                    notificationSettingCommonGoalReminderAdapter.daysList.addAll(it1.filter { it.days_keys != "ALL" })
                    notificationDetailsCommon()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.updateNotificationDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setDetails(notificationReminderOtherResData: NotificationReminderOtherResData?) {
        notificationReminderOtherResData?.let {

            // set selected days in days list of adapter
            val selectedDayValue =
                it.details?.firstOrNull { it.value_type == Common.ReminderValueType.DAYS }?.value
            if (selectedDayValue.isNullOrBlank().not()) {
                try {
                    notificationSettingCommonGoalReminderAdapter.daysList.forEachIndexed { index, daysData ->
                        notificationSettingCommonGoalReminderAdapter.daysList[index].isSelected =
                            selectedDayValue?.split(",")?.contains(daysData.days_keys) == true
                    }
                } catch (e: Exception) {
                }
            }

            // set frequency
            it.frequency?.let { it1 ->
                notificationSettingCommonGoalReminderAdapter.frequencyList.clear()
                notificationSettingCommonGoalReminderAdapter.frequencyList.addAll(it1)
            }

            reminderList.clear()
            it.details?.let { it1 -> reminderList.addAll(it1) }


            // taken days from days list API
            /*it.days?.let { it1 ->
                notificationSettingCommonGoalReminderAdapter.daysList.clear()
                notificationSettingCommonGoalReminderAdapter.daysList.addAll(it1)
            }*/

            commonOptionList.clear()
            it.everyday_remind?.let { it1 ->
                commonOptionList.add(it1)
                if (it1.remind_everyday == "Y") {
                    notificationSettingCommonGoalReminderAdapter.isEditOptionEnabled = false
                    notificationSettingReminderCommonOptionAdapter.selectedPos = 0
                } else {
                    notificationSettingCommonGoalReminderAdapter.isEditOptionEnabled = true
                    notificationSettingReminderCommonOptionAdapter.selectedPos = -1
                }
            }
            notificationSettingCommonGoalReminderAdapter.notifyDataSetChanged()
            notificationSettingReminderCommonOptionAdapter.notifyDataSetChanged()
        }
    }
}