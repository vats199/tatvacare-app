package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.RecordData
import com.mytatva.patient.databinding.CarePlanRowRecordsBinding
import com.mytatva.patient.utils.imagepicker.loadRounded

class CarePlanHistoryRecordAdapter(
    var list: ArrayList<RecordData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<CarePlanHistoryRecordAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = CarePlanRowRecordsBinding.inflate(
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

            if (!(item.document_url?.firstOrNull() ?: "").contains(".pdf", true)) {
                imageViewPdf.visibility = View.GONE
                imageViewRecord.visibility = View.VISIBLE
                imageViewRecord.loadRounded(item.document_url?.firstOrNull() ?: "",
                    context.resources.getDimension(R.dimen.dp_6).toInt())
            } else {
                imageViewPdf.visibility = View.VISIBLE
                imageViewRecord.visibility = View.GONE
            }

            textViewName.text = item.title
            textViewDate.text = item.getFormattedDate
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CarePlanRowRecordsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewPdf.setOnClickListener {
                    adapterListener.onPDFClick(bindingAdapterPosition)
                }
                imageViewRecord.setOnClickListener {
                    adapterListener.onImageClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onPDFClick(position: Int)
        fun onImageClick(position: Int)
    }
}