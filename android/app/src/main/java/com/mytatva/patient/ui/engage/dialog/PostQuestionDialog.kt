package com.mytatva.patient.ui.engage.dialog

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.flexbox.FlexDirection
import com.google.android.flexbox.FlexboxLayoutManager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.QuestionsData
import com.mytatva.patient.data.pojo.response.TopicsData
import com.mytatva.patient.databinding.EngageDialogPostQuestionBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.engage.adapter.PostQuestionDocumentsAdapter
import com.mytatva.patient.ui.engage.adapter.PostQuestionSelectTopicsAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.azure.UploadToAzureStorage
import com.mytatva.patient.utils.azure.UploadToAzureStorage.Companion.createFileName
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.ImageAndVideoPicker
import com.mytatva.patient.utils.listOfField
import java.io.File

class PostQuestionDialog(val questionData: QuestionsData? = null) :
    BaseDialogFragment<EngageDialogPostQuestionBinding>() {

    var callback: (() -> Unit)? = null

    private val documentList = ArrayList<TempDataModel>()
    private val postQuestionDocumentsAdapter by lazy {
        PostQuestionDocumentsAdapter(documentList)
    }

    val topicList = arrayListOf<TopicsData>()
    private val postQuestionSelectTopicsAdapter by lazy {
        PostQuestionSelectTopicsAdapter(topicList)
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageDialogPostQuestionBinding {
        return EngageDialogPostQuestionBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog?.setCancelable(true)
        dialog?.setCanceledOnTouchOutside(false)
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            requireContext().display
        } else {
            wm.defaultDisplay
        }
        val metrics = DisplayMetrics()
        display?.getMetrics(metrics)
        val width = metrics.widthPixels * 1
        val height = metrics.heightPixels * .8
        val win = dialog?.window
        win!!.setLayout(width.toInt(), height.toInt())

        analytics.setScreenName(AnalyticsScreenNames.PostQuestion)
    }

    override fun bindData() {
        setOnShowListener()
        setUpRecyclerView()
        setViewListener()
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setDataForUpdateQuestion() {
        questionData?.let { questionData ->
            with(binding) {
                editTextQuestion.setText(questionData.title)
                //set topics
                topicList.forEachIndexed { index, topicsData ->
                    topicList[index].isSelected =
                        questionData.topics?.any { it.topic_master_id == topicsData.topic_master_id }
                            ?: false
                }
                postQuestionSelectTopicsAdapter.notifyDataSetChanged()
                //documents
                questionData.documents?.forEach {
                    documentList.add(TempDataModel(imagePath = "",
                        name = it.media ?: "",
                        isPdfDocFile = it.media_type == Common.QuestionDocType.PDF,
                        isAlreadyUploaded = true))
                }
                postQuestionDocumentsAdapter.notifyDataSetChanged()
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setOnShowListener() {
        dialog?.setOnShowListener {
            topicList.forEachIndexed { index, topicsData ->
                topicList[index].isSelected = false
            }
            postQuestionSelectTopicsAdapter.notifyDataSetChanged()
            topicList()
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewDocuments.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = postQuestionDocumentsAdapter
            }
            val flexboxLayoutManager = FlexboxLayoutManager(requireActivity())
            flexboxLayoutManager.flexDirection = FlexDirection.ROW
            recyclerViewCategory.apply {
                layoutManager = flexboxLayoutManager
                adapter = postQuestionSelectTopicsAdapter
            }
        }
    }

    private fun setViewListener() {
        binding.apply {
            buttonPost.setOnClickListener { onViewClick(it) }
            imageViewAttach.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonPost -> {
                if (binding.editTextQuestion.text.toString().trim().isBlank()) {
                    showMessage(getString(R.string.validation_empty_question))
                } else if (topicList.any { it.isSelected }.not()) {
                    showMessage(getString(R.string.validation_select_category))
                } else {
                    if (documentList.isNotEmpty()) {
                        handleUploadDocs { uploadedList ->
                            postQuestion(uploadedList)
                        }
                    } else {
                        postQuestion()
                    }
                }
            }
            R.id.imageViewAttach -> {
                showImagePicker()
            }
            R.id.imageViewClose -> {
                dismiss()
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
                        documentList.add(TempDataModel(imagePath = list.first(),
                            name = File(list.first()).name ?: ""))
                        postQuestionDocumentsAdapter.notifyItemInserted(documentList.lastIndex)
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }

                override fun onDocumentSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first()/*, 4*/)) {
                        documentList.add(TempDataModel(imagePath = list.first(),
                            name = File(list.first()).name ?: "",
                            isPdfDocFile = true))
                        postQuestionDocumentsAdapter.notifyItemInserted(documentList.lastIndex)
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }
            }).show(childFragmentManager, ImageAndVideoPicker::class.java.name)
    }

    var imageCount = 0
    private fun handleUploadDocs(success: (uploadedList: ArrayList<ApiRequestSubData>) -> Unit) {
        val uploadedList = arrayListOf<ApiRequestSubData>()
        showLoader()

        val finalImageList = documentList

        for (i in 0 until finalImageList.size) {

            if (finalImageList[i].isAlreadyUploaded) {

                imageCount++
                uploadedList.add(ApiRequestSubData().apply {
                    document = finalImageList[i].name ?: ""
                    document_type =
                        if (finalImageList[i].isPdfDocFile) Common.QuestionDocType.PDF
                        else Common.QuestionDocType.PHOTO
                })
                if (finalImageList.size == uploadedList.size) {
                    hideLoader()
                    success.invoke(uploadedList)
                }

            } else {

                val fileName = UploadToAzureStorage.PREFIX_ASKANEXPERT + createFileName.plus(
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
                        uploadedList.add(ApiRequestSubData().apply {
                            document = fileName
                            document_type =
                                if (finalImageList[i].isPdfDocFile) Common.QuestionDocType.PDF
                                else Common.QuestionDocType.PHOTO
                        })
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
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun topicList() {
        val apiRequest = ApiRequest()
        engageContentViewModel.topicList(apiRequest)
    }

    private fun postQuestion(uploadedList: ArrayList<ApiRequestSubData>? = null) {
        val apiRequest = ApiRequest().apply {
            question = binding.editTextQuestion.text.toString().trim()
            topic_ids = ArrayList(topicList.filter { it.isSelected })
                .listOfField(TopicsData::topic_master_id)
            documents = uploadedList
        }
        showLoader()
        if (questionData?.content_master_id.isNullOrBlank()) {
            //add question API
            engageContentViewModel.postQuestion(apiRequest)
        } else {
            //for update question API
            apiRequest.content_master_id = questionData?.content_master_id
            engageContentViewModel.postQuestionUpdate(apiRequest)
        }
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        engageContentViewModel.postQuestionLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.USER_POST_QUESTION,
                    screenName = AnalyticsScreenNames.PostQuestion)
                callback?.invoke()
                dismiss()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        engageContentViewModel.postQuestionUpdateLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                callback?.invoke()
                dismiss()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //topicListLiveData
        engageContentViewModel.topicListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    topicList.clear()
                    topicList.addAll(it)
                    postQuestionSelectTopicsAdapter.notifyDataSetChanged()
                }
                setDataForUpdateQuestion()
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

}