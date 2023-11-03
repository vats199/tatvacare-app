package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.RoutinesData
import com.mytatva.patient.databinding.GoalRowLogExerciseRoutinesBinding

class LogExerciseRoutineMainAdapter(
    var list: ArrayList<RoutinesData>,
    val adapterListener: LogExerciseRoutineSubAdapter.AdapterListener,
) : RecyclerView.Adapter<LogExerciseRoutineMainAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowLogExerciseRoutinesBinding.inflate(
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
            textViewRoutineNo.text = "Routine ${item.routine_no}"
            recyclerViewRoutinesSub.apply {
                layoutManager = LinearLayoutManager(context,RecyclerView.VERTICAL,false)
                adapter = LogExerciseRoutineSubAdapter(position, item.exercise_details?: arrayListOf(),adapterListener)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowLogExerciseRoutinesBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {

            }
        }
    }

    interface AdapterListener {
        fun onAddClick(position: Int)
    }
}