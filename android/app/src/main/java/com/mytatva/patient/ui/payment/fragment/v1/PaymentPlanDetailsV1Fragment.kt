package com.mytatva.patient.ui.payment.fragment.v1

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.transition.TransitionManager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpDetailsMainData
import com.mytatva.patient.data.pojo.response.BcpDuration
import com.mytatva.patient.data.pojo.response.BcpFeatureTableData
import com.mytatva.patient.databinding.PaymentFragmentPaymentPlanDetailsV1Binding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.v1.ChooseDurationV1Adapter
import com.mytatva.patient.ui.payment.adapter.v1.PlanFeatureHeaderAdapter
import com.mytatva.patient.ui.payment.adapter.v1.PlanFeaturesMainAdapter
import com.mytatva.patient.ui.payment.bottomsheet.SelectAddressBottomSheetDialog
import com.mytatva.patient.ui.payment.dialog.CancelPlanAlertDialog
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.DeviceUtils
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.razorpay.Checkout
import org.json.JSONObject

class PaymentPlanDetailsV1Fragment : BaseFragment<PaymentFragmentPaymentPlanDetailsV1Binding>() {

    enum class IndividualPlanDurationType(val key: String) {
        RENT("Rent"), BUY("Buy")
    }

    private val planMasterId by lazy {
        arguments?.getString(Common.BundleKey.PLAN_ID)
    }

