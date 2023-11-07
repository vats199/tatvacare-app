package com.mytatva.patient.ui.careplan.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.PrescriptionMedicationData
import com.mytatva.patient.databinding.CarePlanRowPrescriptionMedicationBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon

class PrescriptionMedicationAdapter(
    val list: ArrayList<PrescriptionMedicationData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<PrescriptionMedicationAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            CarePlanRowPrescriptionMedicationBinding.inflate(LayoutInflater.from(parent.context),
                parent,
                false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            root.isSelected = position % 2 != 0

            imageViewMedicine.loadUrlIcon(item.image_url ?: "")
            textViewMedicine.text = item.medicine_name
            textViewSubTitle.text = item.dose_type
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CarePlanRowPrescriptionMedicationBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                /*buttonOrderTest.setOnClickListener {
                    adapterListener.onOrderTestClick(absoluteAdapterPosition)
                }*/
            }
        }
    }

    interface AdapterListener {
        fun onOrderMedicineClick(position: Int)
        fun onOrderTestClick(position: Int)
    }
}