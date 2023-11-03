package com.mytatva.patient.utils.chart.markerview

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Canvas
import androidx.appcompat.widget.AppCompatTextView
import com.github.mikephil.charting.components.MarkerView
import com.github.mikephil.charting.data.CandleEntry
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.highlight.Highlight
import com.github.mikephil.charting.utils.MPPointF
import com.github.mikephil.charting.utils.Utils
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.model.getFattyLiverGradeTitle
import com.mytatva.patient.utils.formatToDecimalPoint

class MyMarkerView(
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

    var readingKey = ""
    var isLSM = false

    // callbacks everytime the MarkerView is redrawn, can be used to update the
    // content (user-interface)
    override fun refreshContent(e: Entry, highlight: Highlight) {
        if (e is CandleEntry) {
            val ce = e
            tvContent.text = Utils.formatNumber(ce.low,
                0,
                true) + "-" + Utils.formatNumber(ce.high, 0, true)
        } else {
            when (readingKey) {
                Readings.BMI.readingKey,
                Readings.BodyWeight.readingKey,
                Readings.HbA1c.readingKey,
                Readings.SerumCreatinine.readingKey,
                Readings.BoneMass.readingKey,
                Readings.SubcutaneousFat.readingKey,
                Readings.MuscleMass.readingKey,
                Readings.VisceralFat.readingKey,
                -> {
                    tvContent.text = e.y.toDouble().formatToDecimalPoint(1)
                }
                Readings.FEV1.readingKey,
                Readings.FVC.readingKey,
                Readings.FEV1FVC_RATIO.readingKey,
                Readings.AQI.readingKey,
                Readings.HUMIDITY.readingKey,
                Readings.TEMPERATURE.readingKey,
                -> {
                    tvContent.text = e.y.toDouble().formatToDecimalPoint(2)
                }
                Readings.FIB4Score.readingKey -> {
                    tvContent.text = e.y.toDouble().formatToDecimalPoint(2)
                }
                Readings.FibroScan.readingKey -> {
                    tvContent.text = if (isLSM)
                        e.y.toDouble().formatToDecimalPoint(1)
                    else
                        e.y.toInt().toString()
                }
                Readings.FattyLiverUSGGrade.readingKey -> {
                    tvContent.text = e.y.toInt().getFattyLiverGradeTitle()
                }
                else -> {
                    tvContent.text = e.y.toInt().toString() //Utils.formatNumber(e.y, 0, true)
                }
            }
        }

        if (highlight.dataSetIndex == 0) {
            tvContent.backgroundTintList = ColorStateList.valueOf(color)
        } else {
            tvContent.backgroundTintList = ColorStateList.valueOf(color2)
        }

        super.refreshContent(e, highlight)
    }

    override fun draw(canvas: Canvas?, posX: Float, posY: Float) {
        super.draw(canvas, posX, posY)
        getOffsetForDrawingAtPoint(posX, posY)
    }

    override fun getOffset(): MPPointF {
        return MPPointF((-(width / 2)).toFloat(), (-height).toFloat())
    }

    /*@Override
    public MPPointF getOffsetForDrawingAtPoint(float posX, float posY) {
        return super.getOffsetForDrawingAtPoint(posX, posY);
    }*/
}