package com.mytatva.patient.ui.auth.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.ActivityLevels
import com.mytatva.patient.databinding.AuthRowChooseActivityLevelBinding

class ChooseActivityLevelAdapter(
    var list: ArrayList<ActivityLevels>,
    val callbackOnSelect: () -> Unit,
) :
    RecyclerView.Adapter<ChooseActivityLevelAdapter.ViewHolder>() {

    var selectedPosition = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowChooseActivityLevelBinding.inflate(
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
            textViewTitle.text = item.title
            textViewDescription.text = item.description
            radioActivityLevel.isChecked = selectedPosition == position
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AuthRowChooseActivityLevelBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                selectedPosition = bindingAdapterPosition
                notifyDataSetChanged()
                callbackOnSelect.invoke()
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}