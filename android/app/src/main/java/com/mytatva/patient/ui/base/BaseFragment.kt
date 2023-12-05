package com.mytatva.patient.ui.base

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.TextView
import androidx.annotation.StringRes
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import com.facebook.react.bridge.ReactContext
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.google.android.material.snackbar.Snackbar
import com.mytatva.patient.R
import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.databinding.CommonLayoutOtpBinding
import com.mytatva.patient.databinding.CommonNewLayoutOtpBinding
import com.mytatva.patient.databinding.CommonV2LayoutOtpBinding
import com.mytatva.patient.di.HasComponent
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.di.module.FragmentModule
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.AuthenticationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.AlertNotification
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.DownloadHelper
import com.mytatva.patient.utils.FirebaseConfigUtil
import com.mytatva.patient.utils.Validator
import com.mytatva.patient.utils.coachmarks.CoachMarksUtil
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.googlefit.GoogleFit
import com.mytatva.patient.utils.surveysparrow.SurveyUtil
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.Random
import java.util.regex.Matcher
import java.util.regex.Pattern
import javax.inject.Inject


abstract class BaseFragment<T : ViewBinding> : Fragment(), HasComponent<FragmentComponent> {

    protected val createFileName: String
        get() {
            val SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
            val salt = StringBuilder()
            val rnd = Random()
            while (salt.length < 10) {
                val index = (rnd.nextFloat() * SALTCHARS.length).toInt()
                salt.append(SALTCHARS[index])
            }

            try {
                salt.append(SimpleDateFormat("yyMMddhhmmssMs", Locale.US).format(Date()))
            } catch (e: Exception) {
            }

            return salt.toString()
        }

    protected lateinit var toolbar: HasToolbar

    val firebaseConfigUtil: FirebaseConfigUtil
        get() {
            return (requireActivity() as BaseActivity).firebaseConfigUtil
        }

    @Inject
    lateinit var navigator: Navigator

    @Inject
    lateinit var validator: Validator

    @Inject
    lateinit var session: Session
    val isSessionInitialized get() = this::session.isInitialized

    @Inject
    lateinit var appPreferences: AppPreferences

    @Inject
    lateinit var analytics: AnalyticsClient

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    @Inject
    lateinit var locationManager: LocationManager

    @Inject
    lateinit var googleFit: GoogleFit

    @Inject
    lateinit var downloadHelper: DownloadHelper

    @Inject
    lateinit var surveyUtil: SurveyUtil

    @Inject
    lateinit var coachMarksUtil: CoachMarksUtil

    override val component: FragmentComponent
        get() {
            return getComponent(ActivityComponent::class.java).plus(FragmentModule(this))
        }

    private var _binding: T? = null

    protected val binding: T
        get() = _binding!!


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View? {
        _binding = createViewBinding(inflater, container, false)
        //activity?.let { ActivityCompat.startPostponedEnterTransition(it) }
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        bindData()
    }

    protected fun <C> getComponent(componentType: Class<C>): C {
        return componentType.cast((activity as HasComponent<C>).component)
    }

