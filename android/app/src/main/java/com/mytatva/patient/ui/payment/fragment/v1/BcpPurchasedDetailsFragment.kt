package com.mytatva.patient.ui.payment.fragment.v1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpPurchasedData
import com.mytatva.patient.databinding.PaymentFragmentBcpPurchasedDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.dialog.HelpDialog
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class BcpPurchasedDetailsFragment : BaseFragment<PaymentFragmentBcpPurchasedDetailsBinding>() {

    private val patientPlanRelId by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_PLAN_REL_ID)
    }

    private val isOpenFromPlanList: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_OPEN_FROM_PLAN_LIST) ?: false
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    private var bcpPurchasedData: BcpPurchasedData? = null

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentBcpPurchasedDetailsBinding {
        return PaymentFragmentBcpPurchasedDetailsBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpPurchasedDetails)
        getCartCountData()
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        carePlanServices()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            layoutLabTest.setOnClickListener { onViewClick(it) }
            layoutAppointmentSlot.setOnClickListener { onViewClick(it) }
            layoutMyDevice.setOnClickListener { onViewClick(it) }
            layoutContactUs.setOnClickListener { onViewClick(it) }
            buttonRenewNow.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutContactUs -> {
                analytics.logEvent(
                    analytics.TAP_CONTACT_US,
                    Bundle().apply {
                        putString(analytics.PARAM_PLAN_ID, bcpPurchasedData?.plan_details?.plan_master_id)
                    },
                    screenName = AnalyticsScreenNames.BcpPurchasedDetails
                )

                requireActivity().supportFragmentManager.let {
                    HelpDialog().show(it, HelpDialog::class.java.simpleName)
                }
            }

            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.layoutLabTest -> {
                if (planRemainingDays >= 0) {

                    analytics.logEvent(
                        analytics.TAP_LABTEST_CARD,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_PLAN_ID,
                                bcpPurchasedData?.plan_details?.plan_master_id
                            )
                        },
                        screenName = AnalyticsScreenNames.BcpPurchasedDetails
                    )

                    openCart()
                }
            }

            R.id.layoutAppointmentSlot -> {
                if (planRemainingDays >= 0) {

                    analytics.logEvent(
                        analytics.TAP_HEALTH_COACH_CARD,
                        Bundle().apply {
                            putString(analytics.PARAM_PLAN_ID, bcpPurchasedData?.plan_details?.plan_master_id)
                        },
                        screenName = AnalyticsScreenNames.BcpPurchasedDetails
                    )

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BcpScheduleAppointmentFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.PATIENT_PLAN_REL_ID,
                                patientPlanRelId
                            )
                        )
                    ).start()
                }
            }

            R.id.layoutMyDevice -> {
                if (planRemainingDays >= 0) {

                    analytics.logEvent(
                        analytics.TAP_DEVICE_CARD,
                        Bundle().apply {
                            putString(analytics.PARAM_PLAN_ID, bcpPurchasedData?.plan_details?.plan_master_id)
                        },
                        screenName = AnalyticsScreenNames.BcpPurchasedDetails
                    )

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BcpMyDevicesFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(
                            Common.BundleKey.PATIENT_PLAN_REL_ID, patientPlanRelId
                        )
                    }).start()
                }
            }

            R.id.buttonRenewNow -> {

                analytics.logEvent(analytics.RENEW_PLAN, Bundle().apply {
                    putString(analytics.PARAM_PLAN_ID, bcpPurchasedData?.plan_details?.plan_master_id)
                    putString(analytics.PARAM_PLAN_TYPE, bcpPurchasedData?.plan_details?.plan_type)
                    putString(analytics.PARAM_PLAN_EXPIRY_DATE, bcpPurchasedData?.plan_details?.expiry_date)
                    putString(analytics.PARAM_DAYS_TO_EXPIRE, bcpPurchasedData?.plan_details?.remaining_days)
                }, screenName = AnalyticsScreenNames.BcpPurchasedDetails)

                if ((bcpPurchasedData?.plan_active ?: "") == "Y") {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        PaymentPlanDetailsV1Fragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.PLAN_ID, bcpPurchasedData?.plan_details?.plan_master_id),
                            Pair(Common.BundleKey.PLAN_TYPE, bcpPurchasedData?.plan_details?.plan_type),
                            /*Pair(
                                Common.BundleKey.PATIENT_PLAN_REL_ID,
                                bcpPurchasedData?.plan_details?.patient_plan_rel_id
                            ),*/
                            Pair(Common.BundleKey.ENABLE_RENT_BUY, bcpPurchasedData?.plan_details?.enable_rent_buy),
                        )
                    ).start()
                } else {
                    PaymentCarePlanListingFragment.IS_TO_SCROLL_TO_OTHER_PLAN = true
                    if (isOpenFromPlanList) {
                        navigator.goBack()
                    } else {
                        navigator.loadActivity(IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java)
                            .byFinishingCurrent()
                            .start()
                    }
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun carePlanServices() {
        val apiRequest = ApiRequest().apply {
            patient_plan_rel_id = patientPlanRelId
        }
        showLoader()
        patientPlansViewModel.carePlanServices(apiRequest)
    }

    private fun getCartCountData() {
        doctorViewModel.getCartInfo()
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        patientPlansViewModel.carePlanServicesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                bcpPurchasedData = responseBody.data
                setDetails()
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

        //getCartCountDataLiveData
        doctorViewModel.getCartInfoLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //cart info updated in session
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    private fun setDetails() {
        if (isAdded) {
            with(binding) {
                bcpPurchasedData.let { item ->
                    layoutHeader.textViewToolbarTitle.text = item?.plan_name ?: ""
                    layoutLabTest.isVisible = item?.diagnostic_tests == "Y"
                    layoutAppointmentSlot.isVisible = item?.appointment == "Y"
                    layoutMyDevice.isVisible = item?.my_devices == "Y"

                    textViewLabelYourService.isVisible =
                        bcpPurchasedData?.diagnostic_tests == "Y" || bcpPurchasedData?.appointment == "Y" || bcpPurchasedData?.my_devices == "Y"

                    setProgressOfPlanExpireDetails()
                    setUpWebView()
                }
            }
        }
    }

    var planRemainingDays: Int = 0
    private fun setProgressOfPlanExpireDetails() = with(binding) {
        //Care Plan Name Card Logic Handle
        textViewLabelCarePlanName.text = bcpPurchasedData?.plan_name

        val planDetails = bcpPurchasedData?.plan_details
        planRemainingDays = planDetails?.remaining_days?.toIntOrNull() ?: 0

        if (planRemainingDays > 14) {
            buttonRenewNow.isVisible = false
            setDaysProgressBarColor(
                planDetails?.total_days ?: "",
                planRemainingDays.toString(),
                ContextCompat.getColor(requireContext(), R.color.progress_green)
            )

            val date = DateTimeFormatter.date(planDetails?.expiry_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_MMMMddyyyy)
            textViewLabelExpireDate.text = getString(R.string.bcp_purchase_details_label_expire_date, date)
            textViewLabelExpireDate.setTextColor(ContextCompat.getColor(requireContext(), R.color.background_dark_gray))

        } else {
            buttonRenewNow.isVisible = true
            buttonRenewNow.isVisible = planDetails?.show_renew == "Y"
            if (planRemainingDays < 0) {
                //plan expired, so show renew button based on flag
                textViewLabelExpireDate.text = getString(R.string.bcp_purchase_details_label_plan_expire)
            } else if (planRemainingDays == 0) {
                textViewLabelExpireDate.text = "Expiring Today"
            } else if (planRemainingDays == 1) {
                textViewLabelExpireDate.text = "Expiring Tomorrow"
            } else {
                textViewLabelExpireDate.text = getString(R.string.bcp_purchase_details_label_remaining_days, planRemainingDays.toString())
            }

            if (planRemainingDays <= 7) {
                setDaysProgressBarColor(
                    planDetails?.total_days ?: "",
                    planRemainingDays.toString(),
                    ContextCompat.getColor(requireContext(), R.color.progress_red)
                )
                textViewLabelExpireDate.setTextColor(ContextCompat.getColor(requireContext(), R.color.progress_red))
            } else {
                setDaysProgressBarColor(
                    planDetails?.total_days ?: "",
                    planRemainingDays.toString(),
                    ContextCompat.getColor(requireContext(), R.color.progress_orange)
                )
                textViewLabelExpireDate.setTextColor(ContextCompat.getColor(requireContext(), R.color.progress_orange))
            }
        }

        //Book Lab Test Handle
        bcpPurchasedData.let { item ->
            if (item?.diagnostic_tests == "Y") {
                val totalCount = item.duration_details?.diagnostic_test_session_count

                textViewCount.isVisible = totalCount != null

                if (totalCount != null) {
                    if (planRemainingDays >= 0) {
                        val remainingCount = totalCount.toInt() - item.duration_details.diagnostic_test_used_count!!.toInt()
                        textViewCount.text = "$remainingCount/$totalCount Left"
                        if (remainingCount == 0) {
                            textViewCount.setTextColor(ContextCompat.getColor(requireContext(), R.color.redError))
                        }
                    } else {
                        textViewCount.text = getString(R.string.bcp_purchase_details_label_plan_expire)
                        textViewCount.setTextColor(ContextCompat.getColor(requireContext(), R.color.progress_red))
                    }
                }
            }
        }
    }

    private fun setDaysProgressBarColor(totalDays: String, remainingDays: String, color: Int) = with(binding) {
        var totalDayNew = (totalDays.toIntOrNull() ?: 0)
        var remainingDayNew = (remainingDays.toIntOrNull() ?: 0)
        /*if ((totalDays.toIntOrNull() ?: 0) == 0) {
            // for single day plan, when total days are 0, increment 1 in both to set progress properly
            totalDayNew += 1
            remainingDayNew += 1
        }*/

        //increment 1 in both, to handle the progress
        totalDayNew += 1
        remainingDayNew += 1

        progressIndicator.max = totalDayNew
        progressIndicator.progress = totalDayNew - remainingDayNew
        progressIndicator.setIndicatorColor(color)
    }


    private fun setUpWebView() {
        with(binding) {
            if (bcpPurchasedData?.what_to_expect.isNullOrBlank().not()) {
                textViewLabelExpect.visibility = View.VISIBLE
                webView.visibility = View.VISIBLE

                webView.settings.builtInZoomControls = false
                webView.settings.displayZoomControls = false
                /*webView.settings.useWideViewPort = true
                webView.settings.loadWithOverviewMode = true*/

                bcpPurchasedData?.what_to_expect?.let {
                    val cleanHtml = it.replace("\\\"", "\"")
                    webView.loadDataWithBaseURL(
                        null,
                        cleanHtml,
                        "text/html", //; charset=utf-8
                        "UTF-8",
                        null
                    )
                }

            } else {
                textViewLabelExpect.visibility = View.GONE
                webView.visibility = View.GONE
            }
        }
    }

}