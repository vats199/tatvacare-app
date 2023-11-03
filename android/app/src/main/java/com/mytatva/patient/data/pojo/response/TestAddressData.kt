package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class TestAddressData(
    @SerializedName("patient_address_rel_id")
    val patient_address_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("contact_no")
    val contact_no: String? = null,
    @SerializedName("pincode")
    var pincode: String? = null,
    @SerializedName("address")
    var address: String? = null,
    @SerializedName("street")
    var street: String? = null,
    @SerializedName("address_type")
    val address_type: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("bcp_address")
    val bcp_address: String? = null,
    @SerializedName("latitude")
    var latitude: String? = null,
    @SerializedName("longitude")
    var longitude: String? = null,
) : Parcelable {
    val addressLabel: String
        get() {
            return (address?.plus("\n") ?: "")
                .plus(street?.plus("\n") ?: "")
                .plus(pincode ?: "")
        }

    val addressLabelInReview: String
        get() {
            return (name?.plus("\n") ?: "")
                .plus(address?.plus("\n") ?: "")
                .plus(street?.plus("\n") ?: "")
                .plus(pincode?.plus("\n") ?: "")
                .plus(contact_no ?: "")
        }

    fun addressLabelInDetails(email:String?): String {
            return (name?.plus("\n") ?: "")
                .plus(address?.plus("\n") ?: "")
                //.plus(street?.plus("\n") ?: "")
                .plus(pincode?.plus("\n") ?: "")
                .plus(contact_no?.plus("\n") ?: "")
                .plus(email ?: "")
        }
}