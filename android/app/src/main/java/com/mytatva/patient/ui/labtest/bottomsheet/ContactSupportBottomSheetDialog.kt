package com.mytatva.patient.ui.labtest.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.LabtestBottomsheetContactSupportBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel

class ContactSupportBottomSheetDialog(
    val orderMasterId: String,
    val callback: (message: String) -> Unit,
) : BaseBottomSheetDialogFragment<LabtestBottomsheetContactSupportBinding>() {

    /*WeekDaysData.values().toList()*/

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestBottomsheetContactSupportBinding {
        return LabtestBottomsheetContactSupportBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
        setViewListener()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    private fun setViewListener() {
        binding.apply {
            textViewCancel.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewCancel -> {
                dismiss()
            }
            R.id.buttonSubmit -> {
                if (binding.editTextQuery.text.toString().trim().isBlank()) {
                    showMessage(getString(R.string.validation_empty_query))
                } else {
                    contactSupport()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun contactSupport() {
        val apiRequest = ApiRequest().apply {
            order_master_id = orderMasterId
            message = binding.editTextQuery.text.toString().trim()
        }
        showLoader()
        doctorViewModel.contactSupport(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //contactSupportLiveData
        doctorViewModel.contactSupportLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                callback.invoke(responseBody.message)
                dismiss()
            },
            onError = { throwable ->
                hideLoader()
                showMessage(throwable.message ?: "")
                false
            })
    }
}