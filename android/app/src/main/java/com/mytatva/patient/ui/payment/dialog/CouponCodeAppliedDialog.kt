package com.mytatva.patient.ui.payment.dialog

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.databinding.PaymentDialogCouponCodeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.textdecorator.TextDecorator


class CouponCodeAppliedDialog : BaseDialogFragment<PaymentDialogCouponCodeBinding>() {
    var couponCodeData: CouponCodeData? = null
    var checkCouponData: CheckCouponData? = null

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentDialogCouponCodeBinding {
        return PaymentDialogCouponCodeBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun bindData() {
        setViewListener()
        setUpUI()
        setData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AppliedCouponCodeSuccess)
    }

    private fun setData() {
        binding.textViewCouponCodeApplied.text = "Congratulations!!!\n‘${couponCodeData?.discountCode}’ applied"
        binding.textViewCouponDescription.text = checkCouponData?.subHeadingMessage?:""
    }

    private fun setUpUI() = with(binding) {
        TextDecorator.decorate(binding.textViewLabelThanks, "Got it, Thanks")
            .underline("Got it, Thanks").build()
    }

    private fun setViewListener() {
        binding.apply {
            textViewLabelThanks.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewLabelThanks -> {
                dismiss()

                analytics.logEvent(
                    analytics.USER_TAPS_OK,
                    Bundle().apply {
                        putString(analytics.PARAM_DISCOUNT_CODE, couponCodeData?.discountCode)
                    },
                    screenName = AnalyticsScreenNames.AppliedCouponCodeSuccess
                )
            }
        }
    }


}