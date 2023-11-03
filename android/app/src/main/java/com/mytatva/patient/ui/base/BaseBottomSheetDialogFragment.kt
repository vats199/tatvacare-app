package com.mytatva.patient.ui.base

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.location.Location
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import com.facebook.react.bridge.ReactContext
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.mytatva.patient.R
import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Session
import com.mytatva.patient.di.Injector
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.AuthenticationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.location.LocationException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.ui.address.dialog.LocationPermissionBottomSheetDialog
import com.mytatva.patient.ui.home.dialog.LocationUpdateBottomSheetDialog
import com.mytatva.patient.utils.Validator
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import java.net.ConnectException
import java.net.SocketTimeoutException
import javax.inject.Inject

abstract class BaseBottomSheetDialogFragment<T : ViewBinding> : BottomSheetDialogFragment() {

    private var _binding: T? = null

    protected val binding: T
        get() = _binding!!

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    @Inject
    lateinit var analytics: AnalyticsClient

    @Inject
    lateinit var locationManager: LocationManager

    @Inject
    lateinit var validator: Validator

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var appPreferences: AppPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        setStyle(DialogFragment.STYLE_NORMAL, R.style.myBottomSheetDialog)
        super.onCreate(savedInstanceState)
        injectDependencies(Injector.INSTANCE.applicationComponent)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View? {
        _binding = createViewBinding(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val parent = view.parent as? View
        parent?.setBackgroundColor(Color.TRANSPARENT)
        bindData()
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

    protected fun showMessage(message: String) {
        Toast.makeText(requireContext(), message, Toast.LENGTH_SHORT).show()
    }

    public fun onError(throwable: Throwable) {
        try {
            when (throwable) {
                is ServerException -> showMessage(throwable.message.toString())
                is ConnectException -> showMessage(getString(R.string.connection_exception))
                is AuthenticationException -> {
                    /*(requireActivity() as BaseActivity).logout()*/
                }

                is ApplicationException -> {
                    showMessage(throwable.toString())
                }

                is SocketTimeoutException -> {
                    Log.d("TIMEOUT", ":: BaseDialog")
                    showMessage(getString(R.string.socket_time_out_exception))
                }

                else -> showMessage(getString(R.string.other_exception) + throwable.message)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    protected fun hideLoader() {
        if (isAdded)
            (requireActivity() as BaseActivity).hideLoader()
    }

    protected fun showLoader() {
        if (isAdded)
            (requireActivity() as BaseActivity).showLoader()
    }

    protected fun hideKeyboardFrom(/*context: Context, */view: View) {
        val imm: InputMethodManager =
            requireContext().getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(view.windowToken, 0)
    }


    protected abstract fun injectDependencies(applicationComponent: ApplicationComponent)

    /**
     * This method is used for binding view with your binding
     */
    protected abstract fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): T

    /**
     * This method is used for binding view with your binding
     */
    protected abstract fun bindData()

    open fun onViewClick(view: View) {

    }

    override fun onResume() {
        super.onResume()
        //dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
    }

    /**
     * handleLocationPermission For Home Screen
     */
    fun handleLocationUpdateForHomeScreen(
        successCallBack: ((location: Location?, error: LocationException?) -> Unit),
        manualCallback: () -> Unit
    ) {
        locationManager.isPermissionGranted { granted ->
            if (granted) {
                showLoader()
                locationManager.startLocationUpdates(callback = successCallBack, showLoader = true)
            } else {
                val locationUpdateBottomSheetDialog = LocationUpdateBottomSheetDialog().apply {
                    arguments = this.arguments
                }

                locationUpdateBottomSheetDialog.grantPermission = {
                    locationManager.requestPermissionCustom(successCallback = { location, error ->
                        locationUpdateBottomSheetDialog.dismiss()

                        if (locationUpdateBottomSheetDialog.isVisible) {
                            showLoader()

                            location?.let {
                                successCallBack.invoke(location, error)
                            }

                            error?.let {
                                if (it.status == LocationManager.Status.NO_PERMISSION) {
                                    showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location))
                                }
                            }
                        }
                    })
                }

                locationUpdateBottomSheetDialog.selectManual = {
                    manualCallback.invoke()
                    locationUpdateBottomSheetDialog.dismiss()
                }

                locationUpdateBottomSheetDialog.show(
                    childFragmentManager,
                    LocationPermissionBottomSheetDialog::class.java.simpleName
                )
            }
        }
    }


    fun showOpenPermissionSettingDialog(
        arrayList: ArrayList<BaseActivity.AndroidPermissions> = ArrayList(),
        onCancelCallback: (() -> Unit)? = null,
        onSettingCallback: (() -> Unit)? = null
    ) {
        val sb = StringBuilder()
        sb.append("Please allow required permissions from settings")
        arrayList.forEachIndexed { index, androidPermissions ->
            sb.append("\n").append((index + 1).toString()).append(". ")
                .append(androidPermissions.permissionText)
        }
        showAlertDialogWithOptions(sb.toString(),
            positiveText = "Settings",
            negativeText = "Cancel",
            object : BaseActivity.DialogYesNoListener {
                override fun onYesClick() {
                    onSettingCallback?.invoke()
                    startActivity(Intent().apply {
                        action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
                        data = Uri.fromParts("package", requireActivity().packageName, null)
                    })
                }

                override fun onNoClick() {
                    onCancelCallback?.invoke()
                }
            })
    }


    fun showAlertDialogWithOptions(
        message: String,
        positiveText: String,
        negativeText: String,
        dialogYesNoListener: BaseActivity.DialogYesNoListener?,
    ) {
        AlertDialog.Builder(requireContext(), R.style.dateTimePickerDialog)
            .setMessage(message)
            .setCancelable(false)
            .setPositiveButton(positiveText) { dialog, which ->
                dialogYesNoListener?.onYesClick()
                dialog.cancel()
            }
            .setNegativeButton(negativeText) { dialog, which ->
                dialogYesNoListener?.onNoClick()
                dialog.cancel()
            }.show()
    }

    public fun sendEventToRN(
        reactContext: ReactContext,
        eventName: String,
        params: Any
    ) {
        Log.d("sendEventToRN: ", eventName)

        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }
}