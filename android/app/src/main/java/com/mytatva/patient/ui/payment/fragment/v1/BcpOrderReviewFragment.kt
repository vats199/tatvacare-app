package com.mytatva.patient.ui.payment.fragment.v1

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpDuration
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.PaymentFragmentBcpOrderReviewBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.menu.dialog.HelpDialog
import com.mytatva.patient.ui.payment.dialog.CouponCodeAppliedDialog
import com.mytatva.patient.ui.payment.fragment.PaymentCouponCodeListFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable
import com.razorpay.Checkout
import org.json.JSONObject

class BcpOrderReviewFragment : BaseFragment<PaymentFragmentBcpOrderReviewBinding>() {
    private var couponCodeData: CouponCodeData? = null
    private var checkCouponData: CheckCouponData? = null
    private val bcpPlanData: BcpPlanData? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DATA)
    }

    private val bcpDuration: BcpDuration? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DURATION_DATA)
    }

    private val testAddressData: TestAddressData? by lazy {
        arguments?.parcelable(Common.BundleKey.TEST_ADDRESS_DATA)
    }

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

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentBcpOrderReviewBinding {
        return PaymentFragmentBcpOrderReviewBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpOrderReview)
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setDetails()
        updateDiscountUIAsPerFlags()
    }

    private fun updateDiscountUIAsPerFlags() {
        with(binding) {
            groupDiscountOffers.isVisible = AppFlagHandler.getIsToHideDiscountOnPlan(firebaseConfigUtil).not()
        }
    }

    private fun setDetails() {
        with(binding) {
            textViewCarePlanName.text = bcpPlanData?.plan_name
            textViewContentCarePlan.text =
                bcpDuration?.duration_title?.plus(" - ")?.plus(bcpDuration?.duration_name)

            textViewName.text = session.user?.name

            if (testAddressData == null) {
                groupBcpDetails.isVisible = false
            } else {
                groupBcpDetails.isVisible = true
                textViewPickupFromAddress.text = testAddressData?.addressLabel
                textViewEmail.text = session.user?.email ?: ""
                textViewContact.text =
                    session.user?.country_code?.plus(" ")?.plus(session.user?.contact_no ?: "")
            }

            //old UI logic before discount coupon changes
            /*if ((bcpDuration?.offerPrice?.toDoubleOrNull() ?: 0.0) > 0) {
                layoutActualPrice.isVisible = true
                layoutDiscountPrice.isVisible = true

                textViewActualPriceTotal.text =
                    getString(R.string.symbol_rupee).plus("").plus(bcpDuration?.offerPrice)
                textViewDiscountTotal.text = bcpDuration?.discountPercent.toString().plus("%")
            } else {
                layoutActualPrice.isVisible = false
                layoutDiscountPrice.isVisible = false
            }*/

            //new UI logic after discount coupon changes
            if ((bcpDuration?.offerPrice?.toDoubleOrNull() ?: 0.0) > 0) {
                layoutDiscountPrice.isVisible = true
                textViewActualPriceTotal.text =
                    getString(R.string.symbol_rupee).plus("").plus(bcpDuration?.offerPrice)
                textViewDiscountTotal.text =
                    "- ".plus(getString(R.string.symbol_rupee).plus(bcpDuration?.getDiscountAmount?.toString()))
                //bcpDuration?.discountPercent.toString().plus("%")
            } else {
                textViewActualPriceTotal.text =
                    getString(R.string.symbol_rupee).plus("").plus(bcpDuration?.androidPrice)
                layoutDiscountPrice.isVisible = false
            }


            if ((bcpDuration?.androidGstAmount ?: 0) > 0) {
                layoutGST.isVisible = true
                //textViewGSTTotal.text = bcpPlanData?.getGstPercentage.toString()
                textViewGSTTotal.text = getString(R.string.symbol_rupee)
                    .plus(bcpDuration?.androidGstAmount?.toString())
            } else {
                layoutGST.isVisible = false
            }


            val couponCodeDiscountPrice =
                checkCouponData?.discountAmount?.toDoubleOrNull()?.toInt() ?: 0
            if (checkCouponData != null && couponCodeData != null && couponCodeDiscountPrice > 0) {
                layoutAppliedCouponPrice.isVisible = true
                layoutApplyForCoupon.isVisible = false
                layoutAppliedCouponCode.isVisible = true

                textViewCouponCodeName.text = "‘${couponCodeData?.discountCode}’ applied"
                textViewLabelAppliedCoupon.text = getString(
                    R.string.labtest_billing_label_applied_coupon,
                    couponCodeData?.discountCode ?: ""
                )
                textViewAppliedCouponPrice.text =
                    "- ".plus(getString(R.string.symbol_rupee).plus(couponCodeDiscountPrice))

                // update couponCodeDiscountPrice in bcpDuration to handle androidFinalAmount
                bcpDuration?.couponCodeDiscountAmount = couponCodeDiscountPrice
            } else {
                layoutAppliedCouponPrice.isVisible = false
                layoutApplyForCoupon.isVisible = true
                layoutAppliedCouponCode.isVisible = false

                // reset couponCodeDiscountAmount to 0 when coupon code removed to handle androidFinalAmount
                bcpDuration?.couponCodeDiscountAmount = 0
            }

            //hidden
            /*textViewPurchasePriceTotal.text =
                getString(R.string.symbol_rupee).plus(bcpDuration?.androidPrice)*/
            textViewAmountPayable.text =
                getString(R.string.symbol_rupee).plus(bcpDuration?.androidFinalAmount)
            textViewTotalPayPrice.text =
                getString(R.string.symbol_rupee).plus(bcpDuration?.androidFinalAmount)
            textViewTotalPriceDuration.text = bcpDuration?.duration_name
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonProceedPayment.setOnClickListener { onViewClick(it) }
            layoutApplyForCoupon.setOnClickListener { onViewClick(it) }
            textViewRemove.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text = getString(R.string.payment_care_plan_order_review_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewHelp.visibility = View.VISIBLE
            imageViewHelp.setOnClickListener { onViewClick(it) }
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewHelp -> {
                analytics.logEvent(
                    analytics.TAP_CONTACT_US,
                    Bundle().apply {
                        putString(analytics.PARAM_PLAN_ID, bcpPlanData?.plan_master_id)
                    },
                    screenName = AnalyticsScreenNames.BcpOrderReview
                )
                requireActivity().supportFragmentManager.let {
                    HelpDialog().show(it, HelpDialog::class.java.simpleName)
                }
            }

            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.layoutApplyForCoupon -> {
                analytics.logEvent(
                    analytics.USER_TAPS_ON_APPLY_COUPON_CARD,
                    Bundle().apply {
                        putString(analytics.PARAM_SERVICE_TYPE, "plan")
                        putString(
                            analytics.PARAM_AMOUNT_BEFORE_DISCOUNT,
                            bcpDuration?.androidFinalAmount.toString()
                        )
                    },
                    screenName = AnalyticsScreenNames.BcpOrderReview
                )

                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    PaymentCouponCodeListFragment::class.java
                ).addBundle(
                    bundleOf(
                        Pair(
                            Common.BundleKey.PAYABLE_AMOUNT,
                            bcpDuration?.androidFinalAmount?.toString()
                        )
                    )
                ).forResult(Common.RequestCode.REQUEST_COUPON_CODE)
                    .start()

            }

            R.id.buttonProceedPayment -> {
                /*navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    BcpPaymentSuccessFragment::class.java
                ).start()*/
                analytics.logEvent(
                    analytics.TAP_PROCEED_TO_PAYMENT,
                    Bundle().apply {
                        /*putString(analytics.PARAM_PLAN_ID, bcpPlanData?.plan_master_id)
                        putString(analytics.PARAM_PLAN_VALUE, bcpDuration?.androidFinalAmount.toString())
                        putString(analytics.PARAM_PLAN_TYPE, bcpPlanData?.plan_type)*/
                        if (couponCodeData != null && couponCodeData?.discountCode.isNullOrBlank().not()) {
                            putString(analytics.PARAM_DISCOUNT_CODE, couponCodeData?.discountCode ?: "")
                            putString(analytics.PARAM_AMOUNT_AFTER_DISCOUNT, bcpDuration?.androidFinalAmount.toString())
                        }
                        putString(analytics.PARAM_AMOUNT_BEFORE_DISCOUNT, bcpDuration?.androidFinalAmountBeforeCouponDiscount.toString())
                        putString(analytics.PARAM_SERVICE_TYPE, "plan")
                        putString(analytics.PARAM_PLAN_DURATION, bcpDuration?.duration_title)
                    },
                    screenName = AnalyticsScreenNames.BcpOrderReview
                )

                bcpDuration?.androidFinalAmount?.let {
                    val priceToPurchase = it
                    if (priceToPurchase > 0) {
                        //startPayment(priceToPurchase)
                        generateRazorpayOrderId(priceToPurchase.toString())
                    }
                }
            }

            R.id.textViewRemove -> {
                analytics.logEvent(
                    analytics.USER_TAPS_ON_REMOVE,
                    Bundle().apply {
                        putString(analytics.PARAM_DISCOUNT_CODE, couponCodeData?.discountCode)
                        putString(analytics.PARAM_SERVICE_TYPE, "plan")
                    },
                    screenName = AnalyticsScreenNames.BcpOrderReview
                )

                couponCodeData = null
                checkCouponData = null
                setDetails()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if ((requestCode == Common.RequestCode.REQUEST_COUPON_CODE
                    && data?.hasExtra(Common.BundleKey.CHECK_COUPON_DATA) == true) && data.hasExtra(
                Common.BundleKey.COUPON_CODE_DATA
            )
        ) {
            couponCodeData = data.parcelable(Common.BundleKey.COUPON_CODE_DATA)
            checkCouponData = data.parcelable(Common.BundleKey.CHECK_COUPON_DATA)
            requireActivity().supportFragmentManager.let {
                CouponCodeAppliedDialog().apply {
                    this.couponCodeData = this@BcpOrderReviewFragment.couponCodeData
                    this.checkCouponData = this@BcpOrderReviewFragment.checkCouponData
                }.show(it, CouponCodeAppliedDialog::class.java.simpleName)
            }
            setDetails()
        }
    }

    /**
     * startPayment
     * method to initiate razorpay for individual(one time) plan payment
     */
    private fun startPayment(razorPayOrderId: String) {

        val offerPrice = bcpDuration?.androidFinalAmount!! //bcpDuration?.androidPrice!!

        Checkout.preload(requireActivity().applicationContext)
        //
        val co = Checkout()
        co.setKeyID(firebaseConfigUtil.getRazorPayKey())
        //co.setImage(R.mipmap.ic_launcher_foreground)

        try {
            val options = JSONObject()
            options.put("name", session.user?.name)
            options.put("description", bcpPlanData?.plan_name)
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

    private fun addPatientPlan(paymentId: String?) {
        val apiRequest = ApiRequest().apply {
            plan_master_id = bcpPlanData?.plan_master_id
            plan_package_duration_rel_id =
                bcpDuration?.plan_package_duration_rel_id
            device_type = Session.DEVICE_TYPE
            purchase_amount = bcpDuration?.androidFinalAmount?.toString()
            //subscription_id = subscriptionId
            transaction_id = paymentId

            // for BCP address flow pass address id
            patient_address_rel_id = testAddressData?.patient_address_rel_id

            if (checkCouponData != null) {
                //if coupon code is applied
                discount_amount = checkCouponData?.discountAmount
                discounts_master_id = checkCouponData?.discountCode?.discountsMasterId
                discount_type = checkCouponData?.discountCode?.discountType
            }

            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }
        }
        showLoader()
        patientPlansViewModel.addPatientPlan(apiRequest)
    }

    private fun getPatientDetails() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.getPatientDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //razorpayOrderIdLiveData
        patientPlansViewModel.razorpayOrderIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { razorPayOrderId ->
                    startPayment(razorPayOrderId)
                }
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException) {
                    throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })

        //addPatientPlanLiveData
        patientPlansViewModel.addPatientPlanLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //navigator.goBack()
                bcpPlanData?.patient_plan_rel_id = responseBody.data?.patient_plan_rel_id
                getPatientDetails()
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException) {
                    throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })

        //getPatientDetailsLiveData
        authViewModel.getPatientDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //to update user data and go back
                handleOnPurchase()
            },
            onError = { throwable ->
                hideLoader()
                handleOnPurchase()
                false
            })
    }

    private fun handleOnPurchase() {
        navigator.loadActivity(HomeActivity::class.java)
            .byFinishingAll().start()
        navigator.loadActivity(
            IsolatedFullActivity::class.java,
            BcpPaymentSuccessFragment::class.java
        ).addBundle(Bundle().apply {
            putParcelable(Common.BundleKey.PLAN_DATA, bcpPlanData)
        }).start()
    }

}