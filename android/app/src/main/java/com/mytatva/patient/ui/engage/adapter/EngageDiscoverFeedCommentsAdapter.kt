package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.CommentsData
import com.mytatva.patient.databinding.EngageRowDiscoverFeedCommentsBinding

class EngageDiscoverFeedCommentsAdapter(
    val userId: String,
    var list: ArrayList<CommentsData>,
    val mainItemPosition: Int,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<EngageDiscoverFeedCommentsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowDiscoverFeedCommentsBinding.inflate(
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
            textViewComment.text = item.comment
            textViewName.text = item.commented_by
            imageViewReport.isSelected = item.reported == "Y"

            imageViewDelete.visibility = if (userId == item.patient_id) View.VISIBLE else View.GONE
            imageViewReport.visibility = if (userId == item.patient_id) View.GONE else View.VISIBLE
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowDiscoverFeedCommentsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewReport.setOnClickListener {
                    adapterListener.onReportClick(mainItemPosition, bindingAdapterPosition)
                }
                imageViewDelete.setOnClickListener {
                    adapterListener.onDeleteClick(mainItemPosition, bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onReportClick(mainItemPosition: Int, position: Int)
        fun onDeleteClick(mainItemPosition: Int, position: Int)
    }
}