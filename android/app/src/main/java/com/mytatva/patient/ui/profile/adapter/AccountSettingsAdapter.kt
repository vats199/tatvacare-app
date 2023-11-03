package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.SettingsItem
import com.mytatva.patient.databinding.ProfileRowAccountSettingsBinding
import com.mytatva.patient.utils.imagepicker.loadDrawable

class AccountSettingsAdapter(
    var list: List<SettingsItem>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<AccountSettingsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowAccountSettingsBinding.inflate(
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
            imageViewIcon.loadDrawable(item.icon, false)
            textViewItem.text = context.resources.getString(item.settingItem)
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowAccountSettingsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                root.setOnClickListener { adapterListener.onClick(list[bindingAdapterPosition]) }
            }
        }
    }

    interface AdapterListener {
        fun onClick(item: SettingsItem)
    }
}