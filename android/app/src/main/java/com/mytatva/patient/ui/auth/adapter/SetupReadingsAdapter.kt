package com.mytatva.patient.ui.auth.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.AuthRowSetReadingsBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class SetupReadingsAdapter(
    val activity: BaseActivity,
    var list: ArrayList<GoalReadingData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<SetupReadingsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowSetReadingsBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            imageViewIconReading.loadUrlIcon(item.image_url ?: "", isCenterCrop = false)
            imageViewIconReading.imageTintList =
                ColorStateList.valueOf(item.color_code.parseAsColor())

            imageViewIconReading.backgroundTintList =
                ColorStateList.valueOf(item.background_color.parseAsColor())
            textViewReading.text = item.reading_name
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowSetReadingsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                textViewUpdate.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                    /*if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.reading_logs,
                            list[bindingAdapterPosition].keys ?: "")
                    ) {
                        adapterListener.onClick(bindingAdapterPosition)
                    }*/
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}