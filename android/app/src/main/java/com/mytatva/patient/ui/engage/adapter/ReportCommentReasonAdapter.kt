package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.EngageRowReportCommentResonsBinding

class ReportCommentReasonAdapter(
    var list: ArrayList<TempDataModel>,
) : RecyclerView.Adapter<ReportCommentReasonAdapter.ViewHolder>() {

    var selectedPos = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowReportCommentResonsBinding.inflate(
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
            textViewReason.isChecked = position == selectedPos
            textViewReason.text = item.name
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowReportCommentResonsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewReason.setOnClickListener {
                    selectedPos = adapterPosition
                    notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onReportClick(position: Int)
    }
}