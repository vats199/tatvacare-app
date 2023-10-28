package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.LabtestFragmentAppointmentBookedSuccessBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable
import java.util.*


class LabtestAppointmentBookSuccessFragment :
    BaseFragment<LabtestFragmentAppointmentBookedSuccessBinding>() {

    var resumedTime = Calendar.getInstance().timeInMillis

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

    private val dateStr: String? by lazy {
        arguments?.getString(Common.BundleKey.DATE)
    }

    private val orderMasterId: String? by lazy {
        arguments?.getString(Common.BundleKey.ORDER_MASTER_ID)
    }

    private val finalAmountToPay: Int? by lazy {
        arguments?.getInt(Common.BundleKey.FINAL_AMOUNT_TO_PAY)
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
    ): LabtestFragmentAppointmentBookedSuccessBinding {
        return LabtestFragmentAppointmentBookedSuccessBinding.inflate(
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
        analytics.setScreenName(AnalyticsScreenNames.BookLabtestAppointmentSuccess)
        resumedTime = Calendar.getInstance().timeInMillis
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

    override fun bindData() {
        setUpViewListeners()
        setData()
    }

    override fun onBackActionPerform(): Boolean {
        navigator.loadActivity(HomeActivity::class.java).byFinishingAll().start()
        return false
    }

    private fun setData() {
        with(binding) {
            if (testPatientData?.name.isNullOrBlank()) {
                textViewName.text = session.user?.name
            } else {
                textViewName.text = testPatientData?.name
            }

            /*textViewPrice.text =
                    getString(R.string.symbol_rupee).plus(listCartData?.order_detail?.final_payable_amount)*/
            if ((finalAmountToPay ?: 0) > 0) {
                textViewPrice.text = getString(R.string.symbol_rupee).plus(finalAmountToPay)
            } else {
                textViewPrice.text = getString(R.string.labtest_cart_label_free)
            }

            val dateLabel: String? = dateStr?.let {
                DateTimeFormatter.date(it, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            }
            textViewAppointmentDetails.text = (dateLabel?.plus("\n") ?: "")
                .plus(testTimeSlotData)

            val sbNames = StringBuilder()
            listCartData?.tests_list?.forEach {
                sbNames.append(it.name).append(", ")
            }
            textViewTestNames.text = sbNames.toString().trim().removeSuffix(",")
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonTrackOrder.setOnClickListener { onViewClick(it) }
            buttonGoToHome.setOnClickListener { onViewClick(it) }
        }
    }


    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonTrackOrder -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    LabtestOrderDetailsFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.ORDER_MASTER_ID, orderMasterId),
                            Pair(Common.BundleKey.IS_TO_OPEN_HOME_ON_BACK, true)
                        )
                    ).byFinishingAll().start()
            }

            R.id.buttonGoToHome -> {
                navigator.loadActivity(HomeActivity::class.java)
                    .byFinishingAll()
                    .start()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun addAppointment() {
        /*val apiRequest = ApiRequest().apply {
        }
        showLoader()
        doctorViewModel.addAppointment(apiRequest)*/
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //addAppointmentLiveData
        /*doctorViewModel.addAppointmentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { handleOnAddAppointmentSuccess(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })*/
    }
}