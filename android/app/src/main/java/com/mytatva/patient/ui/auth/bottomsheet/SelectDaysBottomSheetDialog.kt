package com.mytatva.patient.ui.auth.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.model.WeekDaysData
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.databinding.AuthBottomsheetDaysSelectionBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.auth.adapter.SelectDaysAdapter
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment

class SelectDaysBottomSheetDialog(
    val daysList: List<DaysData> = listOf(),
    val callback: (selectedDaysList: List<DaysData>) -> Unit,
) : BaseBottomSheetDialogFragment<AuthBottomsheetDaysSelectionBinding>() {

    /*WeekDaysData.values().toList()*/

    private val selectDaysAdapter by lazy {
        SelectDaysAdapter(daysList)
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthBottomsheetDaysSelectionBinding {
        return AuthBottomsheetDaysSelectionBinding.inflate(inflater, container, attachToRoot)
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
            adapter = selectDaysAdapter
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
                callback.invoke(daysList.filter { it.isSelected }.toList())
                dismiss()
                /*if (daysList.none { it.isSelected }){
                    showMessage("Please select at least one day")
                } else {
                    callback.invoke(daysList.filter { it.isSelected }.toList())
                    dismiss()
                }*/
            }
        }
    }
}