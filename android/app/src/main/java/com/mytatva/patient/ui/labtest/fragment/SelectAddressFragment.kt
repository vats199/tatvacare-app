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
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.LabtestFragmentSelectAddressBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.SelectAddressAdapter
import com.mytatva.patient.ui.labtest.fragment.v1.SelectLabtestAppointmentDateTimeFragmentV1
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable

class SelectAddressFragment : BaseFragment<LabtestFragmentSelectAddressBinding>() {

    //var resumedTime = Calendar.getInstance().timeInMillis

    private val listCartData: ListCartData? by lazy {
        arguments?.getParcelable(Common.BundleKey.LIST_CART_DATA)
    }

    private val testPatientData: TestPatientData? by lazy {
        arguments?.getParcelable(Common.BundleKey.TEST_PATIENT_DATA)
    }

    private val couponCodeData: CouponCodeData? by lazy {
        arguments?.parcelable(Common.BundleKey.COUPON_CODE_DATA)
    }

    private val checkCouponData: CheckCouponData? by lazy {
        arguments?.parcelable(Common.BundleKey.CHECK_COUPON_DATA)
    }

    private var currentClickPos = -1
    private val addressList = arrayListOf<TestAddressData>()
    private val selectAddressAdapter by lazy {
        SelectAddressAdapter(addressList, analytics,
            object : SelectAddressAdapter.AdapterListener {
                override fun onEditClick(position: Int) {
                    currentClickPos = position
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        AddEditAddressFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.ADDRESS_DATA, addressList[position])
                        )).start()
                }

                override fun onDeleteClick(position: Int) {
                    currentClickPos = position
                    addressList[position].patient_address_rel_id?.let { deleteAddress(it) }
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
    ): LabtestFragmentSelectAddressBinding {
        return LabtestFragmentSelectAddressBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectAddress)
        //resumedTime = Calendar.getInstance().timeInMillis
        addressList()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonAddNew.setOnClickListener { onViewClick(it) }
            buttonSave.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewSelectAddress.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = selectAddressAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.select_address_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.buttonAddNew -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    AddEditAddressFragment::class.java)
                    .start()
            }
            R.id.buttonSave -> {
                if (selectAddressAdapter.selectedPosition == -1) {
                    showMessage(getString(R.string.validation_select_address))
                } else {
                    analytics.logEvent(analytics.LABTEST_ADDRESS_SELECTED, Bundle().apply {
                        putString(analytics.PARAM_ADDRESS_ID,
                            addressList[selectAddressAdapter.selectedPosition].patient_address_rel_id)
                    }, screenName = AnalyticsScreenNames.SelectAddress)

                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        SelectLabtestAppointmentDateTimeFragmentV1::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                            Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                            Pair(Common.BundleKey.TEST_ADDRESS_DATA,
                                addressList[selectAddressAdapter.selectedPosition]),

                            Pair(Common.BundleKey.COUPON_CODE_DATA, couponCodeData),
                            Pair(Common.BundleKey.CHECK_COUPON_DATA, checkCouponData)
                        )).start()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun addressList() {
        val apiRequest = ApiRequest()
        showLoader()
        doctorViewModel.addressList(apiRequest)
    }

    private fun deleteAddress(addressId: String) {
        val apiRequest = ApiRequest().apply {
            address_id = addressId
        }
        showLoader()
        doctorViewModel.deleteAddress(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //addressListLiveData
        doctorViewModel.addressListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleOnAddressListResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                handleOnAddressListResponse(null, throwable.message ?: "")
                false
            })

        //deleteAddressLiveData
        doctorViewModel.deleteAddressLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.LABTEST_ADDRESS_DELETED, Bundle().apply {
                    putString(analytics.PARAM_ADDRESS_ID,
                        addressList[currentClickPos].patient_address_rel_id)
                }, screenName = AnalyticsScreenNames.SelectAddress)
                if (selectAddressAdapter.selectedPosition == currentClickPos) {
                    selectAddressAdapter.selectedPosition = -1
                }
                addressList()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleOnAddressListResponse(
        list: ArrayList<TestAddressData>?,
        message: String = "",
    ) {
        addressList.clear()
        list?.let { addressList.addAll(it) }
        selectAddressAdapter.notifyDataSetChanged()
        with(binding) {
            if (list.isNullOrEmpty()) {
                textViewNoData.text = message
                textViewNoData.isVisible = true
                recyclerViewSelectAddress.isVisible = false
            } else {
                textViewNoData.isVisible = false
                recyclerViewSelectAddress.isVisible = true
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