package com.mytatva.patient.data.model

import com.mytatva.patient.R

enum class LabTestStatus(val statusKey: String, val statusTitle: String, val colorRes: Int) {
    YET_TO_ASSIGN("YET TO ASSIGN", "YET TO ASSIGN", R.color.yellow1),
    ACCEPTED("ACCEPTED", "ACCEPTED", R.color.yellow1),
    SERVICED("SERVICED", "SERVICED", R.color.yellow1),
    DONE("DONE", "DONE", R.color.lightGreen),
}