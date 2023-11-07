package com.mytatva.patient.data.model

enum class RelationType constructor(val displayName: String) {
    Parent("Parent"),
    Sibling("Sibling"),
    Spouse("Spouse"),
    Child("Child"),
    Grandparent("Grandparent"),
    OtherRelative("Other Relative"),
}