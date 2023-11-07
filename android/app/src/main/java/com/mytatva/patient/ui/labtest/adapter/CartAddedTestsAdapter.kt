package com.mytatva.patient.ui.labtest.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowCartTestsBinding
import com.mytatva.patient.utils.imagepicker.load

class CartAddedTestsAdapter(
    var list: ArrayList<TestPackageData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<CartAddedTestsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowCartTestsBinding.inflate(
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
            textViewPriceNew.text = "₹".plus(item.discount_price)
            textViewOldPrice.text = "₹".plus(item.price)
            textViewDiscount.text = item.discount_percent.plus("% OFF")

            textViewOldPrice.isVisible = item.discountPercent > 0
            textViewDiscount.isVisible = item.discountPercent > 0
            textViewLabelReportIn
            imageViewIcon.load(item.imageLocation?:"",isCenterCrop = false)
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowCartTestsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {

                }
                imageViewRemove.setOnClickListener {
                    adapterListener.onClickRemove(bindingAdapterPosition)
                    /*list.removeAt(bindingAdapterPosition)
                    notifyItemRemoved(bindingAdapterPosition)*/
                }
            }
        }
    }

    interface AdapterListener {
        fun onClickRemove(position: Int)
    }
}