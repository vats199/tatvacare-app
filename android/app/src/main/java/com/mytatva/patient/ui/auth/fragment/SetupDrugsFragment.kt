package com.mytatva.patient.ui.auth.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.data.pojo.response.DosageTimeData
import com.mytatva.patient.data.pojo.response.GetPrescriptionDetailsResData
import com.mytatva.patient.databinding.AuthFragmentSetupDrugsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.adapter.SetUpDrugAddedMedicationAdapter
import com.mytatva.patient.ui.auth.adapter.SetUpDrugAddedPrescriptionAdapter
import com.mytatva.patient.ui.auth.adapter.SetUpDrugDosageTimeAdapter
import com.mytatva.patient.ui.auth.bottomsheet.SelectDaysBottomSheetDialog
import com.mytatva.patient.ui.auth.bottomsheet.SuggestedDosageBottomSheetDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.azure.UploadToAzureStorage
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.ImageAndVideoPicker
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*
import java.util.concurrent.TimeUnit


class SetupDrugsFragment : BaseFragment<AuthFragmentSetupDrugsBinding>() {

    private val isValidMedicationData: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextDrugName)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_empty_medicine_name))
                        .check()

                    validator.submit(editTextSuggestedDosage)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_dosage))
                        .check()

                    validator.submit(editTextStartDate)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_start_date))
                        .check()

                    validator.submit(editTextEndDate)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_end_date))
                        .check()

                    validator.submit(editTextDaysSelection)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_days))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    var calStart: Calendar? = null
    var calEnd: Calendar? = null
    var selectedDosageTimeData: DosageTimeData? = null
    var selectedDaysList: List<DaysData>? = null

    private val timeSlotList = arrayListOf<String>()
    private val setUpDrugDosageTimeAdapter by lazy {
        SetUpDrugDosageTimeAdapter(requireActivity() as BaseActivity, timeSlotList)
    }

    private val addedMedicationList = arrayListOf<ApiRequestSubData>()
    private val setUpDrugAddedMedicationAdapter by lazy {
        SetUpDrugAddedMedicationAdapter(addedMedicationList)
    }

    private val addedPrescriptionList = arrayListOf<TempDataModel>()
    private val setUpDrugAddedPrescriptionAdapter by lazy {
        SetUpDrugAddedPrescriptionAdapter(addedPrescriptionList)
    }


    val daysDataList = arrayListOf<DaysData>()
    val dosateTimeList = arrayListOf<DosageTimeData>()
    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSetupDrugsBinding {
        return AuthFragmentSetupDrugsBinding.inflate(inflater, container, attachToRoot)
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SetUpDrugs)
        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_UPDATE_PRESCRIPTION, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.SetUpDrugs)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()

        getDaysList()
        doseList()

        setDefaultStartDate()

        if (activity is IsolatedFullActivity) {
            getPrescriptionDetails()
            //edit time
            with(binding) {
                textViewSkipForNow.visibility = View.GONE
                buttonNext.text = getString(R.string.setup_drugs_button_update)
            }
        }
    }

    private fun setDefaultStartDate() {
        calStart = Calendar.getInstance()
        binding.editTextStartDate.setText(
            DateTimeFormatter.date(calStart!!.time)
                .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        )

        // set default end date of after one month on select start date
        calEnd = Calendar.getInstance()
        calEnd?.timeInMillis = calStart?.timeInMillis!!
        calEnd?.add(Calendar.MONTH, 1)
        binding.editTextEndDate.setText(
            DateTimeFormatter.date(calEnd!!.time)
                .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        )
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewDosageTime.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = setUpDrugDosageTimeAdapter
        }

        binding.recyclerViewMedications.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = setUpDrugAddedMedicationAdapter
        }

        binding.recyclerViewPrescription.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = setUpDrugAddedPrescriptionAdapter
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewBack.setOnClickListener { onViewClick(it) }
            editTextDrugName.setOnClickListener { onViewClick(it) }
            editTextSuggestedDosage.setOnClickListener { onViewClick(it) }
            textViewAddAnotherMedication.setOnClickListener { onViewClick(it) }
            editTextUploadPhoto.setOnClickListener { onViewClick(it) }
            textViewAddMorePrescription.setOnClickListener { onViewClick(it) }
            buttonNext.setOnClickListener { onViewClick(it) }
            textViewSkipForNow.setOnClickListener { onViewClick(it) }
            editTextStartDate.setOnClickListener { onViewClick(it) }
            editTextEndDate.setOnClickListener { onViewClick(it) }
            editTextDaysSelection.setOnClickListener { onViewClick(it) }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewBack -> {
                navigator.goBack()
            }
            R.id.editTextDrugName -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SearchMedicineFragment::class.java)
                    .forResult(Common.RequestCode.REQUEST_SELECT_MEDICINE)
                    .start()
            }
            R.id.editTextSuggestedDosage -> {
                activity?.supportFragmentManager?.let {
                    SuggestedDosageBottomSheetDialog(dosateTimeList) { dosageTimeData: DosageTimeData ->
                        selectedDosageTimeData = dosageTimeData
                        binding.editTextSuggestedDosage.setText(selectedDosageTimeData?.dose_type
                            ?: "")

                        timeSlotList.clear()
                        selectedDosageTimeData?.suggested_time_slots?.let { it1 ->
                            timeSlotList.addAll(it1)
                        }
                        setUpDrugDosageTimeAdapter.notifyDataSetChanged()

                    }.show(it, SuggestedDosageBottomSheetDialog::class.java.simpleName)
                }
            }
            R.id.editTextDaysSelection -> {
                activity?.supportFragmentManager?.let {
                    SelectDaysBottomSheetDialog(daysDataList) { selectedDaysList: List<DaysData> ->
                        this.selectedDaysList = selectedDaysList

                        if (selectedDaysList.isNotEmpty()) {
                            val sbDays = StringBuilder()
                            selectedDaysList.forEach { daysData ->
                                sbDays.append(daysData.day?.take(3)).append(",")
                            }
                            binding.editTextDaysSelection.setText(sbDays.removeSuffix(",")
                                .toString())
                        } else {
                            binding.editTextDaysSelection.setText("")
                        }

                    }.show(it, SelectDaysBottomSheetDialog::class.java.simpleName)
                }
            }
            R.id.textViewAddAnotherMedication -> {
                if (isValidMedicationData) {
                    addMedicationDataToList()
                }
            }
            R.id.textViewAddMorePrescription -> {
                ImageAndVideoPicker.newInstance()
                    .pickImage(true) // set true to pick image, default false
                    .pickVideo(false) // set true to pick video, default false
                    .pickDocument(false) // set true to pick docs, default false
                    //.allowMultiple() // to allow multiple selection, default single selection
                    .setResult(imagePickerResult = object :
                        ImageAndVideoPicker.ImageVideoPickerResult() {
                        override fun onFail(message: String) {
                            showMessage(message)
                        }

                        override fun onImagesSelected(list: ArrayList<String>) {
                            if (ImageAndVideoPicker.isValidFileSize(list.first())) {
                                addedPrescriptionList.add(TempDataModel(imagePath = list.first()))
                                setUpDrugAddedPrescriptionAdapter.notifyItemInserted(
                                    addedPrescriptionList.lastIndex)

                                binding.apply {
                                    groupBeforeAddPrescription.visibility = View.GONE
                                    groupAfterAddedPrescription.visibility = View.VISIBLE
                                }
                            } else {
                                showMessage(getString(R.string.validation_invalid_file_size))
                            }
                        }
                    }).show(childFragmentManager, ImageAndVideoPicker::class.java.name)

            }
            R.id.buttonNext -> {
                if (addedMedicationList.isEmpty()) {
                    showMessage(getString(R.string.validation_add_medication))
                }/* else if (addedPrescriptionList.isEmpty()) {
                    showMessage("Please add prescription image")
                }*/ else {

                    if (activity is IsolatedFullActivity) {
                        if (addedPrescriptionList.isEmpty()) {
                            updatePrescription(listOf())
                        } else {
                            handleUploadPrescriptionForUpdate { uplodedList ->
                                activity?.runOnUiThread {
                                    updatePrescription(uplodedList)
                                }
                            }
                        }
                    } else {
                        if (addedPrescriptionList.isEmpty()) {
                            addPrescription(listOf())
                        } else {
                            handleUploadPrescription { uplodedList ->
                                activity?.runOnUiThread {
                                    addPrescription(uplodedList)
                                }
                            }
                        }
                    }

                }
            }
            R.id.textViewSkipForNow -> {
                handleAuthNavigation()
            }
            R.id.editTextStartDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    calStart = Calendar.getInstance()
                    calStart?.set(year, month, dayOfMonth)
                    binding.editTextStartDate.setText(
                        DateTimeFormatter.date(calStart!!.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                    )

                    // set default end date of after one month on select start date
                    calEnd = Calendar.getInstance()
                    calEnd?.timeInMillis = calStart?.timeInMillis!!
                    calEnd?.add(Calendar.MONTH, 1)
                    binding.editTextEndDate.setText(
                        DateTimeFormatter.date(calEnd!!.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                    )
                }, Calendar.getInstance().timeInMillis, 0L)
            }
            R.id.editTextEndDate -> {
                if (binding.editTextStartDate.text.toString().isNotBlank()) {
                    navigator.pickDate({ _, year, month, dayOfMonth ->
                        calEnd = Calendar.getInstance()
                        calEnd?.set(year, month, dayOfMonth)
                        binding.editTextEndDate.setText(
                            DateTimeFormatter.date(calEnd!!.time)
                                .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                        )
                    }, calStart?.timeInMillis ?: 0L, 0L)
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun addMedicationDataToList() {
        val apiRequestSubData = ApiRequestSubData().apply {
            dose_id = selectedDosageTimeData?.dose_master_id
            dose_name = selectedDosageTimeData?.dose_type
            medecine_id = currentSelectedMedicineId ?: ""
            medicine_name = binding.editTextDrugName.text.toString().trim()
            start_date = DateTimeFormatter.date(calStart?.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
            end_date = DateTimeFormatter.date(calEnd?.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)

            val sbDayKeys = StringBuilder()
            selectedDaysList?.forEach { daysData ->
                sbDayKeys.append(daysData.days_keys?.take(3)).append(",")
            }
            dose_days = sbDayKeys.removeSuffix(",").toString()
            dose_time_slot = ArrayList(timeSlotList)
        }
        addedMedicationList.add(apiRequestSubData)
        setUpDrugAddedMedicationAdapter.notifyItemInserted(addedMedicationList.lastIndex)

        with(binding) {
            editTextDrugName.setText("")
            editTextSuggestedDosage.setText("")
            timeSlotList.clear()
            setUpDrugDosageTimeAdapter.notifyDataSetChanged()
            editTextStartDate.setText("")
            editTextEndDate.setText("")
            editTextDaysSelection.setText("")
        }
    }

    var imageCount = 0
    private fun handleUploadPrescription(success: (uplodedList: List<String>) -> Unit) {
        imageCount = 0
        val uploadedList = arrayListOf<String>()
        showLoader()
        for (i in 0 until addedPrescriptionList.size) {

            /*if (addedPrescriptionList[i].isAlreadyUploaded) {
                imageCount++
                uploadedList.add(addedPrescriptionList[i].document_name ?: "")
                if (addedPrescriptionList.size == uploadedList.size) {
                    hideLoader()
                    success.invoke(uploadedList)
                }
            } else {*/

            val fileName = UploadToAzureStorage.PREFIX_DRUG + "$createFileName.jpg"
            UploadToAzureStorage().uploadImage(
                this,
                addedPrescriptionList[i].imagePath,
                UploadToAzureStorage.AZURE_CONTAINER,
                fileName,
                {
                    imageCount++
                    uploadedList.add(fileName)
                    if (addedPrescriptionList.size == uploadedList.size) {
                        hideLoader()
                        success.invoke(uploadedList)
                    }
                },
                {
                    hideLoader()
                    showMessage(it)
                })

            /*}*/
        }
    }

    private fun handleUploadPrescriptionForUpdate(success: (uplodedList: List<ApiRequestSubData>) -> Unit) {
        imageCount = 0
        val uploadedList = arrayListOf<ApiRequestSubData>()
        showLoader()
        for (i in 0 until addedPrescriptionList.size) {

            if (addedPrescriptionList[i].isAlreadyUploaded) {

                imageCount++
                uploadedList.add(ApiRequestSubData().apply {
                    prescription_name = addedPrescriptionList[i].document_name ?: ""
                    prescription_document_rel_id =
                        addedPrescriptionList[i].prescription_document_rel_id ?: ""
                })
                if (addedPrescriptionList.size == uploadedList.size) {
                    hideLoader()
                    success.invoke(uploadedList)
                }

            } else {

                val fileName = UploadToAzureStorage.PREFIX_DRUG + "$createFileName.jpg"
                UploadToAzureStorage().uploadImage(
                    this,
                    addedPrescriptionList[i].imagePath,
                    UploadToAzureStorage.AZURE_CONTAINER,
                    fileName,
                    {
                        imageCount++
                        uploadedList.add(ApiRequestSubData().apply {
                            prescription_name = fileName
                        })
                        if (addedPrescriptionList.size == uploadedList.size) {
                            hideLoader()
                            success.invoke(uploadedList)
                        }
                    },
                    {
                        hideLoader()
                        showMessage(it)
                    })

            }
        }
    }

    var currentSelectedMedicineId: String? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (data != null && resultCode == Activity.RESULT_OK) {
            if (requestCode == Common.RequestCode.REQUEST_SELECT_MEDICINE) {
                val medicineName = data.getStringExtra(Common.BundleKey.MEDICINE_NAME)
                currentSelectedMedicineId = data.getStringExtra(Common.BundleKey.MEDICINE_ID)
                binding.editTextDrugName.setText(medicineName ?: "")
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getDaysList() {
        val apiRequest = ApiRequest()
        //showLoader()
        authViewModel.getDaysList(apiRequest)
    }

    private fun doseList() {
        val apiRequest = ApiRequest()
        //showLoader()
        authViewModel.doseList(apiRequest)
    }

    private fun addPrescription(list: List<String>) {
        val apiRequest = ApiRequest()

        //medicine_details - drug details with date time
        apiRequest.medicine_details = addedMedicationList

        //document_name - uploaded prescription names details
        if (list.isNotEmpty()) {
            val prescriptionsList = arrayListOf<ApiRequestSubData>()
            list.forEach {
                prescriptionsList.add(ApiRequestSubData().apply {
                    prescription_name = it
                })
            }
            apiRequest.document_name = prescriptionsList
        }

        showLoader()
        authViewModel.addPrescription(apiRequest)
    }

    private fun getPrescriptionDetails() {
        val apiRequest = ApiRequest().apply {
            is_active_medicine_only = "N"
        }
        //showLoader()
        authViewModel.getPrescriptionDetails(apiRequest)
    }

    private fun updatePrescription(list: List<ApiRequestSubData>) {
        val apiRequest = ApiRequest()

        //medicine_details - drug details with date time
        apiRequest.medicine_details = addedMedicationList

        //document_name - uploaded prescription names details
        if (list.isNotEmpty()) {
            apiRequest.document_name = ArrayList(list)
        }

        showLoader()
        authViewModel.updatePrescription(apiRequest)
    }

    private fun handleAuthNavigation() {
        navigator.loadActivity(AuthActivity::class.java, SetupHeightWeightFragment::class.java)
            //.byFinishingCurrent()
            .start()
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.getDaysListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                daysDataList.clear()
                responseBody.data?.let { daysDataList.addAll(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.doseListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                dosateTimeList.clear()
                responseBody.data?.let { dosateTimeList.addAll(it) }

                /*dosateTimeList.forEachIndexed { index, dosageTimeData ->
                    if (index == 0) {
                        dosateTimeList[index].dose_type =
                            "${dosateTimeList[index].dose_type} time per days"
                    } else {
                        dosateTimeList[index].dose_type =
                            "${dosateTimeList[index].dose_type} times per days"
                    }
                }*/
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.addPrescriptionLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.NEW_USER_MEDICINE_ADDED, screenName = AnalyticsScreenNames.SetUpDrugs)
                if (activity is IsolatedFullActivity) {
                    navigator.goBack()
                } else {
                    // auth flow
                    handleAuthNavigation()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.getPrescriptionDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.updatePrescriptionLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(getPrescriptionDetailsResData: GetPrescriptionDetailsResData) {

        getPrescriptionDetailsResData.medicine_data?.forEachIndexed { index, medicineResData ->
            val apiRequestSubData = ApiRequestSubData().apply {
                patient_dose_rel_id = medicineResData.patient_dose_rel_id
                dose_id = medicineResData.dose_id
                dose_name = medicineResData.dose_type
                medicine_name = medicineResData.medicine_name
                medecine_id = medicineResData.medecine_id
                start_date = medicineResData.start_date
                end_date = medicineResData.end_date
                dose_days = medicineResData.dose_days
                dose_time_slot = medicineResData.dose_time_slot
            }
            addedMedicationList.add(apiRequestSubData)
        }
        setUpDrugAddedMedicationAdapter.notifyDataSetChanged()


        getPrescriptionDetailsResData.document_data?.forEachIndexed { index, documentResData ->
            addedPrescriptionList.add(TempDataModel().apply {
                isAlreadyUploaded = true
                imagePath = documentResData.document_url ?: ""
                prescription_document_rel_id = documentResData.prescription_document_rel_id
                document_name = documentResData.document_name
            })
        }
        setUpDrugAddedPrescriptionAdapter.notifyDataSetChanged()

    }
}