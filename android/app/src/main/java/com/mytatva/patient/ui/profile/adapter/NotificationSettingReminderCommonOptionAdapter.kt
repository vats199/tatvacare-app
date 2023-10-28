package com.mytatva.patient.ui.profile.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.DialogFragment
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.EverydayRemind
import com.mytatva.patient.databinding.ProfileRowNotificationSettingReminderCommonOptionBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.*

class NotificationSettingReminderCommonOptionAdapter(
    var list: List<EverydayRemind>,
    val navigator: Navigator,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationSettingReminderCommonOptionAdapter.ViewHolder>() {

    var isReminderOn = true

    var selectedPos = -1
        set(value) {
            // when set selectedPos to -1 then set N for elements inside list
            // else update Y for selected value, rest of all N
            list.forEachIndexed { index, everydayRemind ->
                if (value == index) {
                    list[index].remind_everyday = "Y"
                } else {
                    list[index].remind_everyday = "N"
                }
            }
            field = value
        }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingReminderCommonOptionBinding.inflate(
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
            textViewTime.text =
                DateTimeFormatter.date(item.remind_everyday_time, DateTimeFormatter.FORMAT_HHMMSS)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            checkBoxItem.text = item.title

            if (position == selectedPos) {
                checkBoxItem.isChecked = true
                imageViewEdit.visibility = View.VISIBLE
                textViewTime.isChecked = true
            } else {
                checkBoxItem.isChecked = false
                imageViewEdit.visibility = View.INVISIBLE
                textViewTime.isChecked = false
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: ProfileRowNotificationSettingReminderCommonOptionBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                rootLayout.setOnClickListener {
                    if (isReminderOn) {
                        if (selectedPos == -1) {
                            selectedPos = bindingAdapterPosition
                            adapterListener.onCommonOptionClick(true)
                        } else {
                            selectedPos = -1
                            adapterListener.onCommonOptionClick(false)
                        }
                        list.forEachIndexed { index, everydayRemind ->
                            list[index].remind_everyday = if (selectedPos == bindingAdapterPosition)
                                "Y" else "N"
                        }
                        notifyDataSetChanged()
                    }
                }
                imageViewEdit.setOnClickListener {
                    if (selectedPos == bindingAdapterPosition) {
                        showStartTimePicker(bindingAdapterPosition, binding)
                    }
                }
            }
        }
    }

    interface AdapterListener {
        fun onCommonOptionClick(isSelected: Boolean)
    }

    private fun showStartTimePicker(
        position: Int,
        binding: ProfileRowNotificationSettingReminderCommonOptionBinding,
    ) {
        val tpd = com.wdullaer.materialdatetimepicker.time.TimePickerDialog.newInstance(
            { view, hourOfDay, minute1, second ->
                val cal = Calendar.getInstance()
                cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                cal.set(Calendar.MINUTE, minute1)
                cal.set(Calendar.SECOND, 0)
                list[position].remind_everyday_time = DateTimeFormatter.date(cal.time)
                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
                binding.textViewTime.text =
                    DateTimeFormatter.date(list[position].remind_everyday_time,
                        DateTimeFormatter.FORMAT_HHMMSS)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
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

}