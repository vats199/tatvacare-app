package com.mytatva.patient.ui.spirometer.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.SpirometerTestResData
import com.mytatva.patient.databinding.SpirometerRowReadingsBinding
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class SpirometerReadingsAdapter(
    var list: ArrayList<SpirometerTestResData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<SpirometerReadingsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = SpirometerRowReadingsBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        holder.binding.apply {
            if (item.test_type == "S") {//standard
                layoutStandardTestReading.visibility = View.VISIBLE
                layoutIncentiveTestReading.visibility = View.GONE
                imageViewDownload.visibility = View.VISIBLE

                textViewLabelStandardTest.text = "Lung Health"

                textViewValueFvc.text = item.fvc?.plus(item.fvc_unit)
                textViewValuePercentFvc.text = item.fvc_percentage?.plus("% (P)")
                textViewValueFev1.text = item.fev1?.plus(item.fev1_unit)
                textViewValuePercentFev1.text = item.fev1_percentage?.plus("% (P)")
                textViewValueRatio.text = item.fvc_fev1_ratio?.plus(item.fvc_fev1_ratio_unit)
                textViewValuePercentRatio.text = item.fvc_fev1_ratio_percentage?.plus("% (P)")
                textViewValuePef.text = item.pef?.plus(item.pef_unit)
                textViewValuePercentPef.text = item.pef_percentage?.plus("% (P)")

            } else {//incentive
                layoutIncentiveTestReading.visibility = View.VISIBLE
                layoutStandardTestReading.visibility = View.GONE
                imageViewDownload.visibility = View.GONE

                textViewLabelStandardTest.text = "Lung Exercise"

                textViewValueMeasuredVolume.text = item.incentive_current_volume?.plus(" ml")
                textViewValueTargetVolume.text = item.incentive_target_volume?.plus(" ml")
            }

            textViewLabelDateAndTime.text = DateTimeFormatter.date(
                item.test_date_time,
                DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
            )
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_hmm_a)
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: SpirometerRowReadingsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewDownload.setOnClickListener {
                    if (bindingAdapterPosition != RecyclerView.NO_POSITION)
                        adapterListener.onDownloadClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onDownloadClick(position: Int)
    }
}