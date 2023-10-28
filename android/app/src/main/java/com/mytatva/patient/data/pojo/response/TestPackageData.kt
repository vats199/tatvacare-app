package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class TestListSeparateData(
    @SerializedName("tests")
    val tests: ArrayList<TestPackageData>? = null,
    @SerializedName("packages")
    val packages: ArrayList<TestPackageData>? = null,
    @SerializedName("call")
    val call: CallData? = null,
) : Parcelable

@Parcelize
data class CallData(
    @SerializedName("mobile")
    val mobile: String? = null,
) : Parcelable

@Parcelize
data class TestPackageData(
    @SerializedName("lab")
    val lab: CartLab? = null,
    @SerializedName("price")
    val price: String? = null,
    @SerializedName("discount_price")
    val discount_price: String? = null,
    @SerializedName("discount_percent")
    val discount_percent: String? = null,
    @SerializedName("color_code")
    val color_code: String? = null,
    @SerializedName("in_cart")
    var in_cart: String? = null,
    @SerializedName("lab_test_id")
    val lab_test_id: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("code")
    val code: String? = null,
    @SerializedName("testNames")
    val testNames: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("testCount")
    val testCount: String? = null,
    @SerializedName("aliasName")
    val aliasName: String? = null,
    @SerializedName("rate_b2B")
    val rate_b2B: String? = null,
    @SerializedName("rate_b2C")
    val rate_b2C: String? = null,
    @SerializedName("offerRate")
    val offerRate: String? = null,
    @SerializedName("payType")
    val payType: String? = null,
    @SerializedName("urine")
    val urine: String? = null,
    @SerializedName("fluoride")
    val fluoride: String? = null,
    @SerializedName("fasting")
    val fasting: String? = null,
    @SerializedName("diseaseGroup")
    val diseaseGroup: String? = null,
    @SerializedName("groupName")
    val groupName: String? = null,
    @SerializedName("margin")
    val margin: String? = null,
    @SerializedName("specimenType")
    val specimenType: String? = null,
    @SerializedName("imageLocation")
    val imageLocation: String? = null,
    @SerializedName("category")
    val category: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("childs")
    val childs: ArrayList<ChildData>? = null,
    @SerializedName("cart")
    val cart: Cart? = null,
    @SerializedName("available")
    val available: String? = null,
) : Parcelable {
    val discountPercent: Int
        get() {
            return discount_percent?.toDoubleOrNull()?.toInt() ?: 0
        }
    val isPackage: Boolean
        get() {
            return type == "OFFER" /*type != "TEST"*/
        }
}

@Parcelize
data class Cart(
    @SerializedName("total_test")
    val total_test: String? = null,
    @SerializedName("total_price")
    val total_price: String? = null,
    @SerializedName("bcp_flag")
    val bcp_flag: String? = null,
) : Parcelable {
    val totalCartCount: Int
        get() {
            return total_test?.toIntOrNull() ?: 0
        }
}

@Parcelize
data class ChildData(
    @SerializedName("parent_code")
    val parent_code: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("code")
    val code: String? = null,
    @SerializedName("groupName")
    val groupName: String? = null,
    @SerializedName("type")
    val type: String? = null,
) : Parcelable