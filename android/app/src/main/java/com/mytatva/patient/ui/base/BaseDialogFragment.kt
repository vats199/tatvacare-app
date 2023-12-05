package com.mytatva.patient.ui.base

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Toast
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import com.mytatva.patient.R
import com.mytatva.patient.di.Injector
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.AuthenticationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.utils.Validator
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import java.net.ConnectException
import java.net.SocketTimeoutException
import javax.inject.Inject

abstract class BaseDialogFragment<T : ViewBinding> : DialogFragment() {

    @Inject
    lateinit var analytics: AnalyticsClient

    @Inject
    lateinit var validator: Validator

    private var _binding: T? = null

    protected val binding: T
        get() = _binding!!

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    override fun onCreate(savedInstanceState: Bundle?) {
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

    /*protected lateinit var callback: () -> Unit

    fun setCallBack(callback: () -> Unit): BaseDialogFragment<T> {
        this.callback = callback
        return this
    }*/

    protected fun hideLoader() {
        (requireActivity() as BaseActivity).hideLoader()
    }

    protected fun showLoader() {
        (requireActivity() as BaseActivity).showLoader()
    }

    protected fun showToast(message: String) {
        Toast.makeText(requireContext(), message, Toast.LENGTH_SHORT).show()
    }

    protected fun showMessage(message: String) {
        Toast.makeText(requireContext(), message, Toast.LENGTH_SHORT).show()
        //AlertNotification.showSuccessMessage(this,message)
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
        dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog?.setCancelable(false)
        dialog?.setCanceledOnTouchOutside(false)
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            requireContext().display
        } else {
            wm.defaultDisplay
        }
        val metrics = DisplayMetrics()
        display?.getMetrics(metrics)
        val width = metrics.widthPixels * .9
        val height = metrics.heightPixels * .7
        val win = dialog?.window
        win!!.setLayout(width.toInt(), WindowManager.LayoutParams.WRAP_CONTENT)
    }

}