    override fun onAttach(context: Context) {
        inject(component)
        super.onAttach(context)

        if (activity is HasToolbar)
            toolbar = activity as HasToolbar

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

    fun hideKeyboardFrom(/*context: Context, */view: View) {
        val imm: InputMethodManager =
            requireActivity().getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(view.windowToken, 0)
    }

    fun hideKeyBoard() {
        if (activity is BaseActivity) {
            (activity as BaseActivity).hideKeyboard()
        }
    }

    fun showKeyBoard() {
        if (activity is BaseActivity) {
            (activity as BaseActivity).showKeyboard()
        }
    }

    fun <T : BaseFragment<*>> getParentFragment(targetFragment: Class<T>): T? {
        if (parentFragment == null) return null
        try {
            return targetFragment.cast(parentFragment)
        } catch (e: ClassCastException) {
            e.printStackTrace()
        }
        return null
    }

    open fun onShow() {

    }

    /**
     * **************************************************
     * Base methods
     * for show loader, message
     * **************************************************
     */
    fun showLoader() {
        if (isAdded) {
            if (activity is BaseActivity) {
                (activity as BaseActivity).showLoader()
            }
        }
    }

    fun hideLoader() {
        if (isAdded) {
            if (activity is BaseActivity) {
                (activity as BaseActivity).hideLoader()
            }
        }
    }

    fun showMessage(message: String) {
        showSnackBar(message)
    }

    fun showAppMessage(message: String, status: AppMsgStatus = AppMsgStatus.DEFAULT) {
        AlertNotification.showAppMessage(requireActivity(), message, status)
    }

    fun showBottomMessage(
        message: String,
        duration: Int,
        backgroundColor: Int = R.color.colorPrimary,
        startDrawable: Int? = null
    ) {
        val snackbar = Snackbar.make(
            requireActivity().findViewById(android.R.id.content),
            message,
            Snackbar.LENGTH_LONG
        )
        snackbar.duration = duration
        snackbar.setActionTextColor(Color.WHITE)

        val snackView = snackbar.view
        val textView =
            snackView.findViewById(com.google.android.material.R.id.snackbar_text) as TextView

        textView.maxLines = 4
        if (startDrawable != null) {
            val drawable =
                ContextCompat.getDrawable(requireContext(), R.drawable.ic_exercise_tick_unchecked)
            drawable?.setTint(resources.getColor(R.color.white, null))

            textView.setCompoundDrawablesWithIntrinsicBounds(drawable, null, null, null)
            textView.setCompoundDrawablePadding(getResources().getDimensionPixelOffset(R.dimen.dp_10))
        }

        snackView.setBackgroundColor(requireActivity().resources.getColor(backgroundColor, null))

        snackbar.show()
    }

    fun showMessage(@StringRes stringId: Int) {
        showSnackBar(getString(stringId))
    }

    fun showMessage(applicationException: ApplicationException) {
        showSnackBar(applicationException.message)
    }

    fun isFeatureAllowedAsPerPlan(
        featureKey: String,
        subFeatureKey: String = "",
        needToShowDialog: Boolean = true,
        okCallback: (() -> Unit)? = null,
    ): Boolean {
        return (requireActivity() as BaseActivity).isFeatureAllowedAsPerPlan(
            featureKey,
            subFeatureKey,
            needToShowDialog,
            okCallback
        )
    }

    fun fetchOTPfromMessage(message: String): String {
        val pattern: Pattern = Pattern.compile("(\\d{6})")
        val matcher: Matcher = pattern.matcher(message)
        var otp = ""
        if (matcher.find()) {
            try {
                otp = matcher.group(0) ?: ""
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        return otp
    }

    private fun showSnackBar(message: String) {
        hideKeyBoard()
        if (view != null) {
            /*val snackbar = Snackbar.make(requireView(), message, Snackbar.LENGTH_LONG)
            snackbar.duration = 3000
            *//*snackbar.setActionTextColor(Color.WHITE)
            snackbar.setAction("OK", { snackbar.dismiss() })*//*
            val snackView = snackbar.view
            val textView =
                snackView.findViewById(com.google.android.material.R.id.snackbar_text) as TextView
            textView.maxLines = 4

            snackView.setBackgroundColor(requireActivity().resources.getColor(R.color.colorPrimary))
            snackbar.show()*/

            AlertNotification.showMessage(requireActivity() as BaseActivity, message)
        }
    }

    private fun showSnackBar(message: String, viewSet: View?) {
        hideKeyBoard()
        if (viewSet != null) {
            val snackbar = Snackbar.make(viewSet, message, Snackbar.LENGTH_LONG)
            snackbar.duration = 3000
            /*snackbar.setActionTextColor(Color.WHITE)
            snackbar.setAction("OK", View.OnClickListener { snackbar.dismiss() })*/
            val snackView = snackbar.view
            val textView =
                snackView.findViewById(com.google.android.material.R.id.snackbar_text) as TextView
            textView.maxLines = 4
            snackView.setBackgroundColor(requireActivity().resources.getColor(R.color.colorPrimary))
            snackbar.show()
        }
    }

    fun showSkipCoachMarkMessage() {
        (requireActivity() as BaseActivity).showSkipCoachMarkMessage()
    }

    open fun onBackActionPerform(): Boolean {
        return true
    }

    open fun onViewClick(view: View) {

    }

    public fun onError(throwable: Throwable) {
        try {
            when (throwable) {
                is ServerException -> showMessage(throwable.message.toString())
                is ConnectException -> {
                    showMessage(R.string.connection_exception)
                }

                is UnknownHostException -> {
                    showMessage(R.string.connection_exception)
                }

                is AuthenticationException -> {
                    logout()
                }

                is ApplicationException -> {
                    showMessage(throwable.toString())
                }

                is SocketTimeoutException -> {
                    Log.d(
                        "TIMEOUT",
                        ":: BaseFragment ${(activity as BaseActivity).getCurrentFragment<BaseFragment<*>>()}"
                    )
                    //showMessage(R.string.socket_time_out_exception)
                }

                else -> {
                    if (requireActivity() !is HomeActivity) {
                        showMessage(getString(R.string.other_exception) + throwable.message)
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

    fun openNotificationScreen() {

    }

    fun openHome(screenName: String? = null) {

        // removed USER_SESSION_START from here as per Jira story MTP-911, to keep it only on app foreground
        //analytics.logEvent(analytics.USER_SESSION_START)

        appPreferences.putBoolean(Common.IS_LOGIN, true)
        navigator.loadActivity(HomeActivity::class.java)
            .byFinishingAll()
            .start()
        session.user?.let { analytics.login(it) }
    }

    fun logout(screenName: String? = null) {
        (requireActivity() as BaseActivity).logout(screenName)
    }

    fun openPdfViewer(certificate: String, isLocalFile: Boolean = false) {
        navigator.openPdfViewer(certificate)
        /* try {
             val intent = Intent(Intent.ACTION_VIEW)
             intent.setDataAndType(Uri.parse(certificate), "application/pdf")
             requireContext().startActivity(intent)
         } catch (e: ActivityNotFoundException) {
             //user does not have a pdf viewer installed
             showMessage("No apps found to open this file")
             *//*navigator.loadActivity(IsolatedActivity::class.java, PdfViewerFragment::class.java)
                .addBundle(Bundle().apply {
                    putString(Common.BundleKey.DOC_URL, certificate)
                }).start()*//*
        }*/
    }

    fun setPasteCallbackForOTPViews(layoutOTP: CommonLayoutOtpBinding) {
        try {
            with(layoutOTP) {
                editText1.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText2.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText3.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText4.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    fun setOTP(layoutOTP: CommonLayoutOtpBinding, otp: String?) {
        try {
            with(layoutOTP) {
                if (otp?.length == 4) {
                    editText1.setText(otp[0].toString())
                    editText2.setText(otp[1].toString())
                    editText3.setText(otp[2].toString())
                    editText4.setText(otp[3].toString())
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    /**
     * for new 6 digit OTP views
     */
    fun setPasteCallbackForOTPViews(layoutOTP: CommonNewLayoutOtpBinding) {
        try {
            with(layoutOTP) {
                editText1.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText2.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText3.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText4.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText5.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText6.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    fun setOTP(layoutOTP: CommonNewLayoutOtpBinding, otp: String?) {
        try {
            with(layoutOTP) {
                if (otp?.length == 6) {
                    editText1.setText(otp[0].toString())
                    editText2.setText(otp[1].toString())
                    editText3.setText(otp[2].toString())
                    editText4.setText(otp[3].toString())
                    editText5.setText(otp[4].toString())
                    editText6.setText(otp[5].toString())
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    /**
     * for new 6 digit OTP views
     */
    fun setPasteCallbackForOTPViews(layoutOTP: CommonV2LayoutOtpBinding) {
        try {
            with(layoutOTP) {
                editText1.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText2.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText3.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText4.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText5.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
                editText6.setPasteCallback { copiedText ->
                    setOTP(
                        layoutOTP,
                        fetchOTPfromMessage(copiedText)
                    )
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    fun setOTP(layoutOTP: CommonV2LayoutOtpBinding, otp: String?) {
        try {
            with(layoutOTP) {
                if (otp?.length == 6) {
                    editText1.setText(otp[0].toString())
                    editText2.setText(otp[1].toString())
                    editText3.setText(otp[2].toString())
                    editText4.setText(otp[3].toString())
                    editText5.setText(otp[4].toString())
                    editText6.setText(otp[5].toString())
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    protected fun openCart() {
        openCartV2()
        /*if ((session.cart?.totalCartCount ?: 0) > 0 || session.cart?.bcp_flag == "Y") {
            *//*navigator.loadActivity(IsolatedFullActivity::class.java,
                LabtestCartFragment::class.java)
                .start()*//*
            navigator.loadActivity(
                IsolatedFullActivity::class.java,
                LabtestCartV1Fragment::class.java
            ).start()
        } else {
            showAppMessage(getString(R.string.msg_your_cart_is_empty), AppMsgStatus.ERROR)
        }*/
    }

    private fun openCartV2() {

    }

    /*OTP TextWatcher*/
    class GenericKeyEvent internal constructor(
        private val currentView: EditText,
        private val previousView: EditText?,
        private val activity: Activity,
    ) : View.OnKeyListener {
        override fun onKey(p0: View?, keyCode: Int, event: KeyEvent?): Boolean {
            if (event!!.action == KeyEvent.ACTION_DOWN && keyCode == KeyEvent.KEYCODE_DEL && currentView.id != R.id.editText1 && currentView.text.isEmpty()) {
                //If current is empty then previous EditText's number will also be deleted
                previousView!!.text = null
                previousView.requestFocus()
                return true
            }
            return false
        }
    }

    class GenericTextWatcher internal constructor(
        private val currentView: View,
        private val nextView: View?,
        private val activity: BaseActivity,
    ) :
        TextWatcher {
        override fun afterTextChanged(editable: Editable) { // TODO Auto-generated method stub
            val text = editable.toString()
            when (currentView.id) {
                R.id.editText1 -> if (text.length == 1) nextView!!.requestFocus()
                R.id.editText2 -> if (text.length == 1) nextView!!.requestFocus()
                R.id.editText3 -> if (text.length == 1) nextView!!.requestFocus()
                R.id.editText4 -> if (text.length == 1) nextView!!.requestFocus()
                R.id.editText5 -> if (text.length == 1) nextView!!.requestFocus()
                R.id.editText6 -> if (text.length == 1) activity.hideKeyboard()
                //You can use EditText4 same as above to hide the keyboard
            }
        }

        override fun beforeTextChanged(
            arg0: CharSequence,
            arg1: Int,
            arg2: Int,
            arg3: Int,
        ) {
        }

        override fun onTextChanged(
            arg0: CharSequence,
            arg1: Int,
            arg2: Int,
            arg3: Int,
        ) {
        }

    }
    /*OTP TextWatcher end*/

    protected abstract fun inject(fragmentComponent: FragmentComponent)

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
}
