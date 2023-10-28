package com.mytatva.patient.utils.textdecorator

import android.graphics.Paint
import android.graphics.Typeface
import android.text.style.TypefaceSpan


class CustomTypefaceSpan constructor(family: String = "", typeface: Typeface?) : TypefaceSpan(family) {

    private val newTypeface = typeface

    companion object {
        fun applyCustomTypeface(paint: Paint?, typeface: Typeface?) {
            val oldStyle: Int
            val old = paint?.typeface
            oldStyle = old?.style ?: 0

            val fake = oldStyle and typeface?.style?.inv()!!
            if (fake and Typeface.BOLD != 0) {
                paint?.isFakeBoldText = true
            }

            if (fake and Typeface.ITALIC != 0) {
                paint?.textSkewX = -0.25f
            }

            paint?.typeface = typeface
        }
    }

    /*override fun updateDrawState(ds: TextPaint?) {
        applyCustomTypeface(ds, newTypeface)
    }

    override fun updateMeasureState(paint: TextPaint?) {
        applyCustomTypeface(paint, newTypeface)
    }*/
}