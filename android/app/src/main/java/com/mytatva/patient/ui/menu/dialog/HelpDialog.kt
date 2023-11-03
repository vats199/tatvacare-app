package com.mytatva.patient.ui.menu.dialog

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.QueryReasonData
import com.mytatva.patient.databinding.MenuDialogHelpBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.azure.UploadToAzureStorage
import com.mytatva.patient.utils.azure.UploadToAzureStorage.Companion.createFileName
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.ImageAndVideoPicker
import java.io.File

class HelpDialog : BaseDialogFragment<MenuDialogHelpBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextAbout)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_select_what_is_this_about))
                        .check()

                    validator.submit(editTextQuestion)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_enter_your_question))
                        .check()

                    /*validator.submit(editTextUploadAttachment)
                        .checkEmpty().errorMessage("Please upload attachment")
                        .check()*/

                    /*if (selectedImage.isNullOrBlank()) {
                        throw ApplicationException("Please upload attachment")
                    }*/
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    var selectedImage: String? = null
    var selectedQueryId: String? = null

    val queryReasonList = arrayListOf<QueryReasonData>()

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
    ): MenuDialogHelpBinding {
        return MenuDialogHelpBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.FaqQuery)
    }

    override fun bindData() {
        setViewListener()
        queryReasonList()
    }

    private fun setViewListener() {
        binding.apply {
            editTextAbout.setOnClickListener { onViewClick(it) }
            editTextUploadAttachment.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.editTextAbout -> {
                BottomSheet<QueryReasonData>().showBottomSheetDialog(requireActivity(),
                    queryReasonList,
                    "",
                    object : BottomSheetAdapter.ItemListener<QueryReasonData> {
                        override fun onItemClick(item: QueryReasonData, position: Int) {
                            selectedQueryId = item.query_reason_master_id
                            binding.editTextAbout.setText(item.query_reason)
                        }

                        override fun onBindViewHolder(
                            holder: BottomSheetAdapter<QueryReasonData>.MyViewHolder,
                            position: Int,
                            item: QueryReasonData,
                        ) {
                            holder.textView.text = item.query_reason
                        }
                    })
            }

            R.id.editTextUploadAttachment -> {
                showImagePicker()
            }

            R.id.buttonCancel -> {
                dismiss()
            }

            R.id.buttonSubmit -> {
                if (isValid) {
                    if (selectedImage.isNullOrBlank()) {
                        sendQuery()
                    } else {
                        uploadImageAndCallAPI()
                    }
                }
            }

            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }

    private fun showImagePicker() {
        ImageAndVideoPicker.newInstance()
            .pickImage(true) // set true to pick image, default false
            .pickVideo(false) // set true to pick video, default false
            .pickDocument(false) // set true to pick docs, default false
            //.allowMultiple() // to allow multiple selection, default single selection
            .setResult(imagePickerResult = object : ImageAndVideoPicker.ImageVideoPickerResult() {
                override fun onFail(message: String) {
                    showToast(message)
                }

                override fun onImagesSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first())) {
                        isPDF = false
                        selectedImage = list.first()
                        try {
                            binding.editTextUploadAttachment.setText(File(selectedImage ?: "").name)
                        } catch (e: Exception) {
                        }
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }

                override fun onDocumentSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first())) {
                        isPDF = true
                        selectedImage = list.first()
                        try {
                            binding.editTextUploadAttachment.setText(File(selectedImage ?: "").name)
                        } catch (e: Exception) {
                        }
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }
            }).show(childFragmentManager, ImageAndVideoPicker::class.java.name)
    }

    var isPDF = true

    private fun uploadImageAndCallAPI() {
        val fileName = if (isPDF)
            UploadToAzureStorage.PREFIX_SUPPORT + "$createFileName.pdf"
        else
            UploadToAzureStorage.PREFIX_SUPPORT + "$createFileName.jpg"

        showLoader()
        UploadToAzureStorage().uploadImage(
            this,
            selectedImage!!,
            UploadToAzureStorage.AZURE_CONTAINER,
            fileName,
            success = {
                //hideLoader()
                sendQuery(fileName)
            },
            failure = {
                hideLoader()
                showMessage(it)
            })
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun sendQuery(fileName: String? = null) {
        val apiRequest = ApiRequest().apply {
            query_reason_master_id = selectedQueryId
            description = binding.editTextQuestion.text.toString().trim()
            if (fileName.isNullOrBlank().not()) {
                query_docs = arrayListOf(fileName!!)
            } else {
                query_docs = arrayListOf()
            }
        }
        showLoader()
        authViewModel.sendQuery(apiRequest)
    }

    private fun queryReasonList() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.queryReasonList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.sendQueryLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //showMessage(responseBody.message)
                analytics.logEvent(
                    analytics.USER_SENT_QUERY,
                    screenName = AnalyticsScreenNames.FaqQuery
                )

                ThankYouMessageDialog().apply {
                    message = responseBody.message
                }.show(
                    requireActivity().supportFragmentManager,
                    ThankYouMessageDialog::class.java.simpleName
                )

                dismiss()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.queryReasonListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                queryReasonList.clear()
                responseBody.data?.let { queryReasonList.addAll(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

}