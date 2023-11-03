package com.mytatva.patient.ui.payment.fragment.v1

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.data.pojo.response.TimeSlotData
import com.mytatva.patient.databinding.PaymentFragmentBcpAppointmentDateTimeBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.v1.SelectScheduleTimeSlotAdapter
import com.mytatva.patient.ui.payment.adapter.v1.SelectScheduleTimeSlotMainAdapter
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.convertToDate
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.prolificinteractive.materialcalendarview.CalendarDay
import com.prolificinteractive.materialcalendarview.DayViewDecorator
import com.prolificinteractive.materialcalendarview.DayViewFacade
import com.prolificinteractive.materialcalendarview.MaterialCalendarView
import devs.mulham.horizontalcalendar.HorizontalCalendar
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarListener
import devs.mulham.horizontalcalendar.utils.Utils
import org.threeten.bp.DayOfWeek
import java.util.*


class PaymentBCPAppointmentDateTimeFragment :
    BaseFragment<PaymentFragmentBcpAppointmentDateTimeBinding>() {

    private val patientPlanRelId by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_PLAN_REL_ID)
    }
    private val isPhysiotherapist: Boolean? by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_PHYSIOTHERAPIST)
    }

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    if (SelectScheduleTimeSlotAdapter.selectedPosition == -1 || timeSlotList.isNullOrEmpty()) {
                        throw ApplicationException(getString(R.string.validation_select_time_slot))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showAppMessage(e.message, AppMsgStatus.ERROR)
                false
            }
        }


    private val timeSlotList: ArrayList<TimeSlotData> = arrayListOf()

    var resumedTime = Calendar.getInstance().timeInMillis

    private val selectTimeSlotAdapter by lazy {
        SelectScheduleTimeSlotMainAdapter(timeSlotList,
            object : SelectScheduleTimeSlotAdapter.AdapterListener {
                override fun onClick() {
                    updateReviewButtonStatus()
                }
            })
    }

    private var horizontalCalendar: HorizontalCalendar? = null

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
    ): PaymentFragmentBcpAppointmentDateTimeBinding {
        return PaymentFragmentBcpAppointmentDateTimeBinding.inflate(
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
        analytics.setScreenName(AnalyticsScreenNames.BcpHcServiceSelectTimeSlot)
        resumedTime = Calendar.getInstance().timeInMillis
        setUpRecyclerView()
    }

    override fun bindData() {
        updateReviewButtonStatus()
        setUpToolbar()
        setUpViewListeners()
        //setUpCalendar()

        setUpMaterialCalendar()
    }

    private fun setUpMaterialCalendar() {
        with(binding) {
            val startDate = Calendar.getInstance()
            startDate.add(Calendar.DAY_OF_YEAR, 1)
            val endDate = get10thDayExcludingSundays()

//        materialCalender.tileHeight = materialCalender.tileWidth
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

            /*materialCalender.addDecorator(
                CurrentDayDecorator(
                    requireActivity(),
                    isBlueTheme = true
                )
            )*/

            calSelectedDate.timeInMillis = startDate.time.time
            updateDateAndCallAPI()
            //setUpCalorieDecorators()

            materialCalender.setOnDateChangedListener { widget, date, selected ->
                val selectedDate = date.date.convertToDate()
                calSelectedDate.timeInMillis = selectedDate.time
                updateDateAndCallAPI()
            }
            materialCalender.selectedDate = CalendarDay.from(
                startDate.get(Calendar.YEAR),
                startDate.get(Calendar.MONTH) + 1,
                startDate.get(Calendar.DAY_OF_MONTH)
            )
        }
    }


    private fun setResult(message: String) {
        val intent = Intent()
        intent.putExtra(Common.BundleKey.MESSAGE, message)
        requireActivity().setResult(Activity.RESULT_OK, intent)
        requireActivity().finish()
    }

    private fun setUpCalendar() {
        try {
            val startDate = Calendar.getInstance()
            val endDate = get10thDayExcludingSundays()//Calendar.getInstance()

            // handle for range select issue
            //startDate.add(Calendar.DAY_OF_YEAR, 1)
            //endDate.add(Calendar.YEAR, 5)

            if (horizontalCalendar == null) {
                horizontalCalendar =
                    HorizontalCalendar.Builder(requireActivity(), R.id.calendarView)
                        .range(startDate, endDate)
                        .mode(HorizontalCalendar.Mode.DAYS)
                        .defaultSelectedDate(startDate)
                        /*.disableDates(object : HorizontalCalendarPredicate {
                            override fun test(date: Calendar?): Boolean {
                                return date?.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY
                            }

                            override fun style(): CalendarItemStyle? {
                                return CalendarItemStyle(R.color.red, null*//*ColorDrawable(Color.TRANSPARENT)*//*)
                            }
                        })*/
                        .datesNumberOnScreen(7)
                        .build()
            }

            calSelectedDate.timeInMillis = startDate.time.time
            updateDateAndCallAPI()

            horizontalCalendar?.calendarListener = object : HorizontalCalendarListener() {
                override fun onDateSelected(date: Calendar?, position: Int) {
                    // check same date to handle double callback sometimes
                    if (Utils.isSameDate(calSelectedDate, date)) {
                        Log.d("HorizontalCal", "same date")
                    } else {
                        Log.d("HorizontalCal", "not same date")
                        calSelectedDate.timeInMillis = date!!.timeInMillis
                        updateDateAndCallAPI()
                    }
                }
            }
        } catch (e: Exception) {
            //navigator.loadActivity(HomeActivity::class.java).byFinishingAll().start()
        }

    }

    private fun get10thDayExcludingSundays(): Calendar {
        val calendar = Calendar.getInstance()
        //calendar.add(Calendar.DAY_OF_YEAR, 1)
        var count = 0
        while (count < 10) {
            calendar.add(Calendar.DAY_OF_YEAR, 1)
            if (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
                count++
            }
        }
        return calendar
    }

    private fun updateDateAndCallAPI() {
        analytics.logEvent(analytics.USER_CHANGES_DATE, screenName = AnalyticsScreenNames.BcpHcServiceSelectTimeSlot)

        /*binding.textViewDate.text = DateTimeFormatter.date(calSelectedDate.time)
            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dMMMMyyyy)*/

        SelectScheduleTimeSlotAdapter.selectedMainPosition = -1
        SelectScheduleTimeSlotAdapter.selectedPosition = -1
        updateReviewButtonStatus()

        if (calSelectedDate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
            // when selected date is of Sunday, clear the slots
            handleTimeSlotResponse(
                arrayListOf(),
                "Looks like, there are no slots available, please check for a different date to get the slots"
            )
        } else {
            getBcpTimeSlots()
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            //textViewDate.setOnClickListener { onViewClick(it) }
            buttonReviewDetails.setOnClickListener { onViewClick(it) }
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
            //root.enableShadow()
            if (isPhysiotherapist == true) {
                textViewToolbarTitle.text = getString(R.string.bcp_appointment_date_time_label_with_physiotherapist)
            } else {
                textViewToolbarTitle.text = getString(R.string.bcp_appointment_date_time_label_with_nutritionist)
            }
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewDate -> {
                navigator.pickDate(
                    { view, year, month, dayOfMonth ->
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

            R.id.buttonReviewDetails -> {
                if (isValid) {
                    if (isPhysiotherapist != null)
                        updateHCDetails()
                }
            }
        }
    }

    private fun updateReviewButtonStatus() = with(binding) {
        buttonReviewDetails.isEnabled = SelectScheduleTimeSlotAdapter.selectedPosition != -1
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getBcpTimeSlots() {
        showLoader()
        doctorViewModel.getBcpTimeSlots(ApiRequest().apply {
            bcpSlotDate = DateTimeFormatter.date(calSelectedDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        })
    }

    private fun updateHCDetails() {
        val timeSlot = timeSlotList[SelectScheduleTimeSlotAdapter.selectedMainPosition].slots?.get(
            SelectScheduleTimeSlotAdapter.selectedPosition
        )?.split("-")
        val startTime = timeSlot?.get(0).toString().trim()
        val endTime = timeSlot?.get(1).toString().trim()

        val apiRequest = ApiRequest().apply {

            patient_plan_rel_id = this@PaymentBCPAppointmentDateTimeFragment.patientPlanRelId

            if (!isPhysiotherapist!!) {
                nutritionist_availability_date = DateTimeFormatter.date(calSelectedDate.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
                nutritionist_start_time = hhMMaToHHmmConvert(startTime)
                nutritionist_end_time = hhMMaToHHmmConvert(endTime)
            }

            if (isPhysiotherapist!!) {
                physiotherapist_availability_date = DateTimeFormatter.date(calSelectedDate.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
                physiotherapist_start_time = hhMMaToHHmmConvert(startTime)
                physiotherapist_end_time = hhMMaToHHmmConvert(endTime)
            }
        }

        doctorViewModel.updateBcpHCDetails(apiRequest)
    }

    private fun hhMMaToHHmmConvert(string: String): String {
        return DateTimeFormatter.date(string, DateTimeFormatter.FORMAT_hhmma)
            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_HHMM)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //getBcpTimeSlots
        doctorViewModel.getBcpTimeSlotsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    handleTimeSlotResponse(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                handleTimeSlotResponse(null, throwable.message ?: "")
                false
            })

        //updateBcpHCDetails
        doctorViewModel.updateBcpHCDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setResult(
                    responseBody.message
                )
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException){
                    throwable.message?.let { it1 -> showAppMessage(it1,AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleTimeSlotResponse(list: ArrayList<TimeSlotData>?, message: String = "") {
        timeSlotList.clear()
        list?.let { timeSlotList.addAll(it) }
        selectTimeSlotAdapter.notifyDataSetChanged()
        with(binding) {
            if (timeSlotList.isEmpty()) {
                textViewLabelChooseTime.isVisible = false
                recyclerViewTimeSlots.isVisible = false
                textViewNoData.isVisible = true
                textViewNoData.text = message
            } else {
                textViewLabelChooseTime.isVisible = true
                recyclerViewTimeSlots.isVisible = true
                textViewNoData.isVisible = false
            }
        }
    }
}