package com.mytatva.patient.ui.payment.adapter

import android.annotation.SuppressLint
import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.databinding.PaymentRowCouponCodeListBinding

class PaymentCouponCodeListAdapter(
    var list: ArrayList<CouponCodeData>,
    var payableAmount: String? = null,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<PaymentCouponCodeListAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowCouponCodeListBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    @SuppressLint("ResourceAsColor")
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.binding()
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            textViewCouponTitle.text = item.discountCode
            textViewCouponDescription.text = item.label
            textViewLabelOrderDiscount.text = item.onlydescription
            item.description?.let {
                val cleanHtml = it.replace("\\\"", "\"")

                /*webView.settings.builtInZoomControls = false
                webView.settings.displayZoomControls = false
                webView.settings.useWideViewPort = true
                webView.settings.loadWithOverviewMode = true*/
                webView.isHorizontalScrollBarEnabled = false
                webView.isVerticalScrollBarEnabled = false

                webView.loadDataWithBaseURL(
                    null, cleanHtml/*dummyWebData*/, "text/html", //; charset=utf-8
                    "UTF-8", null
                )
            }

            if (item.isToSetDisable(payableAmount?.toIntOrNull() ?: 0)) {
                imageViewCoupon.setColorFilter(context.resources.getColor(R.color.textGray1, null))
                textViewCouponTitle.setTextColor(context.resources.getColor(R.color.textGray1, null))
                textViewCouponDescription.setTextColor(context.resources.getColor(R.color.gray9, null))
                textViewLabelApply.setTextColor(context.resources.getColor(R.color.textGray1, null))
                textViewLabelOrderDiscount.setTextColor(context.resources.getColor(R.color.textGray7, null))
                textViewViewDetailsMoreLess.setTextColor(context.resources.getColor(R.color.textGray1, null))
                textViewViewDetailsMoreLess.compoundDrawableTintList =
                    ColorStateList.valueOf(context.resources.getColor(R.color.textGray1, null))
            } else {
                imageViewCoupon.setColorFilter(context.resources.getColor(R.color.purpleLight5, null))
                textViewCouponTitle.setTextColor(context.resources.getColor(R.color.textBlack9, null))
                textViewCouponDescription.setTextColor(context.resources.getColor(R.color.gray9, null))
                textViewLabelApply.setTextColor(context.resources.getColor(R.color.colorAccent, null))
                textViewLabelOrderDiscount.setTextColor(context.resources.getColor(R.color.textGray7, null))
                textViewViewDetailsMoreLess.setTextColor(context.resources.getColor(R.color.colorAccent, null))
                textViewViewDetailsMoreLess.compoundDrawableTintList =
                    ColorStateList.valueOf(context.resources.getColor(R.color.colorAccent, null))
            }
        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, payloads: MutableList<Any>) {
        super.onBindViewHolder(holder, position, payloads)
        holder.apply {
            if (payloads.isNotEmpty() && payloads.first().toString()
                    .equals("textViewViewDetailsMoreLess")
            ) {
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: PaymentRowCouponCodeListBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun binding() = with(binding) {
            if (textViewViewDetailsMoreLess.isChecked) {
                textViewViewDetailsMoreLess.text =
                    itemView.context.getString(R.string.coupon_code_list_label_hide_details)
                webView.visibility = View.VISIBLE
                viewLine2.visibility = View.VISIBLE
            } else {
                textViewViewDetailsMoreLess.text =
                    itemView.context.getString(R.string.coupon_code_list_label_view_details)
                webView.visibility = View.GONE
                viewLine2.visibility = View.GONE
            }
        }

        init {
            with(binding) {
                textViewLabelApply.setOnClickListener {
                    if (list[bindingAdapterPosition].isToSetDisable(payableAmount?.toIntOrNull() ?: 0).not()) {
                        adapterListener.onApplyClick(bindingAdapterPosition)
                    }
                }

                textViewViewDetailsMoreLess.setOnClickListener {
                    if (list[bindingAdapterPosition].isToSetDisable(payableAmount?.toIntOrNull() ?: 0).not()) {
                        textViewViewDetailsMoreLess.isChecked =
                            !textViewViewDetailsMoreLess.isChecked
                        adapterListener.onViewDetailsClick(bindingAdapterPosition, textViewViewDetailsMoreLess.isChecked)
                        notifyItemChanged(absoluteAdapterPosition, "textViewViewDetailsMoreLess")
                    }
                }
            }
        }
    }

    interface AdapterListener {
        fun onApplyClick(position: Int)
        fun onViewDetailsClick(position: Int, checked: Boolean)
    }
}