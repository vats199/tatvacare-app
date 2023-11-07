package com.mytatva.patient.data.model

data class TypeWithTitleField(
    var title: String,
    var units: Enum<*>,
)

enum class DetailsTypeEnum(val tabItem: ArrayList<TypeWithTitleField>? = null) {
    Height(
        tabItem = arrayListOf(
            TypeWithTitleField("Feet", HeightUnit.FEET_INCHES),
            TypeWithTitleField("cm", HeightUnit.CM)
        )
    ),
    Weight(
        tabItem = arrayListOf(
            TypeWithTitleField("kgs", WeightUnit.KG),
            TypeWithTitleField("lbs", WeightUnit.LBS)
        )
    ),
    Age(null),
    Ethnicity(null)
}

object DetailsTypeEnumData {

    fun getFeetList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 3..8) {
            array.add("$i'")
        }
        return array
    }

    fun getInchList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 0..11) {
            array.add("$i''")
        }
        return array
    }

    fun getCMList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 91..272) {
            array.add("$i cm")
        }
        return array
    }

    fun getKGsListWithDecimal(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 30..300) {
            for (j in 0..9) {
                array.add("$i.$j")
            }
        }
        return array
    }

    fun getLBsListWithDecimal(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 66..660) {
            for (j in 0..9) {
                array.add("$i.$j")
            }
        }
        return array
    }

    fun getKGsList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 30..300) {
            array.add("$i")
        }
        return array
    }

    fun getLBsList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 66..660) {
            array.add("$i")
        }
        return array
    }

    fun getDecimalPlacesList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (j in 0..9) {
            array.add(".$j")
        }
        return array
    }

    fun getAgeList(): ArrayList<String> {
        val array = arrayListOf<String>()
        for (i in 18..100) {
            array.add(i.toString())
        }
        return array
    }

    fun getCityList(): ArrayList<String> {
        val array = arrayListOf<String>()
        array.add("Caucasian")
        array.add("North Indian")
        array.add("South Indian")
        array.add("Other")
        return array
    }
}