package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.DoseTimeSlotData
import com.mytatva.patient.databinding.GoalRowLogMedicationIndicatorBinding

class LogMedicationIndicatorAdapter(var list: List<DoseTimeSlotData>) :
    RecyclerView.Adapter<LogMedicationIndicatorAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            GoalRowLogMedicationIndicatorBinding.inflate(
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
            viewLineEnd.visibility = if (position == list.lastIndex) View.GONE else View.VISIBLE
            viewLineStart.visibility = if (position == 0) View.GONE else View.VISIBLE

            checkBoxSelect.isChecked = item.taken == "Y"
            textViewTime.text = item.getFormattedTime
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowLogMedicationIndicatorBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                checkBoxSelect.setOnClickListener {
                    list[bindingAdapterPosition].taken =
                        if (list[bindingAdapterPosition].taken == "Y") "N" else "Y"
                    notifyItemChanged(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}