package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ExercisePlanData
import com.mytatva.patient.databinding.ExerciseRowMyPlansBinding

class ExerciseMyPlansAdapter(
    var list: ArrayList<ExercisePlanData>,
    val adapterListener: AdapterListener,
    val subAdapterListener: ExerciseMyPlansSubAdapter.AdapterListener,
) : RecyclerView.Adapter<ExerciseMyPlansAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowMyPlansBinding.inflate(
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
            textViewPlanName.text = item.title
            recyclerView.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = ExerciseMyPlansSubAdapter(position,
                    item.getSubDataList,
                    subAdapterListener,
                    false)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowMyPlansBinding) :
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