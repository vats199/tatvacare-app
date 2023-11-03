package com.mytatva.patient.ui.labtest.fragment

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
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.LabtestFragmentBookAppointmentReviewBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.labtest.adapter.ReviewCartItemsAdapter
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.textdecorator.TextDecorator
import com.razorpay.Checkout
import org.json.JSONObject


class BookAppointmentReviewFragment : BaseFragment<LabtestFragmentBookAppointmentReviewBinding>() {

    //var resumedTime = Calendar.getInstance().timeInMillis

    private val addedTestList = arrayListOf<TestPackageData>()

    private val listCartData: ListCartData? by lazy {
        arguments?.getParcelable(Common.BundleKey.LIST_CART_DATA)
    }

    private val testPatientData: TestPatientData? by lazy {
        arguments?.getParcelable(Common.BundleKey.TEST_PATIENT_DATA)
    }

    private val testAddressData: TestAddressData? by lazy {
        arguments?.getParcelable(Common.BundleKey.TEST_ADDRESS_DATA)
    }

    private val testTimeSlotData: String? by lazy {
        arguments?.getString(Common.BundleKey.TIME_SLOT)
    }

    private val dateStr: String? by lazy {
        arguments?.getString(Common.BundleKey.DATE)
    }

    private val reviewCartItemsAdapter by lazy {
        ReviewCartItemsAdapter(addedTestList)
    }


    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentBookAppointmentReviewBinding {
        return LabtestFragmentBookAppointmentReviewBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BookLabtestAppointmentReview)
        //resumedTime = Calendar.getInstance().timeInMillis

