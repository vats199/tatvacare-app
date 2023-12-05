package com.mytatva.patient.ui.spirometer.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import com.aigestudio.wheelpicker.WheelPicker
import com.google.android.material.tabs.TabLayout
import com.mytatva.patient.R
import com.mytatva.patient.data.model.DetailsTypeEnumData
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.databinding.SpirometerBottomsheetDetailsTypeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.utils.apputils.HeightWeightUtils

class WeightWheelPickerDialog :
    BaseBottomSheetDialogFragment<SpirometerBottomsheetDetailsTypeBinding>() {

    private var callback: (String, WeightUnit) -> Unit = { _, _ -> }
    private var tabList: ArrayList<String> = arrayListOf()
    private var selectedWeightInKg = ""
    private var selectedUnit: WeightUnit = WeightUnit.KG

    companion object {
        fun showBottomSheet(
            selectedItem: String,
            selectedUnit: WeightUnit,
            tabList: ArrayList<String>,
            callback: (String, WeightUnit) -> Unit,
        ): WeightWheelPickerDialog {
            val bottomSheet = WeightWheelPickerDialog()
            bottomSheet.selectedWeightInKg = selectedItem
            bottomSheet.selectedUnit = selectedUnit
            bottomSheet.callback = callback
            if (tabList.size > 0) {
                bottomSheet.tabList.addAll(tabList)
            }
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
        setSelectedData(isFirstTime = true)
        setUpViewListeners()
    }

    private fun setSelectedData(isFirstTime: Boolean = false) = with(binding) {
        if (selectedWeightInKg != "") {
            if (tabLayoutSelected.selectedTabPosition == 0) {//kg
                /*val kgs = if (isFirstTime) selectedWeightInKg.toDoubleOrNull().formatToDecimalPointSkipRounding(1)
                else HeightWeightUtils.convertLbsToKg(selectedWeightInKg)*/
                val kgs = selectedWeightInKg

                val selectedFeetIndext =
                    wheelFeet.data.indexOf(wheelFeet.data.find { it?.equals(kgs.split(".")[0]) == true })
                val selectedDecimalIndex =
                    wheelCM.data.indexOf(wheelCM.data.find { it?.equals(".".plus(kgs.split(".")[1])) == true })

                wheelFeet.setSelectedItemPosition(selectedFeetIndext, true)
                wheelFeet.selectedItemPosition = selectedFeetIndext

                wheelCM.setSelectedItemPosition(selectedDecimalIndex, true)
                wheelCM.selectedItemPosition = selectedDecimalIndex

                //
                //selectedWeightInKg = wheelFeet.data[wheelFeet.currentItemPosition].toString() + wheelCM.data[wheelCM.currentItemPosition].toString()

            } else {//lbs

                val lbs = HeightWeightUtils.convertKgToLbs(selectedWeightInKg)
                val selectedIndext =
                    wheelFeet.data.indexOf(wheelFeet.data.find { it?.equals(lbs.split(".")[0]) == true })
                val selectedDecimalIndex =
                    wheelCM.data.indexOf(wheelCM.data.find { it?.equals(".".plus(lbs.split(".")[1])) == true })

                wheelFeet.setSelectedItemPosition(selectedIndext, true)
                wheelFeet.selectedItemPosition = selectedIndext

                wheelCM.setSelectedItemPosition(selectedDecimalIndex, true)
                wheelCM.selectedItemPosition = selectedDecimalIndex

                //
                //selectedWeightInKg = wheelFeet.data[wheelFeet.currentItemPosition].toString() + wheelCM.data[wheelCM.currentItemPosition].toString()
            }
        }
    }

    private fun setTheData() = with(binding) {
        setTabLayout()
        textViewTestTitle.text = getString(R.string.days_selection_button_select) + " Weight"
    }

    private fun setTabLayout() = with(binding) {
        if (tabList.isNotEmpty()) {
            tabList.forEach {
                tabLayoutSelected.addTab(tabLayoutSelected.newTab().setText(it))
            }
            tabLayoutSelected.selectTab(tabLayoutSelected.getTabAt(if (selectedUnit == WeightUnit.KG) 0 else 1))
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
        } else {
            tabLayoutSelected.isVisible = false
        }
    }

    private fun setWheelPicker() = with(binding) {
        //wheelCM.isVisible = false
        wheelFeet.itemAlign = WheelPicker.ALIGN_RIGHT

        val lp: ConstraintLayout.LayoutParams =
            wheelFeet.layoutParams as ConstraintLayout.LayoutParams
        lp.marginEnd = 0

        when (tabLayoutSelected.selectedTabPosition) {
            0 -> {
                selectedUnit = WeightUnit.KG
                wheelFeet.data = DetailsTypeEnumData.getKGsList()
            }

            else -> {
                selectedUnit = WeightUnit.LBS
                wheelFeet.data = DetailsTypeEnumData.getLBsList()
            }
        }
        wheelCM.data = DetailsTypeEnumData.getDecimalPlacesList()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveNext.setOnClickListener { onViewClick(it) }
            wheelFeet.setOnItemSelectedListener { _, data, _ ->
                selectedWeightInKg = selectedItem() //data.toString()
            }
            wheelCM.setOnItemSelectedListener { _, data, _ ->
                selectedWeightInKg = selectedItem() //data.toString()
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
        selectedWeightInKg = when (selectedUnit) {
            WeightUnit.KG -> {
                val kgs = binding.wheelFeet.data[binding.wheelFeet.currentItemPosition].toString()
                    .plus(binding.wheelCM.data[binding.wheelCM.currentItemPosition].toString())
                kgs
            }

            else -> {
                val kgs = HeightWeightUtils.convertLbsToKg(
                    binding.wheelFeet.data[binding.wheelFeet.currentItemPosition].toString() + binding.wheelCM.data[binding.wheelCM.currentItemPosition].toString()
                )
                kgs
            }
        }
        return selectedWeightInKg
    }
}