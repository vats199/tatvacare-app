package com.mytatva.patient.ui.profile.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.SettingsItem
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.ProfileFragmentAccountSettingsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.AccountSettingsAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.Calendar
import java.util.concurrent.TimeUnit


class AccountSettingsFragment : BaseFragment<ProfileFragmentAccountSettingsBinding>() {

    private val settingsList = SettingsItem.values().toList()
    private val accountSettingsAdapter by lazy {
        AccountSettingsAdapter(settingsList,
            object : AccountSettingsAdapter.AdapterListener {
                override fun onClick(item: SettingsItem) {
                    analytics.logEvent(analytics.ACCOUNT_SETTING_NAVIGATION,
                        Bundle().apply {
                            putString(analytics.PARAM_MENU, resources.getString(item.settingItem))
                        }, screenName = AnalyticsScreenNames.MyAccount)
                    handleSettingItemClick(item)
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
    ): ProfileFragmentAccountSettingsBinding {
        return ProfileFragmentAccountSettingsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.MyAccount)
        resumedTime = Calendar.getInstance().timeInMillis
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
        binding.recyclerViewSettings.apply {
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
        analytics.logEvent(analytics.TIME_SPENT_ACCOUNT_SETTING, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.MyAccount)
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.account_setting_title)
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

    private fun handleSettingItemClick(item: SettingsItem) {
        when (item) {
            /*SettingsItem.Profile -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    MyProfileFragment::class.java).start()
            }
            SettingsItem.Goals -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SetupGoalsReadingsFragment::class.java).start()
            }*/
            /*SettingsItem.Plans -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    PaymentPlanServiceMainFragment::class.java).start()
            }*/
            /*SettingsItem.CareTeam -> {
            }*/
            SettingsItem.ConnectedDevices -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    MyDevicesFragment::class.java).start()
            }
            SettingsItem.NotificationSettings -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    NotificationSettingsFragment::class.java).start()
            }
            /*SettingsItem.UpdateLocation -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SelectYourLocationFragment::class.java).start()
            }
            SettingsItem.UpdateHeightWeight -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SetupHeightWeightFragment::class.java).start()
            }*/
            SettingsItem.DeleteMyAccount -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    DeleteMyAccountFragment::class.java).start()
            }
            SettingsItem.LogOut -> {
                navigator.showAlertDialogWithOptions("Are you sure want to log out?",
                    dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                        override fun onYesClick() {
                            callLogoutApi()
                        }

                        override fun onNoClick() {

                        }
                    })
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    fun callLogoutApi() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.logout(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.logoutLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            logout(screenName = AnalyticsScreenNames.MyAccount)
        }, onError = { throwable ->
            hideLoader()
            /*googleFit.disconnect {
                 logout()
             }*/
            true
        })
    }

}