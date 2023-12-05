package com.mytatva.patient.ui.auth.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.LanguageData
import com.mytatva.patient.databinding.AuthRowSelectLanguageBinding

class LanguageAdapter(var list: ArrayList<LanguageData>) :
    RecyclerView.Adapter<LanguageAdapter.ViewHolder>() {

    var selectedPosition = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowSelectLanguageBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            textViewLanguage.text = item.language_name
            checkBoxSelectIcon.isChecked = selectedPosition == position
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowSelectLanguageBinding) :
        RecyclerView.ViewHolder(binding.root)

    interface AdapterListener {
        fun onClick(position: Int)
    }
}