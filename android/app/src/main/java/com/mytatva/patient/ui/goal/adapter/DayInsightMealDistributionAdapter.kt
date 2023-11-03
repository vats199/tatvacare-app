package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MealEnergyDistribution
import com.mytatva.patient.databinding.GoalRowInsightMealDistributionBinding
import com.mytatva.patient.utils.parseAsColor

class DayInsightMealDistributionAdapter(
    var list: ArrayList<MealEnergyDistribution>,
) : RecyclerView.Adapter<DayInsightMealDistributionAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowInsightMealDistributionBinding.inflate(
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
            textViewName.text = item.meal_type
            textViewValueIndicator.text = item.limit

            val maxCal = item.recommended?.toDoubleOrNull() ?: 0.0
            val calTaken = item.calories_taken?.toDoubleOrNull() ?: 0.0

            textViewValue.text = StringBuilder()
                .append(calTaken.toInt())
                .append(" of ")
                .append(maxCal.toInt())
                .append(" ")
                .append(item.cal_unit_name)

            progressIndicator.max = (maxCal * 100).toInt()
            progressIndicator.progress = (calTaken * 100).toInt()
            progressIndicator.setIndicatorColor(item.color_code.parseAsColor())
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowInsightMealDistributionBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {

            }
        }
    }

    interface AdapterListener {
        fun onAddClick(position: Int)
    }
}