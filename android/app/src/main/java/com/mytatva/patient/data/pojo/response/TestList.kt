package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class TestList(
    val name: String
) : Parcelable