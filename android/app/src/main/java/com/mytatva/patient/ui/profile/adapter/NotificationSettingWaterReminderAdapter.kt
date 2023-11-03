package com.mytatva.patient.ui.profile.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.HoursTimesData
import com.mytatva.patient.data.pojo.response.WaterReminderDetails
import com.mytatva.patient.databinding.ProfileRowNotificationSettingWaterReminderBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter

class NotificationSettingWaterReminderAdapter(
    var list: List<WaterReminderDetails>,
    val navigator: Navigator,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationSettingWaterReminderAdapter.ViewHolder>() {

    var selectedPosition = -1

    val hoursDataList = arrayListOf<HoursTimesData>()
    val timesDataList = arrayListOf<HoursTimesData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingWaterReminderBinding.inflate(
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
            if (selectedPosition == position) {
                textViewTime.isChecked = true
                checkBoxItem.isChecked = true
                imageViewEdit.visibility = View.VISIBLE
            } else {
                textViewTime.isChecked = false
                checkBoxItem.isChecked = false
                imageViewEdit.visibility = View.INVISIBLE
            }

            checkBoxItem.text = item.title
            textViewTime.text = when (item.value_type) {
                Common.ReminderValueType.TIMES -> {
                    timesDataList.firstOrNull { it.value == list[position].value }?.title
                }
                Common.ReminderValueType.HOUR -> {
                    hoursDataList.firstOrNull { it.value == list[position].value }?.title
                }
                else -> {
                    ""
                }
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: ProfileRowNotificationSettingWaterReminderBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                checkBoxItem.setOnClickListener {
                    selectedPosition = bindingAdapterPosition
                    notifyDataSetChanged()
                    adapterListener.onClick(bindingAdapterPosition)
                }
                imageViewEdit.setOnClickListener {
                    when (list[bindingAdapterPosition].value_type) {
                        Common.ReminderValueType.TIMES -> {
                            showTimesSelection(bindingAdapterPosition)
                        }
                        Common.ReminderValueType.HOUR -> {
                            showHoursSelection(bindingAdapterPosition)
                        }
                    }
                }
            }
        }
    }

    private fun showHoursSelection(bindingAdapterPosition: Int) {
        BottomSheet<HoursTimesData>().showBottomSheetDialog(navigator as BaseActivity,
            hoursDataList,
            "",
            object : BottomSheetAdapter.ItemListener<HoursTimesData> {
                override fun onItemClick(item: HoursTimesData, position: Int) {
                    list[bindingAdapterPosition].value = item.value
                    notifyItemChanged(bindingAdapterPosition)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<HoursTimesData>.MyViewHolder,
                    position: Int,
                    item: HoursTimesData,
                ) {
                    holder.textView.text = item.title
                }
            })
    }

    private fun showTimesSelection(bindingAdapterPosition: Int) {
        BottomSheet<HoursTimesData>().showBottomSheetDialog(navigator as BaseActivity,
            timesDataList,
            "",
            object : BottomSheetAdapter.ItemListener<HoursTimesData> {
                override fun onItemClick(item: HoursTimesData, position: Int) {
                    list[bindingAdapterPosition].value = item.value
                    notifyItemChanged(bindingAdapterPosition)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<HoursTimesData>.MyViewHolder,
                    position: Int,
                    item: HoursTimesData,
                ) {
                    holder.textView.text = item.title
                }
            })
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}