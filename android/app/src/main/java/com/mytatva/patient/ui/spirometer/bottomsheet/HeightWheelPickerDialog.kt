package com.mytatva.patient.ui.spirometer.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import com.aigestudio.wheelpicker.WheelPicker
import com.google.android.material.tabs.TabLayout
import com.mytatva.patient.R
import com.mytatva.patient.data.model.DetailsTypeEnumData
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.databinding.SpirometerBottomsheetDetailsTypeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.utils.apputils.HeightWeightUtils

class HeightWheelPickerDialog :
    BaseBottomSheetDialogFragment<SpirometerBottomsheetDetailsTypeBinding>() {

    private var callback: (String, HeightUnit) -> Unit = { _, _ -> }
    private var tabList: ArrayList<String> = arrayListOf()
    private var selectedHeightInCm = ""

    //private var selectedSecondItem = ""
    private var selectedUnit: HeightUnit = HeightUnit.CM

    companion object {
        fun showBottomSheet(
            selectedItem: String,
            selectedUnit: HeightUnit,
            tabList: ArrayList<String>,
            callback: (String, HeightUnit) -> Unit,
        ): HeightWheelPickerDialog {
            val bottomSheet = HeightWheelPickerDialog()
            bottomSheet.selectedHeightInCm = selectedItem
            bottomSheet.selectedUnit = selectedUnit
            bottomSheet.callback = callback
            bottomSheet.tabList.addAll(tabList)
            return bottomSheet
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
        setSelectedData()

        setUpViewListeners()
    }

    private fun setSelectedData() = with(binding) {
        if (selectedHeightInCm != "") {
            if (tabLayoutSelected.selectedTabPosition == 0) {
                //when cm to ft/in selected
                selectedUnit = HeightUnit.FEET_INCHES
                val pairFeetInches = HeightWeightUtils.convertCmToFeetInches(
                    selectedHeightInCm.replace("cm", "").trim().toDoubleOrNull()?.toInt().toString()
                )
                val feet = pairFeetInches.first
                val inch = pairFeetInches.second

                val selectedFeetIndext =
                    wheelFeet.data.indexOf(wheelFeet.data.find { it?.equals("$feet'") == true })
                val selectedInchIndext =
                    wheelCM.data.indexOf(wheelCM.data.find { it?.equals("$inch''") == true })

                wheelFeet.setSelectedItemPosition(selectedFeetIndext, true)
                wheelCM.setSelectedItemPosition(selectedInchIndext, true)
                wheelFeet.selectedItemPosition = selectedFeetIndext
                wheelCM.selectedItemPosition = selectedInchIndext
            } else {
                //when ft/in to cm selected
                selectedUnit = HeightUnit.CM
                val cm = selectedHeightInCm.toDoubleOrNull()?.toInt().toString()
                val index =
                    wheelFeet.data.indexOf(wheelFeet.data.find { it?.equals("$cm cm") == true })
                wheelFeet.setSelectedItemPosition(index, true)
                wheelFeet.selectedItemPosition = index
            }
        }
    }

    private fun getHeightInCmFromFeetInchWheelPicker(): String {
        val feet = binding.wheelFeet.data[binding.wheelFeet.currentItemPosition].toString()
            .replace("'", "")
        val inch =
            binding.wheelCM.data[binding.wheelCM.currentItemPosition].toString().replace("''", "")
        return HeightWeightUtils.convertFeetInchesToCm(feet, inch)
    }

    private fun setTheData() = with(binding) {
        setTabLayout()
        textViewTestTitle.text = getString(R.string.days_selection_button_select) + " Height"
    }

    private fun setTabLayout() = with(binding) {
        tabList.forEach {
            tabLayoutSelected.addTab(tabLayoutSelected.newTab().setText(it))
        }
        tabLayoutSelected.selectTab(tabLayoutSelected.getTabAt(if (selectedUnit == HeightUnit.FEET_INCHES) 0 else 1))
        tabLayoutSelected.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab) {
                setWheelPicker()
                setSelectedData()
            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {

            }

            override fun onTabReselected(tab: TabLayout.Tab?) {

            }
        })
    }

    private fun setWheelPicker() = with(binding) {
        when (tabLayoutSelected.selectedTabPosition) {
            0 -> {
                wheelCM.isVisible = true
                wheelFeet.itemAlign = WheelPicker.ALIGN_RIGHT
                wheelFeet.data = DetailsTypeEnumData.getFeetList()
                wheelCM.data = DetailsTypeEnumData.getInchList()
            }

            else -> {
                wheelCM.isVisible = false
                wheelFeet.itemAlign = WheelPicker.ALIGN_CENTER
                wheelFeet.data = DetailsTypeEnumData.getCMList()
            }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveNext.setOnClickListener { onViewClick(it) }
            var heightFeet = HeightWeightUtils.convertCmToFeetInches(
                selectedHeightInCm.toDoubleOrNull()?.toInt().toString()
            ).first
            var heightInch = HeightWeightUtils.convertCmToFeetInches(
                selectedHeightInCm.toDoubleOrNull()?.toInt().toString()
            ).second

            wheelFeet.setOnItemSelectedListener { _, data, _ ->
                if (selectedUnit == HeightUnit.CM) {
                    selectedHeightInCm = data.toString().replace("cm", "").trim()
                } else {
                    heightFeet = data.toString().replace("'", "").trim()
                    selectedHeightInCm =
                        HeightWeightUtils.convertFeetInchesToCm(heightFeet, heightInch)
                }
            }
            wheelCM.setOnItemSelectedListener { _, data, _ ->
                heightInch = data.toString().replace("''", "").trim()
                selectedHeightInCm = HeightWeightUtils.convertFeetInchesToCm(heightFeet, heightInch)
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSaveNext -> {
                callback.invoke(selectedItem(), selectedUnit)
                dismiss()
            }
        }
    }

    private fun selectedItem(): String {
        return when (selectedUnit) {
            HeightUnit.FEET_INCHES -> {
                getHeightInCmFromFeetInchWheelPicker()
            }

            else -> {
                binding.wheelFeet.data[binding.wheelFeet.currentItemPosition].toString()
                    .replace(" cm", "", true)
            }
        }
    }
}