package com.mytatva.patient.ui.labtest.bottomsheet

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestTimeSlotData
import com.mytatva.patient.databinding.AppointmentRowSelectTimeSlotBinding

class LabtestSelectTimeSlotAdapter(
    var list: ArrayList<TestTimeSlotData>,
) : RecyclerView.Adapter<LabtestSelectTimeSlotAdapter.ViewHolder>() {

    var selectedPosition = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = AppointmentRowSelectTimeSlotBinding.inflate(
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
            textViewItem.isChecked = position == selectedPosition
            textViewItem.text = item.slot
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AppointmentRowSelectTimeSlotBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewItem.setOnClickListener {
                    selectedPosition = bindingAdapterPosition
                    notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}