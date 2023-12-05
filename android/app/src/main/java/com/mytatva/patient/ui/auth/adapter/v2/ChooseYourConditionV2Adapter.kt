package com.mytatva.patient.ui.auth.adapter.v2

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.databinding.AuthRowChooseConditionV2Binding
import com.mytatva.patient.utils.imagepicker.load

class ChooseYourConditionV2Adapter(
    var list: ArrayList<MedicalConditionData>,
    var onClick: (MedicalConditionData?) -> Unit,
) :
    RecyclerView.Adapter<ChooseYourConditionV2Adapter.ViewHolder>() {

    private var prevPosition: Int = -1
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowChooseConditionV2Binding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        if (list.isNotEmpty()) {
            val item = list[position]
            holder.bind(item)
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowChooseConditionV2Binding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: MedicalConditionData) = with(binding) {
            val isByDefaultSelected = if (prevPosition == -1) {
                list.any { it.isSelected }
            } else false

            root.isSelected = item.isSelected
            imageViewCondition.load(
                if (item.isSelected) item.selected_imagess ?: "" else item.unselected_imagess ?: "",
                false
            )

            textViewLabelConditionName.isSelected = item.isSelected
            textViewLabelConditionName.text = item.medical_condition_name
            root.setOnClickListener {
                if (!isByDefaultSelected) {
                    singleSelection(bindingAdapterPosition)
                    onClick.invoke(item)
                } else {
                    onClick.invoke(null)
                }
            }
        }
    }

    private fun singleSelection(position: Int) {
        if (prevPosition != -1) {
            list[prevPosition].isSelected = false
            notifyItemChanged(prevPosition)
        }
        list[position].isSelected = true
        notifyItemChanged(position)
        prevPosition = position
    }
}