package com.mytatva.patient.ui.common.dialog

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import com.aigestudio.wheelpicker.WheelPicker
import com.mytatva.patient.R
import com.mytatva.patient.databinding.CommonBottomsheetSelectItemBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.utils.listOfField
import kotlin.reflect.KProperty1

class SelectItemBottomSheetDialog : BaseBottomSheetDialogFragment<CommonBottomsheetSelectItemBinding>() {

    private var callback: (Int) -> Unit = { position -> }
    private var list: ArrayList<String> = arrayListOf()
    private var title = ""
    private var selectedItem: String? = null

    companion object {
        fun showBottomSheet(
            title: String,
            list: ArrayList<String>,
            selectedItem: String? = null,
            callback: (Int) -> Unit,
        ): SelectItemBottomSheetDialog = SelectItemBottomSheetDialog().apply {
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
    ): CommonBottomsheetSelectItemBinding {
        return CommonBottomsheetSelectItemBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setTheData()
        setWheelPicker()
        setAutoSelected()
        setUpViewListeners()
    }

    private fun setAutoSelected() = with(binding) {
        if (selectedItem != null && list.contains(selectedItem)) {

            val firstListIndex = wheel.data.indexOfFirst { it == selectedItem }
            wheel.setSelectedItemPosition(firstListIndex, true)
            wheel.selectedItemPosition = firstListIndex
        }
    }

    private fun setTheData() = with(binding) {
        textViewTestTitle.text = title
    }

    private fun setWheelPicker() = with(binding) {
        wheel.isVisible = false
        wheel.itemAlign = WheelPicker.ALIGN_CENTER
        wheel.data = list
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveNext.setOnClickListener { onViewClick(it) }
            wheel.setOnItemSelectedListener { picker, data, position ->
                //selectedItem = data
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSaveNext -> {
                callback.invoke(binding.wheel.currentItemPosition)
                dismiss()
            }
        }
    }

}