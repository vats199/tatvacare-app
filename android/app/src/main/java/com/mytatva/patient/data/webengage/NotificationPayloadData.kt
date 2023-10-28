package com.mytatva.patient.data.webengage

import com.google.gson.annotations.SerializedName

class NotificationPayloadData(
    @SerializedName("identifier")
    val identifier: String? = null,
    @SerializedName("image")
    val image: String? = null,
    @SerializedName("custom")
    val custom: ArrayList<Custom>? = null,
    @SerializedName("expandableDetails")
    val expandableDetails: ExpandableDetails? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("message")
    val message: String? = null,
    @SerializedName("priority")
    val priority: String? = null,
    @SerializedName("cta")
    val cta: CTA? = null,
    @SerializedName("timeToLive")
    val timeToLive: String? = null,
    @SerializedName("messageAction")
    val messageAction: String? = null,
    /*@SerializedName("customEventData")
    val customEventData: String? = null,*/
    @SerializedName("experimentId")
    val experimentId: String? = null,
    @SerializedName("packageName")
    val packageName: String? = null,
    @SerializedName("license_code")
    val license_code: String? = null,
)

class Custom(
    @SerializedName("value")
    val value: String? = null,
    @SerializedName("key")
    val key: String? = null,
)

class ExpandableDetails(
    @SerializedName("image")
    val image: String? = null,
    @SerializedName("ratingScale")
    val ratingScale: String? = null,
    @SerializedName("style")
    val style: String? = null,
    @SerializedName("message")
    val message: String? = null,
    @SerializedName("cta1")
    val cta1: CTA? = null,
    @SerializedName("cta2")
    val cta2: CTA? = null,
)

class CTA(
    @SerializedName("actionText")
    val actionText: String? = null,
    @SerializedName("id")
    val id: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("templateId")
    val templateId: String? = null,
    @SerializedName("actionLink")
    val actionLink: String? = null,
)