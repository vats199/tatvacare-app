package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
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
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.data.pojo.response.TimeSlotData
import com.mytatva.patient.databinding.LabtestFragmentSelectAppointmentDateTimeBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.appointment.adapter.SelectTimeSlotAdapter
import com.mytatva.patient.ui.appointment.adapter.SelectTimeSlotMainAdapter
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.fragment.v1.LabtestOrderReviewFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import devs.mulham.horizontalcalendar.HorizontalCalendar
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarListener
import devs.mulham.horizontalcalendar.utils.Utils
import java.util.*


class SelectLabtestAppointmentDateTimeFragment :
    BaseFragment<LabtestFragmentSelectAppointmentDateTimeBinding>() {

    private val listCartData: ListCartData? by lazy {
        arguments?.getParcelable(Common.BundleKey.LIST_CART_DATA)
    }

    // this will be null for BCP flow, in normal flow testPatientData will be there
    private val testPatientData: TestPatientData? by lazy {
        arguments?.getParcelable(Common.BundleKey.TEST_PATIENT_DATA)
    }

    private val testAddressData: TestAddressData? by lazy {
        arguments?.getParcelable(Common.BundleKey.TEST_ADDRESS_DATA)
    }

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    if (SelectTimeSlotAdapter.selectedPosition == -1 || timeSlotList.isNullOrEmpty()) {
                        throw ApplicationException(getString(R.string.validation_select_time_slot))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }


    private val timeSlotList = arrayListOf<TimeSlotData>()
    var resumedTime = Calendar.getInstance().timeInMillis

    private val selectTimeSlotAdapter by lazy {
        SelectTimeSlotMainAdapter(timeSlotList)
    }

    var horizontalCalendar: HorizontalCalendar? = null

    private val calSelectedDate = Calendar.getInstance()

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
    ): LabtestFragmentSelectAppointmentDateTimeBinding {
        return LabtestFragmentSelectAppointmentDateTimeBinding.inflate(
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
        analytics.setScreenName(AnalyticsScreenNames.SelectLabtestAppointmentDateTime)
        resumedTime = Calendar.getInstance().timeInMillis
        setUpRecyclerView()
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
        setUpToolbar()
        setUpViewListeners()
        setUpCalendar()

        getAppointmentSlots()
    }

    private fun setUpCalendar() {
        try {
            val startDate = Calendar.getInstance()
            val endDate = Calendar.getInstance()

            // handle for range select issue
            //startDate.add(Calendar.DAY_OF_YEAR, 1)
            endDate.add(Calendar.YEAR, 5)

            if (horizontalCalendar == null) {
                horizontalCalendar = HorizontalCalendar.Builder(activity, R.id.calendarView)
                    .range(startDate, endDate)
                    .mode(HorizontalCalendar.Mode.DAYS)
                    .defaultSelectedDate(startDate)
                    .datesNumberOnScreen(7)
                    .build()
            }

            calSelectedDate.timeInMillis = startDate.time.time
            updateDate()

            horizontalCalendar?.calendarListener = object : HorizontalCalendarListener() {
                override fun onDateSelected(date: Calendar?, position: Int) {
                    // check same date to handle double callback sometimes
                    if (Utils.isSameDate(calSelectedDate, date)) {
                        Log.d("HorizontalCal", "same date")
                    } else {
                        Log.d("HorizontalCal", "not same date")
                        calSelectedDate.timeInMillis = date!!.timeInMillis
                        updateDate()

                        SelectTimeSlotAdapter.selectedMainPosition = -1
                        SelectTimeSlotAdapter.selectedPosition = -1
                        getAppointmentSlots()
                    }
                }

                /* override fun onCalendarScroll(calendarView: HorizontalCalendarView?, dx: Int, dy: Int) {
                     super.onCalendarScroll(calendarView, dx, dy)
                 }*/
            }
        } catch (e: Exception) {
            //navigator.loadActivity(HomeActivity::class.java).byFinishingAll().start()
        }

    }

    private fun updateDate() {
        binding.textViewDate.text = DateTimeFormatter.date(calSelectedDate.time)
            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dMMMMyyyy)
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewDate.setOnClickListener { onViewClick(it) }
            buttonReview.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewTimeSlots.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = selectTimeSlotAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_select_date_time_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewDate -> {
                navigator.pickDate({ view, year, month, dayOfMonth ->
                    val cal = Calendar.getInstance()
                    cal.set(year, month, dayOfMonth)
                    horizontalCalendar?.selectDate(cal, true)
                }, minimumDate = Calendar.getInstance().timeInMillis,
                    maximumDate = Calendar.getInstance().apply {
                        add(Calendar.YEAR, 5)
                    }.timeInMillis
                )
            }

            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonReview -> {
                if (isValid) {
                    analytics.logEvent(analytics.LABTEST_APPOINTMENT_TIME_SELECTED, Bundle().apply {
                        putString(
                            analytics.PARAM_APPOINTMENT_DATE,
                            DateTimeFormatter.date(calSelectedDate.time)
                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
                        )
                        putString(
                            analytics.PARAM_SLOT_TIME,
                            timeSlotList[SelectTimeSlotAdapter.selectedMainPosition].slots
                                ?.get(SelectTimeSlotAdapter.selectedPosition)
                        )
                    }, screenName = AnalyticsScreenNames.SelectLabtestAppointmentDateTime)

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        /*BookAppointmentReviewFragment*/LabtestOrderReviewFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                            Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                            Pair(Common.BundleKey.TEST_ADDRESS_DATA, testAddressData),
                            Pair(
                                Common.BundleKey.DATE, DateTimeFormatter.date(calSelectedDate.time)
                                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
                            ),
                            Pair(
                                Common.BundleKey.TIME_SLOT,
                                timeSlotList[SelectTimeSlotAdapter.selectedMainPosition].slots
                                    ?.get(SelectTimeSlotAdapter.selectedPosition)
                            )
                        )
                    ).start()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getAppointmentSlots() {
        val apiRequest = ApiRequest().apply {
            Pincode = testAddressData?.pincode
            Date = DateTimeFormatter.date(calSelectedDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
        showLoader()
        doctorViewModel.getAppointmentSlots(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //getAppointmentSlotsLiveData
        doctorViewModel.getAppointmentSlotsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleTimeSlotResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                handleTimeSlotResponse(null, throwable.message ?: "")
                false
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleTimeSlotResponse(list: ArrayList<TimeSlotData>?, message: String = "") {
        timeSlotList.clear()
        list?.let { timeSlotList.addAll(it) }
        selectTimeSlotAdapter.notifyDataSetChanged()
        with(binding) {
            if (timeSlotList.isNullOrEmpty()) {
                recyclerViewTimeSlots.isVisible = false
                textViewNoData.isVisible = true
                textViewNoData.text = message
            } else {
                recyclerViewTimeSlots.isVisible = true
                textViewNoData.isVisible = false
            }
        }
    }
}