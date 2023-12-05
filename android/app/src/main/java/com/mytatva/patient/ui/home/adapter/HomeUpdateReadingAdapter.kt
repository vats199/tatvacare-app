package com.mytatva.patient.ui.home.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.HomeRowUpdateYourReadingNewBinding
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor
import java.math.RoundingMode
import java.text.DecimalFormat
import java.text.NumberFormat


class HomeUpdateReadingAdapter(
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HomeUpdateReadingAdapter.ViewHolder>() {

    lateinit var user: User

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowUpdateYourReadingNewBinding.inflate(
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
            imageViewIcon.loadUrlIcon(item.image_url ?: "", false)
            imageViewIcon.imageTintList =
                ColorStateList.valueOf(item.in_range?.icon_color.parseAsColor())
            textViewReading.text = item.reading_name

            /*Glide.with(context)
                .asBitmap()
                .load(item.image_url)
                .into(object : CustomTarget<Bitmap>(){
                    override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                        val palette: Palette = Palette.from(resource).generate()
                        textViewReading.setBackgroundColor(palette.getVibrantColor(Color.TRANSPARENT))
                        layoutReadingValue.setBackgroundColor(palette.getDominantColor(Color.TRANSPARENT))
                        textViewReadingValue.setBackgroundColor(palette.getDarkVibrantColor(Color.TRANSPARENT))
                    }

                    override fun onLoadCleared(placeholder: Drawable?) {
                        // this is called when imageView is cleared on lifecycle call or for
                        // some other reason.
                        // if you are referencing the bitmap somewhere else too other than this imageView
                        // clear it here as you can no longer have the bitmap
                    }
                })*/

            val color = item.color_code.parseAsColor()
            //imageViewInfo.imageTintList = ColorStateList.valueOf(color)
            //imageViewIcon.imageTintList = ColorStateList.valueOf(color)

            //textViewAverageReading.text = item.getStandardReadingLabel("")
            //item.getReadingAvgLabel(context.getString(R.string.label_avg_reading_of_others_))

            /*if (item.getReadingLabel.isNotBlank() && item.updated_at.isNullOrBlank().not()) {
                layoutReadingValue.visibility = View.VISIBLE
                *//*textViewUpdatedAt.visibility = View.VISIBLE
                textViewDefaultMessage.visibility = View.GONE*//*

                //item.setReadingValueLabelUIAndData(textViewReadingValue)
                //item.setReadingValueLabelUIAndDataV2(textViewReadingValue)

                textViewReadingValue.maxLines = if (item.keys == Readings.FattyLiverUSGGrade.readingKey) 2 else 1

                item.setReadingValueLabelUIAndData(textViewReadingValue, textViewReadingValue2,
                        textViewReadingUnit, textViewReadingUnit2, textViewReadingValueSeparator, user)
                //textViewReadingUnit.text = item.getReadingsMeasurement

                *//*textViewUpdatedAt.text = if (item.formattedUpdatedDate.isBlank()) ""
                else "Updated " + item.formattedUpdatedDate
                textViewUpdatedAt.isSelected = true// for marquee*//*

            } else {
                layoutReadingValue.visibility = View.INVISIBLE
                *//*textViewUpdatedAt.visibility = View.INVISIBLE
                textViewDefaultMessage.visibility = View.VISIBLE

                textViewDefaultMessage.text =
                    "Tap to update"*//**//*"Please update your ${item.reading_name?.lowercase()}"*//*
            }*/

            /*textViewDefaultMessage.setTextColor(ContextCompat.getColor(context,
                if (item.reading_required == "Y") R.color.red else R.color.gray8))
            textViewUpdatedAt.setTextColor(ContextCompat.getColor(context,
                if (item.reading_required == "Y") R.color.red else R.color.gray8))
            imageViewStar.isVisible = item.reading_required == "Y"

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                if (item.reading_required == "Y") {
                    cardRoot.outlineSpotShadowColor = ContextCompat.getColor(context, R.color.red)
                    cardRoot.outlineAmbientShadowColor =
                            ContextCompat.getColor(context, R.color.red)
                } else {
                    cardRoot.outlineSpotShadowColor = ContextCompat.getColor(context, R.color.black)
                    cardRoot.outlineAmbientShadowColor =
                            ContextCompat.getColor(context, R.color.black)
                }
            }*/

            textViewReadingValue2.isVisible = false
            textViewReadingValueSeparator.isVisible = false
            textViewReadingUnit2.isVisible = false

            if (item.measurements.isNullOrEmpty()) {
                textViewReadingUnit.text = "/ -"
            } else {
                textViewReadingUnit.text = "/ ${item.measurements}"
            }

            if (item.keys == Readings.FibroScan.readingKey) {
                if (item.reading_value_data?.lsm.isNullOrEmpty() && item.reading_value_data?.cap.isNullOrEmpty()) {
                    textViewReadingValue.text = "-"
                } else {
                    textViewReadingValue.text = NumberFormat.getInstance().format(
                        roundOffDecimal(
                            item.reading_value_data?.lsm?.toFloat() ?: 0.0f
                        )
                    )

                    textViewReadingValue2.text = NumberFormat.getInstance().format(
                        roundOffDecimal(
                            item.reading_value_data?.cap?.toFloat() ?: 0.0f
                        )
                    )
                }

                textViewReadingValue2.isVisible = true
                textViewReadingUnit2.isVisible = true

                textViewReadingUnit.text =
                    if (item.measurements != null && item.measurements.contains(","))
                        item.measurements.split(",")[0]
                    else ""

                textViewReadingUnit2.text =
                    if (item.measurements != null && item.measurements.contains(","))
                        item.measurements.split(",")[1]
                    else ""

            } else if (item.keys == Readings.BloodGlucose.readingKey) {
                if (item.reading_value_data?.fast.isNullOrEmpty() && item.reading_value_data?.pp.isNullOrEmpty()) {
                    textViewReadingValue.text = "-"
                } else {
                    textViewReadingValue.text =
                        NumberFormat.getInstance().format(
                            roundOffDecimal(
                                item.reading_value_data?.fast?.toFloat() ?: 0.0f
                            )
                        )

                    textViewReadingValue2.text =
                        NumberFormat.getInstance().format(
                            roundOffDecimal(
                                item.reading_value_data?.pp?.toFloat() ?: 0.0f
                            )
                        )
                }

                textViewReadingValue2.isVisible = true
                textViewReadingUnit2.isVisible = true

                textViewReadingUnit.text = item.measurements
                textViewReadingUnit2.text = item.measurements
            } else if (item.keys == Readings.BloodPressure.readingKey) {
                if (item.reading_value_data?.systolic.isNullOrEmpty() && item.reading_value_data?.diastolic.isNullOrEmpty()) {
                    textViewReadingValue.text = "-"
                } else {
                    textViewReadingValue.text =
                        "${
                            NumberFormat.getInstance().format(
                                roundOffDecimal(
                                    item.reading_value_data?.systolic?.toFloat() ?: 0.0f
                                )
                            )
                        }/${
                            NumberFormat.getInstance().format(
                                roundOffDecimal(
                                    item.reading_value_data?.diastolic?.toFloat() ?: 0.0f
                                )
                            )
                        }"
                }
            } else {
                if (item.reading_value.isNullOrEmpty()) {
                    textViewReadingValue.text = "-"
                } else {
                    textViewReadingValue.text = NumberFormat.getInstance().format(
                        roundOffDecimal(
                            item.reading_value.toFloat()
                        )
                    ).toString()
                }
            }


        }


    }

    fun roundOffDecimal(number: Float): Float {
        val df = DecimalFormat("#.##")
        df.roundingMode = RoundingMode.CEILING
        return df.format(number).toFloat()
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowUpdateYourReadingNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
            /*binding.imageViewInfo.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onInfoClick(bindingAdapterPosition)
                }
            }*/
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onInfoClick(position: Int)
    }
}