package com.mytatva.patient.ui.payment.fragment.v1

import android.view.LayoutInflater
import android.view.ViewGroup
import com.mytatva.patient.databinding.PaymentFragmentDeviceDetailsOrderSummaryNewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment

class PaymentDeviceDetailsOrderSummaryFragment : BaseFragment<PaymentFragmentDeviceDetailsOrderSummaryNewBinding>() {

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentDeviceDetailsOrderSummaryNewBinding {
        return PaymentFragmentDeviceDetailsOrderSummaryNewBinding.inflate(layoutInflater)
    }

    override fun bindData() {

    }
}