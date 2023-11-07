package com.mytatva.patient.ui.careplan.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.DoseTakenData
import com.mytatva.patient.databinding.CarePlanRowGoalSummaryMedicationIndicatorBinding

class GoalSummaryMedicationIndicatorAdapter(var list: List<DoseTakenData>) :
    RecyclerView.Adapter<GoalSummaryMedicationIndicatorAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            CarePlanRowGoalSummaryMedicationIndicatorBinding.inflate(LayoutInflater.from(parent.context),
                parent,
                false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            viewLineEnd.visibility = if (position == list.lastIndex) View.GONE else View.VISIBLE
            viewLineStart.visibility = if (position == 0) View.GONE else View.VISIBLE
            
            imageViewBadge.visibility = /*if (position % 2 == 0) View.VISIBLE else*/ View.INVISIBLE
            textViewTime.text = item.dose_day

            val achievedValue = item.achieved_value?.toIntOrNull() ?: 0
            val goalValue = item.goal_value?.toIntOrNull() ?: 0
            if (achievedValue >= goalValue) {
                imageViewDone.visibility = View.VISIBLE
                textViewProgress.visibility = View.GONE
            } else {
                imageViewDone.visibility = View.GONE
                textViewProgress.visibility = View.VISIBLE
                textViewProgress.text =
                    achievedValue.toString().plus("/").plus(goalValue.toString())
            }

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CarePlanRowGoalSummaryMedicationIndicatorBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {

            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}