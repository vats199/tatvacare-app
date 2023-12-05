package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.HomeRowBookTestBinding
import com.mytatva.patient.utils.imagepicker.load

class HomeBookTestAdapter(
    var list: ArrayList<TestPackageData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<HomeBookTestAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowBookTestBinding.inflate(
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
            textViewTitle.text = item.catalogName
            textViewDescription.text = item.description
            textViewPriceOld.text =
                context.resources.getString(R.string.symbol_rupee)
                    .plus(item.mrpPrice?.toDoubleOrNull()?.toInt())
            textViewPriceNew.text =
                context.resources.getString(R.string.symbol_rupee)
                    .plus(item.discount_price?.toDoubleOrNull()?.toInt())
            imageViewIcon.load(item.imageLocation ?: "", isCenterCrop = false)

            textViewPriceOld.isVisible = item.discountPercent > 0
            textViewDiscount.isVisible = item.discountPercent > 0

            textViewDiscount.text = "${item.discount_percent?.toDoubleOrNull()?.toInt()}%\nOff"
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowBookTestBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION && list.isNotEmpty()) {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}