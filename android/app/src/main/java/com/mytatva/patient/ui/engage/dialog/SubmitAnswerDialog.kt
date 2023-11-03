package com.mytatva.patient.ui.engage.dialog

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AnswerData
import com.mytatva.patient.data.pojo.response.QuestionsData
import com.mytatva.patient.databinding.EngageDialogSubmitAnswerBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class SubmitAnswerDialog(
    var contentMasterId: String? = null,
    var question: String? = null,
    // when open for update answer
    var answerData: AnswerData? = null,
) : BaseDialogFragment<EngageDialogSubmitAnswerBinding>() {

    var callback: ((questionData: QuestionsData) -> Unit)? = null
    fun setCallback(callback: (questionData: QuestionsData) -> Unit): SubmitAnswerDialog {
        this.callback = callback
        return this
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[EngageContentViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageDialogSubmitAnswerBinding {
        return EngageDialogSubmitAnswerBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        binding.textViewQuestion.text = question
        answerData?.let {
            binding.editTextAnswer.setText(it.comment)
        }
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            buttonSubmit.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSubmit -> {
                if (binding.editTextAnswer.text.toString().trim().isBlank()) {
                    showMessage(getString(R.string.validation_empty_answer))
                } else {
                    updateAnswer()
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
    private fun updateAnswer() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            description = binding.editTextAnswer.text.toString().trim()
            content_comments_id = answerData?.content_comments_id
        }
        showLoader()
        engageContentViewModel.updateAnswer(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        engageContentViewModel.updateAnswerLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (answerData == null) {
                    analytics.logEvent(analytics.USER_SUBMIT_ANSWER, Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
                    },screenName = AnalyticsScreenNames.SubmitAnswer)
                } else {
                    analytics.logEvent(analytics.USER_UPDATE_ANSWER, Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
                        putString(analytics.PARAM_CONTENT_COMMENTS_ID,
                            answerData?.content_comments_id)
                    },screenName = AnalyticsScreenNames.SubmitAnswer)
                }
                responseBody.data?.let { callback?.invoke(it) }
                dismiss()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

}