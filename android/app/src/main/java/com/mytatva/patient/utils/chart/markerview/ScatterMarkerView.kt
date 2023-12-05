package com.mytatva.patient.utils.chart.markerview

import android.content.Context
import android.content.res.ColorStateList
import androidx.appcompat.widget.AppCompatTextView
import com.github.mikephil.charting.components.MarkerView
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.highlight.Highlight
import com.github.mikephil.charting.utils.MPPointF
import com.mytatva.patient.R
import com.mytatva.patient.core.Common

class ScatterMarkerView(
    context: Context?,
    layoutResource: Int,
    val color: Int,
    val color2: Int = Common.Colors.COLOR_PRIMARY,
) :
    MarkerView(context, layoutResource) {

    private val tvContent: AppCompatTextView

    init {
        tvContent = findViewById(R.id.textViewGraphPrice)
    }

    // callbacks everytime the MarkerView is redrawn, can be used to update the
    // content (user-interface)
    override fun refreshContent(e: Entry, highlight: Highlight) {

        //tvContent.text = Utils.formatNumber(highlight.y, 0, true)
        tvContent.text = e.y.toInt().toString() //Utils.formatNumber(e.y, 0, true)

        if (highlight.dataSetIndex == 0) {
            tvContent.backgroundTintList = ColorStateList.valueOf(color)
        } else {
            tvContent.backgroundTintList = ColorStateList.valueOf(color2)
        }

        super.refreshContent(e, highlight)
    }

    override fun getOffset(): MPPointF {
        return MPPointF((-(width / 2)).toFloat(), (-height).toFloat())
    }
}