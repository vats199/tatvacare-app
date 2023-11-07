package com.mytatva.patient.data.model

import androidx.annotation.DrawableRes
import com.mytatva.patient.R

enum class Device constructor(val deviceKey: String, @DrawableRes val deviceIcon: Int) {
    BcaScale("bca", R.drawable.ic_bca_scale),
    Spirometer("spirometer", R.drawable.ic_spirometer),
}