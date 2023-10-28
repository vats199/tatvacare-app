package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.RoutineExerciseData
import com.mytatva.patient.databinding.GoalRowLogExerciseRoutinesSubBinding

class LogExerciseRoutineSubAdapter(
    var mainPosition: Int,
    var list: ArrayList<RoutineExerciseData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<LogExerciseRoutineSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowLogExerciseRoutinesSubBinding.inflate(
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
            textViewTitle.text = item.title
            editTextExerciseDuration.text = item.time_duration.plus(" ").plus(item.duration_unit)
            imageViewStatus.isSelected = item.done == "Y"
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowLogExerciseRoutinesSubBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                imageViewStatus.setOnClickListener {
                    adapterListener.onDoneClick(mainPosition, bindingAdapterPosition)
                    /*if (list[bindingAdapterPosition].done == "Y") {
                        list[bindingAdapterPosition].done = "N"
                    } else {
                        list[bindingAdapterPosition].done = "Y"
                    }
                    notifyItemChanged(bindingAdapterPosition)*/
                }
            }
        }
    }

    interface AdapterListener {
        fun onDoneClick(mainPosition: Int, position: Int)
    }
}