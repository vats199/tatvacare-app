package com.mytatva.patient.ui.labtest.fragment.v1

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
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
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpTestMainData
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.CommonLayoutLabtestBillingBinding
import com.mytatva.patient.databinding.LabtestFragmentCartV1Binding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.v1.BcpLabtestCartMainAdapter
import com.mytatva.patient.ui.labtest.adapter.v1.LabtestCartTestV1Adapter
import com.mytatva.patient.ui.labtest.fragment.LabTestListNormalFragment
import com.mytatva.patient.ui.labtest.fragment.PatientDetailsFragment
import com.mytatva.patient.ui.payment.dialog.CouponCodeAppliedDialog
import com.mytatva.patient.ui.payment.fragment.PaymentCouponCodeListFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable

class LabtestCartV1Fragment : BaseFragment<LabtestFragmentCartV1Binding>() {
    companion object {
        private var couponCodeData: CouponCodeData? = null
        private var checkCouponData: CheckCouponData? = null

        fun clearAppliedCouponCodeData() {
            couponCodeData = null
            checkCouponData = null
        }

        private var isNewTestAddedAfterCouponApplied = false
        fun updateFlagIfCouponCodeAppliedOnCartModified() {
            if (checkCouponData != null && couponCodeData != null) {
                isNewTestAddedAfterCouponApplied = true
            }
        }
    }

    var finalAmountToPay: Int = 0

    private var listBcpMain = ArrayList<BcpTestMainData>()
    private val bcpLabtestCartMainAdapter by lazy {
        BcpLabtestCartMainAdapter(listBcpMain, object : BcpLabtestCartMainAdapter.AdapterListener {
            override fun onItemClick(position: Int) {
                if (listBcpMain[position].is_bcp_tests_added == "Y") {
                    // remove this bcp tests from cart
                    listBcpMain[position].bcp_tests_list?.let {
                        removeFromCartBcp(it)
                    }
                } else {
                    // when select any checkbox then add that test to cart,
                    // other bcp tests will be removed from backend and unchecked
                    listBcpMain[position].bcp_tests_list?.let {
                        addToCart(it, listBcpMain[position].patient_plan_rel_id)
                    }
                }
            }
        })
    }

