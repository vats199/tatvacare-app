package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.ProfileRowNotificationSettingReadingsReminderSubBinding
import com.mytatva.patient.ui.manager.Navigator
import java.util.*

class NotificationSettingReadingReminderSubAdapter(
    val mainPosition: Int,
    var list: List<TempDataModel>,
    val navigator: Navigator,
    //val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationSettingReadingReminderSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingReadingsReminderSubBinding.inflate(
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
            textViewTime
            textViewItem
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowNotificationSettingReadingsReminderSubBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                imageViewEdit.setOnClickListener {
                    navigator.pickTime({ _, hourOfDay, minute ->
                        val calTemp = Calendar.getInstance()
                        calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        calTemp.set(Calendar.MINUTE, minute)
                        calTemp.set(Calendar.SECOND, 0)
                    }, false)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}