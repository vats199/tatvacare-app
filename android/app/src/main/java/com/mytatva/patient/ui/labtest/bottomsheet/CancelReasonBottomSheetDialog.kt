package com.mytatva.patient.ui.labtest.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.LabtestBottomsheetCancelReasonBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.labtest.adapter.SelectCancelReasonAdapter

class CancelReasonBottomSheetDialog(
    val callback: () -> Unit,
) : BaseBottomSheetDialogFragment<LabtestBottomsheetCancelReasonBinding>() {

    /*WeekDaysData.values().toList()*/

    private val selectCancelReasonAdapter by lazy {
        SelectCancelReasonAdapter(arrayListOf(TempDataModel(),
            TempDataModel(),
            TempDataModel(),
            TempDataModel()))
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestBottomsheetCancelReasonBinding {
        return LabtestBottomsheetCancelReasonBinding.inflate(inflater, container, attachToRoot)
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
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewDays.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = selectCancelReasonAdapter
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewCancel.setOnClickListener { onViewClick(it) }
            buttonCancelOrder.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewCancel -> {
                dismiss()
            }
            R.id.buttonCancelOrder -> {
                callback.invoke()
                dismiss()
            }
        }
    }
}