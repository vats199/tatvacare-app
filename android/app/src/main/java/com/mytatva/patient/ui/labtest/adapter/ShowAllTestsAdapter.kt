package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ChildData
import com.mytatva.patient.databinding.LabtestRowShowAllTestBinding

class ShowAllTestsAdapter(var list: List<ChildData>) :
    RecyclerView.Adapter<ShowAllTestsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            LabtestRowShowAllTestBinding.inflate(
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
            textViewName.text = item.name
            recyclerViewAllTests.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = ShowAllTestsSubAdapter(arrayListOf())
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowShowAllTestBinding) :
        RecyclerView.ViewHolder(binding.root) {
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}