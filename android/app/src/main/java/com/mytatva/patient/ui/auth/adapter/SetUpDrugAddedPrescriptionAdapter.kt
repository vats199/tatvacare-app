package com.mytatva.patient.ui.auth.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.AuthRowAddedPrescriptionBinding
import com.mytatva.patient.utils.imagepicker.loadDrawable
import com.mytatva.patient.utils.imagepicker.loadRounded

class SetUpDrugAddedPrescriptionAdapter(var list: ArrayList<TempDataModel>/*,val adapterListener: AdapterListener*/) :
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

            imageViewPdf.isVisible = item.isPdfDocFile
            imageViewPrescription.isVisible = item.isPdfDocFile.not()

            if (item.isPdfDocFile) {
                imageViewPrescription.loadDrawable(R.drawable.ic_pdf)
            } else {
                imageViewPrescription.loadRounded(
                    item.imagePath,
                    context.resources.getDimension(R.dimen.dp_5).toInt()
                )
            }


            /*textViewPrescriptionName.text = item.name
            textViewDate.text = item.name*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowAddedPrescriptionBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            /*binding.imageViewPdf.setOnClickListener {
                adapterListener.onPdfClick(bindingAdapterPosition)
            }
            binding.imageViewPrescription.setOnClickListener {
                adapterListener.onImageClick(bindingAdapterPosition)
            }*/
            binding.imageViewRemove.setOnClickListener {
                list.removeAt(bindingAdapterPosition)
                notifyItemRemoved(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onImageClick(position: Int)
        fun onPdfClick(position: Int)
    }
}