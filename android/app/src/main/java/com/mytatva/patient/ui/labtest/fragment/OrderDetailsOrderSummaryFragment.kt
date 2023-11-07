package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.transition.TransitionManager
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.OrderStatusData
import com.mytatva.patient.data.pojo.response.TestOrderSummaryResData
import com.mytatva.patient.databinding.LabtestFragmentOrderDetailOrderSummaryBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.TrackOrderStatusAdapter
import com.mytatva.patient.ui.labtest.bottomsheet.ContactSupportBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter


class OrderDetailsOrderSummaryFragment :
    BaseFragment<LabtestFragmentOrderDetailOrderSummaryBinding>() {

    var callbackToNext: () -> Unit = {}

    private var orderSummaryResData: TestOrderSummaryResData? = null

    private val trackOrderList = arrayListOf<OrderStatusData>()
    private val trackOrderStatusAdapter by lazy {
        TrackOrderStatusAdapter(trackOrderList)
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentOrderDetailOrderSummaryBinding {
        return LabtestFragmentOrderDetailOrderSummaryBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setViewListeners()
        setUpViewRecyclerView()
    }

    private fun setUpViewRecyclerView() {
        with(binding) {
            recyclerViewTrackOrderStatus.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = trackOrderStatusAdapter
            }
        }
    }

    private fun setViewListeners() {
        with(binding) {
            buttonContactSupport.setOnClickListener { onViewClick(it) }
            layoutStatus.setOnClickListener { onViewClick(it) }
            textViewItemCount.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewItemCount -> {
                callbackToNext.invoke()
            }

            R.id.buttonContactSupport -> {
                orderSummaryResData?.order_master_id?.let {
                    ContactSupportBottomSheetDialog(it) { message ->
                        showMessage(message)
                    }.show(
                        requireActivity().supportFragmentManager,
                        ContactSupportBottomSheetDialog::class.java.simpleName
                    )
                }
            }

            R.id.layoutStatus -> {
                with(binding) {
                    TransitionManager.beginDelayedTransition(root)
                    if (recyclerViewTrackOrderStatus.isVisible) {
                        recyclerViewTrackOrderStatus.isVisible = false
                        imageViewDropDown.rotation = 0F
                    } else {
                        recyclerViewTrackOrderStatus.isVisible = true
                        imageViewDropDown.rotation = 180F
                    }
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setDetails(orderSummaryResData: TestOrderSummaryResData?) {
        this.orderSummaryResData = orderSummaryResData

        with(binding) {
            orderSummaryResData?.let {
                textViewPatientName.text = it.member?.name
                textViewOrderNo.text = it.ref_order_id

                tetViewAppointmentDate.text =
                    DateTimeFormatter.date(it.appointment_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_EEEddMMMyyyy)
                textViewTime.text = it.slot_time

                if (it.service_date_time.isNullOrBlank().not()) {
                    groupServiceDateTime.isVisible = true
                    textViewServicedDateTime.text = try {
                        DateTimeFormatter.date(
                            it.service_date_time,
                            DateTimeFormatter.FORMAT_ddMMyyyy_HHmm
                        )
                            .formatDateToLocalTimeZoneDisplay("dd MMM, yyyy hh:mm a")
                    } catch (e: Exception) {
                        ""
                    }
                } else {
                    groupServiceDateTime.isVisible = false
                }

                //textViewStatus.text = ""

                textViewAddressType.text = it.address?.address_type
                textViewPickupFromAddress.text =
                    it.address?.addressLabelInDetails(it.member?.email ?: "")

                textViewLabLocation.text = it.lab?.address
                textViewLabName.text = it.lab?.name

                textViewItemCount.text = "${it.total_items} Items"

                if (it.bcp_test_price_data?.bcp_final_amount_to_pay.isNullOrBlank().not()) {
                    //set pricing as per BCP
                    it.bcp_test_price_data?.let { bcpTestPriceData ->
                        if (bcpTestPriceData.bcpTotalAmountOld > 0) {
                            textViewTotalAmount.text = getString(R.string.symbol_rupee)
                                .plus(bcpTestPriceData.bcpTotalAmountOld)
                        } else {
                            textViewTotalAmount.text = getString(R.string.labtest_cart_label_free)
                        }

                        if (bcpTestPriceData.bcpTotalAmount > 0) {
                            textViewAmountPayable.text = getString(R.string.symbol_rupee)
                                .plus(bcpTestPriceData.bcpTotalAmount)
                        } else {
                            textViewAmountPayable.text = getString(R.string.labtest_cart_label_free)
                        }

                        if (bcpTestPriceData.bcpHomeCollectionCharge > 0) {
                            textViewHomeCollectionCharges.text = getString(R.string.symbol_rupee)
                                .plus(bcpTestPriceData.bcpHomeCollectionCharge)
                        } else {
                            textViewHomeCollectionCharges.text =
                                getString(R.string.labtest_cart_label_free)
                        }

                        if (bcpTestPriceData.bcpServiceCharge > 0) {
                            textViewServiceCharge.text = getString(R.string.symbol_rupee)
                                .plus(bcpTestPriceData.bcpServiceCharge)
                        } else {
                            textViewServiceCharge.text = getString(R.string.labtest_cart_label_free)
                        }

                        if (bcpTestPriceData.bcpFinalAmountToPay > 0) {
                            textViewAmountToPaid.text = getString(R.string.symbol_rupee)
                                .plus(bcpTestPriceData.bcpFinalAmountToPay)
                        } else {
                            textViewAmountToPaid.text = getString(R.string.labtest_cart_label_free)
                        }

                    }
                } else {
                    //normal
                    textViewTotalAmount.text = getString(R.string.symbol_rupee)
                        .plus(it.order_total)
                    textViewAmountPayable.text = getString(R.string.symbol_rupee)
                        .plus(it.payable_amount)
                    if ((it.home_collection_charge?.toDoubleOrNull()?.toInt() ?: 0) > 0) {
                        textViewHomeCollectionCharges.text = getString(R.string.symbol_rupee)
                            .plus(it.home_collection_charge)
                    } else {
                        textViewHomeCollectionCharges.text =
                            getString(R.string.labtest_cart_label_free)
                    }

                    if ((it.service_charge?.toDoubleOrNull()?.toInt() ?: 0) > 0) {
                        textViewServiceCharge.text = getString(R.string.symbol_rupee)
                            .plus(it.service_charge)
                    } else {
                        textViewServiceCharge.text = getString(R.string.labtest_cart_label_free)
                    }

                    textViewAmountToPaid.text = getString(R.string.symbol_rupee)
                        .plus(it.final_payable_amount)
                }

                // coupon code discount
                if (it.coupon_code.isNullOrBlank().not() && it.coupon_discount.isNullOrBlank().not()) {
                    layoutAppliedCouponPrice.isVisible = true
                    textViewLabelAppliedCoupon.text = getString(R.string.labtest_billing_label_applied_coupon, it.coupon_code?:"")
                    textViewAppliedCouponPrice.text = "- ".plus(getString(R.string.symbol_rupee).plus(it.coupon_discount?.toDoubleOrNull()?.toInt()?:""))
                } else {
                    layoutAppliedCouponPrice.isVisible = false
                }

                textViewStatus.text = it.order_status ?: ""
                trackOrderList.clear()
                it.order_status_data?.let { it1 -> trackOrderList.addAll(it1) }
                trackOrderStatusAdapter.notifyDataSetChanged()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {

    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}