package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.LabtestRowShowAllTestSubBinding

class ShowAllTestsSubAdapter(var list: List<TempDataModel>) :
    RecyclerView.Adapter<ShowAllTestsSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            LabtestRowShowAllTestSubBinding.inflate(
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
            //textViewName.text = item.day
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowShowAllTestSubBinding) :
        RecyclerView.ViewHolder(binding.root) {
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}