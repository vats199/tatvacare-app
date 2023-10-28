package com.mytatva.patient.ui.payment.fragment

import android.annotation.SuppressLint
import android.content.res.ColorStateList
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.Duration
import com.mytatva.patient.data.pojo.response.PatientPlanData
import com.mytatva.patient.databinding.PaymentFragmentPaymentPlanDetailsBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.ChooseDurationAdapter
import com.mytatva.patient.ui.payment.dialog.CancelPlanAlertDialog
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.loadUrl
import com.mytatva.patient.utils.parseAsColor
import com.razorpay.Checkout
import org.json.JSONObject

class PaymentPlanDetailsFragment : BaseFragment<PaymentFragmentPaymentPlanDetailsBinding>() {

    private var subscriptionId: String? = null

    private val isIndividualPlan by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_INDIVIDUAL_PLAN) ?: false
    }

    private val planMasterId by lazy {
        arguments?.getString(Common.BundleKey.PLAN_ID)
    }

    private val isClickOnBuyButton by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_CLICK_ON_BUY) ?: false
    }

    private var patientPlanData: PatientPlanData? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    /*private val razorPayViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[RazorPayViewModel::class.java]
    }*/

    private val durationList = arrayListOf<Duration>()
    private val chooseDurationAdapter by lazy {
        ChooseDurationAdapter(durationList,
        object :ChooseDurationAdapter.AdapterListener{
            override fun onDurationSelect(position: Int) {
                analytics.logEvent(analytics.USER_CLICKED_ON_SUBSCRIPTION_DURATION,
                    Bundle().apply {
                        putString(analytics.PARAM_PLAN_ID, patientPlanData?.plan_master_id)
                        putString(analytics.PARAM_PLAN_TYPE, patientPlanData?.plan_type)
                        putString(analytics.PARAM_PLAN_DURATION, durationList[position].duration_title)
                    }, screenName = getScreenName())
            }
        })
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentPaymentPlanDetailsBinding {
        return PaymentFragmentPaymentPlanDetailsBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(getScreenName())
    }

    private fun getScreenName(): String {
        return if (isIndividualPlan)
            AnalyticsScreenNames.MyTatvaIndividualPlanDetail
        else
            AnalyticsScreenNames.MyTatvaPlanDetail
    }

    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpRecyclerView()
        plansDetailsById()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewDurations.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = chooseDurationAdapter
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.payment_plan_details_title)
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewFilter.visibility = View.GONE
            imageViewSearch.visibility = View.GONE
            imageViewNotification.visibility = View.GONE
        }
    }

    private fun setViewListeners() {
        with(binding) {
            buttonBuyNow.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpgrade.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.buttonUpgrade -> {
                PaymentPlansFragment.IS_TO_SCROLL_TO_OTHER_PLAN = true
                navigator.goBack()
            }
            R.id.buttonCancel -> {
                patientPlanData?.let {
                    if (it.plan_type == Common.MyTatvaPlanType.SUBSCRIPTION) {
                        if (it.device_type == "A") {
                            showCancelAlert()
                        } else {
                            navigator.showAlertDialog(getString(R.string.payment_plan_details_msg_can_not_cancel_plan_created_from_ios))
                        }
                    } else {
                        showCancelAlert()
                    }
                }
            }
            R.id.buttonBuyNow -> {

                if (durationList.isNotEmpty()) {

                    analytics.logEvent(analytics.USER_CLICKED_ON_SUBSCRIPTION_BUY,
                        Bundle().apply {
                            putString(analytics.PARAM_PLAN_ID, patientPlanData?.plan_master_id)
                            putString(analytics.PARAM_PLAN_TYPE, patientPlanData?.plan_type)
                            putString(analytics.PARAM_PLAN_DURATION, durationList[chooseDurationAdapter.selectedPos].duration_title)
                            putString(analytics.PARAM_PLAN_VALUE, durationList[chooseDurationAdapter.selectedPos].androidPrice.toString())
                        }, screenName = getScreenName())

                    if (patientPlanData?.plan_type == Common.MyTatvaPlanType.INDIVIDUAL) {

                        val priceToPurchase =
                            durationList[chooseDurationAdapter.selectedPos].androidPrice
                        /*if (durationList[chooseDurationAdapter.selectedPos].offerPrice > 0)
                            durationList[chooseDurationAdapter.selectedPos].offerPrice
                        else
                            durationList[chooseDurationAdapter.selectedPos].androidPrice*/

                        if (priceToPurchase > 0) {
                            //startPayment(priceToPurchase)
                            generateRazorpayOrderId(priceToPurchase.toString())
                        }

                    } else {

                        if (session.user?.patient_plans?.any { it.plan_type == Common.MyTatvaPlanType.SUBSCRIPTION } == true) {

                            navigator.showAlertDialogWithOptions(
                                getString(R.string.payment_plan_details_alert_msg_existing_plan_cancel),
                                positiveText = "Yes",
                                negativeText = "Cancel",
                                dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                                    override fun onYesClick() {
                                        continuePurchaseFlow()
                                    }

                                    override fun onNoClick() {

                                    }
                                })

                        } else {
                            continuePurchaseFlow()
                        }
                    }

                }

                /*val priceToPurchase =
                    if (durationList[chooseDurationAdapter.selectedPos].offerPerMonthPrice > 0)
                        durationList[chooseDurationAdapter.selectedPos].offerPerMonthPrice
                    else
                        durationList[chooseDurationAdapter.selectedPos].androidPerMonthPrice
                if (priceToPurchase > 0) {
                    startPayment(priceToPurchase)
                }*/
            }
        }
    }

    private fun continuePurchaseFlow() {
        if (durationList[chooseDurationAdapter.selectedPos].isFree) {
            // pass "Free" in transaction id for free plan purchase
            addPatientPlan("Free")
        } else {
            durationList[chooseDurationAdapter.selectedPos].razorpay_plan_id?.let {
                createSubscriptions(it)
            }
        }
    }

    private fun showCancelAlert() {
        CancelPlanAlertDialog {
            cancelPatientPlan()
        }.show(requireActivity().supportFragmentManager,
            CancelPlanAlertDialog::class.java.simpleName)
    }

    private fun startPaymentSubscription(subscriptionId: String) {
        this.subscriptionId = subscriptionId

        Checkout.preload(requireActivity().applicationContext)
        //
        val co = Checkout()
        co.setKeyID(firebaseConfigUtil.getRazorPayKey())
        //co.setImage(R.mipmap.ic_launcher_foreground)

        try {
            val options = JSONObject()
            options.put("name", durationList[chooseDurationAdapter.selectedPos].duration_name)
            options.put("description",
                durationList[chooseDurationAdapter.selectedPos].duration_title)
            //options.put("image", "https://s3.amazonaws.com/rzp-mobile/images/rzp.png")
            //options.put("order_id", "order_DBJOWzybf0sJbb") //from response of step 3.
            //options.put("theme.color", "#3399cc")
            options.put("currency", "INR")
            options.put("subscription_id", subscriptionId)
            options.put("recurring", true)
            //options.put("amount", (offerPrice * 100).toString()) //pass amount in currency subunits

            val preFill = JSONObject()
            preFill.put("email", session.user?.email)
            preFill.put("contact", session.user?.country_code + session.user?.contact_no)
            options.put("prefill", preFill)

            /*options.put("prefill.email", session.user?.email)
            options.put("prefill.contact", session.user?.contact_no)*/


            val retryObj = JSONObject()
            retryObj.put("enabled", true)
            retryObj.put("max_count", 4)
            options.put("retry", retryObj)

            //added from referred code
            //options.put("captured", true)


            co.open(activity, options)
        } catch (e: Exception) {
            Log.d("PaymentFragment", "Error in starting Razorpay Checkout", e)
        }
    }

    private fun startPayment(razorPayOrderId: String) {

        val offerPrice = durationList[chooseDurationAdapter.selectedPos].androidPrice

        Checkout.preload(requireActivity().applicationContext)
        //
        val co = Checkout()
        co.setKeyID(firebaseConfigUtil.getRazorPayKey())
        //co.setImage(R.mipmap.ic_launcher_foreground)

        try {
            val options = JSONObject()
            options.put("name", durationList[chooseDurationAdapter.selectedPos].duration_name)
            options.put("description",
                durationList[chooseDurationAdapter.selectedPos].duration_title)
            //options.put("image", "https://s3.amazonaws.com/rzp-mobile/images/rzp.png")
            //options.put("theme.color", "#3399cc")
            options.put("order_id", razorPayOrderId) //from response of step 3.
            options.put("currency", "INR")
            options.put("amount", (offerPrice * 100).toString()) //pass amount in currency subunits

            val preFill = JSONObject()
            preFill.put("email", session.user?.email)
            preFill.put("contact", session.user?.country_code + session.user?.contact_no)
            options.put("prefill", preFill)

            /*options.put("prefill.email", session.user?.email)
            options.put("prefill.contact", session.user?.contact_no)*/

            val retryObj = JSONObject()
            retryObj.put("enabled", true)
            retryObj.put("max_count", 4)
            options.put("retry", retryObj)

            //added from referred code
            //options.put("captured", true)

            co.open(activity, options)
        } catch (e: Exception) {
            Log.d("PaymentFragment", "Error in starting Razorpay Checkout", e)
        }
    }

    fun onPaymentSuccess(paymentId: String?) {
        //showMessage("Success $paymentId")
        //Log.e("RAZORPAY", "onPaymentSuccess: $paymentId")
        addPatientPlan(paymentId)
    }

    fun onPaymentError(code: Int, error: String?) {
        Log.d("RazorPay", "onPaymentError: $code :: $error")
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun plansDetailsById() {
//        val apiRequest = ApiRequest().apply {
//            plan_id = planMasterId
//        }
//        showLoader()
//        patientPlansViewModel.plansDetailsById(apiRequest)
    }

    private fun addPatientPlan(paymentId: String?) {
        val apiRequest = ApiRequest().apply {
            plan_master_id = planMasterId
            plan_package_duration_rel_id =
                durationList[chooseDurationAdapter.selectedPos].plan_package_duration_rel_id
            device_type = Session.DEVICE_TYPE
            purchase_amount = durationList[chooseDurationAdapter.selectedPos].android_price
            subscription_id = subscriptionId
            transaction_id = paymentId

            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }
        }
        showLoader()
        patientPlansViewModel.addPatientPlan(apiRequest)
    }

    private fun cancelPatientPlan() {
        val apiRequest = ApiRequest().apply {
            patient_plan_rel_id = patientPlanData?.patient_plan_rel_id
            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }
        }
        showLoader()
        patientPlansViewModel.cancelPatientPlan(apiRequest)
    }

    private fun createSubscriptions(razorPayPlanId: String) {
        val apiRequest = ApiRequest().apply {
            live = if (MyTatvaApp.IS_RAZORPAY_LIVE) "Yes" else "No"
            plan_id = razorPayPlanId

            //set total count as 99 for all the plans weather it's monthly, yearly, etc.
            //total_count = 99 // setup done from backend
        }

        showLoader()
        //razorPayViewModel.createSubscriptions(apiRequest)
        patientPlansViewModel.razorpaySubscription(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.getPatientDetails(apiRequest)
    }

    private fun generateRazorpayOrderId(payableAmount: String) {
        val apiRequest = ApiRequest().apply {
            amount = payableAmount
            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }
        }
        showLoader()
        patientPlansViewModel.razorpayOrderId(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
//        patientPlansViewModel.plansDetailsByIdLiveData.observe(this,
//            onChange = { responseBody ->
//                hideLoader()
//                patientPlanData = responseBody.data
//                setPlanDetails()
//            },
//            onError = { throwable ->
//                hideLoader()
//                true
//            })

        patientPlansViewModel.addPatientPlanLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //navigator.goBack()
                getPatientDetails()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        patientPlansViewModel.cancelPatientPlanLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //navigator.goBack()
                getPatientDetails()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        /*razorPayViewModel.createSubscriptionsLiveData.observe(this) {
            hideLoader()
            if (it.id.isNullOrBlank().not()) {
                startPaymentSubscription(it.id!!)
            } else {
                showMessage(it.error?.description ?: "error")
            }
        }*/

        patientPlansViewModel.razorpaySubscriptionLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    startPaymentSubscription(it.id!!)
                }
            },
            onError = { throwable ->
                hideLoader()
                navigator.goBack()
                false
            })

        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //to update user data and go back
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                navigator.goBack()
                false
            })

        patientPlansViewModel.razorpayOrderIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { razorPayOrderId ->
                    startPayment(razorPayOrderId)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setPlanDetails() {
        patientPlanData?.let {
            with(binding) {
                layoutContent.visibility = View.VISIBLE

                val color = it.colour_scheme.parseAsColor()
                textViewTitle.setTextColor(color)
                buttonBuyNow.backgroundTintList = ColorStateList.valueOf(color)
                buttonCancel.backgroundTintList = ColorStateList.valueOf(color)
                buttonUpgrade.backgroundTintList = ColorStateList.valueOf(color)

                if (it.plan_type == Common.MyTatvaPlanType.FREE) {
                    buttonUpgrade.visibility = View.VISIBLE
                    buttonBuyNow.visibility = View.GONE
                    buttonCancel.visibility = View.GONE
                    textViewLabelChooseDuration.visibility = View.GONE
                    recyclerViewDurations.visibility = View.GONE
                } else {
                    buttonUpgrade.visibility = View.GONE
                    if (it.plan_purchased == "Y") {
                        buttonBuyNow.visibility = View.GONE
                        if (it.plan_type == Common.MyTatvaPlanType.INDIVIDUAL) {
                            buttonCancel.visibility = View.GONE
                        } else {
                            buttonCancel.visibility = View.VISIBLE
                        }
                    } else {
                        buttonBuyNow.visibility = View.VISIBLE
                        buttonCancel.visibility = View.GONE
                    }
                }

                imageViewPlanIcon.loadUrl(it.image_url ?: "", isCenterCrop = false)

                layoutHeader.textViewToolbarTitle.text = it.plan_name
                textViewTitle.text = it.plan_name
                textViewSubTitle.text = it.sub_title
                //textViewDescription.text = it.getHtmlFormattedDescription
                setUpWebView()

                durationList.clear()
                it.duration?.let { it1 -> durationList.addAll(it1) }
                chooseDurationAdapter.selectedPos = getIndexOfMaxDurationItem()
                chooseDurationAdapter.color = color
                chooseDurationAdapter.notifyDataSetChanged()

                if (isClickOnBuyButton) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        if (isAdded) {
                            nestedScrollView.post {
                                /*nestedScrollView.fullScroll(View.FOCUS_DOWN)*/
                                nestedScrollView.smoothScrollTo(0,
                                    nestedScrollView.getChildAt(0).height)
                            }
                        }
                    }, 800)
                }
            }
        }
    }

    private fun getIndexOfMaxDurationItem(): Int {
        return durationList.indexOfFirst { it.getDurationDays == durationList.maxOf { it.getDurationDays } }
    }

    private fun setUpWebView() {
        with(binding) {
            if (patientPlanData?.description.isNullOrBlank().not()) {
                webView.visibility = View.VISIBLE

                /*webView.settings.builtInZoomControls = true
                webView.settings.displayZoomControls = false
                webView.settings.useWideViewPort = true
                webView.settings.loadWithOverviewMode = true*/

                patientPlanData?.description?.let {
                    val cleanHtml = it.replace("\\\"", "\"")
                    webView.loadDataWithBaseURL(null,
                        cleanHtml
                        /*dummyWebData*/,
                        "text/html", //; charset=utf-8
                        "UTF-8",
                        null)
                }

            } else {
                webView.visibility = View.GONE
            }
        }
    }

}