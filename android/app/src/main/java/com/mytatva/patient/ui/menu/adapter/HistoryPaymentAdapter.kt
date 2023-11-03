package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.PaymentHistorySubData
import com.mytatva.patient.databinding.MenuRowHistoryPaymentBinding
import com.mytatva.patient.utils.doCapitalize
import com.mytatva.patient.utils.imagepicker.loadUrl
import kotlin.math.roundToInt

class HistoryPaymentAdapter(
    var list: ArrayList<PaymentHistorySubData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryPaymentAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryPaymentBinding.inflate(
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
            //textViewDate.text = item.formattedDate

            /*val offerPrice = item.offer_price?.toDoubleOrNull()?.toInt() ?: 0
            val price = item.android_price?.toDoubleOrNull()?.toInt() ?: 0
            val finalPriceToDisplay = if (offerPrice > 0) offerPrice else price*/

            val finalPriceToDisplay = item.android_price?.toDoubleOrNull()?.roundToInt() ?: 0

            if (finalPriceToDisplay == 0) {
                textViewPrice.text = context.getString(R.string.labtest_cart_label_free)
            } else {
                textViewPrice.text = context.getString(R.string.symbol_rupee).plus(finalPriceToDisplay)
            }

            textViewName.text = item.plan_name
            textViewDate.text = item.getFormattedPlanPurchaseDate
            textViewServicePeriod.text = item.getServicePeriodLabel("to")
            imageViewIcon.loadUrl(item.image_url ?: "", isCenterCrop = false)
            imageViewUpDown.rotation = if (item.isSelected) 180f else 0f
            layoutInfo.visibility = if (item.isSelected) View.VISIBLE else View.GONE

            groupServicePeriod.isVisible = item.type == Common.PaymentHistoryType.PLAN

            textViewPaymentMethod.text =
                when (item.type) {
                    Common.PaymentHistoryType.PLAN -> {
                        if (item.transaction_type.isNullOrBlank())
                            "-"
                        else
                            item.transaction_type.doCapitalize()

                        /*if (item.device_type?.equals("A", true) == true)
                            item.transaction_type?.doCapitalize()
                        else if (item.device_type?.equals("I", true) == true)
                            "In-App"
                        else
                            "-"*/
                    }

                    Common.PaymentHistoryType.TEST -> {
                        item.transaction_type?.doCapitalize()
                    }

                    else -> {
                        ""
                    }
                }

            buttonGetInvoice.isVisible = item.invoice_url.isNullOrBlank().not()

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryPaymentBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewUpDown.setOnClickListener {
                    if (list.isNotEmpty()) {
                        list[bindingAdapterPosition].isSelected =
                            list[bindingAdapterPosition].isSelected.not()
                        notifyItemChanged(bindingAdapterPosition)
                    }
                }

                buttonGetInvoice.setOnClickListener {
                    adapterListener.onGetInvoiceClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onGetInvoiceClick(position: Int)
    }
}