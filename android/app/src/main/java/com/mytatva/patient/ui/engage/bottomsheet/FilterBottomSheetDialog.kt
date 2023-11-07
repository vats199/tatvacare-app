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
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.databinding.EngageBottomsheetFilterBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.engage.adapter.FilterContentTypesAdapter
import com.mytatva.patient.ui.engage.adapter.FilterGenresAdapter
import com.mytatva.patient.ui.engage.adapter.FilterLanguageAdapter
import com.mytatva.patient.ui.engage.adapter.FilterTopicsAdapter
import com.mytatva.patient.ui.engage.fragment.EngageDiscoverFragment
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel

class FilterBottomSheetDialog(
    val callback: (
        languageList: ArrayList<LanguageData>,
        genresList: ArrayList<GenreData>,
        topicsList: ArrayList<TopicsData>,
        contentTypeList: ArrayList<ContentTypeData>,
        isShowRecommendedByDoctor: Boolean,
    ) -> Unit,
) : BaseBottomSheetDialogFragment<EngageBottomsheetFilterBinding>() {

    private val languageList = arrayListOf<LanguageData>()
    private val filterLanguageAdapter by lazy {
        FilterLanguageAdapter(languageList)
    }

    private val genresList = arrayListOf<GenreData>()
    private val filterGenresAdapter by lazy {
        FilterGenresAdapter(genresList)
    }

    private val topicsList = arrayListOf<TopicsData>()
    private val filterTopicsAdapter by lazy {
        FilterTopicsAdapter(topicsList)
    }

    private val contentTypeList = arrayListOf<ContentTypeData>()
    private val filterContentTypesAdapter by lazy {
        FilterContentTypesAdapter(contentTypeList)
    }

    /*private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }*/

    private var engageContentViewModel: EngageContentViewModel? = null

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageBottomsheetFilterBinding {
        return EngageBottomsheetFilterBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        engageContentViewModel = ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
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
        if (EngageDiscoverFragment.filterLanguageList.isNotEmpty()) {
            languageList.forEachIndexed { index, languageData ->
                languageList[index].isSelected =
                    EngageDiscoverFragment.filterLanguageList.any { it.languages_id == languageData.languages_id }
            }
            filterLanguageAdapter.notifyDataSetChanged()
        }
        if (EngageDiscoverFragment.filterGenresList.isNotEmpty()) {
            genresList.forEachIndexed { index, genreData ->
                genresList[index].isSelected =
                    EngageDiscoverFragment.filterGenresList.any { it.genre_master_id == genreData.genre_master_id }
            }
            filterGenresAdapter.notifyDataSetChanged()
        }
        if (EngageDiscoverFragment.filterTopicsList.isNotEmpty()) {
            topicsList.forEachIndexed { index, topicsData ->
                topicsList[index].isSelected =
                    EngageDiscoverFragment.filterTopicsList.any { it.topic_master_id == topicsData.topic_master_id }
            }
            filterTopicsAdapter.notifyDataSetChanged()
        }
        if (EngageDiscoverFragment.filterContentTypeList.isNotEmpty()) {
            contentTypeList.forEachIndexed { index, contentTypeData ->
                contentTypeList[index].isSelected =
                    EngageDiscoverFragment.filterContentTypeList.any {
                        //it.content_type_id == contentTypeData.content_type_id
                        it.keys == contentTypeData.keys
                    }
            }
            filterContentTypesAdapter.notifyDataSetChanged()
        }
    }

    private fun setUpRecyclerView() {
        val flexboxLayoutManagerLanguage = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerLanguage.flexDirection = FlexDirection.ROW
        binding.recyclerViewLanguage.apply {
            layoutManager = flexboxLayoutManagerLanguage
            adapter = filterLanguageAdapter
        }

        val flexboxLayoutManagerGenres = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerGenres.flexDirection = FlexDirection.ROW
        binding.recyclerViewGenres.apply {
            layoutManager = flexboxLayoutManagerGenres
            adapter = filterGenresAdapter
        }

        val flexboxLayoutManagerTopics = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerTopics.flexDirection = FlexDirection.ROW
        binding.recyclerViewTopics.apply {
            layoutManager = flexboxLayoutManagerTopics
            adapter = filterTopicsAdapter
        }

        val flexboxLayoutManagerContentTypes = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerContentTypes.flexDirection = FlexDirection.ROW
        binding.recyclerViewContentTypes.apply {
            layoutManager = flexboxLayoutManagerContentTypes
            adapter = filterContentTypesAdapter
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
            ArrayList(languageList.filter { it.isSelected }.toList()),
            ArrayList(genresList.filter { it.isSelected }.toList()),
            ArrayList(topicsList.filter { it.isSelected }.toList()),
            ArrayList(contentTypeList.filter { it.isSelected }.toList()),
            binding.textViewOnlyFromDoctorHealthCoach.isChecked
        )
    }

    private fun resetFilters() {
        languageList.forEachIndexed { index, tempDataModel ->
            languageList[index].isSelected = false
        }

        genresList.forEachIndexed { index, tempDataModel ->
            genresList[index].isSelected = false
        }

        topicsList.forEachIndexed { index, tempDataModel ->
            topicsList[index].isSelected = false
        }

        contentTypeList.forEachIndexed { index, tempDataModel ->
            contentTypeList[index].isSelected = false
        }

        binding.textViewOnlyFromDoctorHealthCoach.isChecked = false

        // pass empty list to clear and reset filters in callback
        callback.invoke(arrayListOf(), arrayListOf(), arrayListOf(), arrayListOf(), false)
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun contentFilters() {
        val apiRequest = ApiRequest()
        engageContentViewModel?.contentFilters(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //contentFiltersLiveData
        engageContentViewModel?.contentFiltersLiveData?.observe(this,
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
    private fun setData(contentFiltersData: ContentFiltersData) {
        /*languageList.clear()
        contentFiltersData.language?.let { languageList.addAll(it) }
        filterLanguageAdapter.notifyDataSetChanged()*/

        topicsList.clear()
        contentFiltersData.topic?.let { topicsList.addAll(it) }
        binding.textViewLabelTopics.isVisible = topicsList.isNotEmpty()
        filterTopicsAdapter.notifyDataSetChanged()

        /*genresList.clear()
        contentFiltersData.genre?.let { genresList.addAll(it) }
        filterGenresAdapter.notifyDataSetChanged()*/

        contentTypeList.clear()
        contentFiltersData.content_type?.let { contentTypeList.addAll(it) }
        binding.textViewLabelContentTypes.isVisible = contentTypeList.isNotEmpty()
        filterContentTypesAdapter.notifyDataSetChanged()

        handleForSelectedFilters()
    }
}