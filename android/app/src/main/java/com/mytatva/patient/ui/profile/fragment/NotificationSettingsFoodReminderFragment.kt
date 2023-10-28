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
import com.mytatva.patient.data.pojo.response.EverydayRemind
import com.mytatva.patient.data.pojo.response.FoodReminderDetails
import com.mytatva.patient.data.pojo.response.NotificationReminderFoodResData
import com.mytatva.patient.databinding.ProfileFragmentNotificationSettingsFoodReminderBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.NotificationSettingFoodReminderAdapter
import com.mytatva.patient.ui.profile.adapter.NotificationSettingReminderCommonOptionAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel


class NotificationSettingsFoodReminderFragment :
    BaseFragment<ProfileFragmentNotificationSettingsFoodReminderBinding>() {

    private val notificationMasterId: String? by lazy {
        arguments?.getString(Common.BundleKey.NOTIFICATION_MASTER_ID)
    }
    private val isReminderOn: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_REMINDER_ON) ?: false
    }
    private val reminderList = arrayListOf<FoodReminderDetails>()
    private val notificationSettingFoodReminderAdapter by lazy {
        NotificationSettingFoodReminderAdapter(reminderList,
            navigator,
            requireActivity() as BaseActivity,
            object : NotificationSettingFoodReminderAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    handleCommonOptionAdapter()
                }
            }
        )
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleCommonOptionAdapter() {
        if (notificationSettingReminderCommonOptionAdapter.selectedPos != -1
            && reminderList.any { it.isActive }
        ) {
            notificationSettingReminderCommonOptionAdapter.selectedPos = -1
            notificationSettingReminderCommonOptionAdapter.notifyDataSetChanged()
        }
    }

    private val commonOptionList = arrayListOf<EverydayRemind>()
    private val notificationSettingReminderCommonOptionAdapter by lazy {
        NotificationSettingReminderCommonOptionAdapter(commonOptionList, navigator,
            object : NotificationSettingReminderCommonOptionAdapter.AdapterListener {
                @SuppressLint("NotifyDataSetChanged")
                override fun onCommonOptionClick(isSelected: Boolean) {
                    //notificationSettingFoodReminderAdapter.isEditOptionEnabled = !isSelected
                    reminderList.forEachIndexed { index, foodReminderDetails ->
                        reminderList[index].isActive = false
                    }
                    notificationSettingFoodReminderAdapter.notifyDataSetChanged()
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
    ): ProfileFragmentNotificationSettingsFoodReminderBinding {
        return ProfileFragmentNotificationSettingsFoodReminderBinding.inflate(inflater,
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
        notificationDetailsFood()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSave.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewFoodReminder.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = notificationSettingFoodReminderAdapter
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
            textViewToolbarTitle.text = getString(R.string.notification_setting_label_food_reminder)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            checkBoxOnOff.visibility = View.VISIBLE
            checkBoxOnOff.isChecked = isReminderOn
            checkBoxOnOff.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSave -> {
                updateMealReminder()
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.checkBoxOnOff -> {
                handleOnOff()
                with(binding) {
                    notificationMasterId?.let {
                        updateNotificationReminder(it,
                            if (layoutHeader.checkBoxOnOff.isChecked) "Y" else "N")
                    }
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleOnOff() {
        with(binding) {
            val checked = layoutHeader.checkBoxOnOff.isChecked
            buttonSave.isEnabled = checked
            if (checked.not()) {
                reminderList.forEachIndexed { index, foodReminderDetails ->
                    reminderList[index].isActive = false
                }
            }
            notificationSettingFoodReminderAdapter.isMealReminderOn = checked
            notificationSettingFoodReminderAdapter.notifyDataSetChanged()
            notificationSettingReminderCommonOptionAdapter.isReminderOn = checked
            if (notificationSettingReminderCommonOptionAdapter.selectedPos != -1) {
                notificationSettingReminderCommonOptionAdapter.selectedPos = -1
                notificationSettingReminderCommonOptionAdapter.notifyDataSetChanged()
            }
        }
    }

    private fun notificationDetailsFood() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
        }
        showLoader()
        authViewModel.notificationDetailsFood(apiRequest)
    }

    private fun updateNotificationReminder(notificationMasterId: String, isActive: String) {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            is_active = isActive
        }
        showLoader()
        authViewModel.updateNotificationReminder(apiRequest, analytics)
    }

    private fun updateMealReminder() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId

            val list = arrayListOf<ApiRequestSubData>()
            reminderList.forEachIndexed { index, foodReminderDetails ->
                list.add(ApiRequestSubData().apply {
                    this.meal_types_id = foodReminderDetails.meal_types_id
                    this.meal_time = foodReminderDetails.meal_time
                    this.is_active = foodReminderDetails.is_active
                })
            }
            meal_data = list

            remind_everyday = commonOptionList.firstOrNull()?.remind_everyday
            remind_everyday_time = commonOptionList.firstOrNull()?.remind_everyday_time
        }
        showLoader()
        authViewModel.updateMealReminder(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.notificationDetailsFoodLiveData.observe(this,
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

        authViewModel.updateMealReminderLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handling methods
     * *****************************************************
     */
    @SuppressLint("NotifyDataSetChanged")
    private fun setDetails(notificationReminderFoodResData: NotificationReminderFoodResData?) {
        notificationReminderFoodResData?.let {
            reminderList.clear()
            it.details?.let { it1 -> reminderList.addAll(it1) }
            notificationSettingFoodReminderAdapter.notifyDataSetChanged()

            commonOptionList.clear()
            it.everyday_remind?.let { it1 ->
                commonOptionList.add(it1)

                if (it1.remind_everyday == "Y")
                    notificationSettingReminderCommonOptionAdapter.selectedPos = 0
                else
                    notificationSettingReminderCommonOptionAdapter.selectedPos = -1
            }

            notificationSettingFoodReminderAdapter.isMealReminderOn = isReminderOn
            notificationSettingReminderCommonOptionAdapter.isReminderOn = isReminderOn

            notificationSettingFoodReminderAdapter.notifyDataSetChanged()
            notificationSettingReminderCommonOptionAdapter.notifyDataSetChanged()
        }
    }
}