package com.mytatva.patient.ui.appointment.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TimeSlotData
import com.mytatva.patient.databinding.AppointmentRowSelectTimeSlotMainBinding

class SelectTimeSlotMainAdapter(
    var list: ArrayList<TimeSlotData>,
    //val adapterListener: AdapterListener,
) : RecyclerView.Adapter<SelectTimeSlotMainAdapter.ViewHolder>() {

    //var selectedPosition = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = AppointmentRowSelectTimeSlotMainBinding.inflate(
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

            val timeSlotAdapter by lazy {
                SelectTimeSlotAdapter(this@SelectTimeSlotMainAdapter,
                    position, list[position].slots ?: arrayListOf())
            }
            recyclerViewTimeSlots.apply {
                layoutManager = GridLayoutManager(recyclerViewTimeSlots.context,
                    2,
                    RecyclerView.VERTICAL,
                    false)
                adapter = timeSlotAdapter
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: AppointmentRowSelectTimeSlotMainBinding) :
        RecyclerView.ViewHolder(binding.root) {

        val timeSlotAdapter by lazy {
            SelectTimeSlotAdapter(this@SelectTimeSlotMainAdapter,
                bindingAdapterPosition,
                list[bindingAdapterPosition].slots ?: arrayListOf())
        }

        init {
            with(binding) {
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}