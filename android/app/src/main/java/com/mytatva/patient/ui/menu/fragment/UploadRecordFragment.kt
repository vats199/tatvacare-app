package com.mytatva.patient.ui.menu.fragment

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
import com.mytatva.patient.data.pojo.response.TestTypeData
import com.mytatva.patient.databinding.MenuFragmentUploadRecordBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.UploadRecordAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.azure.UploadToAzureStorage
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.ImageAndVideoPicker
import java.io.File


class UploadRecordFragment : BaseFragment<MenuFragmentUploadRecordBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextDocTitle)
                        .checkEmpty().errorMessage(getString(R.string.validation_enter_document_title))
                        .check()


                    validator.submit(editTextTestType)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_record_type))
                        .check()

                    if (docList.isEmpty()) {
                        throw ApplicationException(getString(R.string.validation_upload_one_doc))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private var selectedTestTypeId: String? = null
    private val testTypeList = arrayListOf<TestTypeData>()

    private val docList = arrayListOf<TempDataModel>()
    private val uploadRecordAdapter by lazy {
        UploadRecordAdapter(docList,
            object : UploadRecordAdapter.AdapterListener {
                override fun onRemoveClick(position: Int) {

                }
            })
    }

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
    ): MenuFragmentUploadRecordBinding {
        return MenuFragmentUploadRecordBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.UploadRecord)
        setUpRecyclerView()
    }

    override fun bindData() {
        setUpToolbar()
        testTypes()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonDone.setOnClickListener { onViewClick(it) }
            editTextTestType.setOnClickListener { onViewClick(it) }
            //editTextDocTitle.setOnClickListener { onViewClick(it) }
            imageViewCameraIcon.setOnClickListener { onViewClick(it) }
            textViewTakePicture.setOnClickListener { onViewClick(it) }
            buttonBrowse.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewDocs.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = uploadRecordAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.upload_record_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.editTextDocTitle -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SearchRecordTitleFragment::class.java)
                    .forResult(Common.RequestCode.REQUEST_SELECT_RECORD_TITLE)
                    .start()
            }
            R.id.editTextTestType -> {
                BottomSheet<TestTypeData>().showBottomSheetDialog(requireActivity(),
                    testTypeList,
                    "",
                    object : BottomSheetAdapter.ItemListener<TestTypeData> {
                        override fun onItemClick(item: TestTypeData, position: Int) {
                            selectedTestTypeId = item.test_type_id
                            binding.editTextTestType.setText(item.test_name)
                        }

                        override fun onBindViewHolder(
                            holder: BottomSheetAdapter<TestTypeData>.MyViewHolder,
                            position: Int,
                            item: TestTypeData,
                        ) {
                            holder.textView.text = item.test_name
                        }
                    })
            }
            R.id.imageViewCameraIcon -> {
                showImagePicker()
            }
            R.id.textViewTakePicture -> {
                showImagePicker()
            }
            R.id.buttonBrowse -> {
                showImagePicker()
            }
            R.id.buttonDone -> {
                if (isValid) {
                    handleUploadDocs { uploadedList ->
                        updatedRecords(uploadedList)
                    }
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (data != null && resultCode == Activity.RESULT_OK) {
            if (requestCode == Common.RequestCode.REQUEST_SELECT_RECORD_TITLE) {
                val title = data.getStringExtra(Common.BundleKey.TITLE)
                binding.editTextDocTitle.setText(title ?: "")
            }
        }
    }

    private fun showImagePicker() {
        ImageAndVideoPicker.newInstance()
            .pickImage(true)
            .pickVideo(false)
            .pickDocument(true)
            //.allowMultiple()
            .setResult(imagePickerResult = object : ImageAndVideoPicker.ImageVideoPickerResult() {
                override fun onFail(message: String) {
                    showMessage(message)
                }

                override fun onImagesSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first()/*, 4*/)) {
                        docList.add(TempDataModel(imagePath = list.first(),
                            name = File(list.first()).name ?: ""))
                        uploadRecordAdapter.notifyItemInserted(docList.lastIndex)
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }

                override fun onDocumentSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first()/*, 4*/)) {
                        docList.add(TempDataModel(imagePath = list.first(),
                            name = File(list.first()).name ?: "",
                            isPdfDocFile = true))
                        uploadRecordAdapter.notifyItemInserted(docList.lastIndex)
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }

            }).show(childFragmentManager, ImageAndVideoPicker::class.java.name)
    }

    var imageCount = 0
    private fun handleUploadDocs(success: (uploadedList: List<String>) -> Unit) {
        val uploadedList = arrayListOf<String>()
        showLoader()

        val finalImageList = docList

        for (i in 0 until finalImageList.size) {

            val fileName = UploadToAzureStorage.PREFIX_RECORD + createFileName.plus(
                if (finalImageList[i].isPdfDocFile) ".pdf"
                else ".jpg"
            )
            UploadToAzureStorage().uploadImage(
                this,
                finalImageList[i].imagePath,
                UploadToAzureStorage.AZURE_CONTAINER,
                fileName,
                {
                    imageCount++
                    uploadedList.add(fileName)
                    if (finalImageList.size == uploadedList.size) {
                        hideLoader()
                        success.invoke(uploadedList)
                    }
                },
                {
                    hideLoader()
                    requireActivity().runOnUiThread {
                        showMessage(it)
                    }
                })
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun testTypes() {
        val apiRequest = ApiRequest()
        authViewModel.testTypes(apiRequest)
    }

    private fun updatedRecords(uploadedList: List<String>) {
        val apiRequest = ApiRequest().apply {
            test_type_id = selectedTestTypeId
            title = binding.editTextDocTitle.text.toString().trim()
            description = binding.editTextDescription.text.toString().trim()
            document_data = ArrayList(uploadedList)
        }
        authViewModel.updatedRecords(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updatedRecordsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                navigator.goBack()

                analytics.logEvent(analytics.USER_RECORDS_UPDATED,screenName = AnalyticsScreenNames.UploadRecord)
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.testTypesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                testTypeList.clear()
                responseBody.data?.test_type?.let { it1 -> testTypeList.addAll(it1) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}