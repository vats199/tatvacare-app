package com.mytatva.patient.ui.payment.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.databinding.PaymentScheduleRowSelectTimeSlotBinding

class SelectScheduleTimeSlotAdapter(
    val mainAdapter: SelectScheduleTimeSlotMainAdapter,
    val mainPosition: Int,
    var list: ArrayList<String>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<SelectScheduleTimeSlotAdapter.ViewHolder>() {

    companion object{
        var selectedMainPosition = -1
        var selectedPosition = -1
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentScheduleRowSelectTimeSlotBinding.inflate(
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
            textViewItem.isChecked =
                position == selectedPosition && selectedMainPosition == mainPosition
            textViewItem.text = item.replace("AM","",true).replace("PM","",true).replace("  "," ",true)
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentScheduleRowSelectTimeSlotBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewItem.setOnClickListener {
                    selectedMainPosition = mainPosition
                    selectedPosition = bindingAdapterPosition
                    adapterListener.onClick()
                    mainAdapter.notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick()
    }
}