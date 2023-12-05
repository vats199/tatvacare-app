package com.mytatva.patient.ui.auth.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.DosageTimeData
import com.mytatva.patient.databinding.AuthBottomsheetSuggestedDosageBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.auth.adapter.SuggestedDosageAdapter
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment

class SuggestedDosageBottomSheetDialog(
    val dosageList: List<DosageTimeData> = listOf(),
    val callback: (DosageTimeData) -> Unit,
) : BaseBottomSheetDialogFragment<AuthBottomsheetSuggestedDosageBinding>() {

    /*listOf(
        TempDataModel(name = "1 time a day"),
        TempDataModel(name = "2 times a day"),
        TempDataModel(name = "3 times a day"),
        TempDataModel(name = "4 times a day"),
        TempDataModel(name = "5 times a day"),
        TempDataModel(name = "6 times a day"),
    )*/

    private val suggestedDosageAdapter by lazy {
        SuggestedDosageAdapter(dosageList)
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthBottomsheetSuggestedDosageBinding {
        return AuthBottomsheetSuggestedDosageBinding.inflate(inflater, container, attachToRoot)
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
        binding.recyclerViewDosage.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = suggestedDosageAdapter
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
                if (dosageList.isNotEmpty()) {
                    callback.invoke(dosageList[suggestedDosageAdapter.selectedPosition])
                }
                dismiss()
            }
        }
    }
}