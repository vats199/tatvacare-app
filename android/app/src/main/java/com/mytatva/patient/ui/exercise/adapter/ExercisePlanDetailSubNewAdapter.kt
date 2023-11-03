package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.RoutineData
import com.mytatva.patient.databinding.ExerciseRowPlanDetailsSubNewBinding

class ExercisePlanDetailSubNewAdapter(
    var mainPosition: Int,
    var list: ArrayList<RoutineData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<ExercisePlanDetailSubNewAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowPlanDetailsSubNewBinding.inflate(
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
            imageViewUpDown.rotation = if (item.isSelected) 180F else 0F
            layoutBreathingExercise.visibility = if (item.isSelected) View.VISIBLE else View.GONE
            textViewRoutine.text = "Routine ${item.routine} for the day"
            textViewValueBreathing.text = item.breathingCountLabel
            imageViewSelectBreathing.isSelected = item.breathing_done == "Y"
            textViewValueExercise.text = item.exerciseCountLabel
            imageViewSelectExercise.isSelected = item.exercise_done == "Y"
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowPlanDetailsSubNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                layoutBreathingExercise.setOnClickListener {
                    adapterListener.onItemClick(mainPosition, bindingAdapterPosition)
                }
                layoutHeader.setOnClickListener {
                    list[bindingAdapterPosition].isSelected =
                        list[bindingAdapterPosition].isSelected.not()
                    notifyItemChanged(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(mainPosition: Int, position: Int)
    }
}