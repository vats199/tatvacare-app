package com.mytatva.patient.ui.payment.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.databinding.PaymentRowCarePlanForYouBinding
import com.mytatva.patient.utils.imagepicker.loadRounded

class PaymentCarePlanListingAdapter(
    var list: ArrayList<BcpPlanData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<PaymentCarePlanListingAdapter.ViewHolder>() {

    var isToHideHeaders = false

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowCarePlanForYouBinding.inflate(
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
            if (isToHideHeaders.not() && item.headerTitle.isNotBlank()) {
                textViewPlanTitle.visibility = View.VISIBLE
                textViewPlanTitle.text = item.headerTitle
            } else {
                textViewPlanTitle.visibility = View.GONE
            }

            //imageViewPlan.alpha = if (item.plan_type==Common.MyTatvaPlanType.INDIVIDUAL) 1.0f else 0.25f

            imageViewPlan.loadRounded(
                item.image_url ?: "",
                radius = context.resources.getDimension(R.dimen.dp_10).toInt()
            )
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: PaymentRowCarePlanForYouBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.imageViewPlan.setOnClickListener {
                adapterListener.onClick(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}