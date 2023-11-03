package com.mytatva.patient.ui.payment.fragment.v1

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.databinding.PaymentFragmentBcpPaymentSuccessBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable

class BcpPaymentSuccessFragment : BaseFragment<PaymentFragmentBcpPaymentSuccessBinding>() {

    private val bcpPlanData: BcpPlanData? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DATA)
    }

    val handler = Handler(Looper.getMainLooper())
    lateinit var runnable: Runnable

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentBcpPaymentSuccessBinding {
        return PaymentFragmentBcpPaymentSuccessBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setUpViewListeners()
        setUpHandler()
    }

    private fun setUpHandler() {
        runnable = Runnable {
            continueToViewPlan()
        }
        handler.postDelayed(runnable, 3000)
    }

    override fun onDestroyView() {
        handler.removeCallbacks(runnable)
        super.onDestroyView()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpPurchaseSuccess)
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonViewPlan.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonViewPlan -> {
                continueToViewPlan()
            }
        }
    }

    private fun continueToViewPlan() {
        navigator.loadActivity(
            IsolatedFullActivity::class.java, BcpPurchasedDetailsFragment::class.java
        ).addBundle(Bundle().apply {
            putString(
                Common.BundleKey.PATIENT_PLAN_REL_ID, bcpPlanData?.patient_plan_rel_id
            )
        }).byFinishingCurrent().start()
    }
}