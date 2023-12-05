package com.mytatva.patient.ui.goal.adapter

import android.app.Activity
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.FoodItemData
import com.mytatva.patient.databinding.GoalRowSelectFoodBinding

class SelectFoodAdapter(
    var list: ArrayList<FoodItemData>,
    var activity: Activity,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<SelectFoodAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowSelectFoodBinding.inflate(
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
            textViewItem.text = item.food_name

            textViewCalorie.text = if (item.getGmsLabel.isNotBlank()) {
                item.getGmsLabel.plus(" - ").plus(item.getCalculatedCalorieLabel)
            } else {
                item.getCalculatedCalorieLabel
            }

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowSelectFoodBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                /*imageViewAdd*/root.setOnClickListener {
                adapterListener.onAddClick(bindingAdapterPosition)
            }
            }
        }
    }

    interface AdapterListener {
        fun onAddClick(position: Int)
    }
}