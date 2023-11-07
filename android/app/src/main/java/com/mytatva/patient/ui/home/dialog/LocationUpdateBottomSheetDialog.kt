package com.mytatva.patient.ui.home.dialog

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import com.mytatva.patient.R
import com.mytatva.patient.databinding.AddressBottomsheetLocationPermissionBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class LocationUpdateBottomSheetDialog() :
    BaseBottomSheetDialogFragment<AddressBottomsheetLocationPermissionBinding>() {

    var grantPermission: () -> Unit = {}
    var selectManual: () -> Unit = {}

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LocationPermission)

        analytics.logEvent(
            analytics.SHOW_BOTTOM_SHEET,
            Bundle().apply {
                putString(analytics.PARAM_BOTTOM_SHEET_NAME, "grant location permission")
            }, screenName = AnalyticsScreenNames.LocationPermission
        )
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AddressBottomsheetLocationPermissionBinding {
        return AddressBottomsheetLocationPermissionBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun bindData() = with(binding) {
        buttonSelectManually.isVisible = true
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSelectManually.setOnClickListener { onViewClick(it) }
            buttonGrant.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSelectManually -> {
                analytics.logEvent(
                    eventName = analytics.TAP_SELECT_MANUALLY,
                    bundle = Bundle().apply {
                        putString(analytics.PARAM_BOTTOM_SHEET_NAME, "grant location permission")
                    },
                    screenName = AnalyticsScreenNames.LocationPermission
                )
                selectManual.invoke()
            }

            R.id.buttonGrant -> {
                analytics.logEvent(
                    eventName = analytics.TAP_GRANT_LOCATION,
                    bundle = Bundle().apply {
                        putString(analytics.PARAM_BOTTOM_SHEET_NAME, "grant location permission")
                    },
                    screenName = AnalyticsScreenNames.LocationPermission
                )
                grantPermission.invoke()
            }
        }
    }
}