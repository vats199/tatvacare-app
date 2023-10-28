package com.mytatva.patient.ui.labtest.fragment.v1

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.BcpTestMainData
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.CommonLayoutLabtestBillingBinding
import com.mytatva.patient.databinding.LabtestFragmentOrderReviewBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.labtest.adapter.v1.LabtestOrderReviewTestAdapter
import com.mytatva.patient.ui.labtest.fragment.LabtestAppointmentBookSuccessFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable
import com.mytatva.patient.utils.textdecorator.TextDecorator
import com.razorpay.Checkout
import org.json.JSONObject

class LabtestOrderReviewFragment : BaseFragment<LabtestFragmentOrderReviewBinding>() {

    private val listCartData: ListCartData? by lazy {
        arguments?.parcelable(Common.BundleKey.LIST_CART_DATA)
    }

    private val testPatientData: TestPatientData? by lazy {
        arguments?.parcelable(Common.BundleKey.TEST_PATIENT_DATA)
    }

    private val testAddressData: TestAddressData? by lazy {
        arguments?.parcelable(Common.BundleKey.TEST_ADDRESS_DATA)
    }

    private val testTimeSlotData: String? by lazy {
        arguments?.getString(Common.BundleKey.TIME_SLOT)
    }

    private val testTitleData: String? by lazy {
        arguments?.getString(Common.BundleKey.TITLE)
    }

    private val dateStr: String? by lazy {
        arguments?.getString(Common.BundleKey.DATE)
    }

    private val couponCodeData: CouponCodeData? by lazy {
        arguments?.parcelable(Common.BundleKey.COUPON_CODE_DATA)
    }

    private val checkCouponData: CheckCouponData? by lazy {
        arguments?.parcelable(Common.BundleKey.CHECK_COUPON_DATA)
    }

    private var addedTestList = ArrayList<TestPackageData>()
    private val labtestOrderReviewTestAdapter by lazy {
        LabtestOrderReviewTestAdapter(addedTestList)
    }


