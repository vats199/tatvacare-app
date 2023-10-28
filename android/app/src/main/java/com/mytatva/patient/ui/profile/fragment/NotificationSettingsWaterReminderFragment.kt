package com.mytatva.patient.ui.profile.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.EverydayRemind
import com.mytatva.patient.data.pojo.response.NotificationReminderWaterResData
import com.mytatva.patient.data.pojo.response.WaterReminderDetails
import com.mytatva.patient.databinding.ProfileFragmentNotificationSettingsWaterReminderBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.NotificationSettingReminderCommonOptionAdapter
import com.mytatva.patient.ui.profile.adapter.NotificationSettingWaterReminderAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.*


class NotificationSettingsWaterReminderFragment :
    BaseFragment<ProfileFragmentNotificationSettingsWaterReminderBinding>() {

    private val isValid: Boolean
        get() {
            try {
                if (notificationSettingReminderCommonOptionAdapter.selectedPos == -1) {
                    with(binding) {
                        if (textViewStartTime.text.toString().trim().isBlank()) {
                            throw ApplicationException(getString(R.string.validation_select_from_time))
                        }
                        if (textViewEndTime.text.toString().trim().isBlank()) {
                            throw ApplicationException(getString(R.string.validation_select_to_time))
                        }
                    }

                    if (notificationSettingWaterReminderAdapter.selectedPosition != -1
                        && reminderList[notificationSettingWaterReminderAdapter.selectedPosition].value.isNullOrBlank()
                    ) {
                        if (reminderList[notificationSettingWaterReminderAdapter.selectedPosition].value_type == Common.ReminderValueType.HOUR) {
                            throw ApplicationException(getString(R.string.validation_select_remind_me_every))
                        }

                        if (reminderList[notificationSettingWaterReminderAdapter.selectedPosition].value_type == Common.ReminderValueType.TIMES) {
                            throw ApplicationException(getString(R.string.validation_select_remind_me))
                        }
                    }
                }
                return true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                return false
            }
        }

    private val notificationMasterId: String? by lazy {
        arguments?.getString(Common.BundleKey.NOTIFICATION_MASTER_ID)
    }

    private val isReminderOn: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_REMINDER_ON) ?: false
    }

    private val reminderList =
        arrayListOf<WaterReminderDetails>()
    private val notificationSettingWaterReminderAdapter by lazy {
        NotificationSettingWaterReminderAdapter(reminderList, navigator,
            object : NotificationSettingWaterReminderAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    removeSelectionFromCommonOptions()
                }
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun removeSelectionFromCommonOptions() {
        if (notificationSettingReminderCommonOptionAdapter.selectedPos != -1) {
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
                    /*notificationSettingWaterReminderAdapter.selectedPosition = -1
                    notificationSettingWaterReminderAdapter.notifyDataSetChanged()*/
                    if (isSelected) {
                        notificationSettingWaterReminderAdapter.selectedPosition = -1
                        notificationSettingWaterReminderAdapter.notifyDataSetChanged()
                    } else {
                        notificationSettingWaterReminderAdapter.selectedPosition = 0
                        notificationSettingWaterReminderAdapter.notifyDataSetChanged()
                    }
                }
            })
    }

    private val calStartTime = Calendar.getInstance()
    private val calEndTime = Calendar.getInstance()

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
    ): ProfileFragmentNotificationSettingsWaterReminderBinding {
        return ProfileFragmentNotificationSettingsWaterReminderBinding.inflate(inflater,
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
        setViewClickListeners()
        notificationDetailsWater()
    }

    private fun setViewClickListeners() {
        with(binding) {
            textViewStartTime.setOnClickListener { onViewClick(it) }
            textViewEndTime.setOnClickListener { onViewClick(it) }
            buttonSave.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewWaterReminder.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = notificationSettingWaterReminderAdapter
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
            textViewToolbarTitle.text = getString(R.string.notification_setting_label_water_reminder)
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
            R.id.textViewStartTime -> {
                showStartTimePicker()
            }
            R.id.textViewEndTime -> {
                showEndTimePicker()
            }
            R.id.buttonSave -> {
                if (isValid) {
                    updateWaterReminder()
                }
            }
        }
    }

    private fun showStartTimePicker() {
        val tpd = com.wdullaer.materialdatetimepicker.time.TimePickerDialog.newInstance(
            { view, hourOfDay, minute1, second ->
                calStartTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                calStartTime.set(Calendar.MINUTE, minute1)
                calStartTime.set(Calendar.SECOND, 0)

                binding.textViewStartTime.text = DateTimeFormatter.date(calStartTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)

                calEndTime.set(Calendar.HOUR_OF_DAY, hourOfDay + 5)
                calEndTime.set(Calendar.MINUTE, minute1)
                calEndTime.set(Calendar.SECOND, 0)

                binding.textViewEndTime.text = DateTimeFormatter.date(calEndTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            },
            0, 0,
            false
        )
        /*tpd.setMinTime(5, 0, 0)*/
        //tpd.setMaxTime(18, 0, 0)
        tpd.setTimeInterval(1, 15)
        tpd.accentColor = ContextCompat.getColor((navigator as BaseActivity), R.color.colorPrimary)
        tpd.setStyle(DialogFragment.STYLE_NORMAL, R.style.dateTimePickerDialog)
        activity?.supportFragmentManager?.let { tpd.show(it, "TimePickerDialog") }
    }

    private fun showEndTimePicker() {
        val tpd = com.wdullaer.materialdatetimepicker.time.TimePickerDialog.newInstance(
            { view, hourOfDay, minute1, second ->
                calEndTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                calEndTime.set(Calendar.MINUTE, minute1)
                calEndTime.set(Calendar.SECOND, 0)
                binding.textViewEndTime.text = DateTimeFormatter.date(calEndTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            },
            0, 0,
            false
        )
        /*tpd.setMinTime(calStartTime.get(Calendar.HOUR_OF_DAY) + 5,
            calStartTime.get(Calendar.MINUTE),
            0)*/
        /*if (calStartTime.get(Calendar.HOUR_OF_DAY) + 5 > 24) {
            try {
                Log.e("TAG",
                    "showEndTimePicker: +5 " + (calStartTime.get(Calendar.HOUR_OF_DAY) + 5))
                Log.e("TAG",
                    "showEndTimePicker: +23 " + (calStartTime.get(Calendar.HOUR_OF_DAY) + 23))
                tpd.setMaxTime(calStartTime.get(Calendar.HOUR_OF_DAY) + 23,
                    calStartTime.get(Calendar.MINUTE),
                    0)
            } catch (e: Exception) {
                e.printStackTrace()
                Log.e("TAG", "showEndTimePicker:" + e.localizedMessage)
            }
        }*/
        tpd.setTimeInterval(1, 15)
        tpd.accentColor = ContextCompat.getColor((navigator as BaseActivity), R.color.colorPrimary)
        tpd.setStyle(DialogFragment.STYLE_NORMAL, R.style.dateTimePickerDialog)
        activity?.supportFragmentManager?.let { tpd.show(it, "TimePickerDialog") }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun notificationDetailsWater() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
        }
        showLoader()
        authViewModel.notificationDetailsWater(apiRequest)
    }

    private fun updateNotificationReminder(notificationMasterId: String, isActive: String) {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            is_active = isActive
        }
        showLoader()
        authViewModel.updateNotificationReminder(apiRequest, analytics)
    }

    private fun updateWaterReminder() {
        val apiRequest = ApiRequest().apply {
            notification_master_id = notificationMasterId
            is_active = "Y"

            // main option
            notify_from = DateTimeFormatter.date(calStartTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
            notify_to = DateTimeFormatter.date(calEndTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
            if (notificationSettingWaterReminderAdapter.selectedPosition != -1) {
                if (reminderList[notificationSettingWaterReminderAdapter.selectedPosition].value_type == Common.ReminderValueType.HOUR) {
                    reminds_type = "H"
                } else {
                    reminds_type = "T"
                }
            } else {
                // pass empty remind type, when every day other option is selected
                reminds_type = ""
            }

            remind_every =
                reminderList.firstOrNull { it.value_type == Common.ReminderValueType.HOUR }?.value
            total_reminds =
                reminderList.firstOrNull { it.value_type == Common.ReminderValueType.TIMES }?.value

            // other option
            remind_everyday = commonOptionList.firstOrNull()?.remind_everyday
            remind_everyday_time = commonOptionList.firstOrNull()?.remind_everyday_time
        }
        showLoader()
        authViewModel.updateWaterReminder(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.notificationDetailsWaterLiveData.observe(this,
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

        authViewModel.updateWaterReminderLiveData.observe(this,
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
    private fun setDetails(notificationReminderWaterResData: NotificationReminderWaterResData?) {
        notificationReminderWaterResData?.let {
            it.hours_data?.let { it1 ->
                notificationSettingWaterReminderAdapter.hoursDataList.clear()
                notificationSettingWaterReminderAdapter.hoursDataList.addAll(it1)
            }
            it.times_data?.let { it1 ->
                notificationSettingWaterReminderAdapter.timesDataList.clear()
                notificationSettingWaterReminderAdapter.timesDataList.addAll(it1)
            }
            reminderList.clear()
            it.details?.let { it1 -> reminderList.addAll(it1) }
            notificationSettingWaterReminderAdapter.notifyDataSetChanged()

            //common option
            commonOptionList.clear()
            it.everyday_remind?.let { it1 ->
                commonOptionList.add(it1)
                if (it1.remind_everyday == "Y") {
                    notificationSettingReminderCommonOptionAdapter.selectedPos = 0
                    notificationSettingWaterReminderAdapter.selectedPosition = -1
                } else {
                    notificationSettingReminderCommonOptionAdapter.selectedPos = -1

                    if (it.basic_details?.remind_type == "T") {
                        notificationSettingWaterReminderAdapter.selectedPosition =
                            reminderList.indexOfFirst { it.value_type == Common.ReminderValueType.TIMES }
                    } else if (it.basic_details?.remind_type == "H") {
                        notificationSettingWaterReminderAdapter.selectedPosition =
                            reminderList.indexOfFirst { it.value_type == Common.ReminderValueType.HOUR }
                    } else {
                        notificationSettingWaterReminderAdapter.selectedPosition = 0
                    }
                }
            }
            notificationSettingWaterReminderAdapter.notifyDataSetChanged()
            notificationSettingReminderCommonOptionAdapter.notifyDataSetChanged()

            // from to times
            try {
                calStartTime.timeInMillis =
                    DateTimeFormatter.date(it.basic_details?.notify_from,
                        DateTimeFormatter.FORMAT_HHMMSS).date?.time!!

                calEndTime.timeInMillis =
                    DateTimeFormatter.date(it.basic_details?.notify_to,
                        DateTimeFormatter.FORMAT_HHMMSS).date?.time!!

                binding.textViewStartTime.text = DateTimeFormatter.date(calStartTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
                binding.textViewEndTime.text = DateTimeFormatter.date(calEndTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)

            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }
}