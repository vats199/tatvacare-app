package com.mytatva.patient.utils.chart

import com.github.mikephil.charting.components.AxisBase
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter

class MyYAxisValueFormatter internal constructor(internal var yLabels: ArrayList<String>) :
    IndexAxisValueFormatter(yLabels) {

    override fun getFormattedValue(value: Float, axis: AxisBase): String {

        if (value.toInt() >= yLabels.size) {
            return ""
        }
        if (value.toInt() < 0) {
            return ""
        }
        try {
            return yLabels[value.toInt()]
        } catch (e: Exception) {

            return ""
        }
    }
}