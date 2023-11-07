package com.mytatva.patient.ui.careplan.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MedicationSummaryData
import com.mytatva.patient.databinding.CarePlanRowGoalSummaryMedicationBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon

class GoalSummaryMedicationAdapter(val list: ArrayList<MedicationSummaryData>) :
    RecyclerView.Adapter<GoalSummaryMedicationAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            CarePlanRowGoalSummaryMedicationBinding.inflate(LayoutInflater.from(parent.context),
                parent,
                false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            root.isSelected = position % 2 != 0

            /*GlideApp.with(context)
                .load(item.image_url ?: "")
                .centerCrop()
                .transition(DrawableTransitionOptions.withCrossFade())
                .into(imageViewMedicine)*/

            imageViewMedicine.loadUrlIcon(item.image_url ?: "", false)
            textViewMedicine.text = item.medicine_name
            recyclerViewMedicationIndicator.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                adapter = GoalSummaryMedicationIndicatorAdapter(item.dose_taken_data ?: listOf())
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CarePlanRowGoalSummaryMedicationBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {

            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}