package com.mytatva.patient.ui.labtest.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowTestsListNormalBinding

class NormalTestListAdapter(
    var list: ArrayList<TestPackageData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NormalTestListAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowTestsListNormalBinding.inflate(
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
            textViewTitle.text=item.name
            viewLine1.isVisible = position < list.lastIndex
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowTestsListNormalBinding) :
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