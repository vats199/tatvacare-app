package com.mytatva.patient.ui.appointment.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
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
import androidx.transition.AutoTransition
import androidx.transition.TransitionManager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.AppointmentTypes
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.databinding.AppointmentFragmentBookAppointmentBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.appointment.adapter.SelectTimeSlotAdapter
import com.mytatva.patient.ui.appointment.adapter.SelectTimeSlotMainAdapter
import com.mytatva.patient.ui.appointment.dialog.AppointmentConfirmedDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.WebViewPaymentFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.calendar.CalendarHelper
import com.mytatva.patient.utils.calendar.CalendarHelper.CALENDARHELPER_PERMISSION_REQUEST_CODE
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import devs.mulham.horizontalcalendar.HorizontalCalendar
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarListener
import devs.mulham.horizontalcalendar.utils.Utils
import java.util.*


class BookAppointmentsFragment : BaseFragment<AppointmentFragmentBookAppointmentBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    if (layoutDoctor.isVisible) {
                        validator.submit(editTextClinic).checkEmpty()
                            .errorMessage(getString(R.string.validation_select_clinic)).check()

                        validator.submit(editTextDoctor).checkEmpty()
                            .errorMessage(getString(R.string.validation_select_doctor)).check()
                    } else {
                        validator.submit(editTextCoach).checkEmpty()
                            .errorMessage(getString(R.string.validation_select_coach)).check()
                    }

                    validator.submit(editTextAppointmentType).checkEmpty()
                        .errorMessage(getString(R.string.validation_select_appointment_type))
                        .check()

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
    private val clinicList = arrayListOf<ClinicData>()
    private var selectedClinicId: String? = null
    private val clinicDoctorsList = arrayListOf<DoctorDetails>()
    private var selectedDoctorId: String? = null

    private var selectedAppointmentType: AppointmentTypes? = null

    //for health coach appointment parameters
    private var healthCoachListEmptyMessage = ""
    private val healthCoachList = ArrayList<HealthCoachData>()
    private var selectedCoachId: String? = null


    //private var selectedTimeSlot: String? = null
    private val appointmentTypes: ArrayList<AppointmentTypes> by lazy {
        ArrayList(AppointmentTypes.values().toList())
    }

    private val timeSlotList = arrayListOf<TimeSlotData>()
    var resumedTime = Calendar.getInstance().timeInMillis

    private val selectTimeSlotAdapter by lazy {
        SelectTimeSlotMainAdapter(timeSlotList)
    }

    var horizontalCalendar: HorizontalCalendar? = null

    private val calSelectedDate = Calendar.getInstance()

    private val doctorViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[DoctorViewModel::class.java]
    }

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private val selection by lazy {
        arguments?.getString(Common.BundleKey.SELECTION)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AppointmentFragmentBookAppointmentBinding {
        return AppointmentFragmentBookAppointmentBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BookAppointment)
        resumedTime = Calendar.getInstance().timeInMillis
        setUpRecyclerView()
    }

    override fun onPause() {
        super.onPause()
        //updateScreenTimeDurationInAnalytics()
    }


    override fun bindData() {
        with(binding) {
            layoutHC.isVisible = false
            editTextNote.isVisible = false
        }

        setUpToolbar()
        setUpViewListeners()
        setUpCalendar()

        setUpUIAndCallAPI()
    }

    private fun setUpUIAndCallAPI() {
        // handle for isToShowDoctorAppointmentModule
        if (session.user?.isToShowDoctorAppointmentModule == true) {
            binding.radioDoctor.isVisible = true
            binding.radioDoctor.isChecked = true
        } else {
            binding.radioDoctor.isVisible = false
            binding.radioCoach.isChecked = true
        }

        // handle default selection
        if (selection.isNullOrBlank().not() && selection == "HC") {
            binding.radioCoach.isChecked = true
        }

        //handle plan features as per final selection
        handlePlanChecks()

        // call APIs as per final selection
        if (binding.radioDoctor.isChecked) {
            clinicDoctorList()
        } else {
            //binding.radioCoach.callOnClick()
            onCoachSelect()
        }

    }

    private fun handlePlanChecks() {
        if (isFeatureAllowedAsPerPlan(
                PlanFeatures.book_appointments,
                subFeatureKey = PlanFeatures.book_appointments_doctor,
                needToShowDialog = false
            ).not()
            && isFeatureAllowedAsPerPlan(
                PlanFeatures.book_appointments,
                subFeatureKey = PlanFeatures.book_appointments_hc,
                needToShowDialog = false
            ).not()
        ) {
            // if both HC & doctor not allowed,
            // then show popup and go back, on callback
            isFeatureAllowedAsPerPlan(
                PlanFeatures.book_appointments,
                subFeatureKey = PlanFeatures.book_appointments_doctor,
                okCallback = {
                    navigator.goBack()
                }
            )

        } else if (binding.radioDoctor.isVisible && binding.radioDoctor.isChecked) {
            // doctor is visible and checked,
            // then check for doctor allowed or not,
            // if it is not allowed then coach is allowed, so check it.
            isFeatureAllowedAsPerPlan(
                PlanFeatures.book_appointments,
                subFeatureKey = PlanFeatures.book_appointments_doctor,
                okCallback = {
                    binding.radioCoach.isChecked = true
                }
            )
        } else if (binding.radioCoach.isChecked) {
            // HC is checked,
            // then check for HC is allowed or not,
            // if now allowed, then on ok callback will be there, so go back
            isFeatureAllowedAsPerPlan(
                PlanFeatures.book_appointments,
                subFeatureKey = PlanFeatures.book_appointments_hc,
                okCallback = {
                    navigator.goBack()
                }
            )
        }
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
                    .range(startDate, endDate).mode(HorizontalCalendar.Mode.DAYS)
                    /*.disableDates(object : HorizontalCalendarPredicate {
                        override fun test(date: Calendar?): Boolean {
                            return date?.after(Calendar.getInstance().apply {
                                add(Calendar.DAY_OF_YEAR,4)
                            }) ?: false
                        }

                        override fun style(): CalendarItemStyle? {
                            return CalendarItemStyle(Color.RED,null)
                        }
                    })*/.defaultSelectedDate(startDate).datesNumberOnScreen(7).build()
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
                        appointmentTimeSlot()
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
            radioDoctor.setOnClickListener { onViewClick(it) }
            radioCoach.setOnClickListener { onViewClick(it) }

            editTextCoach.setOnClickListener { onViewClick(it) }
            editTextClinic.setOnClickListener { onViewClick(it) }
            editTextDoctor.setOnClickListener { onViewClick(it) }
            editTextAppointmentType.setOnClickListener { onViewClick(it) }
            buttonConfirm.setOnClickListener { onViewClick(it) }
            textViewDate.setOnClickListener { onViewClick(it) }
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
            textViewToolbarTitle.text = getString(R.string.book_appointment_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
            buttonToolbarViewAll.visibility = View.GONE
            buttonToolbarViewAll.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonToolbarViewAll -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    AllAppointmentsFragment::class.java).start()
            }
            R.id.radioDoctor -> {
                if (isFeatureAllowedAsPerPlan(
                        PlanFeatures.book_appointments,
                        subFeatureKey = PlanFeatures.book_appointments_doctor,
                    )
                ) {
                    onDoctorSelect()
                } else {
                    binding.radioCoach.isChecked = true
                }
            }
            R.id.radioCoach -> {
                if (isFeatureAllowedAsPerPlan(
                        PlanFeatures.book_appointments,
                        subFeatureKey = PlanFeatures.book_appointments_doctor,
                    )
                ) {
                    onCoachSelect()
                } else {
                    binding.radioDoctor.isChecked = true
                }
            }
            R.id.textViewDate -> {
                navigator.pickDate({ view, year, month, dayOfMonth ->
                    val cal = Calendar.getInstance()
                    cal.set(year, month, dayOfMonth)
                    horizontalCalendar?.selectDate(cal, true)
                },
                    minimumDate = Calendar.getInstance().timeInMillis,
                    maximumDate = Calendar.getInstance().apply {
                        add(Calendar.YEAR, 5)
                    }.timeInMillis)
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.editTextCoach -> {
                showCoachSelection()
            }
            R.id.editTextClinic -> {
                showClinicSelection()
            }
            R.id.editTextDoctor -> {
                if (binding.editTextClinic.text.toString().trim().isBlank()) {
                    showMessage(getString(R.string.validation_select_clinic))
                } else {
                    showDoctorSelection()
                }
            }
            R.id.editTextAppointmentType -> {
                showAppointmentTypeSelection()
            }
            R.id.buttonConfirm -> {
                if (isValid) {
                    analytics.logEvent(analytics.USER_CONFIRM_BOOK_APPOINTMENT, Bundle().apply {
                        putString(analytics.PARAM_TYPE, if (binding.radioDoctor.isChecked) {
                            Common.AppointmentForType.DOCTOR
                        } else {
                            Common.AppointmentForType.HEALTHCOACH
                        })
                    }, screenName = AnalyticsScreenNames.BookAppointment)
                    addAppointment()
                }
            }
        }
    }

    private fun onDoctorSelect() {
        with(binding) {
            clearRequiredDataOnSwitchDoctorHC()
            TransitionManager.beginDelayedTransition(root,
                AutoTransition().setDuration(200))
            layoutDoctor.isVisible = true
            layoutHC.isVisible = false

            appointmentTimeSlot()
        }
    }

    private fun onCoachSelect() {
        with(binding) {
            clearRequiredDataOnSwitchDoctorHC()
            TransitionManager.beginDelayedTransition(root,
                AutoTransition().setDuration(200))
            layoutDoctor.isVisible = false
            layoutHC.isVisible = true
            if (healthCoachList.isEmpty()) {
                linkedHealthCoachList()
            }
            appointmentTimeSlot()
        }
    }

    private fun clearRequiredDataOnSwitchDoctorHC() {
        with(binding) {
            selectedAppointmentType = null
            binding.editTextAppointmentType.setText("")
        }
    }

    private fun showClinicSelection() {
        BottomSheet<ClinicData>().showBottomSheetDialog(requireActivity(),
            clinicList,
            "",
            object : BottomSheetAdapter.ItemListener<ClinicData> {
                override fun onItemClick(item: ClinicData, position: Int) {
                    selectedClinicId = item.clinic_id
                    binding.editTextClinic.setText(item.clinic_name)

                    clinicDoctorsList.clear()
                    item.doctor_details?.let { clinicDoctorsList.addAll(it) }

                    //clear doctor
                    selectedDoctorId = null
                    binding.editTextDoctor.setText("")
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<ClinicData>.MyViewHolder,
                    position: Int,
                    item: ClinicData,
                ) {
                    holder.textView.text = item.clinic_name
                }
            })
    }

    private fun showDoctorSelection() {
        BottomSheet<DoctorDetails>().showBottomSheetDialog(requireActivity(),
            clinicDoctorsList,
            "",
            object : BottomSheetAdapter.ItemListener<DoctorDetails> {
                override fun onItemClick(item: DoctorDetails, position: Int) {
                    selectedDoctorId = item.doctor_uniq_id
                    binding.editTextDoctor.setText(item.doctor_name)
                    appointmentTimeSlot()
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<DoctorDetails>.MyViewHolder,
                    position: Int,
                    item: DoctorDetails,
                ) {
                    holder.textView.text = item.doctor_name
                }
            })
    }

    private fun showCoachSelection() {
        BottomSheet<HealthCoachData>().showBottomSheetDialog(requireActivity(),
            healthCoachList,
            "",
            object : BottomSheetAdapter.ItemListener<HealthCoachData> {
                override fun onItemClick(item: HealthCoachData, position: Int) {
                    selectedCoachId = item.health_coach_id
                    binding.editTextCoach.setText(item.first_name.plus(" ").plus(item.last_name)
                        .plus(" (${item.role})"))
                    appointmentTimeSlot()
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<HealthCoachData>.MyViewHolder,
                    position: Int,
                    item: HealthCoachData,
                ) {
                    holder.textView.text =
                        item.first_name.plus(" ").plus(item.last_name).plus(" (${item.role})")
                }
            },
            noDataMessage = healthCoachListEmptyMessage)
    }

    private fun showAppointmentTypeSelection() {
        appointmentTypes.clear()
        if (binding.radioDoctor.isChecked) {
            appointmentTypes.addAll(AppointmentTypes.values().toList())
        } else {
            appointmentTypes.addAll(AppointmentTypes.values().toList())
            // remove clinic type for healthcoach
            appointmentTypes.remove(AppointmentTypes.CLINIC)
        }

        BottomSheet<AppointmentTypes>().showBottomSheetDialog(requireActivity(),
            appointmentTypes,
            "",
            object : BottomSheetAdapter.ItemListener<AppointmentTypes> {
                override fun onItemClick(item: AppointmentTypes, position: Int) {
                    selectedAppointmentType = item
                    binding.editTextAppointmentType.setText(item.title)
                    appointmentTimeSlot()
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<AppointmentTypes>.MyViewHolder,
                    position: Int,
                    item: AppointmentTypes,
                ) {
                    holder.textView.text = item.title
                }
            })
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun addAppointment() {
        val apiRequest = ApiRequest().apply {

            if (binding.radioDoctor.isChecked) {
                clinic_id = selectedClinicId
                doctor_id = selectedDoctorId
                type = Common.AppointmentForType.DOCTOR
            } else {
                health_coach_id = selectedCoachId
                type = Common.AppointmentForType.HEALTHCOACH
            }

            consulation_type = selectedAppointmentType?.typeKey
            appointment_date = DateTimeFormatter.date(calSelectedDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)
            time_slot = timeSlotList[SelectTimeSlotAdapter.selectedMainPosition].slots?.get(
                SelectTimeSlotAdapter.selectedPosition)
        }
        showLoader()
        doctorViewModel.addAppointment(apiRequest)
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun appointmentTimeSlot() {
        //clear existing if any
        if (timeSlotList.isNotEmpty()) {
            timeSlotList.clear()
            SelectTimeSlotAdapter.selectedMainPosition = -1
            SelectTimeSlotAdapter.selectedPosition = -1
            selectTimeSlotAdapter.notifyDataSetChanged()
        }

        if (binding.radioDoctor.isChecked) {
            // for doctor appointment api call
            if (selectedClinicId.isNullOrBlank().not() && selectedDoctorId.isNullOrBlank()
                    .not() && selectedAppointmentType != null
            ) {
                val apiRequest = ApiRequest().apply {
                    consulation_type = selectedAppointmentType?.typeKey
                    appointment_date = DateTimeFormatter.date(calSelectedDate.time)
                        .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)
                    type = Common.AppointmentForType.DOCTOR
                    clinic_id = selectedClinicId
                    doctor_id = selectedDoctorId
                }
                showLoader()
                doctorViewModel.appointmentTimeSlot(apiRequest)
            }

        } else if (binding.radioCoach.isChecked) {
            // for health coach appointment api call
            if (selectedCoachId.isNullOrBlank().not() && selectedAppointmentType != null) {

                val apiRequest = ApiRequest().apply {
                    consulation_type = selectedAppointmentType?.typeKey
                    appointment_date = DateTimeFormatter.date(calSelectedDate.time)
                        .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)
                    type = Common.AppointmentForType.HEALTHCOACH
                    health_coach_id = selectedCoachId
                }
                showLoader()
                doctorViewModel.appointmentTimeSlot(apiRequest)
            }
        }

        /*if (((binding.radioDoctor.isChecked && selectedClinicId.isNullOrBlank().not()
                    && selectedDoctorId.isNullOrBlank().not())
                    || (binding.radioCoach.isChecked && selectedCoachId.isNullOrBlank().not()))
            && selectedAppointmentType != null
        ) {
            val apiRequest = ApiRequest().apply {
                consulation_type = selectedAppointmentType?.typeKey
                appointment_date = DateTimeFormatter.date(calSelectedDate.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)

                type = if (binding.radioDoctor.isChecked) "D" else "H"

                if (binding.radioDoctor.isChecked) {
                    clinic_id = selectedClinicId
                    doctor_id = selectedDoctorId
                } else {
                    health_coach_id = selectedCoachId
                }
            }
            showLoader()
            doctorViewModel.appointmentTimeSlot(apiRequest)
        }*/
    }

    private fun clinicDoctorList() {
        val apiRequest = ApiRequest()
        showLoader()
        doctorViewModel.clinicDoctorList(apiRequest)
    }

    private fun linkedHealthCoachList() {
        val apiRequest = ApiRequest()
        // A for all HCs or C for chat not initiated HCs only
        apiRequest.list_type = "A"
        showLoader()
        authViewModel.linkedHealthCoachList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //addAppointmentLiveData
        doctorViewModel.addAppointmentLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                handleOnAddAppointmentSuccess(it)
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //appointmentTimeSlotLiveData
        doctorViewModel.appointmentTimeSlotLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                timeSlotList.clear()
                it.result?.time_slot?.let { it1 ->
                    /*timeSlotList.forEachIndexed { index, s ->
                        val startTime = s.trim().split("-").firstOrNull()
                        startTime
                    }*/
                    timeSlotList.addAll(it1)
                }
                selectTimeSlotAdapter.notifyDataSetChanged()
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //clinicDoctorListLiveData
        doctorViewModel.clinicDoctorListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                clinicList.clear()
                it.result?.let { it1 -> clinicList.addAll(it1) }

                //handle for auto fill clinic & linked doctor
                autoPopulateLinkedDoctor()
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //linkedHealthCoachListLiveData
        authViewModel.linkedHealthCoachListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            healthCoachList.clear()
            responseBody.data?.let { healthCoachList.addAll(it) }
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException) {
                healthCoachListEmptyMessage = throwable.message ?: ""
            }
            false
        })
    }//

    private fun autoPopulateLinkedDoctor() {
        with(binding) {
            val clinicItem = clinicList.firstOrNull {
                it.clinic_id == session.user?.patient_link_doctor_details?.firstOrNull()?.clinic_id
            }
            if (clinicItem != null) {
                selectedClinicId = clinicItem.clinic_id
                binding.editTextClinic.setText(clinicItem.clinic_name)

                clinicDoctorsList.clear()
                clinicItem.doctor_details?.let { clinicDoctorsList.addAll(it) }

                val linkedDoctor = clinicDoctorsList.firstOrNull {
                    it.doctor_name == session.user?.patient_link_doctor_details?.firstOrNull()?.name
                    /*it.doctor_uniq_id == session.user?.patient_link_doctor_details?.firstOrNull()?.doctor_uniq_id*/
                }

                //set clinic and doctor
                if (linkedDoctor != null) {
                    selectedDoctorId = linkedDoctor.doctor_uniq_id
                    binding.editTextDoctor.setText(linkedDoctor.doctor_name ?: "")
                }
            }
        }
    }

    var bookedAppointmentData: AppointmentData? = null
    private fun handleOnAddAppointmentSuccess(appointmentData: AppointmentData) {
        if (appointmentData.url.isNullOrBlank()
                .not() && selectedAppointmentType == AppointmentTypes.VIDEO
        ) {
            navigator.loadActivity(IsolatedFullActivity::class.java,
                WebViewPaymentFragment::class.java)
                .addBundle(bundleOf(Pair(Common.BundleKey.TITLE, "Payment"),
                    Pair(Common.BundleKey.URL, appointmentData.url)))
                .forResult(Common.RequestCode.REQUEST_APPOINTMENT_PAYMENT).start()
        } else {
            bookedAppointmentData = appointmentData
            showDialogToInsertCalendarEvent()
            //showAppointmentConfirmedDialog(appointmentData)
        }

    }

    private fun showDialogToInsertCalendarEvent() {
        navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_add_appointment_to_calendar),
            dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                override fun onYesClick() {
                    insertEventToCalendar()
                }

                override fun onNoClick() {
                    bookedAppointmentData?.let { showAppointmentConfirmedDialog(it) }
                    //navigator.goBack()
                }
            })
    }

    private fun insertEventToCalendar() {

        /*
          if (binding.radioDoctor.isChecked) {
                clinic_id = selectedClinicId
                doctor_id = selectedDoctorId
                type = Common.AppointmentForType.DOCTOR
            } else {
                health_coach_id = selectedCoachId
                type = Common.AppointmentForType.HEALTHCOACH
            }

            consulation_type = selectedAppointmentType?.typeKey
            appointment_date = DateTimeFormatter.date(calSelectedDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)
            time_slot = timeSlotList[SelectTimeSlotAdapter.selectedMainPosition].slots
                ?.get(SelectTimeSlotAdapter.selectedPosition)
         */

        if (CalendarHelper.haveCalendarWritePermissions(requireActivity())) {

            val timeSlot = timeSlotList[SelectTimeSlotAdapter.selectedMainPosition].slots?.get(
                SelectTimeSlotAdapter.selectedPosition)
            val startTime = timeSlot?.split("-")?.get(0)?.trim()
            val endTime = timeSlot?.split("-")?.get(1)?.trim()

            val appointmentStartDateTime = DateTimeFormatter.date(calSelectedDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash) + " " + startTime
            val appointmentEndDateTime = DateTimeFormatter.date(calSelectedDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash) + " " + endTime

            val calStart = Calendar.getInstance()
            calStart.timeInMillis = DateTimeFormatter.date(appointmentStartDateTime,
                DateTimeFormatter.FORMAT_dd_MM_yyyy_hmm_a).date?.time!!

            val calEnd = Calendar.getInstance()
            calEnd.timeInMillis = DateTimeFormatter.date(appointmentEndDateTime,
                DateTimeFormatter.FORMAT_dd_MM_yyyy_hmm_a).date?.time!!

            val hcDocName =
                if (binding.radioDoctor.isChecked) binding.editTextDoctor.text.toString().trim()
                else binding.editTextCoach.text.toString().trim()
            val appointmentType = binding.editTextAppointmentType.text.toString().trim()

            val appointmentDesc = "You have the $appointmentType appointment with $hcDocName"

            CalendarHelper.makeNewCalendarEntry(
                requireActivity(),
                title = "MyTatva Appointment",
                description = appointmentDesc,
                startTime = calStart.timeInMillis, endTime = calEnd.timeInMillis,
                allDay = false,
                hasAlarm = true,
                selectedReminderValue = 0,
            )

            // show confirmed dialog after added to calendar
            bookedAppointmentData?.let { showAppointmentConfirmedDialog(it) }
        } else {
            // request calendar permissions if not granted
            CalendarHelper.requestCalendarWritePermission(requireActivity())
        }
    }

    private fun showAppointmentConfirmedDialog(appointmentData: AppointmentData) {
        AppointmentConfirmedDialog(appointmentData).setCallback {
            navigator.goBack()
        }.show(requireActivity().supportFragmentManager,
            AppointmentConfirmedDialog::class.java.simpleName)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CALENDARHELPER_PERMISSION_REQUEST_CODE) {
            if (PermissionUtil.verifyPermissions(grantResults)) {
                insertEventToCalendar()
            } else {

                navigator.showAlertDialog("Calendar permission denied, you can allow it from settings",
                    dialogOkListener = object : BaseActivity.DialogOkListener {
                        override fun onClick() {
                            bookedAppointmentData?.let { showAppointmentConfirmedDialog(it) }
                        }
                    })

                /*if (ActivityCompat.shouldShowRequestPermissionRationale(requireActivity(),
                        Manifest.permission.WRITE_CALENDAR)
                ) {
                    // case 4 User has denied permission but not permanently
                    insertEventToCalendar()
                } else {
                    //Permission denied permanently.
                    //You can open Permission setting's page from here now.
                    navigator.showAlertDialog("Calendar permission denied, you can allow it from settings",
                        dialogOkListener = object : BaseActivity.DialogOkListener {
                            override fun onClick() {
                                bookedAppointmentData?.let { showAppointmentConfirmedDialog(it) }
                            }
                        })
                }*/
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == Common.RequestCode.REQUEST_APPOINTMENT_PAYMENT) {
            if (resultCode == Activity.RESULT_OK) {
                val appointmentData =
                    data?.getParcelableExtra<AppointmentData>(Common.BundleKey.APPOINTMENT_DATA)
                appointmentData?.let {
                    bookedAppointmentData = it
                    showDialogToInsertCalendarEvent()
                    //showAppointmentConfirmedDialog(it)
                }
            }
        }
    }

}