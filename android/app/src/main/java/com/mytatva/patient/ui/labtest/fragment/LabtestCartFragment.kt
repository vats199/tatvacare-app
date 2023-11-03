package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
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
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestFragmentCartBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.CartAddedTestsAdapter
import com.mytatva.patient.ui.labtest.bottomsheet.ApplyCouponBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.load


class LabtestCartFragment : BaseFragment<LabtestFragmentCartBinding>() {

    //var resumedTime = Calendar.getInstance().timeInMillis

    private var listCartData: ListCartData? = null

    private val addedTestList = arrayListOf<TestPackageData>()
    private val cartAddedTestsAdapter by lazy {
        CartAddedTestsAdapter(addedTestList,
            object : CartAddedTestsAdapter.AdapterListener {
                override fun onClickRemove(position: Int) {

                    navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                        dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                            override fun onYesClick() {
                                addedTestList[position].code?.let {
                                    removeFromCart(it,
                                        addedTestList[position].lab_test_id ?: "")
                                }
                            }

                            override fun onNoClick() {

                            }
                        })


                }
            })
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
    ): LabtestFragmentCartBinding {
        return LabtestFragmentCartBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LabtestCart)
        //resumedTime = Calendar.getInstance().timeInMillis
        analytics.logEvent(analytics.USER_VIEWED_CART, screenName = AnalyticsScreenNames.LabtestCart)
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setUpRecyclerView()
        listCart()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonViewSelectPatientDetails.setOnClickListener { onViewClick(it) }
            textViewApplyCoupon.setOnClickListener { onViewClick(it) }
            //textViewAddMoreTest.setOnClickListener { onViewClick(it) }
            layoutAddMoreTest.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewTests.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = cartAddedTestsAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_cart_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutAddMoreTest -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabTestListNormalFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.IS_ALL, true))
                    ).start()
            }
            R.id.buttonViewSelectPatientDetails -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    PatientDetailsFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.LIST_CART_DATA, listCartData)
                    )).start()
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.textViewApplyCoupon -> {
                ApplyCouponBottomSheetDialog {
                }.show(requireActivity().supportFragmentManager,
                    ApplyCouponBottomSheetDialog::class.java.simpleName)
            }

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

    private fun removeFromCart(testCode: String, labTestId: String) {
        val apiRequest = ApiRequest().apply {
            code = testCode
        }
        showLoader()
        doctorViewModel.removeFromCart(apiRequest, labTestId, screenName = AnalyticsScreenNames.LabtestCart)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //listCartLiveData
        doctorViewModel.listCartLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                with(binding) {
                    nestedScrollView.isVisible = true
                    textViewNoData.isVisible = false
                }
                setCartDetails(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                with(binding) {
                    nestedScrollView.isVisible = false
                    textViewNoData.isVisible = true
                    textViewNoData.text = throwable.message
                }
                navigator.goBack()
                false
            })

        //removeFromCartLiveData
        doctorViewModel.removeFromCartLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                listCart()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setCartDetails(listCartData: ListCartData?) {
        this.listCartData = listCartData
        with(binding) {
            listCartData?.let {
                imageViewIcon.load(it.lab?.image ?: "", isCenterCrop = false)
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
                    textViewHomeCollectionChargeNew.text =
                        getString(R.string.labtest_cart_label_free)
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

                addedTestList.clear()
                it.tests_list?.let { list -> addedTestList.addAll(list) }
                cartAddedTestsAdapter.notifyDataSetChanged()
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