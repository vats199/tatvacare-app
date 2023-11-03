package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MedicationData
import com.mytatva.patient.databinding.GoalRowLogMedicationBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon

class LogMedicationAdapter(val list: ArrayList<MedicationData>) :
    RecyclerView.Adapter<LogMedicationAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            GoalRowLogMedicationBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            root.isSelected = position % 2 != 0

            imageViewMedicine.loadUrlIcon(item.image_url ?: "")
            textViewMedicine.text = item.medicine_name
            recyclerViewMedicationIndicator.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                adapter = LogMedicationIndicatorAdapter(item.dose_time_slot ?: listOf())
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowLogMedicationBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {

            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}