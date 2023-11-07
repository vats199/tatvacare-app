package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.LabTestStatus
import com.mytatva.patient.data.pojo.response.HistoryTestOrderData
import com.mytatva.patient.databinding.MenuRowHistoryTestsBinding
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class HistoryTestsAdapter(
    var list: ArrayList<HistoryTestOrderData>,
    val navigator: Navigator,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryTestsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryTestsBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {//
            textViewTitle.text = item.name
            textViewOldPrice.text = context.resources.getString(R.string.symbol_rupee)
                .plus(item.order_total)
            if (item.bcp_test_price_data?.bcp_final_amount_to_pay.isNullOrBlank().not()) {
                if ((item.bcp_test_price_data?.bcpFinalAmountToPay ?: 0) > 0) {
                    textViewPriceNew.text = context.resources.getString(R.string.symbol_rupee)
                        .plus(item.bcp_test_price_data?.bcpFinalAmountToPay)
                } else {
                    textViewPriceNew.text =
                        context.resources.getString(R.string.labtest_cart_label_free)
                }
            } else {
                textViewPriceNew.text = context.resources.getString(R.string.symbol_rupee)
                    .plus(item.final_payable_amount)
            }

            textViewDate.text =
                DateTimeFormatter.date(item.appointment_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_EEEddMMMyyyy)
            textViewTime.text = item.slot_time

            textViewOrderNo.text = "Order No : ${item.ref_order_id ?: ""}"
            textViewItemCount.text = "Items : ${item.total_items ?: ""}"

            when (item.order_status) {
                LabTestStatus.YET_TO_ASSIGN.statusKey -> {
                }

                LabTestStatus.ACCEPTED.statusKey -> {
                }

                LabTestStatus.SERVICED.statusKey -> {
                }

                LabTestStatus.DONE.statusKey -> {
                }
            }

            //textViewStatus.text = item.order_status

            /*var colorRes: Int = AppointmentStatus.SCHEDULED.colorRes
            var statusLabel: String = item.appointment_status ?: ""
            when (item.appointment_status) {
                AppointmentStatus.SCHEDULED.statusKey -> {
                    colorRes = AppointmentStatus.SCHEDULED.colorRes
                    statusLabel = AppointmentStatus.SCHEDULED.statusTitle
                }
                AppointmentStatus.CANCELLED.statusKey -> {
                    colorRes = AppointmentStatus.CANCELLED.colorRes
                    statusLabel = AppointmentStatus.CANCELLED.statusTitle
                }
                AppointmentStatus.COMPLETED.statusKey -> {
                    colorRes = AppointmentStatus.COMPLETED.colorRes
                    statusLabel = AppointmentStatus.COMPLETED.statusTitle
                }
            }
            textViewStatus.backgroundTintList =
                ColorStateList.valueOf(context.resources.getColor(colorRes, null))
            textViewStatus.text = statusLabel

            textViewDate.text = item.formattedAppointmentData
            textViewTime.text = item.appointment_time*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryTestsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                binding.root.setOnClickListener {
                    adapterListener.onItemClick(bindingAdapterPosition)
                }
                textViewDownloadReports.setOnClickListener {
                    adapterListener.onDownloadReportClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
        fun onDownloadReportClick(position: Int)
    }
}