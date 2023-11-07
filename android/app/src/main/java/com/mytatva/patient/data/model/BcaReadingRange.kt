package com.mytatva.patient.data.model

import androidx.annotation.ColorRes
import com.mytatva.patient.R

enum class BcaReadingRange constructor(val title: String, @ColorRes val color:Int) {
    Low("Low", R.color.range_low),
    Normal("Normal", R.color.range_normal),
    High("High", R.color.range_high),
    TooHigh("Too High", R.color.range_toohigh),
    Good("Good", R.color.range_good),
}

fun String?.getColorsAsPerStatus(): Int {
    return when (this) {
        BcaReadingRange.Low.title -> {
            BcaReadingRange.Low.color
        }

        BcaReadingRange.Normal.title -> {
            BcaReadingRange.Normal.color
        }

        BcaReadingRange.High.title -> {
            BcaReadingRange.High.color
        }

        BcaReadingRange.TooHigh.title -> {
            BcaReadingRange.TooHigh.color
        }

        BcaReadingRange.Good.title -> {
            BcaReadingRange.Good.color
        }

        else -> {
            R.color.colorPrimary
        }
    }
}