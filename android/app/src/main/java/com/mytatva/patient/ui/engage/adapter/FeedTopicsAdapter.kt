package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.databinding.EngageRowFeedTopicsBinding

class FeedTopicsAdapter(
    var list: ArrayList<String>
) : RecyclerView.Adapter<FeedTopicsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowFeedTopicsBinding.inflate(
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
            textViewTopic.text = item
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowFeedTopicsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {

            }
        }
    }
}