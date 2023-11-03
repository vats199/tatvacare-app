package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.data.pojo.response.MyDevicesData
import com.mytatva.patient.databinding.HomeRowMyDevicesBinding
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class HomeMyDeviceAdapter(
    var list: ArrayList<MyDevicesData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HomeMyDeviceAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowMyDevicesBinding.inflate(
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

    inner class ViewHolder(val binding: HomeRowMyDevicesBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.layoutMyDevice.setOnClickListener {
                adapterListener.onLayoutClick(bindingAdapterPosition)
            }
            binding.textViewConnect.setOnClickListener {
                adapterListener.onConnectClick(bindingAdapterPosition)
            }
        }

        fun binding(position: Int) = with(binding) {
            val context = textViewLastSynced.context
            val item = list[position]

            textViewDeviceName.text = item.title

            if (item.lastSyncDate?.trim().isNullOrBlank()) {
                textViewLastSynced.text =
                    context.resources.getString(R.string.validation_device_connection_required)
            } else {
                val dateStr = DateTimeFormatter
                    .date(item.lastSyncDate, DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_hmm_a)
                textViewLastSynced.text = "Last synced on $dateStr"
            }

            val image = when (item.key) {
                Device.BcaScale.deviceKey -> {
                    Device.BcaScale.deviceIcon
                }

                Device.Spirometer.deviceKey -> {
                    Device.Spirometer.deviceIcon
                }

                else -> {
                    Device.BcaScale.deviceIcon
                }
            }
            imageViewBCA.setImageResource(image)

            if (position != list.lastIndex) {
                viewLine.visibility = View.VISIBLE
            } else {
                viewLine.visibility = View.INVISIBLE
            }
        }

    }

    interface AdapterListener {
        fun onLayoutClick(position: Int)
        fun onConnectClick(position: Int)
    }
}