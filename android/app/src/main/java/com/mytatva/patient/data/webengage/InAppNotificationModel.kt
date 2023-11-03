package com.mytatva.patient.data.webengage

import com.google.gson.annotations.SerializedName

class InAppNotificationModel(
    @SerializedName("canClose")
    val canClose: String? = null,
    @SerializedName("layoutAttributes")
    val layoutAttributes: LayoutAttributes? = null,
    @SerializedName("showTitle")
    val showTitle: String? = null,
    @SerializedName("notificationEncId")
    val notificationEncId: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("canMinimize")
    val canMinimize: String? = null,
    @SerializedName("id")
    val id: String? = null,
    @SerializedName("isActive")
    val isActive: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("actions")
    val actions: ArrayList<Actions>? = null,
    @SerializedName("config")
    val config: Config? = null,
    @SerializedName("direction")
    val direction: String? = null,
)

class LayoutAttributes(
    @SerializedName("posX")
    val posX: String? = null,
    @SerializedName("posY")
    val posY: String? = null,
    @SerializedName("TITLE_ALIGN")
    val TITLE_ALIGN: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
    @SerializedName("TITLE_WRAP")
    val TITLE_WRAP: String? = null,
    @SerializedName("wvWidth")
    val wvWidth: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("wvHeight")
    val wvHeight: String? = null,
    @SerializedName("fullScreen")
    val fullScreen: String? = null,
)

class Actions(
    @SerializedName("actionText")
    val actionText: String? = null,
    @SerializedName("actionEId")
    val actionEId: String? = null,
    @SerializedName("actionTarget")
    val actionTarget: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("actionLink")
    val actionLink: String? = null,
    @SerializedName("isPrime")
    val isPrime: String? = null,
)

class Config(
    @SerializedName("titleColor")
    val titleColor: String? = null,
    @SerializedName("c2aBackgroundColor")
    val c2aBackgroundColor: String? = null,
    @SerializedName("c2aTextFont")
    val c2aTextFont: String? = null,
    @SerializedName("titleFont")
    val titleFont: String? = null,
    @SerializedName("c2aTextColor")
    val c2aTextColor: String? = null,
    @SerializedName("hideLogo")
    val hideLogo: String? = null,
)