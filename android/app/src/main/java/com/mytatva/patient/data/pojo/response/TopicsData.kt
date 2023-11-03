package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class TopicsData(
    @SerializedName("topic_master_id")
    val topic_master_id: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("icon")
    val icon: String? = null,
    @SerializedName("color_code")
    val color_code: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("total_content")
    val total_content: String? = null,
    @SerializedName("no_of_bookmark")
    val no_of_bookmark: String? = null,
    @SerializedName("no_of_shares")
    val no_of_shares: String? = null,
    @SerializedName("no_of_views")
    val no_of_views: String? = null,
    @SerializedName("no_of_comments")
    val no_of_comments: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
    var isSelected: Boolean = false,
) {
    fun doCopy(): TopicsData {
        return TopicsData(
            topic_master_id,
            name,
            icon,
            color_code,
            is_active,
            is_deleted,
            updated_by,
            created_at,
            updated_at,
            total_content,
            no_of_bookmark,
            no_of_shares,
            no_of_views,
            no_of_comments,
            image_url,
            isSelected
        )
    }
}