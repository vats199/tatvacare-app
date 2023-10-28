package com.mytatva.patient.ui.auth.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.RelationType
import com.mytatva.patient.databinding.AuthRowSelectRelationTypeBinding

class SelectRelationTypeAdapter(var list: List<RelationType>) :
    RecyclerView.Adapter<SelectRelationTypeAdapter.ViewHolder>() {

    var selectionPos = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowSelectRelationTypeBinding.inflate(
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
            checkBoxDays.text = item.displayName
            checkBoxDays.isChecked = position == selectionPos
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowSelectRelationTypeBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.checkBoxDays.setOnClickListener {
                selectionPos = bindingAdapterPosition
                notifyDataSetChanged()
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}