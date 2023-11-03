package com.mytatva.patient.ui.auth.fragment

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.SparseArray
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import com.google.android.gms.vision.barcode.Barcode
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.firebase.dynamiclinks.PendingDynamicLinkData
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.AuthFragmentScanQrCodeBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.notbytes.barcode_reader.BarcodeReaderFragment

class ScanQRCodeFragment : BaseFragment<AuthFragmentScanQrCodeBinding>(),
    BarcodeReaderFragment.BarcodeReaderListener {

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentScanQrCodeBinding {
        return AuthFragmentScanQrCodeBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onPause() {
        super.onPause()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setViewListeners()
        checkPermissions()
        setUpToolbar()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Scan"
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
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
                setUpQR()
            }
        } else {
            setUpQR()
        }
    }

    private var barcodeReader = BarcodeReaderFragment()

    private fun setUpQR() {
        childFragmentManager.beginTransaction().replace(R.id.placeHolder, barcodeReader).commit()
        barcodeReader.fragmentContext = context
        barcodeReader.activity = activity
        barcodeReader.createCameraSource(true, false)
        barcodeReader.setListener(this)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (PermissionUtil.verifyPermissions(grantResults)) {
            setUpQR()
        } else {
            showMessage(getString(R.string.scan_permission_msg))
            //checkPermissions()
        }
    }

    //var data: BusinessPartnerData? = null
    private fun setViewListeners() {
        binding.apply {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    override fun onScanned(barcode: Barcode?) {
        barcodeReader.pauseScanning()
        try {
            //val aes = AES(Common.AES_KEY)
            //val decryptedData = aes.decrypt(barcode!!.displayValue)
            val deepLink = barcode?.displayValue
            //showMessage(decryptedData)

            if (deepLink.isNullOrBlank().not()) {
                getDeepLink(Uri.parse(deepLink)) {
                    showAppMessage(getString(R.string.validation_invalid_qr_code), AppMsgStatus.ERROR)
                }
            }

            Log.d("DecryptedData", barcode?.displayValue ?: "::")
        } catch (e: Exception) {
            e.printStackTrace()
            //showMessage("error:- ${e.message}")
            //data = null
        }

        /*if (!data?.bussiness_name.isNullOrEmpty() && !data?.bussiness_id.isNullOrEmpty() && !data?.latitude.isNullOrEmpty()) {
            barcodeReader.resumeScanning()
            callCheckInStatusWs()
        } else {
            navigator?.showAlertDialog(getString(R.string.invalid_qr_msg),
                getString(R.string.label_ok),
                object : BaseActivity.DialogOkListener {
                    override fun onClick() {
                        barcodeReader.resumeScanning()

                    }
                })
        }*/
    }

    override fun onScannedMultiple(barcodes: MutableList<Barcode>?) {

    }

    override fun onBitmapScanned(sparseArray: SparseArray<Barcode>?) {

    }

    override fun onScanError(errorMessage: String?) {

    }

    override fun onCameraPermissionDenied() {

    }

    private fun getDeepLink(deepLink: Uri, callback: () -> Unit) {
        FirebaseDynamicLinks.getInstance()
            .getDynamicLink(deepLink)
            .addOnSuccessListener(requireActivity()) { pendingDynamicLinkData: PendingDynamicLinkData? ->
                // Get deep link from result (may be null if no link is found)
                var deepLink: Uri? = null
                if (pendingDynamicLinkData != null) {

                    deepLink = pendingDynamicLinkData.link
//https://mytatva.page.link/?link=https://mytatva.com/&operation=signup_link_doctor&access_code=358796940&contact_no=9879878888&apn=com.mytatva.patient&ibi=com.mytatva.patient&efr=1&isi=1590299281
                    if (deepLink?.queryParameterNames?.contains(FirebaseLink.Params.OPERATION) == true) {

                        when (deepLink.getQueryParameter(FirebaseLink.Params.OPERATION)) {
                            FirebaseLink.Operation.SIGNUP_LINK_DOCTOR -> {

                                val isValueAssignedSuccess =
                                    FirebaseLink.handleSignUpLinkDoctorOperationDeepLinkWithResult(
                                        deepLink)

                                if (isValueAssignedSuccess) {

                                    //set result
                                    val resultIntent = Intent()
                                    resultIntent.putExtra(Common.BundleKey.IS_QR_SCAN_SUCCESS, true)
                                    requireActivity().setResult(Activity.RESULT_OK, resultIntent)
                                    requireActivity().finish()

                                } else {
                                    callback.invoke()
                                }

                                /*if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.ACCESS_CODE) == true
                                    && deepLink.queryParameterNames?.contains(FirebaseLink.Params.DOCTOR_ACCESS_CODE) == true
                                ) {

                                    val accessCode =
                                        deepLink.getQueryParameter(FirebaseLink.Params.ACCESS_CODE)
                                    val doctorAccessCode =
                                        deepLink.getQueryParameter(FirebaseLink.Params.DOCTOR_ACCESS_CODE)

                                    //set result
                                    val resultIntent = Intent()
                                    resultIntent.putExtra(Common.BundleKey.ACCESS_CODE, accessCode)
                                    resultIntent.putExtra(Common.BundleKey.DOCTOR_ACCESS_CODE,
                                        doctorAccessCode)
                                    requireActivity().setResult(Activity.RESULT_OK, resultIntent)
                                    requireActivity().finish()

                                } else {
                                    callback.invoke()
                                }*/

                            }
                            else -> {
                                callback.invoke()
                            }
                        }
                    } else {
                        callback.invoke()
                    }

                } else {
                    callback.invoke()
                }
            }.addOnFailureListener(requireActivity()) { e: Exception? ->
                callback.invoke()
            }
    }
}