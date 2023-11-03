package com.mytatva.patient.ui.auth.fragment.v1

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthNewFragmentVerifyLinkDoctorBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.ScanQRCodeFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.disableFocus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink


class VerifyLinkDoctorFragment : BaseFragment<AuthNewFragmentVerifyLinkDoctorBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextAccessCode)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_access_code))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    var accessCode: String? = null
    var doctorAccessCode: String? = null

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthNewFragmentVerifyLinkDoctorBinding {
        return AuthNewFragmentVerifyLinkDoctorBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LinkDoctor)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpToolbar()
        setViewListeners()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            progressBar.isVisible = true
            progressBar.progress = 50
        }
    }

    private fun setViewListeners() {
        binding.apply {
            layoutHeader.imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            textViewLabelScanQRCode.setOnClickListener { onViewClick(it) }
            buttonNext.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.textViewLabelScanQRCode -> {
                checkPermissions()
            }
            R.id.buttonNext -> {
                if (isValid) {
                    analytics.logEvent(analytics.ENTER_DOCTOR_CODE, Bundle().apply {
                        putString(analytics.PARAM_DOCTOR_ACCESS_CODE,
                            binding.editTextAccessCode.text.toString().trim())
                    }, screenName = AnalyticsScreenNames.LinkDoctor)
                    updateAccessCode()
                }
            }
        }
    }

    private fun checkPermissions() {
        if (Build.VERSION.SDK_INT >= 23) {
            if (ActivityCompat.checkSelfPermission(
                    requireActivity(),
                    Manifest.permission.CAMERA
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                requestPermissions(Common.PERMISSIONS_ONLY_CAMERA,
                    Common.RequestCode.REQUEST_CAMERA_PERMISSION)
            } else {
                openScanner()
            }
        } else {
            openScanner()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == Common.RequestCode.REQUEST_CAMERA_PERMISSION) {
            if (PermissionUtil.verifyPermissions(grantResults)) {
                openScanner()
            } else {
                showMessage(getString(R.string.scan_permission_msg))
                //checkPermissions()
            }
        }
    }

    private fun openScanner() {
        navigator.loadActivity(IsolatedFullActivity::class.java,
            ScanQRCodeFragment::class.java)
            .forResult(Common.RequestCode.REQUEST_SCAN_QR_CODE)
            .start()
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == Common.RequestCode.REQUEST_SCAN_QR_CODE && resultCode == Activity.RESULT_OK) {

            if (data?.getBooleanExtra(Common.BundleKey.IS_QR_SCAN_SUCCESS, false) == true) {

                if (FirebaseLink.Values.accessCode.isNullOrBlank().not()) {
                    accessCode = FirebaseLink.Values.accessCode ?: "" //pass empty if null
                    doctorAccessCode =
                        FirebaseLink.Values.doctorAccessCode //pass only it is there via link

                    with(binding) {
                        if (accessCode.isNullOrBlank().not()) {
                            editTextAccessCode.setText(accessCode)
                            editTextAccessCode.disableFocus()

                            analytics.logEvent(analytics.SCAN_DOCTOR_QR, Bundle().apply {
                                putString(analytics.PARAM_DOCTOR_ACCESS_CODE,
                                    editTextAccessCode.text.toString().trim())
                            }, screenName = AnalyticsScreenNames.LinkDoctor)

                            // call API directly on code scanned successfully
                            updateAccessCode()

                            /*buttonVerify.isEnabled = false
                            scrollOnVerifyAccessCodesSuccess()*/
                        }
                    }
                }
            }
        }
    }

    private fun continueToNextFlow() {
        navigator.loadActivity(AuthActivity::class.java,
            AddAccountDetailsNewFragment::class.java)
            .start()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateAccessCode() {
        val apiRequest = ApiRequest().apply {
            access_code =
                if (binding.editTextAccessCode.text.toString().trim().isBlank().not())
                    binding.editTextAccessCode.text.toString().trim()
                else
                    null
        }
        showLoader()
        authViewModel.updateAccessCode(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updateAccessCodeLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            continueToNextFlow()
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }
}