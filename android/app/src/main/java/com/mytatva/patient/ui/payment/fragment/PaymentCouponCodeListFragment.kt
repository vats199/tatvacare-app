package com.mytatva.patient.ui.payment.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.content.res.ResourcesCompat
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.databinding.PaymentFragmentCouponCodeListBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.PaymentCouponCodeListAdapter
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class PaymentCouponCodeListFragment : BaseFragment<PaymentFragmentCouponCodeListBinding>() {
    private val couponCodeList = arrayListOf<CouponCodeData>()
    private var checkCouponData: CheckCouponData? = null
    private val isFromLabTest: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_FROM_LAB_TEST) ?: false
    }
    private val payableAmount by lazy {
        arguments?.getString(Common.BundleKey.PAYABLE_AMOUNT)
    }

    private var currentClickPosition = -1

    private val paymentCouponCodeListAdapter by lazy {
        PaymentCouponCodeListAdapter(
            couponCodeList,
            payableAmount,
            object : PaymentCouponCodeListAdapter.AdapterListener {
                override fun onApplyClick(position: Int) {
                    analytics.logEvent(
                        analytics.APPLY_CLICK,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_DISCOUNT_CODE,
                                couponCodeList[position].discountCode
                            )
                            putString(analytics.PARAM_DESIGN_ELEMENT_TYPE, "discount_card")
                        },
                        screenName = AnalyticsScreenNames.CouponCodeList
                    )

                    currentClickPosition = position
                    checkDiscount(couponCodeList[position], false)
                }

                override fun onViewDetailsClick(position: Int, checked: Boolean) {
                    analytics.logEvent(
                        analytics.USER_TAPS_ON_DETAILS,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_DISCOUNT_CODE,
                                couponCodeList[position].discountCode
                            )
                            putString(analytics.PARAM_ACTION, if (checked) "view" else "hide")
                        },
                        screenName = AnalyticsScreenNames.CouponCodeList
                    )
                }
            })
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
        attachToRoot: Boolean
    ): PaymentFragmentCouponCodeListBinding {
        return PaymentFragmentCouponCodeListBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpToolbar()
        setViewListener()
        changeListener()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        discountList()
        analytics.setScreenName(AnalyticsScreenNames.CouponCodeList)
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.coupon_code_list_label_apply_coupon)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewToolbarCart.visibility = View.GONE
        }
    }

    private fun EditText.focusableSelectorBlackGray(textInputLayout: TextInputLayout) {
        textInputLayout.setHintTextAppearance(R.style.hintAppearance)
        this.onFocusChangeListener = View.OnFocusChangeListener { _, b ->
            if (!b && this.text.toString() != "") {
                this.isSelected = true
                textInputLayout.isSelected = true
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
            } else if (this.text.toString() == "") {
                this.isSelected = b
                textInputLayout.isSelected = b
            }
        }
        this.doOnTextChanged { text, _, _, _ ->
            if (text?.length!! > 0) {
                if (text.startsWith(".") || text.startsWith("'")) {
                    this.setText("")
                }
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
            } else {
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_regular)
            }
        }
    }

    private fun changeListener() = with(binding) {
        editTextCouponCode.focusableSelectorBlackGray(inputLayoutEnterCouponCode)
        editTextCouponCode.doOnTextChanged { text, _, _, _ ->
            textViewApply.isEnabled = text.isNullOrBlank() != true
            if (editTextCouponCode.text.toString().length == 10) {
                analytics.logEvent(
                    analytics.USER_ENTERS_CODE,
                    Bundle().apply {
                        putString(analytics.PARAM_DISCOUNT_CODE, editTextCouponCode.text.toString())
                    },
                    screenName = AnalyticsScreenNames.CouponCodeList
                )
            }
        }
    }

    private fun setViewListener() = with(binding) {
        textViewApply.setOnClickListener { onViewClick(it) }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.textViewApply -> {
                checkDiscount(null, true)

                analytics.logEvent(
                    analytics.APPLY_CLICK,
                    Bundle().apply {
                        putString(
                            analytics.PARAM_DISCOUNT_CODE,
                            binding.editTextCouponCode.text.toString()
                        )
                        putString(analytics.PARAM_DESIGN_ELEMENT_TYPE, "discount_textfield")
                    },
                    screenName = AnalyticsScreenNames.CouponCodeList
                )
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewCouponForYou.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = paymentCouponCodeListAdapter
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun discountList() {
        val apiRequest = ApiRequest().apply {
            if (isFromLabTest) {
                discount_type = "L"
            } else {
                discount_type = "P"
            }
            price = payableAmount
        }
        showLoader()
        patientPlansViewModel.discountList(apiRequest)
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun checkDiscount(couponCodeData: CouponCodeData?, isManual: Boolean) {
        val apiRequest = ApiRequest().apply {
            price = payableAmount
            if (isManual) {
                discount_code = binding.editTextCouponCode.text.toString().trim()
            } else {
                discounts_master_id = couponCodeData?.discountsMasterId
            }
        }
        showLoader()
        patientPlansViewModel.checkDiscount(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        patientPlansViewModel.discountListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                couponCodeList.clear()
                responseBody.data?.let { couponCodeList.addAll(it) }
                paymentCouponCodeListAdapter.notifyDataSetChanged()

                binding.textViewNoData.visibility = View.GONE
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException) {
                    binding.textViewNoData.visibility = View.VISIBLE
                    binding.textViewNoData.text = throwable.message
                    false
                } else {
                    throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                }
            })

        patientPlansViewModel.checkDiscountLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                val couponCodeData = if (currentClickPosition != -1) {
                    couponCodeList[currentClickPosition]
                } else {
                    responseBody.data?.discountCode
                }
                checkCouponData = responseBody.data
                val resultIntent = Intent()
                resultIntent.putExtra(Common.BundleKey.CHECK_COUPON_DATA, checkCouponData)
                resultIntent.putExtra(Common.BundleKey.COUPON_CODE_DATA, couponCodeData)
                requireActivity().setResult(Common.RequestCode.REQUEST_COUPON_CODE, resultIntent)
                requireActivity().finish()
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
}