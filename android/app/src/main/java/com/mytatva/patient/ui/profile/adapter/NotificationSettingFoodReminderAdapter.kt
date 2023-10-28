package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.DialogFragment
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.FoodReminderDetails
import com.mytatva.patient.databinding.ProfileRowNotificationSettingFoodReminderBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.*

class NotificationSettingFoodReminderAdapter(
    var list: List<FoodReminderDetails>,
    val navigator: Navigator,
    val activity: BaseActivity,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationSettingFoodReminderAdapter.ViewHolder>() {

    var isMealReminderOn = false

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingFoodReminderBinding.inflate(
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
            viewLine1.visibility = if (position == list.lastIndex) View.GONE else View.VISIBLE

            textViewTime.text =
                DateTimeFormatter.date(item.meal_time, DateTimeFormatter.FORMAT_HHMMSS)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            checkBoxItem.text = item.meal_type

            if (item.isActive) {
                checkBoxItem.isChecked = true
                textViewTime.isChecked = true
                imageViewEdit.visibility = View.VISIBLE
            } else {
                checkBoxItem.isChecked = false
                textViewTime.isChecked = false
                imageViewEdit.visibility = View.INVISIBLE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowNotificationSettingFoodReminderBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                root.setOnClickListener {
                    if (isMealReminderOn) {
                        list[bindingAdapterPosition].isActive =
                            list[bindingAdapterPosition].isActive.not()
                        notifyItemChanged(bindingAdapterPosition)
                        adapterListener.onClick(bindingAdapterPosition)
                    }
                }
                imageViewEdit.setOnClickListener {
                    showTimePicker(bindingAdapterPosition, binding)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }

    private fun showTimePicker(
        position: Int,
        binding: ProfileRowNotificationSettingFoodReminderBinding,
    ) {
        val tpd = com.wdullaer.materialdatetimepicker.time.TimePickerDialog.newInstance(
            { view, hourOfDay, minute1, second ->
                val cal = Calendar.getInstance()
                cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                cal.set(Calendar.MINUTE, minute1)
                cal.set(Calendar.SECOND, 0)
                list[position].meal_time = DateTimeFormatter.date(cal.time)
                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
                binding.textViewTime.text =
                    DateTimeFormatter.date(list[position].meal_time,
                        DateTimeFormatter.FORMAT_HHMMSS)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            },
            0, 0,
            false
        )
        tpd.setTimeInterval(1, 15)
        tpd.accentColor = ContextCompat.getColor(activity, R.color.colorPrimary)
        tpd.setStyle(DialogFragment.STYLE_NORMAL, R.style.dateTimePickerDialog)
        activity.supportFragmentManager.let { tpd.show(it, "TimePickerDialog") }
    }
}