package com.mytatva.patient.ui.auth.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.DosageTimeData
import com.mytatva.patient.databinding.*

class SuggestedDosageAdapter(var list: List<DosageTimeData>) :
    RecyclerView.Adapter<SuggestedDosageAdapter.ViewHolder>() {

    var selectedPosition = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowSuggestedDosageBinding.inflate(
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
            radioDosage.text = item.dose_type
            radioDosage.isChecked = position == selectedPosition
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowSuggestedDosageBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.radioDosage.setOnClickListener {
                selectedPosition = adapterPosition
                notifyDataSetChanged()
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}