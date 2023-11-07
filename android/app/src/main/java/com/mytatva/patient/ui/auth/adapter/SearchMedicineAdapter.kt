package com.mytatva.patient.ui.auth.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.GetMedicineResData
import com.mytatva.patient.databinding.AuthRowSearchMedicineBinding

class SearchMedicineAdapter(
    var list: ArrayList<GetMedicineResData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<SearchMedicineAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = AuthRowSearchMedicineBinding.inflate(
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
            if (item.isSelected) {
                textViewMedicine.text = "Add ${item.medicine_name} as a Drug"
                textViewMedicine.setTextColor(context.resources.getColor(R.color.colorPrimary,
                    null))
            } else {
                textViewMedicine.text = item.medicine_name
                textViewMedicine.setTextColor(context.resources.getColor(R.color.textBlack1, null))
            }
        }

    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowSearchMedicineBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                adapterListener.onClick(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}