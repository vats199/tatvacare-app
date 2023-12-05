package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class ListCartData(
    @SerializedName("tests_list")
    val tests_list: ArrayList<TestPackageData>? = null,
    @SerializedName("bcp_tests_list")
    val bcp_tests_list: ArrayList<BcpTestMainData>? = null,
    @SerializedName("order_detail")
    val order_detail: CartOrderDetails? = null,
    @SerializedName("home_collection_charge")
    val home_collection_charge: CartHomeCollectionCharges? = null,
    @SerializedName("lab")
    val lab: CartLab? = null,
    @SerializedName("vendor_flag")
    val vendor_flag: String? = null,
) : Parcelable {
    val normalTestsList: List<TestPackageData>
        get() {
            return ((tests_list?.filter { testPackageData -> testPackageData.type != "bcp" })
                ?: ArrayList())
        }
}

@Parcelize
data class BcpTestMainData(
    @SerializedName("bcp_address_data")
    val bcp_address_data: TestAddressData? = null,
    @SerializedName("patient_plan_rel_id")
    val patient_plan_rel_id: String? = null,
    @SerializedName("plan_name")
    val plan_name: String? = null,
    @SerializedName("bcp_tests_list")
    val bcp_tests_list: ArrayList<TestPackageData>? = null,
    @SerializedName("is_bcp_tests_added")
    var is_bcp_tests_added: String? = null,
    @SerializedName("vendor_flag")
    val vendor_flag: String? = null,
) : Parcelable

@Parcelize
data class CartOrderDetails(
    @SerializedName("total_test")
    val total_test: String? = null,
    @SerializedName("payable_amount")
    val payable_amount: String? = null,
    @SerializedName("order_total")
    val order_total: String? = null,
    @SerializedName("final_payable_amount")
    val final_payable_amount: String? = null,
    @SerializedName("service_charge")
    val service_charge: String? = null,
) : Parcelable

@Parcelize
data class CartHomeCollectionCharges(
    @SerializedName("ammount")
    val ammount: String? = null,
    @SerializedName("payable_ammount")
    val payable_ammount: String? = null,
) : Parcelable

@Parcelize
data class CartLab(
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("address")
    val address: String? = null,
    @SerializedName("image")
    val image: String? = null,
) : Parcelable