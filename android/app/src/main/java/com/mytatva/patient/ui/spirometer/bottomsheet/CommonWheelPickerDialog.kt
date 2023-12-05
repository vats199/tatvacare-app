package com.mytatva.patient.ui.spirometer.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import com.aigestudio.wheelpicker.WheelPicker
import com.mytatva.patient.R
import com.mytatva.patient.databinding.SpirometerBottomsheetDetailsTypeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment

class CommonWheelPickerDialog :
    BaseBottomSheetDialogFragment<SpirometerBottomsheetDetailsTypeBinding>() {

    private var callback: (Int) -> Unit = { position -> }
    private var list: ArrayList<String> = arrayListOf()
    private var title = ""
    private var selectedItem: String? = null

    companion object {
        fun showBottomSheet(
            title: String,
            list: ArrayList<String>,
            selectedItem: String? = null,
            callback: (Int) -> Unit
        ): CommonWheelPickerDialog = CommonWheelPickerDialog().apply {
            this.title = title

            if (selectedItem != null)
                this.selectedItem = selectedItem

            this.callback = callback
            this.list.addAll(list)
        }
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        setStyle(DialogFragment.STYLE_NORMAL, R.style.myBottomSheetDialog)
        super.onCreate(savedInstanceState)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): SpirometerBottomsheetDetailsTypeBinding {
        return SpirometerBottomsheetDetailsTypeBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setTheData()
        setWheelPicker()
        setAutoSelected()
        setUpViewListeners()
    }

    private fun setAutoSelected() = with(binding) {
        if (selectedItem != null && list.contains(selectedItem)) {

            val firstListIndex = wheelFeet.data.indexOfFirst { it == selectedItem }
            wheelFeet.setSelectedItemPosition(firstListIndex, true)
            wheelFeet.selectedItemPosition = firstListIndex
        }
    }

    private fun setTheData() = with(binding) {
        setTabLayout()
        textViewTestTitle.text = title
    }

    private fun setTabLayout() = with(binding) {
        tabLayoutSelected.isVisible = false
    }

    private fun setWheelPicker() = with(binding) {
        wheelCM.isVisible = false
        wheelFeet.itemAlign = WheelPicker.ALIGN_CENTER
        wheelFeet.data = list
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveNext.setOnClickListener { onViewClick(it) }
            wheelFeet.apply {
                setOnItemSelectedListener { _, data, _ ->
                    selectedItem = data.toString()
                }
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSaveNext -> {
                callback.invoke(binding.wheelFeet.currentItemPosition)
                dismiss()
            }
        }
    }

}