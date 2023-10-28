package com.mytatva.patient.ui.auth.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.databinding.AuthRowDaysSelectionBinding

class SelectDaysAdapter(var list: List<DaysData>) :
    RecyclerView.Adapter<SelectDaysAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowDaysSelectionBinding.inflate(
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
            checkBoxDays.text = item.day
            checkBoxDays.isChecked = item.isSelected
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowDaysSelectionBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.checkBoxDays.setOnClickListener {
                // as per all day logic, if all is clicked
                if (list[bindingAdapterPosition].days_keys.equals("All", true)) {
                    // if select All day then only last will be selected, another all days will be false
                    list.forEachIndexed { index, tempDataModel ->
                        list[index].isSelected = index == bindingAdapterPosition
                    }
                    notifyDataSetChanged()
                } else {
                    list[bindingAdapterPosition].isSelected =
                        list[bindingAdapterPosition].isSelected.not()
                    // if All day selected then set to false
                    list.forEachIndexed { index, daysData ->
                        if (list[index].days_keys.equals("All", true)) {
                            list[index].isSelected = false
                        }
                    }
                    notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}