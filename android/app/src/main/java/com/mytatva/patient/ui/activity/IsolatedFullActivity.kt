package com.mytatva.patient.ui.activity

import android.os.Bundle
import android.view.View
import com.mytatva.patient.R
import com.mytatva.patient.databinding.IsolatedAcitivtyFullBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.manager.ActivityStarter
import com.razorpay.PaymentData
import com.razorpay.PaymentResultWithDataListener

class IsolatedFullActivity : BaseActivity(), /*PaymentResultListener,*/
    PaymentResultWithDataListener {

    lateinit var isolatedFullActivityBinding: IsolatedAcitivtyFullBinding

    override fun findFragmentPlaceHolder(): Int {
        return R.id.placeHolder
    }

    override fun createViewBinding(): View {
        isolatedFullActivityBinding = IsolatedAcitivtyFullBinding.inflate(layoutInflater)
        return isolatedFullActivityBinding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null) {
            val page =
                intent.getSerializableExtra(ActivityStarter.ACTIVITY_FIRST_PAGE) as Class<BaseFragment<*>>
            load(page)
                .setBundle(intent.extras!!)
                .replace(false)
        }
    }

    /*override fun onPaymentSuccess(paymentId: String?) {
        if (getCurrentFragment<BaseFragment<*>>() is PaymentPlanDetailsFragment) {
            (getCurrentFragment<BaseFragment<*>>() as PaymentPlanDetailsFragment).onPaymentSuccess(
                paymentId)
        } else if (getCurrentFragment<BaseFragment<*>>() is BookAppointmentReviewFragment) {
            (getCurrentFragment<BaseFragment<*>>() as BookAppointmentReviewFragment).onPaymentSuccess(
                paymentId)
        }
    }

    override fun onPaymentError(code: Int, error: String?) {
        if (getCurrentFragment<BaseFragment<*>>() is PaymentPlanDetailsFragment) {
            (getCurrentFragment<BaseFragment<*>>() as PaymentPlanDetailsFragment).onPaymentError(
                code,
                error)
        } else if (getCurrentFragment<BaseFragment<*>>() is BookAppointmentReviewFragment) {
            (getCurrentFragment<BaseFragment<*>>() as BookAppointmentReviewFragment).onPaymentError(
                code,
                error)
        }
    }*/

    override fun onPaymentSuccess(p0: String?, paymentData: PaymentData?) {

    }

    override fun onPaymentError(code: Int, error: String?, p2: PaymentData?) {

    }

}