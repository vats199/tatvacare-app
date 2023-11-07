package com.mytatva.patient.ui.engage.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.EngageBottomsheetReportCommentBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.engage.adapter.ReportCommentReasonAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class ReportCommentBottomSheetDialog(
    val callback: (reportType: String, reportDesc: String) -> Unit,
) : BaseBottomSheetDialogFragment<EngageBottomsheetReportCommentBinding>() {

    val commentList = arrayListOf<TempDataModel>().apply {
        add(TempDataModel(name = "It’s spam", key = "S"))
        add(TempDataModel(name = "It’s inappropriate", key = "I"))
        add(TempDataModel(name = "It’s false information", key = "F"))
    }
    val reportCommentReasonAdapter by lazy {
        ReportCommentReasonAdapter(commentList)
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageBottomsheetReportCommentBinding {
        return EngageBottomsheetReportCommentBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ReportComment)
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
        setViewListener()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewReportReason.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = reportCommentReasonAdapter
            }
        }
    }

    private fun setViewListener() {
        binding.apply {
            buttonSubmit.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSubmit -> {
                callback.invoke(commentList[reportCommentReasonAdapter.selectedPos].key,
                    binding.editTextOtherComments.text.toString().trim())
                dismiss()
            }
        }
    }
}