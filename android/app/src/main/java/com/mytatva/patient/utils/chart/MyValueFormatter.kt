package com.mytatva.patient.utils.chart

import com.github.mikephil.charting.data.CandleEntry
import com.github.mikephil.charting.formatter.ValueFormatter
import java.text.DecimalFormat

class CandleValueFormatter : ValueFormatter() {
    private val format = DecimalFormat("###,##0.0")

    // override this for e.g. LineChart or ScatterChart
//    override fun getPointLabel(entry: Entry?): String {
//        return format.format(entry?.y)
//    }

    override fun getCandleLabel(candleEntry: CandleEntry?): String {
        /*return getFormattedValue(candleEntry?.low ?: 0f) + "-" + getFormattedValue(candleEntry?.high
            ?: 0f)*/

        return (candleEntry?.low?.toInt() ?: 0).toString() + "-" + (candleEntry?.high?.toInt()
            ?: 0).toString()
    }
}