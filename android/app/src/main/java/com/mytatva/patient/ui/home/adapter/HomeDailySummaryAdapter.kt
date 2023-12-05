package com.mytatva.patient.ui.home.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.HomeRowDailySummaryBinding
import com.mytatva.patient.utils.imagepicker.loadTopicIcon
import com.mytatva.patient.utils.parseAsColor

class HomeDailySummaryAdapter(
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HomeDailySummaryAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowDailySummaryBinding.inflate(
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

            root.transitionName = item.keys

            val color =
                if (item.color_code.isNullOrBlank().not())
                    item.color_code.parseAsColor()
                else progressIndicator.context.resources
                    .getColor(R.color.colorPrimary, null)

            layoutBgTitle.backgroundTintList = ColorStateList.valueOf(color)

            progressIndicator.setIndicatorColor(color)
            /*imageViewIcon.imageTintList = ColorStateList.valueOf(color)*/

            imageViewIcon.loadTopicIcon(item.image_url ?: "", false)
            textViewName.text = item.goal_name

            val achievedValue = item.todays_achieved_value?.toDoubleOrNull() ?: 0.0
            val goalValue = item.goal_value?.toDoubleOrNull() ?: 0.0

            if (goalValue == 0.0 && item.keys == Goals.Medication.goalKey) {
                progressIndicator.max = goalValue.toInt()
                progressIndicator.progress = goalValue.toInt()
                textViewValue.text = "Add medicine"
            } else {

                /*if (achievedValue >= goalValue) {
                progressIndicator.max = goalValue.toInt()
                progressIndicator.progress = goalValue.toInt()

                if (goalValue == 0.0 && item.keys == Goals.Medication.goalKey) {
                    textViewValue.text = "Add medicine"
                } else {
                    textViewValue.text = "Completed"
                }

            } else {*/

                when (item.keys) {
                    Goals.Sleep.goalKey -> {
                        progressIndicator.max = (goalValue * 100).toInt()
                        progressIndicator.progress = (achievedValue * 100).toInt()

                        textViewValue.text = achievedValue.toInt().toString()
                            .plus(" of ").plus(goalValue.toInt().toString())
                            .plus(" ").plus(item.goal_measurement)
                    }

                    else -> {
                        progressIndicator.max = goalValue.toInt()
                        progressIndicator.progress = achievedValue.toInt()

                        textViewValue.text = achievedValue.toInt().toString()
                            .plus(" of ").plus(goalValue.toInt().toString())
                            .plus(" ").plus(item.goal_measurement)
                    }
                }

                /*}*/

            }

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowDailySummaryBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onClick(bindingAdapterPosition, binding.root)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int, view: View)
    }
}