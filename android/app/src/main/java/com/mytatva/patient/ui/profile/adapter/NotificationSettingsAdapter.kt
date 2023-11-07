package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.NotificationSettingData
import com.mytatva.patient.databinding.ProfileRowNotificationSettingsBinding

class NotificationSettingsAdapter(
    var list: List<NotificationSettingData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<NotificationSettingsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationSettingsBinding.inflate(
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

            checkBoxOnOff.isChecked = item.isActive
            if (item.isDetailPage) {
                textViewItem.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0,
                    R.drawable.ic_next_arrow_gray, 0)
            } else {
                textViewItem.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0,
                    0, 0)
            }
            textViewItem.text = item.title
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowNotificationSettingsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                root.setOnClickListener { adapterListener.onClick(list[bindingAdapterPosition]) }
                checkBoxOnOff.setOnClickListener {
                    list[bindingAdapterPosition].isActive =
                        list[bindingAdapterPosition].isActive.not()
                    adapterListener.onToggleClick(bindingAdapterPosition,
                        list[bindingAdapterPosition])
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(item: NotificationSettingData)
        fun onToggleClick(position: Int, item: NotificationSettingData)
    }
}