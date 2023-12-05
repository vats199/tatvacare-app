package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class HistoryTestOrderData(
    @SerializedName("order_master_id") val order_master_id: String? = null,
    @SerializedName("slot_time") val slot_time: String? = null,
    @SerializedName("ref_order_id") val ref_order_id: String? = null,
    @SerializedName("order_id") val order_id: String? = null,
    @SerializedName("order_total") val order_total: String? = null,
    @SerializedName("payable_amount") val payable_amount: String? = null,
    @SerializedName("home_collection_charge") val home_collection_charge: String? = null,
    @SerializedName("final_payable_amount") val final_payable_amount: String? = null,
    @SerializedName("appointment_date") val appointment_date: String? = null,
    @SerializedName("created_at") val created_at: String? = null,
    @SerializedName("total_items") val total_items: String? = null,
    @SerializedName("status") val status: String? = null,
    @SerializedName("order_status") val order_status: String? = null,
    @SerializedName("name") val name: String? = null,
    @SerializedName("bcp_test_price_data") val bcp_test_price_data: BcpTestPriceData? = null,
    @SerializedName("vendor_flag") val vendor_flag: String? = null,
    @SerializedName("order_process_status") val order_process_status: String? = null,
    @SerializedName("patient_address_data") val patient_address_data: TestAddressData? = null,
    @SerializedName("refund_status") val refund_status: String? = null,
    @SerializedName("report_url") val report_url: String? = null,
    @SerializedName("is_show_button") val is_show_button: String? = null,
    @SerializedName("imageLocation")
    val imageLocation: String? = null,
    var remarks: String? = null
) : Parcelable

@Parcelize
data class BcpTestPriceData(
    @SerializedName("bcp_final_amount_to_pay") val bcp_final_amount_to_pay: String? = null,
    @SerializedName("bcp_home_collection_charge") val bcp_home_collection_charge: String? = null,
    @SerializedName("bcp_home_collection_charge_old") val bcp_home_collection_charge_old: String? = null,
    @SerializedName("bcp_service_charge") val bcp_service_charge: String? = null,
    @SerializedName("bcp_total_amount") val bcp_total_amount: String? = null,
    @SerializedName("bcp_total_amount_old") val bcp_total_amount_old: String? = null,
) : Parcelable {

    val bcpHomeCollectionCharge: Int
        get() {
            return bcp_home_collection_charge?.toDoubleOrNull()?.toInt() ?: 0
        }
    val bcpHomeCollectionChargeOld: Int
        get() {
            return bcp_home_collection_charge_old?.toDoubleOrNull()?.toInt() ?: 0
        }
    val bcpServiceCharge: Int
        get() {
            return bcp_service_charge?.toDoubleOrNull()?.toInt() ?: 0
        }
    val bcpTotalAmount: Int
        get() {
            return bcp_total_amount?.toDoubleOrNull()?.toInt() ?: 0
        }
    val bcpTotalAmountOld: Int
        get() {
            return bcp_total_amount_old?.toDoubleOrNull()?.toInt() ?: 0
        }

    val bcpFinalAmountToPay: Int
        get() {
            return bcp_final_amount_to_pay?.toDoubleOrNull()?.toInt() ?: 0
        }
}