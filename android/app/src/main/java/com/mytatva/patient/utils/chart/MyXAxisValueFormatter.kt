package com.mytatva.patient.utils.chart

import com.github.mikephil.charting.components.AxisBase
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter

class MyXAxisValueFormatter internal constructor(internal var xLabels: ArrayList<String>) :
    IndexAxisValueFormatter(xLabels) {


    override fun getFormattedValue(value: Float, axis: AxisBase): String {

        if (value.toInt() >= xLabels.size) {
            return ""
        }
        try {
            return xLabels[value.toInt()]
        } catch (e: Exception) {

            return ""
        }
    }
}