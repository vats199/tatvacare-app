package com.mytatva.patient.ui.payment.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.BcpDuration
import com.mytatva.patient.databinding.PaymentRowChooseDurationV1Binding

class ChooseDurationV1Adapter(
    var list: ArrayList<BcpDuration>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<ChooseDurationV1Adapter.ViewHolder>() {

    var selectedPosition = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowChooseDurationV1Binding.inflate(
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
            layoutItem.isSelected = position == selectedPosition
            textViewRecommended.isVisible = item.is_recommended == "Y"

            textViewTitle.text = item.duration_title?.plus(" - ")?.plus(item.duration_name)

            //set prices
            if (item.isFree) {
                // show as free
                //textViewPricePer.isVisible = false
                textViewPriceOld.isVisible = false
                //textViewTotalPrice.isVisible = false

                textViewPriceNew.text = "Free"
            } else {
                //textViewPricePer.isVisible = true
                textViewPriceOld.isVisible = true
                //textViewTotalPrice.isVisible = true

                // else set prices when not free
                if ((item.offerPrice.toDoubleOrNull() ?: 0.0) > 0) {
                    textViewPriceOld.text = context.getString(R.string.symbol_rupee)
                        .plus("").plus(item.offerPrice)
                    textViewPriceOld.visibility = View.VISIBLE
                } else {
                    textViewPriceOld.visibility = View.GONE
                }

                textViewPriceNew.text = context.getString(R.string.symbol_rupee)
                    .plus("").plus(item.androidPrice)

                //textViewTotalPrice.text = "Total- ₹${item.androidPriceFormatted}"

            }

            /*imageViewBestValue.visibility =
                if (item.offer_tag == "Best value") View.VISIBLE else View.GONE
            imageViewMostPopular.visibility =
                if (item.offer_tag == "Most popular") View.VISIBLE else View.GONE*/
            /*textViewDiscount.isVisible = item.discountPercent > 0
            textViewDiscount.text = "${item.discountPercent}%\nOff"*/


        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentRowChooseDurationV1Binding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                binding.layoutItem.setOnClickListener {
                    selectedPosition = bindingAdapterPosition
                    adapterListener.onClick(bindingAdapterPosition)
                    notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}