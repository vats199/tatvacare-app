package com.mytatva.patient.ui.payment.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.PatientPlanData
import com.mytatva.patient.databinding.PaymentRowIndividualServicesBinding
import com.mytatva.patient.utils.imagepicker.loadUrl

class IndividualServiceAdapter(
    var list: ArrayList<PatientPlanData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<IndividualServiceAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowIndividualServicesBinding.inflate(
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


            if (item.headerTitle.isNotBlank()) {
                textViewPlanType.visibility = View.VISIBLE
                textViewPlanType.text = item.headerTitle
            } else {
                textViewPlanType.visibility = View.GONE
            }

            if (item.isActivePlan) {
                //buttonBuyNow.text = "Cancel"
                buttonBuyNow.visibility = View.INVISIBLE
                textViewLabelStartAt.visibility = View.GONE
            } else {
                //buttonBuyNow.text = "Buy Now"
                buttonBuyNow.visibility = View.VISIBLE
                textViewLabelStartAt.visibility = View.VISIBLE
            }

            textViewPriceOld.isVisible = item.getDiscountPercentage > 0.0
            textViewPriceOld.text = context.resources.getString(R.string.symbol_rupee).plus(item.getActualPriceStrikeThrough.toString())//.formatToDecimalPoint(1)

            if (item.getDiscountPercentage == 100.0) {
                textViewLabelStartAt.visibility = View.GONE
                textViewPriceSymbol.isVisible = false
                textViewLabelPer.isVisible = false
                textViewPrice.text = "Free"
            } else {
                textViewLabelStartAt.visibility = View.VISIBLE
                textViewPriceSymbol.isVisible = true
                textViewLabelPer.isVisible = true
                textViewPrice.text = item.getPrice
            }

            imageViewService.loadUrl(item.image_url ?: "")
            textViewTitle.text = item.plan_name
            textViewDescription.text = item.getHtmlFormattedDescriptionAsString

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: PaymentRowIndividualServicesBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onBuyClick(bindingAdapterPosition,false)
                }
                buttonBuyNow.setOnClickListener {
                    adapterListener.onBuyClick(bindingAdapterPosition,true)
                }
            }
        }
    }

    interface AdapterListener {
        fun onBuyClick(position: Int, isClickOnBuyButton: Boolean)
    }
}