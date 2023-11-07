package com.mytatva.patient.data.pojo.response


import com.google.gson.annotations.SerializedName

data class HcDevicePlan(
    @SerializedName("devices")
    var devices: Devices? = Devices(),
    @SerializedName("nutritionist")
    var nutritionist: Nutritionist? = Nutritionist(),
    @SerializedName("physiotherapist")
    var physiotherapist: Physiotherapist? = Physiotherapist()
) {
    data class Devices(@SerializedName("is_active")
                       var isActive: String? = "")

    data class Physiotherapist(@SerializedName("is_active")
                       var isActive: String? = "")

    data class Nutritionist(
        @SerializedName("actual_price")
        var actualPrice: String? = "",
        @SerializedName("card_image")
        var cardImage: String? = "",
        @SerializedName("card_image_detail")
        var cardImageDetail: String? = "",
        @SerializedName("cloned_by")
        var clonedBy: Any? = Any(),
        @SerializedName("colour_scheme")
        var colourScheme: String? = "",
        @SerializedName("created_at")
        var createdAt: String? = "",
        @SerializedName("deep_link")
        var deepLink: Any? = Any(),
        @SerializedName("description")
        var description: String? = "",
        @SerializedName("discount_percentage")
        var discountPercentage: String? = "",
        @SerializedName("enable_rent_buy")
        var enableRentBuy: String? = "",
        @SerializedName("gst_percentage")
        var gstPercentage: String? = "",
        @SerializedName("image_url")
        var imageUrl: String? = "",
        @SerializedName("is_active")
        var isActive: String? = "",
        @SerializedName("is_deleted")
        var isDeleted: String? = "",
        @SerializedName("plan_master_id")
        var planMasterId: String? = "",
        @SerializedName("plan_name")
        var planName: String? = "",
        @SerializedName("plan_type")
        var planType: String? = "",
        @SerializedName("renewal_reminder_days")
        var renewalReminderDays: Int? = 0,
        @SerializedName("show_book_device")
        var showBookDevice: String? = "",
        @SerializedName("show_home")
        var showHome: String? = "",
        @SerializedName("show_nutritionist")
        var showNutritionist: String? = "",
        @SerializedName("show_physio")
        var showPhysio: String? = "",
        @SerializedName("start_at")
        var startAt: String? = "",
        @SerializedName("sub_title")
        var subTitle: String? = "",
        @SerializedName("updated_at")
        var updatedAt: String? = "",
        @SerializedName("updated_by")
        var updatedBy: String? = "",
        @SerializedName("what_to_expect")
        var whatToExpect: String? = ""
    )

}