    private var totalAmountOld: Int = 0
    private var totalAmount: Int = 0
    private var totalDiscountOnItem = 0
    private var homeCollectionChargeOld: Int = 0
    private var homeCollectionCharge: Int = 0
    private var serviceCharge: Int = 0
    private var finalAmountToPay: Int = 0
    private var bcpTestDataAddedInCart: BcpTestMainData? = null

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentOrderReviewBinding {
        return LabtestFragmentOrderReviewBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
        setUpUI()
        setDetails()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BookLabtestAppointmentReview)
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setDetails() {
        with(binding) {

            if (testPatientData == null) {
                // when new BCP test booking flow, then test patient details will be null
                // so set self user details
                textViewPatientName.text = session.user?.name ?: ""
                textViewEmail.text = session.user?.email ?: ""
            } else {
                // old normal test booking flow
                testPatientData?.let {
                    textViewPatientName.text = it.name
                    textViewEmail.text = it.email
                    /*textViewAge.text = "Age : ${it.age}"
                    textViewGender.text = "Gender : ${it.gender}"*/
                }
            }

            testAddressData?.let {
                //textViewAddressType.text = it.address_type
                textViewPickupFromAddress.text = it.addressLabel
                textViewContact.text = "+91 ".plus(it.contact_no ?: "")
            }
            testTimeSlotData?.let {
                //textViewValueTime.text = it
                textViewSampleCollectionTime.text = "$testTitleData, $it"
            }
            dateStr?.let {
                /*textViewValueAppointmentDate.text =
                    DateTimeFormatter.date(it, DateTimeFormatter.FORMAT_yyyyMMdd)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_EEEEddMMMyyyy)*/
                textViewSampleCollectionDate.text =
                    DateTimeFormatter.date(it, DateTimeFormatter.FORMAT_yyyyMMdd)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_EEEEddMMMyyyy)
            }

            listCartData?.let {
                bcpTestDataAddedInCart =
                    it.bcp_tests_list?.firstOrNull { it.is_bcp_tests_added == "Y" }

                // add normal & BCP both tests in the test list
                addedTestList.clear()
                addedTestList.addAll(it.normalTestsList)
                bcpTestDataAddedInCart?.bcp_tests_list?.let { it1 -> addedTestList.addAll(it1) }
                labtestOrderReviewTestAdapter.notifyDataSetChanged()

                textViewLabelBilling.isVisible = true
                layoutBilling.isVisible = true

                // set billing details start
                totalAmountOld =
                    it.order_detail?.order_total?.toDoubleOrNull()?.toInt() ?: 0
                totalAmount =
                    it.order_detail?.payable_amount?.toDoubleOrNull()?.toInt() ?: 0
                totalDiscountOnItem = totalAmountOld - totalAmount
                homeCollectionChargeOld =
                    it.home_collection_charge?.ammount?.toDoubleOrNull()?.toInt() ?: 0
                homeCollectionCharge =
                    it.home_collection_charge?.payable_ammount?.toDoubleOrNull()?.toInt() ?: 0
                serviceCharge =
                    it.order_detail?.service_charge?.toDoubleOrNull()?.toInt() ?: 0
                finalAmountToPay =
                    it.order_detail?.final_payable_amount?.toDoubleOrNull()?.toInt() ?: 0

                if (bcpTestDataAddedInCart != null && it.normalTestsList.isNotEmpty()) {
                    // handle pricing - when BCP and normal both tests are added
                    totalAmountOld -= (bcpTestDataAddedInCart?.bcp_tests_list?.sumOf {
                        it.price?.toDoubleOrNull()?.toInt() ?: 0
                    } ?: 0)

                    totalAmount -= (bcpTestDataAddedInCart?.bcp_tests_list?.sumOf {
                        it.discount_price?.toDoubleOrNull()?.toInt() ?: 0
                    } ?: 0)
                    totalDiscountOnItem = totalAmountOld - totalAmount
                    homeCollectionChargeOld
                    homeCollectionCharge
                    serviceCharge

                    finalAmountToPay = (totalAmount + homeCollectionCharge + serviceCharge)
                } else if (bcpTestDataAddedInCart != null) {
                    // handle pricing - when only BCP tests are added, no normal tests are there
                    totalAmountOld = 0
                    totalAmount = 0
                    totalDiscountOnItem = 0
                    homeCollectionChargeOld = 0
                    homeCollectionCharge = 0
                    serviceCharge = 0
                    finalAmountToPay = 0
                }

                // handle for coupon code logic, and update final amount
                val couponCodeDiscountPrice = checkCouponData?.discountAmount?.toDoubleOrNull()?.toInt() ?: 0
                finalAmountToPay -= couponCodeDiscountPrice

                setPricingData(
                    binding.layoutDiscountBilling,
                    totalAmountOld,
                    totalAmount,
                    totalDiscountOnItem,
                    homeCollectionChargeOld,
                    homeCollectionCharge,
                    serviceCharge,
                    finalAmountToPay,
                    couponCodeDiscountPrice
                )


                /*if (totalAmount > 0) {
                    textViewItemTotalOld.text =
                        getString(R.string.symbol_rupee).plus(totalAmountOld)
                    textViewItemTotalNew.text = getString(R.string.symbol_rupee).plus(totalAmount)
                } else {
                    textViewItemTotalOld.isVisible = false
                    textViewItemTotalNew.text = getString(R.string.labtest_cart_label_free)
                }

                if (homeCollectionCharge > 0) {
                    textViewHomeCollectionChargeOld.text =
                        getString(R.string.symbol_rupee).plus(homeCollectionChargeOld)
                    textViewHomeCollectionChargeNew.text =
                        getString(R.string.symbol_rupee).plus(homeCollectionCharge)
                } else {
                    textViewHomeCollectionChargeOld.isVisible = false
                    textViewHomeCollectionChargeNew.text =
                        getString(R.string.labtest_cart_label_free)
                }

                if (serviceCharge > 0) {
                    textViewServiceCharge.text =
                        getString(R.string.symbol_rupee).plus(serviceCharge)
                } else {
                    textViewServiceCharge.text = getString(R.string.labtest_cart_label_free)
                }

                if (finalAmountToPay > 0) {
                    textViewAmountPayable.text =
                        getString(R.string.symbol_rupee).plus(finalAmountToPay)
                } else {
                    textViewAmountPayable.text = getString(R.string.labtest_cart_label_free)
                }

                if (finalAmountToPay > 0) {
                    textViewTotalPayPrice.text =getString(R.string.symbol_rupee).plus(finalAmountToPay)
                    buttonBook.text = getString(R.string.payment_care_plan_order_review_button_proceed_payment)
                } else {
                    textViewTotalPayPrice.text = getString(R.string.labtest_cart_label_free)
                    buttonBook.text = getString(R.string.patient_details_button_confirm)
                }*/
                // set billing details end


            }

        }
    }

    private fun setPricingData(
        layoutDiscountBilling: CommonLayoutLabtestBillingBinding,
        totalAmountOld: Int,
        totalAmount: Int,
        totalDiscountOnItem: Int,
        homeCollectionChargeOld: Int,
        homeCollectionCharge: Int,
        serviceCharge: Int,
        finalAmountToPay: Int,
        couponCodeDiscountPrice: Int = 0
    ) {
        with(layoutDiscountBilling) {

            if (totalAmountOld > 0) {
                textViewItemTotal.text =
                    getString(R.string.symbol_rupee).plus(totalAmountOld)
            } else {
                textViewItemTotal.text = getString(R.string.labtest_cart_label_free)
            }

            if (homeCollectionCharge > 0) {
                textViewHomeCollectionCharge.text =
                    getString(R.string.symbol_rupee).plus(homeCollectionCharge)
            } else {
                textViewHomeCollectionCharge.text = getString(R.string.labtest_cart_label_free)
            }

            if (serviceCharge > 0) {
                textViewServiceCharge.text =
                    getString(R.string.symbol_rupee).plus(serviceCharge)
            } else {
                textViewServiceCharge.text = getString(R.string.labtest_cart_label_free)
            }

            if (totalDiscountOnItem > 0) {
                textViewDiscountOnItems.text =
                    "- ".plus(getString(R.string.symbol_rupee).plus(totalDiscountOnItem))
            } else {
                textViewDiscountOnItems.text = getString(R.string.labtest_cart_label_free)
            }

            // handle for coupon code logic
            if (checkCouponData != null && couponCodeData != null && couponCodeDiscountPrice > 0) {
                layoutAppliedCouponPrice.isVisible = true
                binding.groupCouponCode.isVisible = true

                binding.textViewCouponCodeName.text="‘${couponCodeData?.discountCode}’ applied"
                textViewLabelAppliedCoupon.text = getString(
                    R.string.labtest_billing_label_applied_coupon,
                    couponCodeData?.discountCode ?: ""
                )
                textViewAppliedCouponPrice.text =
                    "- ".plus(getString(R.string.symbol_rupee).plus(couponCodeDiscountPrice))
            } else {
                layoutAppliedCouponPrice.isVisible = false
                binding.groupCouponCode.isVisible = false
            }

            if (finalAmountToPay > 0) {
                textViewAmountToBePaid.text =
                    getString(R.string.symbol_rupee).plus(finalAmountToPay)
                binding.textViewTotalPayPrice.text =getString(R.string.symbol_rupee).plus(finalAmountToPay)
                binding.buttonBook.text = getString(R.string.payment_care_plan_order_review_button_proceed_payment)
            } else {
                textViewAmountToBePaid.text = getString(R.string.labtest_cart_label_free)
                binding.textViewTotalPayPrice.text = getString(R.string.labtest_cart_label_free)
                binding.buttonBook.text = getString(R.string.patient_details_button_confirm)
            }

        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text = getString(R.string.labtest_order_review_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonBook.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonBook -> {
                analytics.logEvent(
                    analytics.TAP_BOOK_LAB_TEST,
                    screenName = AnalyticsScreenNames.BookLabtestAppointmentReview
                )

                analytics.logEvent(
                    analytics.TAP_PROCEED_TO_PAYMENT,
                    Bundle().apply {
                        if(couponCodeData!=null && couponCodeData?.discountCode.isNullOrBlank().not()) {
                            val couponCodeDiscountPrice = checkCouponData?.discountAmount?.toDoubleOrNull()?.toInt() ?: 0
                            val amountBeforeDiscount = finalAmountToPay + couponCodeDiscountPrice
                            putString(analytics.PARAM_DISCOUNT_CODE, couponCodeData?.discountCode?:"")
                            putString(analytics.PARAM_AMOUNT_BEFORE_DISCOUNT, amountBeforeDiscount.toString())
                            putString(analytics.PARAM_AMOUNT_AFTER_DISCOUNT, finalAmountToPay.toString())
                        } else {
                            putString(analytics.PARAM_AMOUNT_BEFORE_DISCOUNT, finalAmountToPay.toString())
                        }
                        putString(analytics.PARAM_SERVICE_TYPE,"test")
                    },
                    screenName = AnalyticsScreenNames.BookLabtestAppointmentReview
                )

                if (binding.checkBoxAgreeTerms.isChecked.not()) {
                    showAppMessage(getString(R.string.common_validation_agree_terms), AppMsgStatus.ERROR)
                } else {
                    checkBookTest()
                }
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewTestDetails.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = labtestOrderReviewTestAdapter
        }
    }

    private fun setUpUI() {
        TextDecorator.decorate(binding.checkBoxAgreeTerms, "I agree to the Terms & Conditions")
            .makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.textGray6), View.OnClickListener {

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        WebViewCommonFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.TITLE, "Terms & Conditions"),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.THYROCARE_TERMS_SERVICE)
                        )
                    ).start()

                }, true, "Terms & Conditions"
            ).build()


        /*TextDecorator.decorate(
            binding.checkBoxAgreeTerms,
            "I agree to the Terms & Conditions"
        ).makeTextClickableWithSecondaryColor(
            requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                //binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    WebViewCommonFragment::class.java
                ).addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.TITLE, "Terms & Conditions"),
                        Pair(Common.BundleKey.URL, URLFactory.AppUrls.THYROCARE_TERMS_SERVICE)
                    )
                ).start()
            }, false, "Terms & Conditions"
        ).build()*/
    }

    /**
     * start razorpay payment
     */
    private fun startPayment(offerPrice: Int, razorPayOrderId: String) {
        Checkout.preload(requireActivity().applicationContext)
        //
        val co = Checkout()
        co.setKeyID(firebaseConfigUtil.getRazorPayKey())/*getString(R.string.razorpay_key_id_test)*/
        //co.setImage(R.mipmap.ic_launcher_foreground)

        try {
            val options = JSONObject()
            options.put("name", testPatientData?.name ?: "")
            options.put("description", "Lab test order")
            //options.put("image", "https://s3.amazonaws.com/rzp-mobile/images/rzp.png")
            //options.put("theme.color", "#3399cc")
            options.put("order_id", razorPayOrderId)//from response of step 3.
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
        //addPatientPlan(paymentId)

        paymentId?.let {
            analytics.logEvent(analytics.LABTEST_ORDER_PAYMENT_SUCCESS, Bundle().apply {
                putString(analytics.PARAM_TRANSACTION_ID, it)
            }, screenName = AnalyticsScreenNames.BookLabtestAppointmentReview)
            bookTest(it)
        }
    }

    fun onPaymentError(code: Int, error: String?) {
        Log.d("RazorPay", "onPaymentError: $code :: $error")
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun bookTest(razorPayPaymentId: String) {
        val apiRequest = ApiRequest().apply {
            appointment_date = dateStr
            slot_time = testTimeSlotData
            address_id = testAddressData?.patient_address_rel_id
            order_total = listCartData?.order_detail?.order_total
            payable_amount = listCartData?.order_detail?.payable_amount
            final_payable_amount = finalAmountToPay.toString() //listCartData?.order_detail?.final_payable_amount
            service_charge = listCartData?.order_detail?.service_charge
            home_collection_charge = listCartData?.home_collection_charge?.payable_ammount

            // will be null for only BCP(free) test booking - member_id,transaction_id
            member_id = testPatientData?.patient_member_rel_id
            transaction_id = razorPayPaymentId

            //when bcp test is there in the cart,
            //pass flag and patient_plan_rel_id(BCP plan)
            if (bcpTestDataAddedInCart != null) {
                bcp_flag = "Y"
                patient_plan_rel_id = bcpTestDataAddedInCart?.patient_plan_rel_id

                bcp_test_price_data = ApiRequestSubData().apply {
                    bcp_total_amount_old = totalAmountOld.toString()
                    bcp_total_amount = totalAmount.toString()
                    bcp_home_collection_charge_old = homeCollectionChargeOld.toString()
                    bcp_home_collection_charge = homeCollectionCharge.toString()
                    bcp_service_charge = serviceCharge.toString()
                    bcp_final_amount_to_pay = finalAmountToPay.toString()
                }
            }

            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }

            if (checkCouponData != null) {
                //if coupon code is applied
                discount_amount = checkCouponData?.discountAmount
                discounts_master_id = checkCouponData?.discountCode?.discountsMasterId
                discount_type = checkCouponData?.discountCode?.discountType
            }
        }
        showLoader()
        doctorViewModel.bookTest(apiRequest)
    }

    private fun checkBookTest() {
        val apiRequest = ApiRequest().apply {
            //pass amount to create order from razorpay
            final_payable_amount =
                finalAmountToPay.toString() //listCartData?.order_detail?.final_payable_amount
            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }
        }
        showLoader()
        doctorViewModel.checkBookTest(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //bookTestLiveData
        doctorViewModel.bookTestLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.LABTEST_ORDER_BOOK_SUCCESS, Bundle().apply {
                    putString(analytics.PARAM_ORDER_MASTER_ID, responseBody.data?.order_master_id)
                }, screenName = AnalyticsScreenNames.BookLabtestAppointmentReview)
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    LabtestAppointmentBookSuccessFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                            Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                            Pair(Common.BundleKey.TEST_ADDRESS_DATA, testAddressData),
                            Pair(Common.BundleKey.DATE, dateStr),
                            Pair(Common.BundleKey.TIME_SLOT, testTimeSlotData),
                            Pair(
                                Common.BundleKey.ORDER_MASTER_ID,
                                responseBody.data?.order_master_id
                            ),
                            Pair(Common.BundleKey.FINAL_AMOUNT_TO_PAY, finalAmountToPay)
                        )
                    ).byFinishingAll().start()
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

        //checkBookTestLiveData
        doctorViewModel.checkBookTestLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                if (finalAmountToPay > 0) {
                    // initiate flow to start payment
                    responseBody.data?.let { razorPayOrderId ->
                        onCheckBookTestSuccess(razorPayOrderId)
                    }

                } else {
                    // book without razorpay payment id, for booking of only BCP(free) tests
                    // pass blank empty string as payment id
                    bookTest("")
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
    }

    private fun onCheckBookTestSuccess(razorPayOrderId: String) {
        //initiate payment flow on check book test success
        listCartData?.order_detail?.final_payable_amount?.toDoubleOrNull()?.let {
            val priceToPurchase = it.toInt()
            if (priceToPurchase > 0) {
                startPayment(priceToPurchase, razorPayOrderId)
            }
        }
    }

}