        analytics.logEvent(analytics.USER_OPEN_LABTEST_ORDER_REVIEW, Bundle().apply {
            putString(analytics.PARAM_APPOINTMENT_DATE, dateStr)
            putString(analytics.PARAM_SLOT_TIME, testTimeSlotData)
            putString(analytics.PARAM_MEMBER_ID, testPatientData?.patient_member_rel_id)
            putString(analytics.PARAM_ADDRESS_ID, testAddressData?.patient_address_rel_id)
        }, screenName = AnalyticsScreenNames.BookLabtestAppointmentReview)
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setDetails()
        setUpUI()
    }

    private fun setUpUI() {
        //"I agree to the terms of services, terms of use & cancellation"
        /* TextDecorator.decorate(binding.checkBoxAgreeTerms,
             "I agree to the terms and conditions and cancellation policy")
             .makeTextClickableWithSecondaryColor(
                 requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                     //binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked

                     //requireActivity().openBrowser(URLFactory.AppUrls.TERMS_CONDITIONS)
                     navigator.loadActivity(IsolatedFullActivity::class.java,
                         WebViewCommonFragment::class.java)
                         .addBundle(bundleOf(
                             Pair(Common.BundleKey.TITLE, ""),
                             Pair(Common.BundleKey.URL, URLFactory.AppUrls.THYROCARE_TERMS_SERVICE)))
                         .start()

                 }, false, "terms and conditions"
             ).makeTextClickableWithSecondaryColor(
                 requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                     //binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked

                     //requireActivity().openBrowser(URLFactory.AppUrls.PRIVACY_POLICY)
                     navigator.loadActivity(IsolatedFullActivity::class.java,
                         WebViewCommonFragment::class.java)
                         .addBundle(bundleOf(
                             Pair(Common.BundleKey.TITLE, ""),
                             Pair(Common.BundleKey.URL, URLFactory.AppUrls.THYROCARE_CANCELLATION)))
                         .start()

                 }, false, "cancellation policy"
             ).build()*/

        TextDecorator.decorate(binding.checkBoxAgreeTerms,
            "I agree to the terms and conditions")
            .makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                    //binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked

                    //requireActivity().openBrowser(URLFactory.AppUrls.TERMS_CONDITIONS)
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        WebViewCommonFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.TITLE, "Terms & Conditions"),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.THYROCARE_TERMS_SERVICE)))
                        .start()

                }, false, "terms and conditions"
            ).build()
    }

    private fun setDetails() {
        with(binding) {
            listCartData?.let {
                textViewLabName.text = it.lab?.name
                textViewLabLocation.text = it.lab?.address
                textViewItemTotalOld.text =
                    getString(R.string.symbol_rupee).plus(it.order_detail?.order_total ?: "0")
                textViewItemTotalNew.text =
                    getString(R.string.symbol_rupee).plus(it.order_detail?.payable_amount ?: "0")

                textViewHomeCollectionChargeOld.text =
                    getString(R.string.symbol_rupee).plus(it.home_collection_charge?.ammount ?: "0")
                if (it.home_collection_charge?.payable_ammount?.toIntOrNull() ?: 0 > 0) {
                    textViewHomeCollectionChargeNew.text =
                        getString(R.string.symbol_rupee).plus(it.home_collection_charge?.payable_ammount
                            ?: "0")
                    textViewLabelFreeHomeSamplePickup.isVisible = false
                } else {
                    textViewHomeCollectionChargeNew.text = "FREE"
                    textViewLabelFreeHomeSamplePickup.isVisible = false
                }

                textViewOrderTotal.text =
                    getString(R.string.symbol_rupee).plus(it.order_detail?.final_payable_amount
                        ?: "0")
                textViewAmountPayable.text =
                    getString(R.string.symbol_rupee).plus(it.order_detail?.final_payable_amount
                        ?: "0")
                textViewServiceCharge.text =
                    getString(R.string.symbol_rupee).plus(it.order_detail?.service_charge
                        ?: "0")

                //items
                addedTestList.clear()
                it.tests_list?.let { list -> addedTestList.addAll(list) }
                recyclerViewCartItems.apply {
                    layoutManager =
                        LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                    adapter = reviewCartItemsAdapter
                }
                textViewLabelItems.text = "${addedTestList.size} items"
            }
            testPatientData?.let {
                textViewName.text = it.name
                textViewEmail.text = it.email
                textViewAge.text = "Age : ${it.age}"
                textViewGender.text = "Gender : ${it.gender}"
            }
            testAddressData?.let {
                textViewAddressType.text = it.address_type
                textViewPickupFromAddress.text = it.addressLabelInReview
            }
            testTimeSlotData?.let {
                textViewAppointmentTime.text = it
            }
            dateStr?.let {
                textViewAppointmentDate.text =
                    DateTimeFormatter.date(it, DateTimeFormatter.FORMAT_yyyyMMdd)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSelectPaymentMethod.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_appointment_review_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSelectPaymentMethod -> {
                if (binding.checkBoxAgreeTerms.isChecked.not()) {
                    showMessage(getString(R.string.common_validation_agree_terms))
                } else {
                    checkBookTest()
                }
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    /**
     *
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
            member_id = testPatientData?.patient_member_rel_id
            order_total = listCartData?.order_detail?.order_total
            payable_amount = listCartData?.order_detail?.payable_amount
            final_payable_amount = listCartData?.order_detail?.final_payable_amount
            service_charge = listCartData?.order_detail?.service_charge
            home_collection_charge = listCartData?.home_collection_charge?.payable_ammount
            transaction_id = razorPayPaymentId

            if (MyTatvaApp.IS_RAZORPAY_LIVE.not()) {
                dev = "true"
            }
        }
        showLoader()
        doctorViewModel.bookTest(apiRequest)
    }

    private fun checkBookTest() {
        val apiRequest = ApiRequest().apply {
            //pass amount to create order from razorpay
            final_payable_amount = listCartData?.order_detail?.final_payable_amount
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
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabtestAppointmentBookSuccessFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                        Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                        Pair(Common.BundleKey.TEST_ADDRESS_DATA, testAddressData),
                        Pair(Common.BundleKey.DATE, dateStr),
                        Pair(Common.BundleKey.TIME_SLOT, testTimeSlotData),
                        Pair(Common.BundleKey.ORDER_MASTER_ID, responseBody.data?.order_master_id)
                    )).byFinishingAll().start()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //checkBookTestLiveData
        doctorViewModel.checkBookTestLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { razorPayOrderId ->
                    onCheckBookTestSuccess(razorPayOrderId)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
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

    override fun onPause() {
        super.onPause()
        //updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        /*val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_MY_DEVICES, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        })*/
    }
}