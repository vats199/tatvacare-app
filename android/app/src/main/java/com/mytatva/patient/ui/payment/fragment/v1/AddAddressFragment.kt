package com.mytatva.patient.ui.payment.fragment.v1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpDuration
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.PaymentFragmentAddAddressBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.disableEmoji
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable


class AddAddressFragment : BaseFragment<PaymentFragmentAddAddressBinding>() {

    private val bcpPlanData: BcpPlanData? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DATA)
    }

    private val bcpDuration: BcpDuration? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DURATION_DATA)
    }

    private val addressData: TestAddressData? by lazy {
        arguments?.parcelable(Common.BundleKey.ADDRESS_DATA)
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {

                    validator.submit(editTextPinCode)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_pin_code))
                        .check()

                    validator.submit(editTextHouseNumberBuilding)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_empty_full_address))
                        .checkMinDigits(25)
                        .errorMessage(getString(R.string.validation_valid_full_address))
                        .check()

                    validator.submit(editTextStreetName)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_street_name))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showAppMessage(e.message,AppMsgStatus.ERROR)
                false
            }
        }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentAddAddressBinding {
        return PaymentFragmentAddAddressBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AddAddress)
        //resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()

        initUI()
    }

    private fun initUI() {
        with(binding) {
            editTextStreetName.disableEmoji()
            editTextHouseNumberBuilding.disableEmoji()
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveNext.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.payment_header_label_add_address)
            imageViewToolbarBack.setImageDrawable(
                ContextCompat.getDrawable(
                    requireContext(),
                    R.drawable.ic_close_menu
                )
            )
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSaveNext -> {
                if (isValid) {
                    pincodeAvailability()
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
    private fun updateAddress() {
        val apiRequest = ApiRequest().apply {
            name = session.user?.name
            pincodeSmall = binding.editTextPinCode.text.toString().trim()
            contact_no = session.user?.contact_no
            street = binding.editTextStreetName.text.toString().trim()
            address_type =
                if (binding.radioHome.isChecked) Common.AddressTypes.HOME
                else if (binding.radioWork.isChecked) Common.AddressTypes.WORK
                else Common.AddressTypes.OTHER
            address = binding.editTextHouseNumberBuilding.text.toString().trim()
        }
        showLoader()
        doctorViewModel.updateAddress(apiRequest)
    }

    private fun pincodeAvailability() {
        val apiRequest = ApiRequest().apply {
            Pincode = binding.editTextPinCode.text.toString().trim()
        }
        showLoader()
        doctorViewModel.pincodeAvailability(apiRequest)
    }


    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updateAddressLiveData
        doctorViewModel.updateAddressLiveData.observe(this,
            onChange = {
                hideLoader()
                showAppMessage(it.message,AppMsgStatus.SUCCESS)
                if (addressData == null) {
                    analytics.logEvent(
                        analytics.LABTEST_ADDRESS_ADDED,
                        screenName = AnalyticsScreenNames.AddAddress
                    )
                } else {
                    analytics.logEvent(analytics.LABTEST_ADDRESS_UPDATED, Bundle().apply {
                        putString(analytics.PARAM_ADDRESS_ID, addressData?.patient_address_rel_id)
                    }, screenName = AnalyticsScreenNames.AddAddress)
                }

                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    BcpOrderReviewFragment::class.java
                ).addBundle(Bundle().apply {
                    putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, it.data)
                    putParcelable(Common.BundleKey.PLAN_DATA, bcpPlanData)
                    putParcelable(Common.BundleKey.PLAN_DURATION_DATA, bcpDuration)
                }).byFinishingCurrent().start()
            },
            onError = {
                hideLoader()
                if (it is ServerException){
                    it.message?.let { it1 -> showAppMessage(it1,AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })

        //pincodeAvailabilityLiveData
        doctorViewModel.pincodeAvailabilityLiveData.observe(this,
            onChange = {
                hideLoader()
                updateAddress()
            },
            onError = {
                hideLoader()
                if (it is ServerException){
                    it.message?.let { it1 -> showAppMessage(it1,AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })
    }

}