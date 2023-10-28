package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ExercisePlanDayData
import com.mytatva.patient.databinding.ExerciseRowPlanDetailsNewBinding

class ExercisePlanDetailsNewAdapter(
    var list: ArrayList<ExercisePlanDayData>,
    //val adapterListener: AdapterListener,
    val subAdapterListener: ExercisePlanDetailSubNewAdapter.AdapterListener,
) : RecyclerView.Adapter<ExercisePlanDetailsNewAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowPlanDetailsNewBinding.inflate(
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
            textViewTitle.text = item.getDayTitleLabelNew
            recyclerView.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter =
                    ExercisePlanDetailSubNewAdapter(position,
                        item.routine_data ?: arrayListOf(),
                        subAdapterListener)
            }

            if (item.is_rest_day == "1") {
                layoutRestDay.visibility = View.VISIBLE
                recyclerView.visibility = View.GONE
            } else {
                layoutRestDay.visibility = View.GONE
                recyclerView.visibility = View.VISIBLE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowPlanDetailsNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    //adapterListener.onItemClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
    }
}