package com.mytatva.patient.ui.appointment.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.AppointmentTypes
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.databinding.AppointmentFragmentAllAppointmentsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.VideoActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.HistoryAppointmentAdapter
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.loadCircle
import java.util.*

class AllAppointmentsFragment : BaseFragment<AppointmentFragmentAllAppointmentsBinding>() {

    //pagination params
    var page = 1
    internal var isLoading = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null

    fun resetPagingData() {
        isLoading = false
        page = 1
        previousTotal = 0
    }

    private val selection by lazy {
        arguments?.getString(Common.BundleKey.SELECTION)
    }

    private var selectedType = Common.AppointmentForType.DOCTOR

    private val appointmentList = arrayListOf<AppointmentData>()
    var resumedTime = Calendar.getInstance().timeInMillis

    private val historyAppointmentAdapter by lazy {
        HistoryAppointmentAdapter(appointmentList, navigator,
            object : HistoryAppointmentAdapter.AdapterListener {
                override fun onCancelClick(position: Int) {
                    currentClickPosition = position
                    navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_cancel_appointment),
                        dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                            override fun onYesClick() {
                                cancelAppointment(appointmentList[position])
                            }

                            override fun onNoClick() {

                            }
                        })
                }

                override fun onJoinVideoClick(position: Int) {

                    if (VideoActivity.isPictureInPictureModeActive) {
                        //just re-launch the activity to open activity again to view in full mode

                        navigator.loadActivity(VideoActivity::class.java).start()

                    } else {
                        currentClickPosition = position
                        getVoiceToken(appointmentList[position])

                        analytics.logEvent(analytics.APPOINTMENT_HISTORY_JOIN_VIDEO,
                            Bundle().apply {
                                putString(analytics.PARAM_APPOINTMENT_ID,
                                    appointmentList[currentClickPosition].appointment_id)
                                putString(analytics.PARAM_TYPE,
                                    appointmentList[currentClickPosition].type)
                            },
                            screenName = AnalyticsScreenNames.AppointmentList)
                    }
                }
            })
    }

    private var currentClickPosition = -1

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
    ): AppointmentFragmentAllAppointmentsBinding {
        return AppointmentFragmentAllAppointmentsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AppointmentList)
        resumedTime = Calendar.getInstance().timeInMillis

        resetPagingData()
        getAppointmentList()
    }

    override fun bindData() {
        handleDefaultSelection()


        setDoctorDetails()
        setUpToolbar()
        setUpViewListeners()
        setUpRecyclerView()
    }

    private fun handleDefaultSelection() {
        if(session.user?.isToShowDoctorAppointmentModule == true) {
            // when isToShowDoctorAppointmentModule, then handle as per selection,
            // else only HC will be there in dropdown, so no need to handle

            if (selection.isNullOrBlank().not()) {
                //if selection is not null already handled from deeplink or bundle data,
                //then show selection based on that "selection" value
                if (selection == "HC") {
                    selectedType = Common.AppointmentForType.HEALTHCOACH
                    binding.editTextAppointmentType.setText(
                        resources.getStringArray(R.array.appointmentFor)
                            .last()
                    )
                } else {
                    selectedType = Common.AppointmentForType.DOCTOR
                    binding.editTextAppointmentType.setText(
                        resources.getStringArray(R.array.appointmentFor)
                            .first()
                    )
                }
            } else {
                //else default show HC selected if any HC is assigned to this patient
                //else doctor will be selected
                if (session.user?.hc_list.isNullOrEmpty().not()) {
                    selectedType = Common.AppointmentForType.HEALTHCOACH
                    binding.editTextAppointmentType.setText(
                        resources.getStringArray(R.array.appointmentFor)
                            .last()
                    )
                } else {
                    selectedType = Common.AppointmentForType.DOCTOR
                    binding.editTextAppointmentType.setText(
                        resources.getStringArray(R.array.appointmentFor)
                            .first()
                    )
                }
            }

        } else {
            //select HC default, when isToShowDoctorAppointmentModule is false
            selectedType = Common.AppointmentForType.HEALTHCOACH
            binding.editTextAppointmentType.setText(
                resources.getStringArray(R.array.appointmentFor)
                    .last()
            )
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                getAppointmentList()
            }
            editTextAppointmentType.setOnClickListener { onViewClick(it) }
            buttonBookAppointment.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        linearLayoutManager =
            LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        binding.recyclerViewAppointment.apply {
            layoutManager = linearLayoutManager
            adapter = historyAppointmentAdapter
        }

        binding.recyclerViewAppointment.addOnScrollListener(object :
            RecyclerView.OnScrollListener() {
            override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {

            }

            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                //pagination
                val visibleItemCount = recyclerView.childCount
                val totalItemCount = linearLayoutManager!!.itemCount
                val pastVisibleItems = linearLayoutManager!!.findFirstVisibleItemPosition()
                if (isLoading) {
                    if (totalItemCount > previousTotal) {
                        isLoading = false
                        previousTotal = totalItemCount
                    }
                }
                if (!isLoading && totalItemCount - visibleItemCount <= pastVisibleItems + 0) {
                    // End has been reached
                    page++
                    getAppointmentList()
                    isLoading = true
                }
            }
        })
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.all_appointment_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
            buttonToolbarBook.visibility = View.VISIBLE
            buttonToolbarBook.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            /*R.id.buttonBookAppointment*/
            R.id.buttonToolbarBook -> {
                analytics.logEvent(analytics.USER_CLICK_BOOK_APPOINTMENT, screenName = AnalyticsScreenNames.AppointmentList)
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java)
                        .start()
                }
            }
            R.id.editTextAppointmentType -> {
                showAppointForSelection()
            }
        }
    }

    private fun showAppointForSelection() {

        val listAppointmentFor = ArrayList(resources.getStringArray(R.array.appointmentFor).toList())

        if (session.user?.isToShowDoctorAppointmentModule?.not() == true) {
            listAppointmentFor.removeIf { it == "Doctor" }
        }

        BottomSheet<String>().showBottomSheetDialog(requireActivity(),
            listAppointmentFor,
            "",
            object : BottomSheetAdapter.ItemListener<String> {
                override fun onItemClick(item: String, position: Int) {
                    selectedType =
                        if (item == "Doctor") Common.AppointmentForType.DOCTOR
                        else Common.AppointmentForType.HEALTHCOACH
                    binding.editTextAppointmentType.setText(item)

                    resetPagingData()
                    getAppointmentList()
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<String>.MyViewHolder,
                    position: Int,
                    item: String,
                ) {
                    holder.textView.text = item
                }
            })
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getAppointmentList() {
        val apiRequest = ApiRequest().apply {
            page_no = this@AllAppointmentsFragment.page.toString()
            type = selectedType
        }
        if (page == 1) {
            binding.swipeRefreshLayout.isRefreshing = true
            //showLoader()
        }

        if (page == 1) {
            if (selectedType == Common.AppointmentForType.DOCTOR) {
                analytics.logEvent(analytics.APPOINTMENT_HISTORY_DOCTOR, screenName = AnalyticsScreenNames.AppointmentList)
            } else {
                analytics.logEvent(analytics.APPOINTMENT_HISTORY_COACH, screenName = AnalyticsScreenNames.AppointmentList)
            }
        }

        doctorViewModel.getAppointmentList(apiRequest)
    }

    private fun cancelAppointment(appointmentData: AppointmentData) {
        val apiRequest = ApiRequest().apply {
            appointment_id = appointmentData.appointment_id
            type = appointmentData.type
            if (type == Common.AppointmentForType.DOCTOR) {
                clinic_id = appointmentData.clinic_id
                doctor_id = appointmentData.doctor_id
                type_consult =
                    if (appointmentData.appointment_type?.contains(AppointmentTypes.CLINIC.typeKey) == true)
                        AppointmentTypes.CLINIC.typeKey
                    else
                        AppointmentTypes.VIDEO.typeKey
                appointment_date = DateTimeFormatter
                    .date(appointmentData.appointment_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)
                appointment_slot = appointmentData.appointment_time
            }
        }
        doctorViewModel.cancelAppointment(apiRequest)
    }

    private fun getVoiceToken(appointmentData: AppointmentData) {
        val apiRequest = ApiRequest().apply {
            appointment_id = appointmentData.appointment_id
            room_id = appointmentData.room_id
            room_name = appointmentData.room_name
            type = appointmentData.type
        }
        showLoader()
        doctorViewModel.getVoiceToken(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //getAppointmentListLiveData
        doctorViewModel.getAppointmentListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (isAdded) {
                    binding.swipeRefreshLayout.isRefreshing = false
                    if (page == 1) {
                        appointmentList.clear()
                        //setDoctorDetails(responseBody.data?.link_doctor_details)
                    }

                    with(binding) {
                        textViewNoData.visibility = View.GONE
                        recyclerViewAppointment.visibility = View.VISIBLE
                    }

                    appointmentList.addAll(responseBody.data?.appointment_list ?: arrayListOf())
                    historyAppointmentAdapter.notifyDataSetChanged()
                }
            },
            onError = { throwable ->
                hideLoader()
                if (isAdded) {
                    binding.swipeRefreshLayout.isRefreshing = false
                    if (page == 1) {
                        with(binding) {
                            textViewNoData.visibility = View.VISIBLE
                            recyclerViewAppointment.visibility = View.GONE
                            textViewNoData.text = throwable.message
                        }
                    }
                }
                false
            })

        //cancelAppointmentLiveData
        doctorViewModel.cancelAppointmentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                analytics.logEvent(analytics.APPOINTMENT_HISTORY_REQ_CANCEL, Bundle().apply {
                    putString(analytics.PARAM_APPOINTMENT_ID,
                        appointmentList[currentClickPosition].appointment_id)
                    putString(analytics.PARAM_TYPE,
                        appointmentList[currentClickPosition].type)
                }, screenName = AnalyticsScreenNames.AppointmentList)

                resetPagingData()
                getAppointmentList()
            },
            onError = { throwable ->
                hideLoader()
                false
            })

        //getVoiceTokenLiveData
        doctorViewModel.getVoiceTokenLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.token?.let {
                    navigator.loadActivity(VideoActivity::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.ACCESS_TOKEN, it),
                            Pair(Common.BundleKey.ROOM_ID,
                                appointmentList[currentClickPosition].room_id),
                            Pair(Common.BundleKey.ROOM_SID,
                                appointmentList[currentClickPosition].room_sid),
                            Pair(Common.BundleKey.ROOM_NAME,
                                appointmentList[currentClickPosition].room_name),
                            Pair(Common.BundleKey.DOCTOR_HC_NAME,
                                appointmentList[currentClickPosition].doctor_name)
                        )).start()
                }
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

    private fun setDoctorDetails() {
        session.user?.patient_link_doctor_details?.firstOrNull()?.let {
            with(binding) {
                imageViewProfile.loadCircle(it.profile_image ?: "")
                textViewDoctorName.text = it.name
                textViewDegree.text = "${it.specialization} - ${it.qualification}"
            }
        }
    }

    override fun onPause() {
        super.onPause()
        //updateScreenTimeDurationInAnalytics()
    }


}