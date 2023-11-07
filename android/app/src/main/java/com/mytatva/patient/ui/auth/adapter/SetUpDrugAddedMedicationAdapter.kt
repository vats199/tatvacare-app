package com.mytatva.patient.ui.auth.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.databinding.AuthRowAddedMedicationBinding
import com.mytatva.patient.databinding.AuthRowDosageTimeBinding
import com.mytatva.patient.databinding.AuthRowSelectLanguageBinding

class SetUpDrugAddedMedicationAdapter(var list: ArrayList<ApiRequestSubData>) :
    RecyclerView.Adapter<SetUpDrugAddedMedicationAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowAddedMedicationBinding.inflate(
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
            textViewDosage.text = item.dose_name
            textViewDrugName.text = item.medicine_name
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowAddedMedicationBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                imageViewRemove.setOnClickListener {
                    list.removeAt(adapterPosition)
                    notifyItemRemoved(adapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}