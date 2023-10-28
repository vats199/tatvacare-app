package com.mytatva.patient.ui.careplan.dialog

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ZydusInfoData
import com.mytatva.patient.databinding.CarePlanDialogRequestCallbackHospitalInfoBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.openBrowser

class RequestCallbackHospitalInfoDialog(/*val callback: () -> Unit*/) :
    BaseDialogFragment<CarePlanDialogRequestCallbackHospitalInfoBinding>() {

    var zydusInfoData: ZydusInfoData? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanDialogRequestCallbackHospitalInfoBinding {
        return CarePlanDialogRequestCallbackHospitalInfoBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        //analytics.setScreenName(AnalyticsScreenNames.RequestCallBack)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        getZydusInfo()
        setViewListener()
    }


    private fun setViewListener() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonListOfTest.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonListOfTest -> {
                //callback.invoke()
                zydusInfoData?.zydus_pdf?.let {
                    requireActivity().openBrowser(it)
                }
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getZydusInfo() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.getZydusInfo(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.getZydusInfoLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                zydusInfoData = responseBody.data
                if (isAdded) {
                    setData()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handle
     * *****************************************************
     **/
    private fun setData() {
        zydusInfoData?.let {
            with(binding) {
                textViewHospitalName.text = it.zydus_name
                textViewContact.text = it.zydus_phone
                textViewAddress.text = it.zydus_address
            }
        }
    }

}