    private var listNormal = ArrayList<TestPackageData>()
    private val labtestCartTestNormalAdapter by lazy {
        LabtestCartTestV1Adapter(listNormal, true, adapterListener = object : LabtestCartTestV1Adapter.AdapterListener {
            override fun onClickRemove(position: Int) {

                navigator.showAlertDialogWithOptions(
                    getString(R.string.alert_msg_delete),
                    dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                        override fun onYesClick() {
                            listNormal[position].code?.let {
                                removeFromCart(
                                    it, listNormal[position].lab_test_id ?: ""
                                )
                            }
                        }

                        override fun onNoClick() {

                        }
                    })

            }
        })
    }


    private var listCartData: ListCartData? = null
    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this, viewModelFactory
        )[DoctorViewModel::class.java]
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this, viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentCartV1Binding {
        return LabtestFragmentCartV1Binding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LabtestCart)
        listCart()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
        updateDiscountUIAsPerFlags()
    }

    private fun updateDiscountUIAsPerFlags() {
        with(binding) {
            groupDiscountOffers.isVisible = AppFlagHandler.getIsToHideDiscountOnLabtest(firebaseConfigUtil).not()
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text = getString(R.string.labtest_cart_v1_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            //checkBoxBcpTest.setOnClickListener { onViewClick(it) }
            buttonSelectDateTime.setOnClickListener { onViewClick(it) }
            textViewAddTest.setOnClickListener { onViewClick(it) }
            layoutApplyForCoupon.setOnClickListener { onViewClick(it) }
            textViewRemove.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewAddTest -> {
                analytics.logEvent(
                    analytics.ADD_TEST, screenName = AnalyticsScreenNames.LabtestCart
                )

                navigator.loadActivity(
                    IsolatedFullActivity::class.java, LabTestListNormalFragment::class.java
                ).addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.IS_ALL, true)
                    )
                ).start()
            }

            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            /*R.id.checkBoxBcpTest -> {
                if (binding.checkBoxBcpTest.isChecked) {
                    addToCart()
                } else {
                    removeFromCartBcp()
                }
            }*/

            R.id.buttonSelectDateTime -> {
                val bcpTestMainData = listBcpMain.firstOrNull { it.is_bcp_tests_added == "Y" }
                if (bcpTestMainData != null) {
                    //new BCP book labtest flow go to directly select date & time slot
                    analytics.logEvent(
                        analytics.SELECT_DATE_TIME, screenName = AnalyticsScreenNames.LabtestCart
                    )

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, SelectLabtestAppointmentDateTimeFragmentV1::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                            //Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                            Pair(
                                Common.BundleKey.TEST_ADDRESS_DATA, bcpTestMainData.bcp_address_data
                            ),

                            Pair(Common.BundleKey.COUPON_CODE_DATA, couponCodeData),
                            Pair(Common.BundleKey.CHECK_COUPON_DATA, checkCouponData)

                        )
                    ).start()
                } else {
                    //old normal book labtest flow to select patient, without BCP tests
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PatientDetailsFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.LIST_CART_DATA, listCartData),

                            Pair(Common.BundleKey.COUPON_CODE_DATA, couponCodeData),
                            Pair(Common.BundleKey.CHECK_COUPON_DATA, checkCouponData)
                        )
                    ).start()
                }
            }

            R.id.layoutApplyForCoupon -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java, PaymentCouponCodeListFragment::class.java
                ).addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.IS_FROM_LAB_TEST, true), Pair(
                            Common.BundleKey.PAYABLE_AMOUNT, getTotalPayableAmount().toString()
                        )
                    )
                ).forResult(Common.RequestCode.REQUEST_COUPON_CODE).start()

                analytics.logEvent(
                    analytics.USER_TAPS_ON_APPLY_COUPON_CARD, Bundle().apply {
                        putString(analytics.PARAM_SERVICE_TYPE, "test")
                        putString(
                            analytics.PARAM_AMOUNT_BEFORE_DISCOUNT, finalAmountToPay.toString()
                        )
                    }, screenName = AnalyticsScreenNames.LabtestCart
                )
            }

            R.id.textViewRemove -> {
                analytics.logEvent(
                    analytics.USER_TAPS_ON_REMOVE, Bundle().apply {
                        putString(analytics.PARAM_DISCOUNT_CODE, couponCodeData?.discountCode)
                        putString(analytics.PARAM_SERVICE_TYPE, "test")
                    }, screenName = AnalyticsScreenNames.LabtestCart
                )

                clearAppliedCouponCodeData()
                handlePricingAndSetData()
            }
        }
    }

    /**
     * getTotalPayableAmount for discount coupon code
     */
    private fun getTotalPayableAmount(): Int {
        // get and pass total amount to pass for discount check with handling bcp test amount
        val bcpTestDataAddedInCart = listBcpMain.firstOrNull { it.is_bcp_tests_added == "Y" }
        var totalAmount = listCartData?.order_detail?.payable_amount?.toDoubleOrNull()?.toInt() ?: 0
        if (bcpTestDataAddedInCart != null && listNormal.isNotEmpty()) {
            // handle pricing - when BCP and normal both tests are added
            totalAmount -= (bcpTestDataAddedInCart.bcp_tests_list?.sumOf {
                it.discount_price?.toDoubleOrNull()?.toInt() ?: 0
            } ?: 0)
        } else if (bcpTestDataAddedInCart != null) {
            // handle pricing - when only BCP tests are added, no normal tests are there
            totalAmount = 0
        }
        return totalAmount
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if ((requestCode == Common.RequestCode.REQUEST_COUPON_CODE && data?.hasExtra(Common.BundleKey.CHECK_COUPON_DATA) == true) && data.hasExtra(
                Common.BundleKey.COUPON_CODE_DATA
            )
        ) {
            couponCodeData = data.parcelable(Common.BundleKey.COUPON_CODE_DATA)
            checkCouponData = data.parcelable(Common.BundleKey.CHECK_COUPON_DATA)
            requireActivity().supportFragmentManager.let {
                CouponCodeAppliedDialog().apply {
                    this.couponCodeData = LabtestCartV1Fragment.couponCodeData
                    this.checkCouponData = LabtestCartV1Fragment.checkCouponData
                }.show(it, CouponCodeAppliedDialog::class.java.simpleName)
            }
            handlePricingAndSetData()
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewBcpTests.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = bcpLabtestCartMainAdapter
        }

        binding.recyclerViewNormalTest.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = labtestCartTestNormalAdapter
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun listCart() {
        showLoader()
        doctorViewModel.listCart(ApiRequest())
    }

    private fun addToCart(listBcpTests: ArrayList<TestPackageData>, patientPlanRelId: String?) {
        val sbTestCodes = StringBuilder()
        listBcpTests.forEachIndexed { index, testPackageData ->
            sbTestCodes.append(testPackageData.code).append(",")
        }

        val apiRequest = ApiRequest().apply {
            code = sbTestCodes.toString().removeSuffix(",")
            bcp_flag = "Y"
            patient_plan_rel_id = patientPlanRelId
        }
        showLoader()
        doctorViewModel.addToCart(
            apiRequest, labTestId = "",// pass blank to ignore for event
            screenName = ""
        )
    }

    private fun removeFromCart(testCode: String, labTestId: String) {
        val apiRequest = ApiRequest().apply {
            code = testCode
        }
        showLoader()
        doctorViewModel.removeFromCart(
            apiRequest, labTestId, screenName = AnalyticsScreenNames.LabtestCart
        )
    }

    private fun removeFromCartBcp(listBcpTests: ArrayList<TestPackageData>) {
        val sbTestCodes = StringBuilder()
        listBcpTests.forEachIndexed { index, testPackageData ->
            sbTestCodes.append(testPackageData.code).append(",")
        }

        val apiRequest = ApiRequest().apply {
            code = sbTestCodes.toString().removeSuffix(",")
            bcp_flag = "Y"
        }

        showLoader()
        doctorViewModel.removeFromCart(
            apiRequest, labTestId = "",// pass blank to ignore for event
            screenName = ""
        )
    }

    private fun checkDiscountCouponCodeIfNewTestAdded(couponCodeData: CouponCodeData?) {
        couponCodeData?.let {
            val apiRequest = ApiRequest().apply {
                price = getTotalPayableAmount().toString()
                discounts_master_id = it.discountsMasterId
            }
            showLoader()
            patientPlansViewModel.checkDiscount(apiRequest)
        }
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //listCartLiveData
        doctorViewModel.listCartLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            with(binding) {
                nestedScrollView.isVisible = true
                //textViewNoData.isVisible = false
            }
            setCartDetails(responseBody.data)

            //if new test added and when coupon code is applied, call checkCouponCode API to again verify new price for coupon code
            if (isNewTestAddedAfterCouponApplied) {
                checkDiscountCouponCodeIfNewTestAdded(couponCodeData)
            }
        }, onError = { throwable ->
            hideLoader()
            with(binding) {
                nestedScrollView.isVisible = false
//                    textViewNoData.isVisible = true
//                    textViewNoData.text = throwable.message
            }
            navigator.goBack()
            false
        })

        //addToCartLiveData
        doctorViewModel.addToCartLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            listCart()
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException) {
                throwable.message?.let { showAppMessage(it, AppMsgStatus.ERROR) }
                false
            } else {
                true
            }
        })

        //removeFromCartLiveData
        doctorViewModel.removeFromCartLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            listCart()
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException) {
                throwable.message?.let { showAppMessage(it, AppMsgStatus.ERROR) }
                false
            } else {
                true
            }
        })


        patientPlansViewModel.checkDiscountLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            isNewTestAddedAfterCouponApplied = false
            val couponCodeData = responseBody.data?.discountCode
            // update coupon code data
            checkCouponData = responseBody.data
            LabtestCartV1Fragment.couponCodeData = couponCodeData
            handlePricingAndSetData()
        }, onError = { throwable ->
            hideLoader()
            isNewTestAddedAfterCouponApplied = false
            // if can not apply coupon code then clear coupon code data, and refresh cart
            clearAppliedCouponCodeData()
            listCart()
            if (throwable is ServerException) {
                throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                false
            } else {
                true
            }
        })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setCartDetails(listCartData: ListCartData?) {
        this.listCartData = listCartData
        with(binding) {
            listCartData?.let {
                listNormal.clear()
                listNormal.addAll(it.normalTestsList)
                labtestCartTestNormalAdapter.notifyDataSetChanged()

                listBcpMain.clear()
                it.bcp_tests_list?.let { it1 -> listBcpMain.addAll(it1) }
                bcpLabtestCartMainAdapter.notifyDataSetChanged()

                val bcpTestDataAddedInCart = listBcpMain.firstOrNull { it.is_bcp_tests_added == "Y" }
                if (bcpTestDataAddedInCart != null) {
                    layoutOrderSummary.isVisible = true
                    textViewLabelSummary.isVisible = true
                    textViewName.text = session.user?.name
                    textViewEmail.text = session.user?.email
                    textViewContact.text = session.user?.country_code.plus(" ").plus(session.user?.contact_no ?: "")
                    textViewPickupFromAddress.text = bcpTestDataAddedInCart.bcp_address_data?.addressLabel
                    buttonSelectDateTime.text = getString(R.string.labtest_cart_v1_button_select_date_time)
                } else {
                    layoutOrderSummary.isVisible = false
                    textViewLabelSummary.isVisible = false
                    buttonSelectDateTime.text = getString(R.string.labtest_cart_button_select_patient_details)
                }

                handlePricingAndSetData()
            }
        }
    }

    private fun handlePricingAndSetData() {
        with(binding) {
            listCartData?.let {

                val bcpTestDataAddedInCart = listBcpMain.firstOrNull { it.is_bcp_tests_added == "Y" }

                if (bcpTestDataAddedInCart == null && listNormal.isEmpty()) {
                    // when neither BCP no normal, any test is not added in cart,
                    // so cart is empty, hide billing details and button
                    layoutSelectDateTime.isVisible = false
                    textViewLabelBilling.isVisible = false
                    layoutBilling.isVisible = false/*groupCouponCode.isVisible = false*/

                    // show apply coupon UI on refresh when no any test is added in cart, neither BCP no any extra
                    binding.layoutApplyForCoupon.isVisible = true
                    binding.layoutAppliedCouponCode.isVisible = false

                } else {
                    layoutSelectDateTime.isVisible = true
                    textViewLabelBilling.isVisible = true
                    layoutBilling.isVisible = true/*groupCouponCode.isVisible = true*/

                    // set billing details start
                    var totalAmountOld = it.order_detail?.order_total?.toDoubleOrNull()?.toInt() ?: 0
                    var totalAmount = it.order_detail?.payable_amount?.toDoubleOrNull()?.toInt() ?: 0
                    var totalDiscountOnItem = totalAmountOld - totalAmount
                    var homeCollectionChargeOld = it.home_collection_charge?.ammount?.toDoubleOrNull()?.toInt() ?: 0
                    var homeCollectionCharge = it.home_collection_charge?.payable_ammount?.toDoubleOrNull()?.toInt() ?: 0
                    var serviceCharge = it.order_detail?.service_charge?.toDoubleOrNull()?.toInt() ?: 0

                    finalAmountToPay = it.order_detail?.final_payable_amount?.toDoubleOrNull()?.toInt() ?: 0

                    if (bcpTestDataAddedInCart != null && listNormal.isNotEmpty()) {
                        // handle pricing - when BCP and normal both tests are added
                        totalAmountOld -= (bcpTestDataAddedInCart.bcp_tests_list?.sumOf {
                            it.price?.toDoubleOrNull()?.toInt() ?: 0
                        } ?: 0)
                        totalAmount -= (bcpTestDataAddedInCart.bcp_tests_list?.sumOf {
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
                        textViewItemTotalNew.text =
                            getString(R.string.symbol_rupee).plus(totalAmount)
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
                    }*/

                    // set billing details end

                }
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
        couponCodeDiscountPrice: Int = 0,
    ) {
        with(layoutDiscountBilling) {

            if (totalAmountOld > 0) {
                textViewItemTotal.text = getString(R.string.symbol_rupee).plus(totalAmountOld)
            } else {
                textViewItemTotal.text = getString(R.string.labtest_cart_label_free)
            }

            if (homeCollectionCharge > 0) {
                textViewHomeCollectionCharge.text = getString(R.string.symbol_rupee).plus(homeCollectionCharge)
            } else {
                textViewHomeCollectionCharge.text = getString(R.string.labtest_cart_label_free)
            }

            if (serviceCharge > 0) {
                textViewServiceCharge.text = getString(R.string.symbol_rupee).plus(serviceCharge)
            } else {
                textViewServiceCharge.text = getString(R.string.labtest_cart_label_free)
            }

            // no need to show Free for totalDiscountOnItem
            textViewDiscountOnItems.text = "- ".plus(getString(R.string.symbol_rupee).plus(totalDiscountOnItem))

            // handle for coupon code logic
            if (checkCouponData != null && couponCodeData != null && couponCodeDiscountPrice > 0) {
                layoutAppliedCouponPrice.isVisible = true
                binding.layoutApplyForCoupon.isVisible = false
                binding.layoutAppliedCouponCode.isVisible = true

                binding.textViewCouponCodeName.text = "‘${couponCodeData?.discountCode}’ applied"
                textViewLabelAppliedCoupon.text = getString(
                    R.string.labtest_billing_label_applied_coupon, couponCodeData?.discountCode ?: ""
                )
                textViewAppliedCouponPrice.text = "- ".plus(getString(R.string.symbol_rupee).plus(couponCodeDiscountPrice))
            } else {
                layoutAppliedCouponPrice.isVisible = false
                binding.layoutApplyForCoupon.isVisible = true
                binding.layoutAppliedCouponCode.isVisible = false
            }

            if (finalAmountToPay > 0) {
                textViewAmountToBePaid.text = getString(R.string.symbol_rupee).plus(finalAmountToPay)
            } else {
                textViewAmountToBePaid.text = getString(R.string.labtest_cart_label_free)
            }

        }
    }
}