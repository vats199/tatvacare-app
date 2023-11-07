package com.mytatva.patient.ui.labtest.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestBottomsheetShowAllTestsBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.labtest.adapter.ShowAllTestsAdapter

class ShowAllTestsBottomSheetDialog(
    val testPackageData: TestPackageData,
    val callback: () -> Unit,
) : BaseBottomSheetDialogFragment<LabtestBottomsheetShowAllTestsBinding>() {

    /*WeekDaysData.values().toList()*/

    private val showAllTestsAdapter by lazy {
        ShowAllTestsAdapter(testPackageData.childs ?: arrayListOf())
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestBottomsheetShowAllTestsBinding {
        return LabtestBottomsheetShowAllTestsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
        setData()
        setUpRecyclerView()
        setViewListener()
    }

    private fun setData() {
        with(binding) {
            testPackageData.let {
                textViewTitle.text = it.name
                textViewNoOfAvailableAtLab
                textViewNoOfTestsInclude.text = "Includes ${it.testCount} tests"
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewAllTests.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = showAllTestsAdapter
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewCancel.setOnClickListener { onViewClick(it) }
            buttonSelect.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewCancel -> {
                dismiss()
            }
            R.id.buttonSelect -> {
                callback.invoke()
                dismiss()
            }
        }
    }
}