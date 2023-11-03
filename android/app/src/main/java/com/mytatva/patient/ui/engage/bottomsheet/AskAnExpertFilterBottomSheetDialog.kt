package com.mytatva.patient.ui.engage.bottomsheet

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.google.android.flexbox.FlexDirection
import com.google.android.flexbox.FlexboxLayoutManager
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AskAnExpertFiltersData
import com.mytatva.patient.data.pojo.response.QuestionTypeData
import com.mytatva.patient.data.pojo.response.TopicsData
import com.mytatva.patient.databinding.EngageBottomsheetAskAnExpertFilterBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.engage.adapter.FilterQuestionTypesAdapter
import com.mytatva.patient.ui.engage.adapter.FilterTopicsAdapter
import com.mytatva.patient.ui.engage.fragment.EngageAskAnExpertFragment
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel

class AskAnExpertFilterBottomSheetDialog(
    val callback: (
        topicsList: ArrayList<TopicsData>,
        questionList: ArrayList<QuestionTypeData>,
        isShowRecommendedByDoctor: Boolean,
    ) -> Unit,
) : BaseBottomSheetDialogFragment<EngageBottomsheetAskAnExpertFilterBinding>() {

    private val topicsList = arrayListOf<TopicsData>()
    private val filterTopicsAdapter by lazy {
        FilterTopicsAdapter(topicsList)
    }

    private val questionTypeList = arrayListOf<QuestionTypeData>()
    private val filterQuestionTypesAdapter by lazy {
        FilterQuestionTypesAdapter(questionTypeList)
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
    ): EngageBottomsheetAskAnExpertFilterBinding {
        return EngageBottomsheetAskAnExpertFilterBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)

            handleForSelectedFilters()
        }
        setUpRecyclerView()
        setViewListener()
        contentFilters()
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleForSelectedFilters() {
        if (EngageAskAnExpertFragment.filterTopicsList.isNotEmpty()) {
            topicsList.forEachIndexed { index, topicsData ->
                topicsList[index].isSelected =
                    EngageAskAnExpertFragment.filterTopicsList.any { it.topic_master_id == topicsData.topic_master_id }
            }
            filterTopicsAdapter.notifyDataSetChanged()
        }
        if (EngageAskAnExpertFragment.filterQuestionTypeList.isNotEmpty()) {
            questionTypeList.forEachIndexed { index, contentTypeData ->
                questionTypeList[index].isSelected =
                    EngageAskAnExpertFragment.filterQuestionTypeList.any {
                        it.value == contentTypeData.value
                    }
            }
            filterQuestionTypesAdapter.notifyDataSetChanged()
        }
    }

    private fun setUpRecyclerView() {
        val flexboxLayoutManagerTopics = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerTopics.flexDirection = FlexDirection.ROW
        binding.recyclerViewTopics.apply {
            layoutManager = flexboxLayoutManagerTopics
            adapter = filterTopicsAdapter
        }

        val flexboxLayoutManagerContentTypes = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerContentTypes.flexDirection = FlexDirection.ROW
        binding.recyclerViewQuestionType.apply {
            layoutManager = flexboxLayoutManagerContentTypes
            adapter = filterQuestionTypesAdapter
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewOnlyFromDoctorHealthCoach.setOnClickListener { onViewClick(it) }
            textViewReset.setOnClickListener { onViewClick(it) }
            buttonApply.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewOnlyFromDoctorHealthCoach -> {
                binding.textViewOnlyFromDoctorHealthCoach.isChecked =
                    binding.textViewOnlyFromDoctorHealthCoach.isChecked.not()
            }
            R.id.textViewReset -> {
                resetFilters()
                dismiss()
            }
            R.id.buttonApply -> {
                applyFilters()
                dismiss()
            }
        }
    }

    private fun applyFilters() {
        callback.invoke(
            ArrayList(topicsList.filter { it.isSelected }.toList()),
            ArrayList(questionTypeList.filter { it.isSelected }.toList()),
            binding.textViewOnlyFromDoctorHealthCoach.isChecked)
    }

    private fun resetFilters() {
        topicsList.forEachIndexed { index, tempDataModel ->
            topicsList[index].isSelected = false
        }

        questionTypeList.forEachIndexed { index, tempDataModel ->
            questionTypeList[index].isSelected = false
        }

        binding.textViewOnlyFromDoctorHealthCoach.isChecked = false

        // pass empty list to clear and reset filters in callback
        callback.invoke(arrayListOf(), arrayListOf(), false)
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun contentFilters() {
        val apiRequest = ApiRequest()
        engageContentViewModel.askAnExpertFilters(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //askAnExpertFiltersLiveData
        engageContentViewModel.askAnExpertFiltersLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setData(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(contentFiltersData: AskAnExpertFiltersData) {
        topicsList.clear()
        contentFiltersData.topic?.let { topicsList.addAll(it) }
        binding.textViewLabelTopics.isVisible = topicsList.isNotEmpty()
        filterTopicsAdapter.notifyDataSetChanged()

        questionTypeList.clear()
        contentFiltersData.question_type?.let { questionTypeList.addAll(it) }
        binding.textViewLabelQuestionTypes.isVisible = questionTypeList.isNotEmpty()
        filterQuestionTypesAdapter.notifyDataSetChanged()

        handleForSelectedFilters()
    }
}