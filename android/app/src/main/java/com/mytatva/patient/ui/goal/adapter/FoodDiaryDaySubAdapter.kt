package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.FoodLogSubData
import com.mytatva.patient.databinding.GoalRowFoodDiarySubBinding

class FoodDiaryDaySubAdapter(
    val mainPosition:Int,
    var list: ArrayList<FoodLogSubData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<FoodDiaryDaySubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowFoodDiarySubBinding.inflate(
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
            textViewCalorie.text = (item.calories?.toDoubleOrNull()?.toInt()?:0).toString().plus(" ${item.cal_unit_name}")
            textViewQty.text = item.quantity.plus(" ${item.unit_name}")
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowFoodDiarySubBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewEdit.setOnClickListener {
                    adapterListener.onEditClick(mainPosition,bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onEditClick(mainPosition: Int,position: Int)
    }
}