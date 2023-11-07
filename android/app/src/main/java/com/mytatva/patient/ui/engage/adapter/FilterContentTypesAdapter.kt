package com.mytatva.patient.ui.engage.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ContentTypeData
import com.mytatva.patient.databinding.EngageRowFilterItemCommonBinding

class FilterContentTypesAdapter(var list: List<ContentTypeData>) :
    RecyclerView.Adapter<FilterContentTypesAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            EngageRowFilterItemCommonBinding.inflate(
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
            textViewItem.text = item.content_type
            textViewItem.isChecked = item.isSelected
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: EngageRowFilterItemCommonBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.textViewItem.setOnClickListener {
                list[adapterPosition].isSelected = list[adapterPosition].isSelected.not()
                notifyItemChanged(adapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}