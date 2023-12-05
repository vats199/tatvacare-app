package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class HistoryLabTestPaymentData(
    @SerializedName("order_master_id")
    val order_master_id: String? = null,
    @SerializedName("transaction_id")
    val transaction_id: String? = null,
    @SerializedName("lab_test_id")
    val lab_test_id: String? = null,
    @SerializedName("order_id")
    val order_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
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
    @SerializedName("customer_rate")
    val customer_rate: String? = null,
    @SerializedName("appointment_date")
    val appointment_date: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("slot_time")
    val slot_time: String? = null,
    @SerializedName("patient_member_rel_id")
    val patient_member_rel_id: String? = null,
    @SerializedName("patient_member_data")
    val patient_member_data: String? = null,
    @SerializedName("patient_address_rel_id")
    val patient_address_rel_id: String? = null,
    @SerializedName("patient_address_data")
    val patient_address_data: String? = null,
    @SerializedName("pay_status")
    val pay_status: String? = null,
    @SerializedName("order_process")
    val order_process: String? = null,
    @SerializedName("service_type")
    val service_type: String? = null,
    @SerializedName("ref_order_id")
    val ref_order_id: String? = null,
    @SerializedName("order_lead_id")
    val order_lead_id: String? = null,
    @SerializedName("order_mobile")
    val order_mobile: String? = null,
    @SerializedName("record_created")
    val record_created: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
)