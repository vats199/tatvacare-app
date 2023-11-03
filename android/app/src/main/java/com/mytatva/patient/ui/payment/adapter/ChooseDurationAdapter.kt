package com.mytatva.patient.ui.payment.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.Duration
import com.mytatva.patient.databinding.PaymentRowChooseDurationBinding

class ChooseDurationAdapter(
    var list: ArrayList<Duration>,
    val adapterListener: AdapterListener
) : RecyclerView.Adapter<ChooseDurationAdapter.ViewHolder>() {

    var selectedPos = 0
    var color = Common.Colors.COLOR_PRIMARY

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowChooseDurationBinding.inflate(
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
            radioDuration.setTextColor(color)
            radioDuration.isChecked = selectedPos == position

            radioDuration.text = item.duration_name
            textViewDescription.text = item.duration_title

            if (item.isFree) {
                // show as free
                textViewPricePer.isVisible = false
                textViewPriceOld.isVisible = false
                textViewTotalPrice.isVisible = false

                textViewPrice.text = "Free"
            } else {
                textViewPricePer.isVisible = true
                textViewPriceOld.isVisible = true
                textViewTotalPrice.isVisible = true

                // else set prices when not free

                if ((item.offerPerMonthPrice.toDoubleOrNull() ?: 0.0) > 0) {
                    textViewPriceOld.text = context.getString(R.string.symbol_rupee)
                        .plus("").plus(item.offerPerMonthPrice)
                    textViewPriceOld.visibility = View.VISIBLE
                } else {
                    textViewPriceOld.visibility = View.GONE
                }

                textViewPrice.text = context.getString(R.string.symbol_rupee)
                    .plus("").plus(item.androidPerMonthPrice)

                textViewTotalPrice.text = "Total- ₹${item.androidPriceFormatted}"

            }

            /*imageViewBestValue.visibility =
                if (item.offer_tag == "Best value") View.VISIBLE else View.GONE
            imageViewMostPopular.visibility =
                if (item.offer_tag == "Most popular") View.VISIBLE else View.GONE*/
            textViewDiscount.isVisible = item.discountPercent > 0
            textViewDiscount.text = "${item.discountPercent}%\nOff"
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentRowChooseDurationBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    selectedPos = bindingAdapterPosition
                    notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onDurationSelect(position: Int)
    }
}