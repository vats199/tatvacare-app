package com.mytatva.patient.ui.auth.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.databinding.AuthBottomsheetMedicalConditionBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.auth.adapter.SelectMedicalConditionAdapter
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment


class SelectMedicalConditionBottomSheetDialog(private val medicalConditionList: ArrayList<MedicalConditionData> = arrayListOf<MedicalConditionData>()) :
    BaseBottomSheetDialogFragment<AuthBottomsheetMedicalConditionBinding>() {

    /*private val medicalConditionList = arrayListOf<TempDataModel>().apply {
        add(TempDataModel())
        add(TempDataModel())
        add(TempDataModel())
        add(TempDataModel())
        add(TempDataModel())
        add(TempDataModel())
        add(TempDataModel())
    }*/

    lateinit var callback: (medicalCondition: MedicalConditionData?) -> Unit

    fun setCallBack(callback: (medicalCondition: MedicalConditionData?) -> Unit): SelectMedicalConditionBottomSheetDialog {
        this.callback = callback
        return this
    }

    private val selectMedicalConditionAdapter by lazy {
        SelectMedicalConditionAdapter(medicalConditionList)
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthBottomsheetMedicalConditionBinding {
        return AuthBottomsheetMedicalConditionBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //setStyle(DialogFragment.STYLE_NORMAL, R.style.myBottomSheetDialog)
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
        binding.recyclerViewMedicalCondition.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = selectMedicalConditionAdapter
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewCancel.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewCancel -> {
                dismiss()
            }

            R.id.buttonSubmit -> {
                if (medicalConditionList.isNotEmpty()) {
                    callback.invoke(medicalConditionList[selectMedicalConditionAdapter.selectedPos])
                } else {
                    callback.invoke(null)
                }
                dismiss()
            }
        }
    }
}