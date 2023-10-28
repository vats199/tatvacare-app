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
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.NotificationReminderReadingsResData
import com.mytatva.patient.data.pojo.response.ReadingsReminderDetails
import com.mytatva.patient.databinding.ProfileFragmentNotificationSettingsReadingsReminderBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.NotificationSettingReadingsReminderAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel


class NotificationSettingsReadingsReminderFragment :
    BaseFragment<ProfileFragmentNotificationSettingsReadingsReminderBinding>() {

    private val notificationMasterId: String? by lazy {
        arguments?.getString(Common.BundleKey.NOTIFICATION_MASTER_ID)
    }

    private val isReminderOn: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_REMINDER_ON) ?: false
    }

    private val reminderList =
        arrayListOf<ReadingsReminderDetails>()
    private val notificationSettingReadingsReminderAdapter by lazy {
        NotificationSettingReadingsReminderAdapter(reminderList, navigator)
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
    ): ProfileFragmentNotificationSettingsReadingsReminderBinding {
        return ProfileFragmentNotificationSettingsReadingsReminderBinding.inflate(inflater,
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
        binding.buttonSave.isEnabled = isReminderOn
        setUpToolbar()
        setUpRecyclerView()
        getDaysList()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSave.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewReadingsReminder.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = notificationSettingReadingsReminderAdapter
            }
        }
    }

    override fun onPause() {
        super.onPause()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.notification_setting_title_reading_reminder)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            checkBoxOnOff.visibility = View.VISIBLE
            checkBoxOnOff.isChecked = isReminderOn
            checkBoxOnOff.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSave -> {
                if (reminderList.any {
                        it.isActive && (it.days_of_week.isNullOrBlank()
                                || it.frequency.isNullOrBlank()
                                || it.day_time.isNullOrBlank())
                    }) {
                    showMessage("Please select all the details for selected vitals")
                } else {
                    updateReadingsNotifications()
                }
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.checkBoxOnOff -> {
                with(binding) {
                    buttonSave.isEnabled = layoutHeader.checkBoxOnOff.isChecked
                    notificationSettingReadingsReminderAdapter.isReminderOn =
                        layoutHeader.checkBoxOnOff.isChecked
                    if (layoutHeader.checkBoxOnOff.isChecked.not()) {
                        reminderList.forEachIndexed { index, foodReminderDetails ->
                            reminderList[index].isActive = false
                        }
                    }
                    notificationSettingReadingsReminderAdapter.notifyDataSetChanged()
                    notificationMasterId?.let {
                        updateNotificationReminder(it,
                            if (layoutHeader.checkBoxOnOff.isChecked) "Y" else "N")
                    }
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getDaysList() {
        val apiRequest = ApiRequest()
        //showLoader()
        authViewModel.getDaysList(apiRequest)
    }

    private fun notificationDetailsReadings() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
        }
        showLoader()
        authViewModel.notificationDetailsReadings(apiRequest)
    }

    private fun updateNotificationReminder(notificationMasterId: String, isActive: String) {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            is_active = isActive
        }
        showLoader()
        authViewModel.updateNotificationReminder(apiRequest, analytics)
    }

    private fun updateReadingsNotifications() {
        val notificationDataList = arrayListOf<ApiRequestSubData>()
        reminderList.forEachIndexed { _, readingsReminderDetails ->
            notificationDataList.add(ApiRequestSubData().apply {
                days_of_week = readingsReminderDetails.days_of_week ?: ""
                frequency = readingsReminderDetails.frequency ?: ""
                day_time = readingsReminderDetails.day_time ?: ""
                readings_master_id = readingsReminderDetails.readings_master_id ?: ""
                is_active = readingsReminderDetails.is_active ?: "N"
            })
        }

        val apiRequest = ApiRequest().apply {
            notification_data = notificationDataList
        }
        showLoader()
        authViewModel.updateReadingsNotifications(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.notificationDetailsReadingsLiveData.observe(this,
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
                    notificationSettingReadingsReminderAdapter.daysList.clear()
                    notificationSettingReadingsReminderAdapter.daysList.addAll(it1.filter { it.days_keys != "ALL" })
                    notificationDetailsReadings()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.updateReadingsNotificationsLiveData.observe(this,
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
    private fun setDetails(notificationReminderReadingsResData: NotificationReminderReadingsResData?) {
        notificationReminderReadingsResData?.let {
            it.frequency?.let { it1 ->
                notificationSettingReadingsReminderAdapter.frequencyList.clear()
                notificationSettingReadingsReminderAdapter.frequencyList.addAll(it1)
            }

            reminderList.clear()
            it.details?.let { it1 -> reminderList.addAll(it1) }
            notificationSettingReadingsReminderAdapter.isReminderOn = isReminderOn
            notificationSettingReadingsReminderAdapter.notifyDataSetChanged()
        }
    }
}