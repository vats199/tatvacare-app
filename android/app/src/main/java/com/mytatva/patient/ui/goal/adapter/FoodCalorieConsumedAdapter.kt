package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MacronutritionAnalysis
import com.mytatva.patient.databinding.GoalRowFoodCalorieConsumedBinding
import com.mytatva.patient.utils.parseAsColor

class FoodCalorieConsumedAdapter(
    var list: ArrayList<MacronutritionAnalysis>,
) : RecyclerView.Adapter<FoodCalorieConsumedAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowFoodCalorieConsumedBinding.inflate(
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
            textViewName.text = item.label

            val taken: Double = item.taken?.toDoubleOrNull() ?: 0.0
            val recommended: Double = item.recommended?.toDoubleOrNull() ?: 0.0

            /*textViewValue.text = StringBuilder()
                .append(taken.formatToDecimalPoint(2))
                .append(" of ")
                .append(recommended.formatToDecimalPoint(2))
                .append(" ")
                .append(item.unit_name)*/

            progressIndicator.setIndicatorColor(item.color_code.parseAsColor())

            progressIndicator.max = (recommended * 100).toInt()
            progressIndicator.progress = (taken * 100).toInt()
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowFoodCalorieConsumedBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {

            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
    }
}