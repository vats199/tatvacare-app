package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.OrderStatusData
import com.mytatva.patient.databinding.LabtestRowTrackOrderStatusBinding

class TrackOrderStatusAdapter(
    var list: ArrayList<OrderStatusData>,
) : RecyclerView.Adapter<TrackOrderStatusAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowTrackOrderStatusBinding.inflate(
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
            textViewSrNo.text = item.index //(position.plus(1)).toString()

            textViewSrNo.isChecked = item.isDone
            viewLine.isSelected = item.isDone

            textViewTitle.text = item.status

            textViewDate
            textViewDate.isVisible = false //item.isDone

            viewLine.isVisible = position != list.lastIndex
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowTrackOrderStatusBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}