package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.ProfileRowMyDevicesBinding
import com.mytatva.patient.utils.imagepicker.loadDrawable

class MyDevicesAdapter(
    var list: List<TempDataModel>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<MyDevicesAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowMyDevicesBinding.inflate(
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
            imageViewIcon.loadDrawable(item.image, false)
            textViewItem.text = item.name
            viewLine1.visibility = if (position == list.lastIndex) View.GONE else View.VISIBLE

            buttonConnect.text = if (item.isConnected) "Disconnect" else "Connect"
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowMyDevicesBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                buttonConnect.setOnClickListener {
                    adapterListener.onConnectClick(bindingAdapterPosition)
                }
                root.setOnClickListener {
                    /*if (list[bindingAdapterPosition].isConnected.not()) {
                        adapterListener.onClick(bindingAdapterPosition)
                    }*/
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onConnectClick(position: Int)
    }
}