package com.mytatva.patient.ui.labtest.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.LabtestRowPackagesListNormalBinding

class NormalPackageListAdapter(
    var list: ArrayList<TempDataModel>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<NormalPackageListAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowPackagesListNormalBinding.inflate(
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
            textViewTitle
            textViewNoOfTestsInclude
            textViewNoOfAvailableAtLab

            viewLine1.visibility = if (position == list.lastIndex) View.INVISIBLE else View.VISIBLE
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowPackagesListNormalBinding) :
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