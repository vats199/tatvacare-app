package com.mytatva.patient.ui.mydevices.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.getColorsAsPerStatus
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.MydeviceRowMyVitalsBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class BcaMyReadingsAdapter(
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<BcaMyReadingsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MydeviceRowMyVitalsBinding.inflate(
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
            imageViewVitals.loadUrlIcon(item.image_url ?: "", isCenterCrop = false)
            imageViewVitals.imageTintList = ColorStateList.valueOf(item.color_code.parseAsColor())
            imageViewVitals.backgroundTintList =
                ColorStateList.valueOf(item.color_code.parseAsColor())
            textViewReadingName.text = item.reading_name.plus(" (${item.measurements})")
            textViewReadingValue.text = item.getReadingLabel.ifBlank { "-" }
            textViewStatus.text = item.reading_range

            if (item.reading_range.isNullOrBlank()) {
                textViewStatus.visibility = View.INVISIBLE
            } else {
                textViewStatus.visibility = View.VISIBLE

                val color = item.reading_range.getColorsAsPerStatus()
                textViewStatus.setTextColor(context.resources.getColor(color, null))
                textViewStatus.backgroundTintList =
                    ColorStateList.valueOf(context.resources.getColor(color, null))
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MydeviceRowMyVitalsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                adapterListener.onItemClick(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
    }
}