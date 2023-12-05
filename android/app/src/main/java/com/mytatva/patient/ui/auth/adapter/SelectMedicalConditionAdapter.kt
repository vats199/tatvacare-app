package com.mytatva.patient.ui.auth.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.databinding.AuthRowMedicalConditionBinding

class SelectMedicalConditionAdapter(var list: ArrayList<MedicalConditionData>) :
    RecyclerView.Adapter<SelectMedicalConditionAdapter.ViewHolder>() {

    var selectedPos = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowMedicalConditionBinding.inflate(
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
            checkBoxMedicalCondition.text = item.medical_condition_name
            checkBoxMedicalCondition.isChecked = selectedPos == position
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowMedicalConditionBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.checkBoxMedicalCondition.setOnClickListener {
                selectedPos = adapterPosition
                notifyDataSetChanged()
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}