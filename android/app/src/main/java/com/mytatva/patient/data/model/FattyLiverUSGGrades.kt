package com.mytatva.patient.data.model

enum class FattyLiverUSGGrades constructor(val title: String, var gradeValue: Int) {
    GRADE_0("Grade 0 - Normal", 0),
    GRADE_1("Grade I Fatty Liver", 1),
    GRADE_2("Grade II Fatty Liver", 2),
    GRADE_3("Grade III Fatty Liver", 3),
}

fun Int.getFattyLiverGradeTitle(): String {
    return FattyLiverUSGGrades.values().firstOrNull { it.gradeValue == this }?.title ?: ""
}