package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.FoodLogMainData
import com.mytatva.patient.databinding.GoalRowFoodDiaryMainBinding
import com.mytatva.patient.utils.imagepicker.loadRounded

class FoodDiaryDayMainAdapter(
    var list: ArrayList<FoodLogMainData>,
    val adapterListener: AdapterListener,
    val subAdapterListener: FoodDiaryDaySubAdapter.AdapterListener,
) : RecyclerView.Adapter<FoodDiaryDayMainAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowFoodDiaryMainBinding.inflate(
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

            textViewTitle.isChecked = item.meal_data.isNullOrEmpty().not()
            textViewTitle.text = item.meal_type

            val imageUrl = item.image_url?.firstOrNull() ?: ""
            if (imageUrl.isNotBlank()) {
                imageViewFood.visibility = View.VISIBLE
                imageViewFood.loadRounded(imageUrl,
                    context.resources.getDimension(R.dimen.dp_4).toInt())
            } else {
                imageViewFood.visibility = View.GONE
            }

            textViewCalorie.text = (item.total_cal?.toDoubleOrNull()?.toInt()?:0).toString().plus(" ${item.cal_unit_name}")

            if (item.isSelected && item.meal_data.isNullOrEmpty().not()) {
                layoutSub.visibility = View.VISIBLE
                imageViewUpDown.rotation = 180F
            } else {
                layoutSub.visibility = View.GONE
                imageViewUpDown.rotation = 0F
            }

            recyclerView.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter =
                    FoodDiaryDaySubAdapter(position,
                        item.meal_data ?: arrayListOf(),
                        subAdapterListener)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowFoodDiaryMainBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                layoutMain.setOnClickListener {
                    if (list[bindingAdapterPosition].meal_data.isNullOrEmpty().not()) {
                        list[bindingAdapterPosition].isSelected =
                            list[bindingAdapterPosition].isSelected.not()
                        notifyItemChanged(bindingAdapterPosition)
                    } else {
                        adapterListener.onItemClick(bindingAdapterPosition)
                    }
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
    }
}