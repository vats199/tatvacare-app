package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.RecordTitleData
import com.mytatva.patient.databinding.MenuRowSearchRecordTitleBinding

class SearchRecordTitleAdapter(
    var list: ArrayList<RecordTitleData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<SearchRecordTitleAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowSearchRecordTitleBinding.inflate(
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
                textViewMedicine.text = item.labelToAddAsCustom
                textViewMedicine.setTextColor(context.resources.getColor(R.color.colorPrimary,
                    null))
            } else {
                textViewMedicine.text = item.title
                textViewMedicine.setTextColor(context.resources.getColor(R.color.textBlack1, null))
            }
        }

    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowSearchRecordTitleBinding) :
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