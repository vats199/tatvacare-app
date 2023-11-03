package com.mytatva.patient.ui.labtest.fragment.v1

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
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.data.pojo.response.TimeSlotData
import com.mytatva.patient.databinding.LabtestFragmentSelectAppointmentDateTimeV1Binding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.appointment.adapter.v1.SelectTimeSlotAdapterV1
import com.mytatva.patient.ui.appointment.adapter.v1.SelectTimeSlotMainAdapterV1
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.convertToDate
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable
import com.prolificinteractive.materialcalendarview.CalendarDay
import com.prolificinteractive.materialcalendarview.DayViewDecorator
import com.prolificinteractive.materialcalendarview.DayViewFacade
import com.prolificinteractive.materialcalendarview.MaterialCalendarView
import devs.mulham.horizontalcalendar.HorizontalCalendar
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarListener
import devs.mulham.horizontalcalendar.utils.Utils
import org.threeten.bp.DayOfWeek
import java.util.*


class SelectLabtestAppointmentDateTimeFragmentV1 :
    BaseFragment<LabtestFragmentSelectAppointmentDateTimeV1Binding>() {

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

    private val couponCodeData: CouponCodeData? by lazy {
        arguments?.parcelable(Common.BundleKey.COUPON_CODE_DATA)
    }

    private val checkCouponData: CheckCouponData? by lazy {
        arguments?.parcelable(Common.BundleKey.CHECK_COUPON_DATA)
    }

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    if (SelectTimeSlotAdapterV1.selectedPosition == -1 || timeSlotList.isNullOrEmpty()) {
                        throw ApplicationException(getString(R.string.validation_select_time_slot))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showAppMessage(e.message,AppMsgStatus.ERROR)
                false
            }
        }


    private val timeSlotList = arrayListOf<TimeSlotData>()
    var resumedTime = Calendar.getInstance().timeInMillis

    private val selectTimeSlotAdapterV1 by lazy {
        SelectTimeSlotMainAdapterV1(timeSlotList,
            object :SelectTimeSlotAdapterV1.AdapterListener{
                override fun onClick() {
                    updateReviewButtonStatus()
                }

            })
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
    ): LabtestFragmentSelectAppointmentDateTimeV1Binding {
        return LabtestFragmentSelectAppointmentDateTimeV1Binding.inflate(
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
        SelectTimeSlotAdapterV1.selectedMainPosition = -1
        SelectTimeSlotAdapterV1.selectedPosition = -1
        updateReviewButtonStatus()
        setUpToolbar()
        setUpViewListeners()
        //setUpCalendar()
        setUpMaterialCalendar()

        getAppointmentSlots()
    }

    private fun setUpMaterialCalendar() {
        with(binding) {
            val startDate = Calendar.getInstance()
            startDate.add(Calendar.DAY_OF_YEAR, 1)
            val endDate = Calendar.getInstance()
            endDate.add(Calendar.YEAR, 5)

            materialCalender.state().edit()
                .setFirstDayOfWeek(DayOfWeek.MONDAY)
                .setMinimumDate(
                    CalendarDay.from(
                        startDate.get(Calendar.YEAR),
                        startDate.get(Calendar.MONTH) + 1,
                        startDate.get(Calendar.DAY_OF_MONTH)
                    )
                )
                .setMaximumDate(
                    CalendarDay.from(
                        endDate.get(Calendar.YEAR),
                        endDate.get(Calendar.MONTH) + 1,
                        endDate.get(Calendar.DAY_OF_MONTH)
                    )
                ).commit()
            materialCalender.selectionMode = MaterialCalendarView.SELECTION_MODE_SINGLE

            materialCalender.addDecorator(object : DayViewDecorator {
                override fun shouldDecorate(day: CalendarDay?): Boolean {
                    return true
                }

                override fun decorate(view: DayViewFacade?) {
                    view?.setSelectionDrawable(resources.getDrawable(R.drawable.date_day_selector_cal_time_slot, null))
                }
            })

            calSelectedDate.timeInMillis = startDate.time.time
            updateDate()

            materialCalender.setOnDateChangedListener { widget, date, selected ->
                val selectedDate = date.date.convertToDate()
                calSelectedDate.timeInMillis = selectedDate.time
                updateDate()
                SelectTimeSlotAdapterV1.selectedMainPosition = -1
                SelectTimeSlotAdapterV1.selectedPosition = -1

                updateReviewButtonStatus()
                getAppointmentSlots()

            }
            materialCalender.selectedDate = CalendarDay.from(
                startDate.get(Calendar.YEAR),
                startDate.get(Calendar.MONTH) + 1,
                startDate.get(Calendar.DAY_OF_MONTH)
            )
        }
    }

    private fun updateReviewButtonStatus() = with(binding) {
        buttonLabTestReview.isEnabled = SelectTimeSlotAdapterV1.selectedPosition != -1
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

                        SelectTimeSlotAdapterV1.selectedMainPosition = -1
                        SelectTimeSlotAdapterV1.selectedPosition = -1

                        updateReviewButtonStatus()

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
        /*binding.textViewDate.text = DateTimeFormatter.date(calSelectedDate.time)
            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dMMMMyyyy)*/
    }

    private fun setUpViewListeners() {
        with(binding) {
            //textViewDate.setOnClickListener { onViewClick(it) }
            buttonLabTestReview.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewTimeSlots.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = selectTimeSlotAdapterV1
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_select_date_time_title_v1)
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

            R.id.buttonLabTestReview -> {
                if (isValid) {
                    analytics.logEvent(analytics.LABTEST_APPOINTMENT_TIME_SELECTED, Bundle().apply {
                        putString(
                            analytics.PARAM_APPOINTMENT_DATE,
                            DateTimeFormatter.date(calSelectedDate.time)
                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
                        )
                        putString(
                            analytics.PARAM_SLOT_TIME,
                            timeSlotList[SelectTimeSlotAdapterV1.selectedMainPosition].slots
                                ?.get(SelectTimeSlotAdapterV1.selectedPosition)
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
                                timeSlotList[SelectTimeSlotAdapterV1.selectedMainPosition].slots
                                    ?.get(SelectTimeSlotAdapterV1.selectedPosition)
                            ),
                            Pair(Common.BundleKey.TITLE, timeSlotList[SelectTimeSlotAdapterV1.selectedMainPosition].title),

                            Pair(Common.BundleKey.COUPON_CODE_DATA, couponCodeData),
                            Pair(Common.BundleKey.CHECK_COUPON_DATA, checkCouponData)
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
                if(throwable is ServerException){
                    handleTimeSlotResponse(null, throwable.message ?: "")
                    false
                } else{
                    true
                }
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleTimeSlotResponse(list: ArrayList<TimeSlotData>?, message: String = "") {
        timeSlotList.clear()
        list?.let { timeSlotList.addAll(it) }
        selectTimeSlotAdapterV1.notifyDataSetChanged()
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