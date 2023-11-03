package com.mytatva.patient.ui.auth.adapter

import android.content.res.ColorStateList
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.AuthRowSetGoalsBinding
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class SetupGoalsAdapter(
    val activity: BaseActivity,
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<SetupGoalsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowSetGoalsBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            imageViewIconGoal.loadUrlIcon(item.image_url ?: "", isCenterCrop = false)
            textViewGoal.text = item.goal_name
            val goalValue = item.goal_value ?: "0"
            textViewGoalTime.text = goalValue.plus(" ")
                .plus(item.goal_measurement?.lowercase())
                .plus(" per day")
            textViewUpdateGoalTime.text = item.goal_measurement?.lowercase().plus(" per day")

            editTextGoalValue.setText(item.goalValueToUpdate)

            if (item.isSelected) {
                layoutUpdate.visibility = View.VISIBLE
            } else {
                layoutUpdate.visibility = View.GONE
            }

            textViewUpdateGoal.visibility =
                if (item.keys == Goals.Medication.goalKey || item.isSelected)
                    View.GONE else View.VISIBLE


            /*when (item.keys) {
                Goals.Exercise.goalKey -> {
                    editTextGoalValue.setMaxLength(2)
                }
                Goals.Pranayam.goalKey -> {
                    editTextGoalValue.setMaxLength(2)
                }
                Goals.Steps.goalKey -> {
                    editTextGoalValue.setMaxLength(5)
                }
                Goals.WaterIntake.goalKey -> {
                    editTextGoalValue.setMaxLength(2)
                }
                Goals.Sleep.goalKey -> {
                    editTextGoalValue.setMaxLength(2)
                }
            }*/
        }
    }

    override fun getItemCount(): Int = list.size

    override fun getItemViewType(position: Int): Int {
        return position
    }

    inner class ViewHolder(val binding: AuthRowSetGoalsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                textViewUpdateGoal.setOnClickListener {
                    if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs,
                            list[bindingAdapterPosition].keys?:"")) {
                        list[bindingAdapterPosition].goalValueToUpdate = ""
                        list[bindingAdapterPosition].isSelected = true
                        notifyItemChanged(bindingAdapterPosition)
                    }
                }
                editTextGoalValue.addTextChangedListener { text ->
                    list[bindingAdapterPosition].goalValueToUpdate = text.toString()
                }
                textViewUpdateGoalValue.setOnClickListener {

                    adapterListener.hideKeyboard()
                    Handler(Looper.getMainLooper()).postDelayed({

                        if (bindingAdapterPosition!=-1) {
                            if (list[bindingAdapterPosition].goalValueToUpdate.isNotBlank()) {
                                if (isValid) {
                                    list[bindingAdapterPosition].goal_value =
                                        list[bindingAdapterPosition].goalValueToUpdate
                                    list[bindingAdapterPosition].isSelected = false
                                    notifyItemChanged(bindingAdapterPosition)
                                    /*list.forEachIndexed { index, goalReadingData ->
                                    list[index].isSelected = false
                                }
                                notifyDataSetChanged()*/
                                }
                            } else {
                                list[bindingAdapterPosition].isSelected = false
                                notifyItemChanged(bindingAdapterPosition)
                            }
                        }

                    }, 100)

                }
            }
        }

        val isValid: Boolean
            get() {
                return try {
                    val goalValue =
                        list[bindingAdapterPosition].goalValueToUpdate.toIntOrNull() ?: 0

                    when (list[bindingAdapterPosition].keys) {
                        Goals.Exercise.goalKey -> {
                            if (goalValue > Goals.Exercise.maxGoalValue) {
                                throw ApplicationException("Please enter value less than ${Goals.Exercise.maxGoalValue}")
                            }
                        }
                        Goals.Pranayam.goalKey -> {
                            if (goalValue > Goals.Pranayam.maxGoalValue) {
                                throw ApplicationException("Please enter value less than ${Goals.Pranayam.maxGoalValue}")
                            }
                        }
                        Goals.Steps.goalKey -> {
                            if (goalValue > Goals.Steps.maxGoalValue) {
                                throw ApplicationException("Please enter value less than ${Goals.Steps.maxGoalValue}")
                            }
                        }
                        Goals.WaterIntake.goalKey -> {
                            if (goalValue > Goals.WaterIntake.maxGoalValue) {
                                throw ApplicationException("Please enter value less than ${Goals.WaterIntake.maxGoalValue}")
                            }
                        }
                        Goals.Sleep.goalKey -> {
                            if (goalValue > Goals.Sleep.maxGoalValue) {
                                throw ApplicationException("Please enter value less than ${Goals.Sleep.maxGoalValue}")
                            }
                        }
                        Goals.Diet.goalKey -> {
                            if (goalValue > Goals.Diet.maxGoalValue) {
                                throw ApplicationException("Please enter value less than ${Goals.Diet.maxGoalValue}")
                            }
                        }
                    }

                    true
                } catch (e: ApplicationException) {
                    adapterListener.showMessage(e.message)
                    false
                }
            }

    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun showMessage(message: String)
        fun hideKeyboard()
    }
}