package com.mytatva.patient.ui.auth.adapter

import android.annotation.SuppressLint
import android.content.res.ColorStateList
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.AuthRowSelectGoalsReadingsBinding
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class SelectGoalsReadingsAdapter(
    val analytics: AnalyticsClient,
    var list: ArrayList<GoalReadingData>,
) : RecyclerView.Adapter<SelectGoalsReadingsAdapter.ViewHolder>() {

    var isGoal: Boolean = false
    /*var selectedPos = 0*/

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowSelectGoalsReadingsBinding.inflate(
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

            checkBoxSelectIcon.isChecked = /*selectedPos == position*/ item.isSelected

            checkBoxSelectIcon.visibility = if (item.mandatory == "Y") View.GONE else View.VISIBLE

            if (isGoal) {
                imageViewIconGoal.visibility = View.VISIBLE
                imageViewIconReading.visibility = View.INVISIBLE
                textViewGoalReading.text = item.goal_name
                imageViewIconGoal.loadUrlIcon(item.image_url ?: "", isCenterCrop = false)
            } else {
                imageViewIconGoal.visibility = View.INVISIBLE
                imageViewIconReading.visibility = View.VISIBLE
                textViewGoalReading.text = item.reading_name
                imageViewIconReading.loadUrlIcon(item.image_url ?: "", isCenterCrop = false)
                imageViewIconReading.imageTintList =
                    ColorStateList.valueOf(item.color_code.parseAsColor())
                imageViewIconReading.backgroundTintList =
                    ColorStateList.valueOf(item.background_color.parseAsColor())
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowSelectGoalsReadingsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {

                // if not mandatory then only allow to add/remove
                if (list[bindingAdapterPosition].mandatory != "Y") {
                    list[bindingAdapterPosition].isSelected =
                        list[bindingAdapterPosition].isSelected.not()

                    if (isGoal) {
                        analytics.logEvent(analytics.USER_SELECT_GOAL, Bundle().apply {
                            putString(
                                analytics.PARAM_GOAL_ID,
                                list[bindingAdapterPosition].goal_master_id
                            )
                            putString(
                                analytics.PARAM_GOAL_NAME,
                                list[bindingAdapterPosition].goal_name
                            )
                            putString(
                                analytics.PARAM_IS_SELECT,
                                if (list[bindingAdapterPosition].isSelected) "1" else "0"
                            )
                        }, screenName = AnalyticsScreenNames.SelectGoals)
                    } else {
                        analytics.logEvent(analytics.USER_SELECT_READING, Bundle().apply {
                            putString(
                                analytics.PARAM_READING_ID,
                                list[bindingAdapterPosition].readings_master_id
                            )
                            putString(
                                analytics.PARAM_READING_NAME,
                                list[bindingAdapterPosition].reading_name
                            )
                            putString(
                                analytics.PARAM_IS_SELECT,
                                if (list[bindingAdapterPosition].isSelected) "1" else "0"
                            )
                        }, screenName = AnalyticsScreenNames.SelectReadings)
                    }

                    notifyItemChanged(bindingAdapterPosition)
                }

                /*selectedPos = adapterPosition
                notifyDataSetChanged()*/
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}