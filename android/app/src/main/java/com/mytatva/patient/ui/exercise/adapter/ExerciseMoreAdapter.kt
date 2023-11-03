package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.ExerciseMainData
import com.mytatva.patient.databinding.ExerciseRowMoreBinding
import com.mytatva.patient.ui.base.BaseActivity

class ExerciseMoreAdapter(
    val activity: BaseActivity,
    val userId: String,
    var list: ArrayList<ExerciseMainData>,
    val adapterListener: AdapterListener,
    val subAdapterListener: ExerciseMoreSubAdapter.AdapterListener,
) : RecyclerView.Adapter<ExerciseMoreAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowMoreBinding.inflate(
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
            textViewTitle.text = item.genre
            val isExerciseOfTheWeek = item.genre_master_id == null
            recyclerViewSub.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                adapter = ExerciseMoreSubAdapter(activity, position, userId,
                    item.content_data ?: arrayListOf(),
                    subAdapterListener,
                    isExerciseOfTheWeek = isExerciseOfTheWeek)
            }

            if (isExerciseOfTheWeek) {
                textViewTitle.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary))
                textViewViewMore.visibility = View.GONE
            } else {
                textViewTitle.setTextColor(ContextCompat.getColor(context, R.color.textBlack1))
                textViewViewMore.visibility = View.VISIBLE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowMoreBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewViewMore.setOnClickListener {
                    adapterListener.onViewMoreClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onViewMoreClick(position: Int)
    }
}