package com.mytatva.patient.ui.labtest.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowHealthPackageListBinding
import com.mytatva.patient.utils.imagepicker.loadRounded

class HealthPackageListAdapter(
    var list: ArrayList<TestPackageData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HealthPackageListAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowHealthPackageListBinding.inflate(
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
            imageViewIcon.loadRounded(item.imageLocation ?: "",
                context.resources.getDimension(R.dimen.dp_8).toInt())
            textViewTitle.text = item.name
            textViewNoOfTestsInclude.text = "Includes ${item.testCount} tests"
            textViewPriceNew.text =
                context.getString(R.string.symbol_rupee).plus(item.discount_price)
            textViewPriceOld.text = context.getString(R.string.symbol_rupee).plus(item.price)
            textViewPriceOld.isVisible = item.discountPercent > 0
            textViewDiscountPercentage.isVisible = item.discountPercent > 0
            textViewDiscountPercentage.text = item.discount_percent.plus("% OFF")
            textViewLabelAvailableAt

            if (item.in_cart == "Y") {
                textViewRemove.isVisible = true
                buttonAddToCart.isVisible = false
            } else {
                textViewRemove.isVisible = false
                buttonAddToCart.isVisible = true
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowHealthPackageListBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
                buttonAddToCart.setOnClickListener {
                    adapterListener.onClickAddToCart(bindingAdapterPosition)
                }
                textViewRemove.setOnClickListener {
                    adapterListener.onClickRemoveFromCart(bindingAdapterPosition)
                }
                layoutIncludeTests.setOnClickListener {
                    adapterListener.onShowAllClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onShowAllClick(position: Int)
        fun onClickAddToCart(position: Int)
        fun onClickRemoveFromCart(position: Int)
    }
}