    private val patientPlanRelId by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_PLAN_REL_ID)
    }

    private val planType by lazy {
        arguments?.getString(Common.BundleKey.PLAN_TYPE)
    }

    private val enableRentBuy by lazy {
        arguments?.getString(Common.BundleKey.ENABLE_RENT_BUY) ?: ""
    }

    private val isRentBuyEnabled: Boolean
        get() {
            return enableRentBuy == "Y"
            /*return planType == Common.MyTatvaPlanType.INDIVIDUAL*/
        }

    private var selectedIndividualPlanDurationType = IndividualPlanDurationType.RENT

    private val authViewModel by lazy {
        ViewModelProvider(
            this, viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this, viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    private val durationList = arrayListOf<BcpDuration>()
    private val chooseDurationV1Adapter by lazy {
        ChooseDurationV1Adapter(
            durationList,
            adapterListener = object : ChooseDurationV1Adapter.AdapterListener {
                override fun onClick(position: Int) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_SUBSCRIPTION_DURATION,
                        Bundle().apply {
                            putString(analytics.PARAM_PLAN_ID, planMasterId)
                            putString(analytics.PARAM_PLAN_TYPE, planType)
                            putString(
                                analytics.PARAM_PLAN_DURATION,
                                durationList[position].duration_title
                            )
                        }, screenName = AnalyticsScreenNames.BcpDetails
                    )
                }
            })
    }

    private val featureHeaderList = arrayListOf<BcpDuration>()
    private val planFeatureHeaderAdapter by lazy {
        PlanFeatureHeaderAdapter(featureHeaderList,
            object : PlanFeatureHeaderAdapter.AdapterListener {
                override fun onInfoClick(position: Int) {
                    val item = featureHeaderList[position]
                    navigator.showAlertDialog(item.duration_title?.plus(" - ")
                        ?.plus(item.duration_name) ?: "",
                        dialogOkListener = object : BaseActivity.DialogOkListener {
                            override fun onClick() {

                            }
                        })
                }
            })
    }

    private val featuresList = arrayListOf<BcpFeatureTableData>()/*
        //
        "Health Coach Sessions",
        "Nutritionist", "Physiotherapist", "Success coach",
        //tests
        "Diagnostic Tests",
        "Liver Profile", "Complete Blood Count", "HBA1C",
        "Fasting Blood Sugar", "Blood Sugar Post Prandial (PPBS)", "Lipid Profile",
        //
        "Integrate Your Smart Watch",
        //
        "MyTatva’s Smart Analyser",
        //
        "Additional App Features",
        "Diet logging",
        "Track your vitals",
        "Activity tracking",
        "Sleep monitoring",
        //
        "Book a Consultation with your prescribing Doctor",*/
    private val planFeaturesMainAdapter by lazy {
        PlanFeaturesMainAdapter(
            featuresList, binding.recyclerViewFeatures, binding.recyclerViewFeatureHeader
        )
    }

    private var bcpDetailsMainData: BcpDetailsMainData? = null
    private var subscriptionId: String? = null

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentPaymentPlanDetailsV1Binding {
        return PaymentFragmentPaymentPlanDetailsV1Binding.inflate(
            inflater, container, attachToRoot
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpDetails)
    }


    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpUI()
        plansDetailsById()
    }

    private fun setUpUI() {
        with(binding) {
            groupRentBuy.isVisible = isRentBuyEnabled
            if (session.user?.medical_condition_name?.firstOrNull()?.medical_condition_name.isNullOrBlank()
                    .not()
            ) {
                textViewMedicalCondition.visibility = View.VISIBLE
                textViewMedicalCondition.text =
                    session.user?.medical_condition_name?.firstOrNull()?.medical_condition_name
            } else {
                textViewMedicalCondition.visibility = View.GONE
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            binding.recyclerViewFeatureHeader.removeOnScrollListener(planFeaturesMainAdapter.syncScrollListener)
            binding.recyclerViewFeatureHeader.addOnScrollListener(planFeaturesMainAdapter.syncScrollListener)

            recyclerViewDurations.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = chooseDurationV1Adapter
            }

            val colToShow = if (durationList.size < 3.0) {
                durationList.size.toDouble()
            } else {
                2.5
            }

            val deviceHalf = DeviceUtils.getDeviceWidthHeight(requireContext()).first / 2
            val cellWidth = (deviceHalf / colToShow/*2.5*/).toInt()
            planFeaturesMainAdapter.cellWidth = cellWidth
            recyclerViewFeatures.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = planFeaturesMainAdapter
            }

            planFeatureHeaderAdapter.cellWidth = cellWidth
            recyclerViewFeatureHeader.apply {
                layoutManager =
                    LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
                adapter = planFeatureHeaderAdapter
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text = getString(R.string.payment_plan_details_title)
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewFilter.visibility = View.GONE
            imageViewSearch.visibility = View.GONE
        }
    }

    private fun setViewListeners() {
        with(binding) {
            buttonBuyNow.setOnClickListener { onViewClick(it) }
            radioRent.setOnClickListener { onViewClick(it) }
            radioBuy.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpgrade.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.radioRent -> {
                analytics.logEvent(
                    analytics.TAP_RENT_BUY,
                    Bundle().apply {
                        putString(analytics.PARAM_PLAN_ID, planMasterId)
                        putString(analytics.PARAM_PLAN_TYPE, planType)
                    },
                    screenName = AnalyticsScreenNames.BcpDetails
                )

                if (selectedIndividualPlanDurationType != IndividualPlanDurationType.RENT) {
                    selectedIndividualPlanDurationType = IndividualPlanDurationType.RENT
                    plansDetailsById()
                }
            }

            R.id.radioBuy -> {
                analytics.logEvent(
                    analytics.TAP_RENT_BUY,
                    Bundle().apply {
                        putString(analytics.PARAM_PLAN_ID, planMasterId)
                        putString(analytics.PARAM_PLAN_TYPE, planType)
                    },
                    screenName = AnalyticsScreenNames.BcpDetails
                )

                if (selectedIndividualPlanDurationType != IndividualPlanDurationType.BUY) {
                    selectedIndividualPlanDurationType = IndividualPlanDurationType.BUY
                    plansDetailsById()
                }
            }

            R.id.buttonCancel -> {
                bcpDetailsMainData?.plan_details?.let {
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
                            putString(analytics.PARAM_PLAN_ID, planMasterId)
                            putString(analytics.PARAM_PLAN_TYPE, planType)
                            putString(
                                analytics.PARAM_PLAN_DURATION,
                                durationList[chooseDurationV1Adapter.selectedPosition].duration_title
                            )
                            putString(
                                analytics.PARAM_PLAN_VALUE,
                                durationList[chooseDurationV1Adapter.selectedPosition].androidPrice.toString()
                            )
                        }, screenName = AnalyticsScreenNames.BcpDetails
                    )

                    if (bcpDetailsMainData?.plan_details?.plan_type == Common.MyTatvaPlanType.INDIVIDUAL) {

                        if (durationList[chooseDurationV1Adapter.selectedPosition].isContainsTestOrDevice) {
                            //if it isContainsTestOrDevice, then select address flow(BCP) before payment
                            SelectAddressBottomSheetDialog().apply {
                                arguments = Bundle().apply {
                                    putParcelable(
                                        Common.BundleKey.PLAN_DATA, bcpDetailsMainData?.plan_details
                                    )
                                    putParcelable(
                                        Common.BundleKey.PLAN_DURATION_DATA,
                                        durationList[chooseDurationV1Adapter.selectedPosition]
                                    )
                                }
                            }.setCallback {

                            }.show(
                                requireActivity().supportFragmentManager,
                                SelectAddressBottomSheetDialog::class.java.simpleName
                            )
                        } else {
                            // normal flow if normal individual
                            /*val priceToPurchase = durationList[chooseDurationV1Adapter.selectedPosition].androidPrice
                            if (priceToPurchase > 0) {
                                //startPayment(priceToPurchase)
                                generateRazorpayOrderId(priceToPurchase.toString())
                            }*/

                            navigator.loadActivity(
                                IsolatedFullActivity::class.java, BcpOrderReviewFragment::class.java
                            ).addBundle(Bundle().apply {
                                putParcelable(
                                    Common.BundleKey.PLAN_DATA, bcpDetailsMainData?.plan_details
                                )
                                putParcelable(
                                    Common.BundleKey.PLAN_DURATION_DATA,
                                    durationList[chooseDurationV1Adapter.selectedPosition]
                                )
                            }).start()

                        }

                    } else {

                        if (session.user?.patient_plans?.any { it.plan_type == Common.MyTatvaPlanType.SUBSCRIPTION } == true) {

                            navigator.showAlertDialogWithOptions(getString(R.string.payment_plan_details_alert_msg_existing_plan_cancel),
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

                } else {
                    showAppMessage(
                        getString(R.string.validation_select_duration),
                        AppMsgStatus.ERROR
                    )
                }

            }

            R.id.buttonUpgrade -> {
                PaymentCarePlanListingFragment.IS_TO_SCROLL_TO_OTHER_PLAN = true
                navigator.goBack()
            }
        }
    }

    private fun showCancelAlert() {
        CancelPlanAlertDialog {
            cancelPatientPlan()
        }.show(
            requireActivity().supportFragmentManager, CancelPlanAlertDialog::class.java.simpleName
        )
    }

    private fun continuePurchaseFlow() {
        if (durationList[chooseDurationV1Adapter.selectedPosition].isFree) {
            // pass "Free" in transaction id for free plan purchase
            addPatientPlan("Free")
        } else {
            durationList[chooseDurationV1Adapter.selectedPosition].razorpay_plan_id?.let {
                createSubscriptions(it)
            }
        }
    }

    /**
     * startPaymentSubscription
     * method to initiate razorpay for subscription plan payment
     */
    private fun startPaymentSubscription(subscriptionId: String) {
        this.subscriptionId = subscriptionId

        Checkout.preload(requireActivity().applicationContext)
        //
        val co = Checkout()
        co.setKeyID(firebaseConfigUtil.getRazorPayKey())
        //co.setImage(R.mipmap.ic_launcher_foreground)

        try {
            val options = JSONObject()
            options.put(
                "name", durationList[chooseDurationV1Adapter.selectedPosition].duration_name
            )
            options.put(
                "description", durationList[chooseDurationV1Adapter.selectedPosition].duration_title
            )
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

    /**
     * *****************************************************
     * RazorPay callback methods
     * *****************************************************
     **/
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
        val apiRequest = ApiRequest().apply {
            plan_id = planMasterId

            if (isRentBuyEnabled) {
                duration_type = selectedIndividualPlanDurationType.key
            }

            patientPlanRelId?.let {// purchased plans
                patient_plan_rel_id = patientPlanRelId
            }
        }
        showLoader()
        patientPlansViewModel.plansDetailsById(apiRequest)
    }

    private fun addPatientPlan(paymentId: String?) {
        val apiRequest = ApiRequest().apply {
            plan_master_id = planMasterId
            plan_package_duration_rel_id =
                durationList[chooseDurationV1Adapter.selectedPosition].plan_package_duration_rel_id
            device_type = Session.DEVICE_TYPE
            purchase_amount = durationList[chooseDurationV1Adapter.selectedPosition].android_price
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
            patient_plan_rel_id = patientPlanRelId
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
        patientPlansViewModel.razorpaySubscription(apiRequest)
    }

    //
    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.getPatientDetails(apiRequest)
    }
//
//    private fun generateRazorpayOrderId(payableAmount: String) {
//        val apiRequest = ApiRequest().apply {
//            amount = payableAmount
//            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
//                dev = "true"
//            }
//        }
//        showLoader()
//        patientPlansViewModel.razorpayOrderId(apiRequest)
//    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        patientPlansViewModel.plansDetailsByIdLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            bcpDetailsMainData = responseBody.data
            if (isAdded) setPlanDetails()
        }, onError = { throwable ->
            hideLoader()
            if (isAdded) handleNoPlanData()
            false
        })

        patientPlansViewModel.addPatientPlanLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            //navigator.goBack()
            getPatientDetails()
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException) {
                throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                false
            } else {
                true
            }
        })

        patientPlansViewModel.cancelPatientPlanLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            //navigator.goBack()
            getPatientDetails()
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException) {
                throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                false
            } else {
                true
            }
        })

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
//
        authViewModel.getPatientDetailsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            //to update user data and go back
            navigator.goBack()
        }, onError = { throwable ->
            hideLoader()
            navigator.goBack()
            false
        })
