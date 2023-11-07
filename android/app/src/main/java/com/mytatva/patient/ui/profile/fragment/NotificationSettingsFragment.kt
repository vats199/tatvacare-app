package com.mytatva.patient.ui.profile.fragment

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
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.NotificationSettingData
import com.mytatva.patient.databinding.ProfileFragmentNotificationSettingsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.NotificationSettingsAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit


class NotificationSettingsFragment : BaseFragment<ProfileFragmentNotificationSettingsBinding>() {

    private val settingsList =
        arrayListOf<NotificationSettingData>()//NotificationSettingsItem.values().toList()
    private val accountSettingsAdapter by lazy {
        NotificationSettingsAdapter(settingsList,
            object : NotificationSettingsAdapter.AdapterListener {
                override fun onClick(item: NotificationSettingData) {
                    handleItemClick(item)
                }

                override fun onToggleClick(position: Int, item: NotificationSettingData) {
                    item.notification_master_id?.let {
                        updateNotificationReminder(it, item.is_active ?: "")
                    }
                }
            })
    }

    var resumedTime = Calendar.getInstance().timeInMillis

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
    ): ProfileFragmentNotificationSettingsBinding {
        return ProfileFragmentNotificationSettingsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.NotificationSettings)
        resumedTime = Calendar.getInstance().timeInMillis
        notificationMasterList()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewNotificationSettings.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = accountSettingsAdapter
        }
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.TIME_SPENT_OPTION_MENU, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        })*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.notification_setting_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewNotification -> {
                openNotificationScreen()
            }
        }
    }

    private fun handleItemClick(item: NotificationSettingData/*NotificationSettingsItem*/) {
        when (item.keys) {
            Goals.Medication.goalKey -> {
                //no details
            }
            Goals.Exercise.goalKey -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsCommonGoalReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.GOALS, Goals.Exercise),
                        Pair(Common.BundleKey.NOTIFICATION_MASTER_ID, item.notification_master_id),
                        Pair(Common.BundleKey.IS_REMINDER_ON, item.isActive)
                    )).start()
            }
            Goals.Diet.goalKey -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsFoodReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.NOTIFICATION_MASTER_ID, item.notification_master_id),
                        Pair(Common.BundleKey.IS_REMINDER_ON, item.isActive)
                    )).start()
            }
            Goals.Pranayam.goalKey -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsCommonGoalReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.GOALS, Goals.Pranayam),
                        Pair(Common.BundleKey.NOTIFICATION_MASTER_ID, item.notification_master_id),
                        Pair(Common.BundleKey.IS_REMINDER_ON, item.isActive)
                    )).start()
            }
            Goals.WaterIntake.goalKey -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsWaterReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.NOTIFICATION_MASTER_ID, item.notification_master_id),
                        Pair(Common.BundleKey.IS_REMINDER_ON, item.isActive)
                    )).start()
            }
            /*NotificationSettingsItem.ReminderSteps -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsCommonGoalReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.GOALS, Goals.Steps)
                    )).start()
            }*/
            Goals.Sleep.goalKey -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsCommonGoalReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.GOALS, Goals.Sleep),
                        Pair(Common.BundleKey.NOTIFICATION_MASTER_ID, item.notification_master_id),
                        Pair(Common.BundleKey.IS_REMINDER_ON, item.isActive)
                    )).start()
            }
            "readings" -> { // common screen for all readings
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsReadingsReminderFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.NOTIFICATION_MASTER_ID, item.notification_master_id),
                        Pair(Common.BundleKey.IS_REMINDER_ON, item.isActive)
                    )).start()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun notificationMasterList() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.notificationMasterList(apiRequest)
    }

    private fun updateNotificationReminder(notificationMasterId: String, isActive: String) {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            is_active = isActive
        }
        showLoader()
        authViewModel.updateNotificationReminder(apiRequest, analytics)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.notificationMasterListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                settingsList.clear()
                responseBody.data?.let { settingsList.addAll(it) }
                accountSettingsAdapter.notifyDataSetChanged()
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
    }
}