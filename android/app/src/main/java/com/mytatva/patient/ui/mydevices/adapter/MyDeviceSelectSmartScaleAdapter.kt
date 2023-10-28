package com.mytatva.patient.ui.mydevices.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.MyDeviceSelectSmartScaleData
import com.mytatva.patient.databinding.MydeviceRowSelectSmartScaleBinding

class MyDeviceSelectSmartScaleAdapter(
    var list: ArrayList<MyDeviceSelectSmartScaleData>,
    val adapterListener: AdapterListener
) : RecyclerView.Adapter<MyDeviceSelectSmartScaleAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MydeviceRowSelectSmartScaleBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.binding(position)
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MydeviceRowSelectSmartScaleBinding) :
        RecyclerView.ViewHolder(binding.root) {

        init {
            binding.root.setOnClickListener {
                adapterListener.onItemClick(bindingAdapterPosition)
            }
        }

        fun binding(position: Int)=with(binding){
            val item = list[position]
            textViewDevices.text = item.title
        }

    }

    interface AdapterListener{
        fun onItemClick(position: Int)
    }
}