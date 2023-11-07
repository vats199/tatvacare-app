package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.FaqMainData
import com.mytatva.patient.databinding.MenuRowFaqBinding

class FAQAdapter(
    var list: List<FaqMainData>,
) : RecyclerView.Adapter<FAQAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowFaqBinding.inflate(
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
            textViewTitle.text = item.category_name
            recyclerViewSub.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = FAQSubAdapter(item.data ?: arrayListOf())
            }

            if (item.isSelected) {
                recyclerViewSub.visibility = View.VISIBLE
            } else {
                recyclerViewSub.visibility = View.GONE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowFaqBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                textViewTitle.setOnClickListener {
                    list[bindingAdapterPosition].isSelected =
                        list[bindingAdapterPosition].isSelected.not()
                    notifyItemChanged(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}