package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ExercisePlanDayData
import com.mytatva.patient.databinding.ExerciseRowPlanDetailsBinding

class ExercisePlanDetailsAdapter(
    var list: ArrayList<ExercisePlanDayData>,
    val adapterListener: AdapterListener,
    val subAdapterListener: ExerciseMyPlansSubAdapter.AdapterListener,
) : RecyclerView.Adapter<ExercisePlanDetailsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowPlanDetailsBinding.inflate(
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

            if (item.is_rest_day == "1") {
                layoutRestDay.visibility = View.VISIBLE
                recyclerView.visibility = View.GONE
            } else {
                layoutRestDay.visibility = View.GONE
                recyclerView.visibility = View.VISIBLE
            }

            textViewTitle.text = item.getDayTitleLabel
            recyclerView.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = ExerciseMyPlansSubAdapter(position,
                    item.getSubDataList,
                    subAdapterListener,
                    true)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowPlanDetailsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onItemClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
    }
}