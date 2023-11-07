package com.mytatva.patient.ui.auth.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.AuthRowAddedPrescriptionBinding
import com.mytatva.patient.utils.imagepicker.loadCircle
import com.mytatva.patient.utils.imagepicker.loadRounded

class SetUpDrugAddedPrescriptionAdapter(var list: ArrayList<TempDataModel>) :
    RecyclerView.Adapter<SetUpDrugAddedPrescriptionAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowAddedPrescriptionBinding.inflate(
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
            imageViewPrescription.loadRounded(item.imagePath,
                context.resources.getDimension(R.dimen.dp_5).toInt())
            /*textViewPrescriptionName.text = item.name
            textViewDate.text = item.name*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowAddedPrescriptionBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.imageViewRemove.setOnClickListener {
                list.removeAt(adapterPosition)
                notifyItemRemoved(adapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}