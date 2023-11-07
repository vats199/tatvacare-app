package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.HistoryLabTestPaymentData
import com.mytatva.patient.databinding.MenuRowHistoryPaymentTestsBinding
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class HistoryLabtestPaymentAdapter(
    var list: ArrayList<HistoryLabTestPaymentData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryLabtestPaymentAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryPaymentTestsBinding.inflate(
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
            textViewOldPrice.text = context.resources.getString(R.string.symbol_rupee)
                .plus(item.order_total)
            textViewPriceNew.text = context.resources.getString(R.string.symbol_rupee)
                .plus(item.final_payable_amount)
            textViewDate.text =
                DateTimeFormatter.date(item.appointment_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_EEEddMMMyyyy)
            textViewTime.text = item.slot_time

            textViewOrderNo.text = "Order No : ${item.ref_order_id?:""}"


            //textViewItemCount.text = "Items : ${item.total_items?:""}"


           /* val offerPrice = item.offer_price?.toDoubleOrNull()?.toInt() ?: 0
            val price = item.android_price?.toDoubleOrNull()?.toInt() ?: 0

            textViewPrice.text = context.getString(R.string.symbol_rupee)
                .plus(if (offerPrice > 0) offerPrice.toString() else price.toString())
            textViewName.text = item.plan_name
            textViewDate.text = item.getFormattedPlanPurchaseDate
            textViewServicePeriod.text = item.getServicePeriodLabel("to")
            imageViewIcon.loadUrl(item.image_url?:"",isCenterCrop = false)
            imageViewUpDown.rotation = if (item.isSelected) 180f else 0f
            layoutInfo.visibility = if (item.isSelected) View.VISIBLE else View.GONE

            textViewPaymentMethod.text = if (item.device_type?.equals("A", true)==true)
                "Online"
            else if (item.device_type?.equals("I", true)==true)
                "In-App"
            else
                "-"*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryPaymentTestsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {

            }
        }
    }

    interface AdapterListener {

    }
}