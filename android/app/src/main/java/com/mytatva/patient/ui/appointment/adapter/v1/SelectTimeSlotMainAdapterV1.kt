package com.mytatva.patient.ui.appointment.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TimeSlotData
import com.mytatva.patient.databinding.AppointmentRowSelectTimeSlotMainV1Binding
import com.mytatva.patient.utils.imagepicker.load

class SelectTimeSlotMainAdapterV1(
    var list: ArrayList<TimeSlotData>,
    val adapterListener: SelectTimeSlotAdapterV1.AdapterListener,
) : RecyclerView.Adapter<SelectTimeSlotMainAdapterV1.ViewHolder>() {

    //var selectedPosition = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = AppointmentRowSelectTimeSlotMainV1Binding.inflate(
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
            imageViewAppointment.load(item.icon_url ?: "", isCenterCrop = false)

            val timeSlotAdapter by lazy {
                SelectTimeSlotAdapterV1(this@SelectTimeSlotMainAdapterV1,
                    position, list[position].slots ?: arrayListOf(),adapterListener)
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
    inner class ViewHolder(val binding: AppointmentRowSelectTimeSlotMainV1Binding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}