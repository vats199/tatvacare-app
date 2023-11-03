package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.LabtestFragmentPatientDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.PatientDetailsAdapter
import com.mytatva.patient.ui.payment.bottomsheet.SelectAddressBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable


class PatientDetailsFragment : BaseFragment<LabtestFragmentPatientDetailsBinding>() {

    private val listCartData: ListCartData? by lazy {
        arguments?.getParcelable(Common.BundleKey.LIST_CART_DATA)
    }

    private val couponCodeData: CouponCodeData? by lazy {
        arguments?.parcelable(Common.BundleKey.COUPON_CODE_DATA)
    }

    private val checkCouponData: CheckCouponData? by lazy {
        arguments?.parcelable(Common.BundleKey.CHECK_COUPON_DATA)
    }

    //var resumedTime = Calendar.getInstance().timeInMillis

    private val patientList = arrayListOf<TestPatientData>()
    private val patientDetailsAdapter by lazy {
        PatientDetailsAdapter(patientList,
            analytics,
            object : PatientDetailsAdapter.AdapterListener {
                override fun onClick(position: Int) {
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
    ): LabtestFragmentPatientDetailsBinding {
        return LabtestFragmentPatientDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectPatient)
        //resumedTime = Calendar.getInstance().timeInMillis
        patientMembersList()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonAdd.setOnClickListener { onViewClick(it) }
            buttonConfirm.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewPatients.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = patientDetailsAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.patient_details_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonAdd -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    AddPatientDetailsFragment::class.java)
                    .start()
            }
            R.id.buttonConfirm -> {
                if (patientDetailsAdapter.selectedPos == -1) {
                    showMessage(getString(R.string.validation_select_patient))
                } else {
                    analytics.logEvent(analytics.LABTEST_PATIENT_SELECTED, Bundle().apply {
                        putString(analytics.PARAM_MEMBER_ID,
                            patientList[patientDetailsAdapter.selectedPos].patient_member_rel_id)
                    }, screenName = AnalyticsScreenNames.SelectPatient)

                    /*navigator.loadActivity(IsolatedFullActivity::class.java,
                        SelectAddressFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                            Pair(Common.BundleKey.TEST_PATIENT_DATA,
                                patientList[patientDetailsAdapter.selectedPos]),

                            Pair(Common.BundleKey.COUPON_CODE_DATA, couponCodeData),
                            Pair(Common.BundleKey.CHECK_COUPON_DATA, checkCouponData)
                        )).start()*/


                    //if it select address flow(Labtest) before payment
                    SelectAddressBottomSheetDialog().apply {
                        arguments = Bundle().apply {
                            putParcelable(
                                Common.BundleKey.LIST_CART_DATA, listCartData
                            )
                            putParcelable(
                                Common.BundleKey.TEST_PATIENT_DATA,
                                patientList[patientDetailsAdapter.selectedPos]
                            )
                            putParcelable(
                                Common.BundleKey.COUPON_CODE_DATA, couponCodeData
                            )
                            putParcelable(
                                Common.BundleKey.CHECK_COUPON_DATA, checkCouponData
                            )
                        }
                    }.setCallback {

                    }.show(
                        requireActivity().supportFragmentManager,
                        SelectAddressBottomSheetDialog::class.java.simpleName
                    )
                }
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun patientMembersList() {
        val apiRequest = ApiRequest()
        showLoader()
        doctorViewModel.patientMembersList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //patientMembersListLiveData
        doctorViewModel.patientMembersListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleOnPatientListResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                handleOnPatientListResponse(null, throwable.message ?: "")
                false
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleOnPatientListResponse(
        list: ArrayList<TestPatientData>?,
        message: String = "",
    ) {
        patientList.clear()
        list?.let { patientList.addAll(it) }
        patientDetailsAdapter.notifyDataSetChanged()
        with(binding) {
            if (list.isNullOrEmpty()) {
                textViewNoData.text = message
                textViewNoData.isVisible = true
                recyclerViewPatients.isVisible = false
            } else {
                textViewNoData.isVisible = false
                recyclerViewPatients.isVisible = true
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