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
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.OrderSummaryItemData
import com.mytatva.patient.data.pojo.response.TestOrderSummaryResData
import com.mytatva.patient.databinding.LabtestFragmentOrderDetailTestBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.OrderDetailsTestAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel


class OrderDetailsTestFragment : BaseFragment<LabtestFragmentOrderDetailTestBinding>() {
    private var orderSummaryResData: TestOrderSummaryResData? = null

    private val orderTestsList = arrayListOf<OrderSummaryItemData>()
    private val orderDetailsTestAdapter by lazy {
        OrderDetailsTestAdapter(orderTestsList)
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
    ): LabtestFragmentOrderDetailTestBinding {
        return LabtestFragmentOrderDetailTestBinding.inflate(inflater,
            container,
            attachToRoot)
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
            recyclerViewTests.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = orderDetailsTestAdapter
            }
        }
    }

    private fun setViewListeners() {
        with(binding) {
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setDetails(orderSummaryResData: TestOrderSummaryResData?) {
        this.orderSummaryResData = orderSummaryResData
        with(binding) {
            orderSummaryResData?.let {

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

                orderTestsList.clear()
                it.items?.let { it1 -> orderTestsList.addAll(it1) }
                orderDetailsTestAdapter.notifyDataSetChanged()
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