package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ExercisePlanData
import com.mytatva.patient.databinding.ExerciseRowMyPlansNewBinding
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.apputils.PlanFeatureHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class ExerciseMyPlansNewAdapter(
    var list: ArrayList<ExercisePlanData>,
    val navigator: Navigator,
    val analytics: AnalyticsClient,
    val adapterListener: AdapterListener,
    val subAdapterListener: ExerciseMyPlansSubNewAdapter.AdapterListener,
) : RecyclerView.Adapter<ExerciseMyPlansNewAdapter.ViewHolder>() {

    var isMyRoutineExerciseBreathingFeatureAllowed = false

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowMyPlansNewBinding.inflate(
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

            PlanFeatureHandler.handleFeatureAccess(
                layoutPlanLocked, navigator,
                isMyRoutineExerciseBreathingFeatureAllowed,
                analytics = analytics,
                eventName = analytics.USER_CLICKED_ON_PLAN_EXERCISE,
                screenName = AnalyticsScreenNames.ExercisePlan,
            )

            textViewPlanName.text = item.title

            if (item.getTotalDays > 0) {
                layoutDays.isVisible = true
                textViewValueDays.text = item.getTotalDays.toString().plus(" Days")
            } else {
                layoutDays.isVisible = false
            }

            if (item.getTotalSets > 0) {
                layoutSets.isVisible = true
                textViewValueSets.text = item.getTotalSets.toString().plus(" Sets")
            } else {
                layoutSets.isVisible = false
            }

            recyclerView.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = ExerciseMyPlansSubNewAdapter(position,
                    item.getSubDataList,
                    subAdapterListener,
                    false)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowMyPlansNewBinding) :
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