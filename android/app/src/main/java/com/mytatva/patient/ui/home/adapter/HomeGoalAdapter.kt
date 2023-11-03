package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.HomeRowUpdateYourReadingNewBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class HomeGoalAdapter(
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HomeGoalAdapter.ViewHolder>() {

    lateinit var user: User

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowUpdateYourReadingNewBinding.inflate(
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
            imageViewIcon.loadUrlIcon(item.image_url ?: "", false)

            //imageViewIcon.backgroundTintList = ColorStateList.valueOf(item.background_color.parseAsColor())
            textViewReading.text = item.goal_name
            textViewReadingValue.text = item.todays_achieved_value ?: "-"
            textViewReadingUnit.text = "/ ${item.goal_value ?: "-"} ${item.goal_measurement}"

            textViewReadingValue2.isVisible = false
            textViewReadingValueSeparator.isVisible = false
            textViewReadingUnit2.isVisible = false

            val color = item.color_code.parseAsColor()
            //imageViewIcon.imageTintList = ColorStateList.valueOf(color)
            //textViewAverageReading.text = item.getStandardReadingLabel("")
            //item.getReadingAvgLabel(context.getString(R.string.label_avg_reading_of_others_))
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowUpdateYourReadingNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
            /*binding.imageViewInfo.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onInfoClick(bindingAdapterPosition)
                }
            }*/
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onInfoClick(position: Int)
    }
}