package com.mytatva.patient.core

object AppDataProvider {
    fun getNumberList(
        start: Int,
        end: Int,
        preFix: String = "",
        postFix: String = "",
    ): ArrayList<String> {
        val list = arrayListOf<String>()
        for (i in start..end) {
            val sb = StringBuilder()
            if (preFix.isNotBlank()) {
                sb.append(preFix).append(" ")
            }
            sb.append(i)
            if (postFix.isNotBlank()) {
                sb.append(" ").append(postFix)
            }
            list.add(sb.toString())
        }
        return list
    }
}