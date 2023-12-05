package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class TestOrderSummaryResData(
    @SerializedName("order_master_id")
    val order_master_id: String? = null,
    @SerializedName("slot_time")
    val slot_time: String? = null,
    @SerializedName("order_id")
    val order_id: String? = null,
    @SerializedName("ref_order_id")
    val ref_order_id: String? = null,
    @SerializedName("order_total")
    val order_total: String? = null,
    @SerializedName("payable_amount")
    val payable_amount: String? = null,
    @SerializedName("home_collection_charge")
    val home_collection_charge: String? = null,
    @SerializedName("service_charge")
    val service_charge: String? = null,
    @SerializedName("final_payable_amount")
    val final_payable_amount: String? = null,
    @SerializedName("appointment_date")
    val appointment_date: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("address")
    val address: TestAddressData? = null,
    @SerializedName("member")
    val member: TestPatientData? = null,
    @SerializedName("total_items")
    val total_items: String? = null,
    @SerializedName("items")
    val items: ArrayList<OrderSummaryItemData>? = null,
    @SerializedName("order_status")
    val order_status: String? = null,
    @SerializedName("order_status_data")
    val order_status_data: ArrayList<OrderStatusData>? = null,
    @SerializedName("lab")
    val lab: CartLab? = null,
    @SerializedName("service_date_time")
    val service_date_time: String? = null,
    @SerializedName("bcp_test_price_data")
    val bcp_test_price_data: BcpTestPriceData? = null,

    @SerializedName("coupon_discount")
    val coupon_discount: String? = null,
    @SerializedName("coupon_code")
    val coupon_code: String? = null,
    @SerializedName("coupon_name")
    val coupon_name: String? = null,
    @SerializedName("order_mobile")
    val order_mobile: String? = null,
) {
    val orderTotalAmount: Int
        get() {
            return order_total?.toDoubleOrNull()?.toInt() ?: 0
        }
    val payableAmount: Int
        get() {
            return payable_amount?.toDoubleOrNull()?.toInt() ?: 0
        }
}

data class OrderSummaryItemData(
    @SerializedName("order_item_rel_id")
    val order_item_rel_id: String? = null,
    @SerializedName("order_master_id")
    val order_master_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("order_no")
    val order_no: String? = null,
    @SerializedName("test_code")
    val test_code: String? = null,
    @SerializedName("service_type")
    val service_type: String? = null,
    @SerializedName("customer_rate")
    val customer_rate: String? = null,
    @SerializedName("ref_order_id")
    val ref_order_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("order_status")
    val order_status: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("data")
    val price_data: ItemPriceData? = null,
    /*@SerializedName("order_status_data")
    val order_status_data: ArrayList<OrderStatusData>? = null,*/
    var isSelected: Boolean = false,
    @SerializedName("imageLocation")
    val imageLocation: String? = null,
)

data class ItemPriceData(
    @SerializedName("price")
    val price: String? = null,
    @SerializedName("discount_price")
    val discount_price: String? = null,
    @SerializedName("discount_percent")
    val discount_percent: String? = null,
    @SerializedName("name")
    val name: String? = null,
)

data class OrderStatusData(
    @SerializedName("index")
    val index: String? = null,
    @SerializedName("status")
    val status: String? = null,
    @SerializedName("done")
    val done: String? = null,
) {
    val isDone: Boolean
        get() {
            return done == "Yes"
        }
}