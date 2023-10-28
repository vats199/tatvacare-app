package com.mytatva.patient.ui.labtest.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowTestsBinding
import com.mytatva.patient.utils.imagepicker.load

class PopularTestAdapter(
    var list: ArrayList<TestPackageData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<PopularTestAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowTestsBinding.inflate(
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
            textViewTitle.text = item.name
            textViewDescription.text = item.description
            textViewPriceOld.text =
                context.resources.getString(R.string.symbol_rupee).plus(item.price)
            textViewPriceNew.text =
                context.resources.getString(R.string.symbol_rupee).plus(item.discount_price)
            imageViewIcon.load(item.imageLocation?:"",isCenterCrop = false)
            textViewPriceOld.isVisible = item.discountPercent > 0
            textViewDiscount.isVisible = item.discountPercent > 0
            textViewDiscount.text = "${item.discount_percent}%\nOff"
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowTestsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                adapterListener.onClick(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}