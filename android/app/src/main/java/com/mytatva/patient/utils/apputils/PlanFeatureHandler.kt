package com.mytatva.patient.utils.apputils

import android.os.Bundle
import androidx.core.view.isVisible
import com.mytatva.patient.databinding.CommonLayoutFeatureLockedBinding
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient

object PlanFeatureHandler {

    fun handleFeatureAccess(
        commonLayoutFeatureLockedBinding: CommonLayoutFeatureLockedBinding,
        navigator: Navigator,
        isFeatureAllowedAsPerPlan: Boolean,
        analytics: AnalyticsClient? = null,
        eventName: String? = null,
        screenName: String? = null,
    ) {
        with(commonLayoutFeatureLockedBinding) {
            layoutLock.isVisible = isFeatureAllowedAsPerPlan.not()

            layoutLock.setOnClickListener {

                eventName?.let {
                    analytics?.logEvent(eventName, Bundle().apply {
                        putString(analytics.PARAM_FEATURE_STATUS, FeatureStatus.INACTIVE)
                    }, screenName = screenName)
                }

                navigator.loadActivity(IsolatedFullActivity::class.java,
                    /*PaymentPlanServiceMainFragment*/
                    PaymentCarePlanListingFragment::class.java).start()
            }
        }
    }

    object FeatureStatus {
        val ACTIVE = "active"
        val INACTIVE = "inactive"
    }

}