//
//        patientPlansViewModel.razorpayOrderIdLiveData.observe(this,
//            onChange = { responseBody ->
//                hideLoader()
//                responseBody.data?.let { razorPayOrderId ->
//                    startPayment(razorPayOrderId)
//                }
//            },
//            onError = { throwable ->
//                hideLoader()
//                true
//            })
    }

    private fun handleNoPlanData() {
        durationList.clear()
        featureHeaderList.clear()
        featuresList.clear()
        setUpRecyclerView()
        with(binding) {
            TransitionManager.beginDelayedTransition(root)
            layoutFeatures.isVisible = featuresList.isNotEmpty()
            groupDurations.isVisible = durationList.isNotEmpty()
        }
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    private fun setPlanDetails() {
        bcpDetailsMainData?.let {
            // set plan details
            with(binding) {
                TransitionManager.beginDelayedTransition(root)

                layoutHeader.textViewToolbarTitle.text = it.plan_details?.plan_name

                groupRentBuy.isVisible = isRentBuyEnabled

                if (isRentBuyEnabled) {
                    val sbDeviceNames = StringBuilder()
                    it.plan_details?.devices?.forEach {
                        /*if (it.key!=Device.Spirometer.deviceKey) {
                            // to remove spirometer from label
                            sbDeviceNames.append(it.title).append(", ")
                        }*/
                        sbDeviceNames.append(it.title).append(", ")
                    }
                    textViewLabelRentBuy.text =
                        "Select to Rent/Buy ${sbDeviceNames.toString().trim().removeSuffix(",")}"
                }

                setUpWebView()

                // set durations and feature table recyclerViews
                durationList.clear()
                it.duration_details?.let { it1 -> durationList.addAll(it1) }
                featureHeaderList.clear()
                it.duration_details?.let { it1 -> featureHeaderList.addAll(it1) }
                featuresList.clear()
                it.data?.let { it1 -> featuresList.addAll(it1) }
                setUpRecyclerView()

                // update UI as per data
                layoutFeatures.isVisible = featuresList.isNotEmpty()
                groupDurations.isVisible = durationList.isNotEmpty()

                // setup action buttons as per purchased state and plan type
                it.plan_details?.let { planDetails ->
                    if (planDetails.plan_type == Common.MyTatvaPlanType.FREE) {
                        buttonUpgrade.visibility = View.VISIBLE
                        buttonBuyNow.visibility = View.GONE
                        buttonCancel.visibility = View.GONE
                        textViewLabelChooseDuration.visibility = View.GONE
                        recyclerViewDurations.visibility = View.GONE
                    } else {
                        buttonUpgrade.visibility = View.GONE
                        if (planDetails.isPlanPurchased) {
                            buttonBuyNow.visibility = View.GONE
                            if (planDetails.plan_type == Common.MyTatvaPlanType.INDIVIDUAL) {
                                buttonCancel.visibility = View.GONE
                            } else {
                                buttonCancel.visibility = View.VISIBLE
                            }
                        } else {
                            buttonBuyNow.visibility = View.VISIBLE
                            buttonCancel.visibility = View.GONE
                        }
                    }
                }

            }
        }
    }

    private fun setUpWebView() {
        with(binding) {
            if (bcpDetailsMainData?.plan_details?.description.isNullOrBlank().not()) {
                webView.visibility = View.VISIBLE

                /*webView.settings.builtInZoomControls = true
                webView.settings.displayZoomControls = false
                webView.settings.useWideViewPort = true
                webView.settings.loadWithOverviewMode = true*/

                webView.settings.builtInZoomControls = false
                webView.settings.displayZoomControls = false
                /*webView.settings.useWideViewPort = true
                webView.settings.loadWithOverviewMode = true*/

                bcpDetailsMainData?.plan_details?.description?.let {
                    val cleanHtml = it.replace("\\\"", "\"")
                    webView.loadDataWithBaseURL(
                        null, cleanHtml/*dummyWebData*/, "text/html", //; charset=utf-8
                        "UTF-8", null
                    )
                }

            } else {
                webView.visibility = View.GONE
            }
        }
    }

}