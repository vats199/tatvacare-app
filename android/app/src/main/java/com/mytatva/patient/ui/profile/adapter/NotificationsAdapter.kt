package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.NotificationData
import com.mytatva.patient.databinding.ProfileRowNotificationsBinding
import com.mytatva.patient.utils.imagepicker.load

class NotificationsAdapter(
    var list: List<NotificationData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NotificationsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowNotificationsBinding.inflate(
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
            if (item.image_url.isNullOrBlank()) {
                imageViewIcon.visibility = View.GONE
            } else {
                imageViewIcon.visibility = View.VISIBLE
                imageViewIcon.load(item.image_url, isCenterCrop = false)
            }
            //imageViewIcon.loadDrawable(R.drawable.ic_pranayam, false)
            textViewTitle.text = item.title
            textViewTime.text = item.formattedUpdatedDate
            root.isSelected = item.is_read == "0"
            textViewMessage.text = item.mesage
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowNotificationsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                root.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}