package com.mytatva.patient.ui.exercise.bottomsheet

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
import com.mytatva.patient.data.pojo.response.ExerciseFilterCommonData
import com.mytatva.patient.data.pojo.response.ExerciseFilterMainData
import com.mytatva.patient.databinding.ExerciseBottomsheetFilterBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.exercise.adapter.FilterExerciseGenresAdapter
import com.mytatva.patient.ui.exercise.adapter.FilterLevelAdapter
import com.mytatva.patient.ui.exercise.adapter.FilterTimeAdapter
import com.mytatva.patient.ui.exercise.adapter.FilterToolsAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel

class ExerciseFilterBottomSheetDialog(
    val callback: (
        timeList: ArrayList<ExerciseFilterCommonData>,
        exerciseToolsList: ArrayList<ExerciseFilterCommonData>,
        levelList: ArrayList<ExerciseFilterCommonData>,
        genreList: ArrayList<ExerciseFilterCommonData>,
    ) -> Unit,
) : BaseBottomSheetDialogFragment<ExerciseBottomsheetFilterBinding>() {

    private val timeList = arrayListOf<ExerciseFilterCommonData>()
    private val filterTimeAdapter by lazy {
        FilterTimeAdapter(timeList)
    }

    private val exerciseToolsList = arrayListOf<ExerciseFilterCommonData>()
    private val filterExerciseToolsAdapter by lazy {
        FilterToolsAdapter(exerciseToolsList)
    }

    private val levelList = arrayListOf<ExerciseFilterCommonData>()
    private val filterLevelAdapter by lazy {
        FilterLevelAdapter(levelList)
    }

    private val genreList = arrayListOf<ExerciseFilterCommonData>()
    private val filterGenreAdapter by lazy {
        FilterExerciseGenresAdapter(genreList)
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
    ): ExerciseBottomsheetFilterBinding {
        return ExerciseBottomsheetFilterBinding.inflate(inflater, container, attachToRoot)
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
        }
        setUpRecyclerView()
        setViewListener()
        exerciseFilters()
    }

    private fun setUpRecyclerView() {
        val flexboxLayoutManagerLanguage = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerLanguage.flexDirection = FlexDirection.ROW
        binding.recyclerViewTime.apply {
            layoutManager = flexboxLayoutManagerLanguage
            adapter = filterTimeAdapter
        }

        val flexboxLayoutManagerGenres = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerGenres.flexDirection = FlexDirection.ROW
        binding.recyclerViewExerciseTools.apply {
            layoutManager = flexboxLayoutManagerGenres
            adapter = filterExerciseToolsAdapter
        }

        val flexboxLayoutManagerTopics = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerTopics.flexDirection = FlexDirection.ROW
        binding.recyclerViewLevel.apply {
            layoutManager = flexboxLayoutManagerTopics
            adapter = filterLevelAdapter
        }

        val flexboxLayoutManagerContentTypes = FlexboxLayoutManager(requireContext())
        flexboxLayoutManagerContentTypes.flexDirection = FlexDirection.ROW
        binding.recyclerViewGenres.apply {
            layoutManager = flexboxLayoutManagerContentTypes
            adapter = filterGenreAdapter
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewReset.setOnClickListener { onViewClick(it) }
            buttonApply.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
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
            ArrayList(timeList.filter { it.isSelected }.toList()),
            ArrayList(exerciseToolsList.filter { it.isSelected }.toList()),
            ArrayList(levelList.filter { it.isSelected }.toList()),
            ArrayList(genreList.filter { it.isSelected }.toList()))
    }

    private fun resetFilters() {
        timeList.forEachIndexed { index, tempDataModel ->
            timeList[index].isSelected = false
        }

        exerciseToolsList.forEachIndexed { index, tempDataModel ->
            exerciseToolsList[index].isSelected = false
        }

        levelList.forEachIndexed { index, tempDataModel ->
            levelList[index].isSelected = false
        }

        genreList.forEachIndexed { index, tempDataModel ->
            genreList[index].isSelected = false
        }

        // pass empty list to clear and reset filters in callback
        callback.invoke(arrayListOf(), arrayListOf(), arrayListOf(), arrayListOf())
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun exerciseFilters() {
        val apiRequest = ApiRequest()
        engageContentViewModel.exerciseFilters(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //exerciseFiltersLiveData
        engageContentViewModel.exerciseFiltersLiveData.observe(this,
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
    private fun setData(contentFiltersData: ArrayList<ExerciseFilterMainData>) {
        timeList.clear()
        contentFiltersData.firstOrNull { it.type == "time" }?.data?.let {
            timeList.addAll(it)
        }
        binding.textViewLabelTime.isVisible = timeList.isNotEmpty()
        filterTimeAdapter.notifyDataSetChanged()

        exerciseToolsList.clear()
        contentFiltersData.firstOrNull { it.type == "exercise_tool" }?.data?.let {
            exerciseToolsList.addAll(it)
        }
        binding.textViewLabelExerciseTools.isVisible = exerciseToolsList.isNotEmpty()
        filterExerciseToolsAdapter.notifyDataSetChanged()

        levelList.clear()
        contentFiltersData.firstOrNull { it.type == "fitness_level" }?.data?.let {
            levelList.addAll(it)
        }
        binding.textViewLabelLevel.isVisible = levelList.isNotEmpty()
        filterLevelAdapter.notifyDataSetChanged()

        genreList.clear()
        contentFiltersData.firstOrNull { it.type == "genre" }?.data?.let {
            genreList.addAll(it)
        }
        binding.textViewLabelTopics.isVisible = genreList.isNotEmpty()
        filterGenreAdapter.notifyDataSetChanged()
    }
}