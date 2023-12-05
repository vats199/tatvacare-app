package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.FoodQtyUtensilData
import com.mytatva.patient.databinding.GoalRowFoodQtyHelpBinding
import com.mytatva.patient.utils.imagepicker.load

class FoodQuantityHelpAdapter(
    var list: ArrayList<FoodQtyUtensilData>,
) : RecyclerView.Adapter<FoodQuantityHelpAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowFoodQtyHelpBinding.inflate(
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
            imageView.load(item.image_url ?: "", false)
            textViewName.text = item.utensil_name
            textViewValue.text = item.quantity
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowFoodQtyHelpBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                root.setOnClickListener {

                }
            }
        }
    }

    interface AdapterListener {

    }
}