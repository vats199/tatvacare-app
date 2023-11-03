package com.mytatva.patient.ui.careplan.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.CarePlanRowYourReadingHistoryLargeBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class ReadingHistoryLargeAdapter(
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<ReadingHistoryLargeAdapter.ViewHolder>() {

    lateinit var user:User

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            CarePlanRowYourReadingHistoryLargeBinding.inflate(
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
            //for transition
            root.transitionName = item.keys

            imageViewIcon.loadUrlIcon(item.image_icon_url ?: "", false)
            imageViewIcon.imageTintList = ColorStateList.valueOf(item.color_code.parseAsColor())

            textViewReadingName.text = item.reading_name

            imageViewBg.backgroundTintList =
                ColorStateList.valueOf(item.background_color.parseAsColor())

            textViewAverageReading.text = item.getStandardReadingLabel("")
            //item.getReadingAvgLabel(context.getString(R.string.label_avg_reading_of_others_))

            if (item.getReadingLabel.isNotBlank() && item.updated_at.isNullOrBlank().not()) {
                groupReadingValue.visibility = View.VISIBLE
                textViewDefaultMessage.visibility = View.GONE

                /* item.setReadingValueLabelUIAndData(textViewValue)
                 textViewUnit.text = item.getReadingsMeasurement*/
                textViewValue.maxLines = if (item.keys== Readings.FattyLiverUSGGrade.readingKey) 2 else 1
                item.setReadingValueLabelUIAndData(
                    textViewValue, textViewValue2,
                    textViewUnit, textViewUnit2, textViewValueSeparator, user
                )

                textViewUpdatedAt.text = if (item.formattedUpdatedDate.isBlank()) ""
                else "Updated " + item.formattedUpdatedDate

            } else {

                groupReadingValue.visibility = View.INVISIBLE
                textViewDefaultMessage.visibility = View.VISIBLE

                textViewDefaultMessage.text =
                    "Tap to update" /*"Please update your ${item.reading_name?.lowercase()}"*/
            }


        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CarePlanRowYourReadingHistoryLargeBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                adapterListener.onClick(bindingAdapterPosition, binding.root)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int, view: View)
    }
}