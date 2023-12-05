package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class CatalogListData(
    @SerializedName("category_name")
    var categoryName: String? = null,
    @SerializedName("catalog_category_master_id")
    var catalogCategoryMasterId: String? = null,
    @SerializedName("catalogs_list")
    var testPackageData: ArrayList<TestPackageData> = arrayListOf(),
) : Parcelable