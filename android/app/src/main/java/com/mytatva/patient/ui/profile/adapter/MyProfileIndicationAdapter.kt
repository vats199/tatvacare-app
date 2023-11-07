package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.ProfileRowMyProfileIndicationBinding

class MyProfileIndicationAdapter(var list: ArrayList<TempDataModel>) :
    RecyclerView.Adapter<MyProfileIndicationAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowMyProfileIndicationBinding.inflate(
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
            imageViewIndicationIcon
            textViewIndication.text=item.name
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowMyProfileIndicationBinding) :
        RecyclerView.ViewHolder(binding.root)

    interface AdapterListener {
        fun onClick(position: Int)
    }
}