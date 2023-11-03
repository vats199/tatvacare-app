package com.mytatva.patient.ui.payment.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.PatientPlanData
import com.mytatva.patient.databinding.PaymentRowPaymentPlansBinding
import com.mytatva.patient.utils.imagepicker.loadUrl
import com.mytatva.patient.utils.parseAsColor

class PaymentPlansAdapter(
    var list: ArrayList<PatientPlanData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<PaymentPlansAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowPaymentPlansBinding.inflate(
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
            val color = item.colour_scheme.parseAsColor()
            /*if (position % 2 == 0) "#5592CC".parseAsColor() else "#FFA639".parseAsColor()*/
            imageViewBg.backgroundTintList = ColorStateList.valueOf(color)
            textViewTitle.setTextColor(color)
            buttonCancelPlan.backgroundTintList = ColorStateList.valueOf(color)
            buttonChoosePlan.backgroundTintList = ColorStateList.valueOf(color)
            textViewMoreDetails.setTextColor(color)
            imageViewNext.imageTintList = ColorStateList.valueOf(color)

            if (item.headerTitle.isNotBlank()) {
                textViewPlanType.visibility = View.VISIBLE
                textViewPlanType.text = item.headerTitle
            } else {
                textViewPlanType.visibility = View.GONE
            }

            if (item.isDefaultFreePlan) {

                buttonCancelPlan.visibility = View.GONE
                buttonChoosePlan.visibility = View.GONE
                textViewLabelStartAt.visibility = View.INVISIBLE
                layoutCurrentPlanDates.visibility = View.GONE
                viewLine2.visibility = View.INVISIBLE

            } else {

                if (item.isActivePlan) {
                    buttonCancelPlan.visibility = View.VISIBLE
                    buttonChoosePlan.visibility = View.GONE
                    textViewLabelStartAt.visibility = View.INVISIBLE
                    layoutCurrentPlanDates.visibility = View.VISIBLE
                    viewLine2.visibility = View.VISIBLE

                    textViewPurchaseDate.text = item.getFormattedPlanStartDate
                    textViewNestRenewalDate.text = item.getFormattedPlanEndDate
                } else {
                    buttonCancelPlan.visibility = View.GONE
                    buttonChoosePlan.visibility = View.VISIBLE
                    textViewLabelStartAt.visibility = View.VISIBLE
                    layoutCurrentPlanDates.visibility = View.GONE
                    viewLine2.visibility = View.INVISIBLE
                }

            }

            imageViewPlanIcon.loadUrl(item.image_url ?: "", isCenterCrop = false)
            textViewTitle.text = item.plan_name
            textViewSubTitle.text = item.sub_title
            textViewDescription.text = item.getHtmlFormattedDescriptionAsString

            textViewPriceOld.isVisible = item.getDiscountPercentage > 0.0
                    && item.isDefaultFreePlan.not()
            textViewPriceOld.text =
                item.getActualPriceStrikeThrough.toString()/*formatToDecimalPoint(1)*/

            if (item.getDiscountPercentage == 100.0 || item.isDefaultFreePlan) {
                textViewLabelStartAt.visibility = View.INVISIBLE
                textViewPriceSymbol.isVisible = false
                textViewLabelPer.isVisible = false
                textViewPrice.text = "Free"
            } else {
                textViewLabelStartAt.visibility = View.VISIBLE
                textViewPriceSymbol.isVisible = true
                textViewLabelPer.isVisible = true
                textViewPrice.text = item.getPrice
            }

            /*if (item.getDiscountPercentage == 0.0) {
                // no discount, no strike through price
                textViewPriceOld.isVisible = false

                textViewPriceSymbol.isVisible = true
                textViewLabelPer.isVisible = true
                textViewPrice.text = item.getPrice

            } else if (item.getDiscountPercentage == 100.0) {
                // 100% discount, price label as "Free"
                textViewPriceOld.isVisible = true
                textViewPriceOld.text = item.getActualPriceStrikeThrough.formatToDecimalPoint(1)

                textViewPriceSymbol.isVisible = false
                textViewLabelPer.isVisible = false
                textViewPrice.text = "Free"

            } else {
                // normal case 0<discount<100
                textViewPriceOld.isVisible = true
                textViewPriceOld.text = item.getActualPriceStrikeThrough.formatToDecimalPoint(1)

                textViewPriceSymbol.isVisible = true
                textViewLabelPer.isVisible = true
                textViewPrice.text = item.getPrice
            }*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: PaymentRowPaymentPlansBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onCardOptionsClick(bindingAdapterPosition,
                        Common.AnalyticsEventActions.CARD)
                }
                buttonChoosePlan.setOnClickListener {
                    adapterListener.onCardOptionsClick(bindingAdapterPosition,
                        Common.AnalyticsEventActions.BUY)
                }
                textViewMoreDetails.setOnClickListener {
                    adapterListener.onCardOptionsClick(bindingAdapterPosition,
                        Common.AnalyticsEventActions.MORE_DETAILS)
                }
                buttonCancelPlan.setOnClickListener {
                    adapterListener.onCardOptionsClick(bindingAdapterPosition,
                        Common.AnalyticsEventActions.CARD)// passed card action, as no different click action as per iOS
                }
            }
        }
    }

    interface AdapterListener {
        fun onCardOptionsClick(position: Int, action: String)
    }
}