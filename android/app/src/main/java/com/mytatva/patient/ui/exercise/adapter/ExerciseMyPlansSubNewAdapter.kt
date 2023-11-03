package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ExercisePlanSubData
import com.mytatva.patient.databinding.ExerciseRowMyPlansSubNewBinding
import com.mytatva.patient.utils.imagepicker.loadDrawable

class ExerciseMyPlansSubNewAdapter(
    val mainPosition: Int,
    var list: List<ExercisePlanSubData>,
    val adapterListener: AdapterListener,
    val isShowSelectIcon: Boolean,
) : RecyclerView.Adapter<ExerciseMyPlansSubNewAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowMyPlansSubNewBinding.inflate(
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
            textViewName.text = item.displayTitle
            textViewValue.text = item.exerciseCountLabel
            imageViewIcon.loadDrawable(item.iconRes, false)
            imageViewSelect.isSelected = item.isDone

            if (isShowSelectIcon) {
                imageViewSelect.visibility = View.VISIBLE
            } else {
                imageViewSelect.visibility = View.GONE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowMyPlansSubNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onItemClick(mainPosition, bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(mainPosition: Int, position: Int)
    }
}