package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.DialogFragment
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.data.pojo.response.OtherReminderDetails
import com.mytatva.patient.data.pojo.response.ReminderFrequency
import com.mytatva.patient.databinding.ProfileRowNotificationSettingCommonGoalReminderBinding
import com.mytatva.patient.ui.auth.bottomsheet.SelectDaysBottomSheetDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.*

class NotificationSettingCommonGoalReminderAdapter(
    var list: List<OtherReminderDetails>,
    val navigator: Navigator,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationSettingCommonGoalReminderAdapter.ViewHolder>() {

    var isEditOptionEnabled = false

    var frequencyList = arrayListOf<ReminderFrequency>()
    var daysList = arrayListOf<DaysData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingCommonGoalReminderBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {

            if (isEditOptionEnabled) {
                imageViewEdit.visibility = View.VISIBLE
                textViewTime.isChecked = true
            } else {
                imageViewEdit.visibility = View.INVISIBLE
                textViewTime.isChecked = false
            }

            textViewTime.text = when (item.value_type) {
                Common.ReminderValueType.DAYS -> {
                    val sbDays = StringBuilder()
                    daysList.forEach { daysData ->
                        if (daysData.isSelected)
                            sbDays.append(daysData.day?.take(3)).append(",")
                    }
                    sbDays.removeSuffix(",").toString()
                }
                Common.ReminderValueType.FREQUENCY -> {
                    frequencyList.firstOrNull { it.key == list[position].value }?.frequency_name
                }
                Common.ReminderValueType.TIME -> {
                    try {
                        DateTimeFormatter.date(list[position].value,
                            DateTimeFormatter.FORMAT_HHMMSS)
                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
                    } catch (e: Exception) {
                        ""
                    }
                }
                else -> {
                    ""
                }
            }

            checkBoxItem.text = item.title
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowNotificationSettingCommonGoalReminderBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                checkBoxItem.setOnClickListener {

                }
                imageViewEdit.setOnClickListener {
                    when (list[bindingAdapterPosition].value_type) {
                        Common.ReminderValueType.DAYS -> {
                            showDaysSelectionDialog(bindingAdapterPosition, binding)
                        }
                        Common.ReminderValueType.FREQUENCY -> {
                            showFrequencySelection(bindingAdapterPosition, binding)
                        }
                        Common.ReminderValueType.TIME -> {
                            showTimePicker(bindingAdapterPosition, binding)
                        }
                    }
                }
            }
        }
    }

    private fun showTimePicker(
        position: Int,
        binding: ProfileRowNotificationSettingCommonGoalReminderBinding,
    ) {
        val tpd = com.wdullaer.materialdatetimepicker.time.TimePickerDialog.newInstance(
            { view, hourOfDay, minute1, second ->
                val cal = Calendar.getInstance()
                cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                cal.set(Calendar.MINUTE, minute1)
                cal.set(Calendar.SECOND, 0)
                list[position].value = DateTimeFormatter.date(cal.time)
                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
                try {
                    binding.textViewTime.text =
                        DateTimeFormatter.date(list[position].value,
                            DateTimeFormatter.FORMAT_HHMMSS)
                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
                } catch (e: Exception) {
                    list[position].value = ""
                    binding.textViewTime.text = ""
                }
            },
            0, 0,
            false
        )
        /*tpd.setMinTime(5, 0, 0)*/
        /*tpd.setMaxTime(23, 0, 0)*/
        tpd.setTimeInterval(1, 15)
        tpd.accentColor = ContextCompat.getColor((navigator as BaseActivity), R.color.colorPrimary)
        tpd.setStyle(DialogFragment.STYLE_NORMAL, R.style.dateTimePickerDialog)
        navigator.supportFragmentManager.let { tpd.show(it, "TimePickerDialog") }
    }

    private fun showFrequencySelection(
        bindingAdapterPosition: Int,
        binding: ProfileRowNotificationSettingCommonGoalReminderBinding,
    ) {
        BottomSheet<ReminderFrequency>().showBottomSheetDialog(navigator as BaseActivity,
            frequencyList,
            "",
            object : BottomSheetAdapter.ItemListener<ReminderFrequency> {
                override fun onItemClick(item: ReminderFrequency, position: Int) {
                    list[bindingAdapterPosition].value = item.key
                    //list[bindingAdapterPosition].valueLabel = item.frequency_name ?: ""
                    notifyItemChanged(bindingAdapterPosition)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<ReminderFrequency>.MyViewHolder,
                    position: Int,
                    item: ReminderFrequency,
                ) {
                    holder.textView.text = item.frequency_name
                }
            })
    }

    private fun showDaysSelectionDialog(
        position: Int,
        binding: ProfileRowNotificationSettingCommonGoalReminderBinding,
    ) {

        (navigator as BaseActivity).supportFragmentManager.let {
            SelectDaysBottomSheetDialog(daysList) { selectedDaysList: List<DaysData> ->
                if (selectedDaysList.isNotEmpty()) {

                    val sbDayKeys = StringBuilder()
                    selectedDaysList.forEach { daysData ->
                        sbDayKeys.append(daysData.days_keys).append(",")
                    }
                    list[position].value = sbDayKeys.removeSuffix(",").toString()

                    /*val sbDays = StringBuilder()
                    selectedDaysList.forEach { daysData ->
                        sbDays.append(daysData.day?.take(3)).append(",")
                    }
                    list[position].valueLabel = sbDays.removeSuffix(",").toString()*/

                } else {
                    list[position].value = ""
                    //list[position].valueLabel = ""
                }
                notifyItemChanged(position)
            }.show(it, SelectDaysBottomSheetDialog::class.java.simpleName)
        }
    }

    interface AdapterListener {
        fun onEditClick(position: Int)
    }
}