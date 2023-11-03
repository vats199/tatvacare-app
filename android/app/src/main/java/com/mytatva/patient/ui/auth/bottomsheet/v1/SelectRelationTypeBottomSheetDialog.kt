package com.mytatva.patient.ui.auth.bottomsheet.v1

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.data.model.RelationType
import com.mytatva.patient.databinding.AuthNewBottomsheetSelectRelationTypeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.auth.adapter.v1.SelectRelationTypeAdapter
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment

class SelectRelationTypeBottomSheetDialog(
    val callback: (relationType: RelationType) -> Unit,
) : BaseBottomSheetDialogFragment<AuthNewBottomsheetSelectRelationTypeBinding>() {

    private val relationsList: ArrayList<RelationType> = ArrayList(RelationType.values().toList())
    private val selectRelationTypeAdapter by lazy {
        SelectRelationTypeAdapter(relationsList)
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthNewBottomsheetSelectRelationTypeBinding {
        return AuthNewBottomsheetSelectRelationTypeBinding.inflate(inflater,
            container,
            attachToRoot)
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
            adapter = selectRelationTypeAdapter
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
                callback.invoke(relationsList[selectRelationTypeAdapter.selectionPos])
                dismiss()
            }
        }
    }
}