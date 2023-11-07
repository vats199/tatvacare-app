package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.OrderSummaryItemData
import com.mytatva.patient.databinding.LabtestRowOrderDetailsTestsBinding

class OrderDetailsTestAdapter(
    var list: ArrayList<OrderSummaryItemData>,
) : RecyclerView.Adapter<OrderDetailsTestAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowOrderDetailsTestsBinding.inflate(
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
            textViewTitle.text = item.price_data?.name

            if (item.type == "bcp") {
                textViewOldPrice.isVisible = false
                textViewDiscountPercentage.isVisible = false
                textViewPriceNew.text =
                    context.resources.getString(R.string.labtest_cart_label_free)
            } else {
                textViewOldPrice.isVisible = true
                textViewDiscountPercentage.isVisible = true
                textViewOldPrice.text =
                    context.resources.getString(R.string.symbol_rupee).plus(item.price_data?.price)
                textViewDiscountPercentage.text = "${item.price_data?.discount_percent}% OFF"
                textViewPriceNew.text = context.resources.getString(R.string.symbol_rupee)
                    .plus(item.price_data?.discount_price)
            }

            /*recyclerViewTrackOrderStatus.isVisible = item.isSelected
            imageViewDropDown.rotation = if (item.isSelected) 180F else 0F

            textViewStatus.text = item.order_status

            recyclerViewTrackOrderStatus.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = holder.trackOrderStatusAdapter
            }*/
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowOrderDetailsTestsBinding) :
        RecyclerView.ViewHolder(binding.root) {

        /*val trackOrderStatusAdapter by lazy {
            TrackOrderStatusAdapter(list[bindingAdapterPosition].order_status_data
                ?: arrayListOf())
        }*/

        init {
            binding.root.setOnClickListener {
            }
            /*binding.layoutStatus.setOnClickListener {
                list[bindingAdapterPosition].isSelected = !list[bindingAdapterPosition].isSelected
                notifyItemChanged(bindingAdapterPosition)
            }*/
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}