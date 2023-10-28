package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.LabtestRowCancelReasonBinding

class SelectCancelReasonAdapter(var list: List<TempDataModel>) :
    RecyclerView.Adapter<SelectCancelReasonAdapter.ViewHolder>() {

    var selectedPos = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            LabtestRowCancelReasonBinding.inflate(
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
            //checkBoxReason.text = item.day
            checkBoxReason.isChecked = selectedPos == position
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowCancelReasonBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.checkBoxReason.setOnClickListener {
                selectedPos = bindingAdapterPosition
                notifyDataSetChanged()
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}