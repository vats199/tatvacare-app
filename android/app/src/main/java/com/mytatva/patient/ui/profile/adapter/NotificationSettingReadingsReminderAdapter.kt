package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.DialogFragment
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.data.pojo.response.ReadingsReminderDetails
import com.mytatva.patient.data.pojo.response.ReminderFrequency
import com.mytatva.patient.databinding.ProfileRowNotificationSettingReadingsReminderBinding
import com.mytatva.patient.ui.auth.bottomsheet.SelectDaysBottomSheetDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.*

class NotificationSettingReadingsReminderAdapter(
    var list: List<ReadingsReminderDetails>,
    val navigator: Navigator,
    //val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationSettingReadingsReminderAdapter.ViewHolder>() {

    var isReminderOn = true
    var frequencyList = arrayListOf<ReminderFrequency>()
    var daysList = arrayListOf<DaysData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingReadingsReminderBinding.inflate(
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

            /*if (item.isVisible) {
                layoutSub.visibility = View.VISIBLE
                imageViewUpDown.rotation = 180F
            } else {
                layoutSub.visibility = View.GONE
                imageViewUpDown.rotation = 0F
            }*/

            checkBoxItem.text = item.reading_name

            checkBoxItem.isChecked = item.isActive
            textViewValueDays.isChecked = item.isActive
            textViewValueFrequency.isChecked = item.isActive
            textViewValueTime.isChecked = item.isActive

            if (item.isActive) {
                imageViewEditDays.visibility = View.VISIBLE
                imageViewEditFrequency.visibility = View.VISIBLE
                imageViewEditTime.visibility = View.VISIBLE

                layoutSub.visibility = View.VISIBLE
                imageViewUpDown.rotation = 180F
            } else {
                imageViewEditDays.visibility = View.INVISIBLE
                imageViewEditFrequency.visibility = View.INVISIBLE
                imageViewEditTime.visibility = View.INVISIBLE

                layoutSub.visibility = View.GONE
                imageViewUpDown.rotation = 0F
            }

            //days - take day names from the daysList as per the
            //comma separated keys inside days_of_week to display
            val sbDays = StringBuilder()
            item.days_of_week?.split(",")?.forEach { dayKey ->
                sbDays.append(daysList.firstOrNull { dayKey == it.days_keys }
                    ?.day?.take(3) ?: "").append(",")
            }
            textViewValueDays.text = sbDays.removeSuffix(",").toString()

            //frequency
            textViewValueFrequency.text =
                frequencyList.firstOrNull { it.key == item.frequency }?.frequency_name

            //time
            textViewValueTime.text = try {
                DateTimeFormatter.date(list[position].day_time,
                    DateTimeFormatter.FORMAT_HHMMSS)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            } catch (e: Exception) {
                ""
            }

            /*recyclerViewSub.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = NotificationSettingReadingReminderSubAdapter(position,
                    arrayListOf(TempDataModel(), TempDataModel(), TempDataModel()), navigator)
            }*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowNotificationSettingReadingsReminderBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                rootLayout.setOnClickListener {
                    if (isReminderOn) {
                        list[bindingAdapterPosition].isActive =
                            !list[bindingAdapterPosition].isActive
                        notifyItemChanged(bindingAdapterPosition)
                    }
                }
                imageViewUpDown.setOnClickListener {
                    list[bindingAdapterPosition].isActive = !list[bindingAdapterPosition].isActive
                    notifyItemChanged(bindingAdapterPosition)

                    /*list[bindingAdapterPosition].isVisible =
                        list[bindingAdapterPosition].isVisible.not()
                    notifyItemChanged(bindingAdapterPosition)*/
                }
                imageViewEditDays.setOnClickListener {
                    showDaysSelectionDialog(bindingAdapterPosition, binding)
                }
                imageViewEditFrequency.setOnClickListener {
                    showFrequencySelection(bindingAdapterPosition, binding)
                }
                imageViewEditTime.setOnClickListener {
                    showTimePicker(bindingAdapterPosition, binding)
                }
            }
        }
    }

    private fun showTimePicker(
        position: Int,
        binding: ProfileRowNotificationSettingReadingsReminderBinding,
    ) {
        val tpd = com.wdullaer.materialdatetimepicker.time.TimePickerDialog.newInstance(
            { view, hourOfDay, minute1, second ->
                val cal = Calendar.getInstance()
                cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                cal.set(Calendar.MINUTE, minute1)
                cal.set(Calendar.SECOND, 0)
                list[position].day_time = DateTimeFormatter.date(cal.time)
                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
                try {
                    binding.textViewValueTime.text =
                        DateTimeFormatter.date(list[position].day_time,
                            DateTimeFormatter.FORMAT_HHMMSS)
                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
                } catch (e: Exception) {
                    list[position].day_time = ""
                    binding.textViewValueTime.text = ""
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
        binding: ProfileRowNotificationSettingReadingsReminderBinding,
    ) {
        BottomSheet<ReminderFrequency>().showBottomSheetDialog(navigator as BaseActivity,
            frequencyList,
            "",
            object : BottomSheetAdapter.ItemListener<ReminderFrequency> {
                override fun onItemClick(item: ReminderFrequency, position: Int) {
                    list[bindingAdapterPosition].frequency = item.key
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
        binding: ProfileRowNotificationSettingReadingsReminderBinding,
    ) {
        // set selected days in days list of adapter to show selected in dialog
        // as per the current reading item
        val selectedDayValue = list[position].days_of_week
        try {
            daysList.forEachIndexed { index, daysData ->
                daysList[index].isSelected =
                    selectedDayValue?.split(",")?.contains(daysData.days_keys) == true
            }
        } catch (e: Exception) {
        }

        // open days selection
        (navigator as BaseActivity).supportFragmentManager.let {
            SelectDaysBottomSheetDialog(daysList) { selectedDaysList: List<DaysData> ->
                if (selectedDaysList.isNotEmpty()) {
                    val sbDayKeys = StringBuilder()
                    selectedDaysList.forEach { daysData ->
                        sbDayKeys.append(daysData.days_keys).append(",")
                    }
                    list[position].days_of_week = sbDayKeys.removeSuffix(",").toString()
                } else {
                    list[position].days_of_week = ""
                }
                notifyItemChanged(position)
            }.show(it, SelectDaysBottomSheetDialog::class.java.simpleName)
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}