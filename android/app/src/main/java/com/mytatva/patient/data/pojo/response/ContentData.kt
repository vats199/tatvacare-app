package com.mytatva.patient.data.pojo.response

import android.os.Build
import android.text.Html
import android.text.Spanned
import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class ContentData(
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("content_type")
    val content_type: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("url")
    val url: String? = null,
    @SerializedName("medical_condition_group_id")
    val medical_condition_group_id: String? = null,
    @SerializedName("poster_designation")
    val poster_designation: String? = null,
    @SerializedName("therapy_based_tags")
    val therapy_based_tags: String? = null,
    @SerializedName("molecule_based_tag")
    val molecule_based_tag: String? = null,
    @SerializedName("description_based_tag")
    val description_based_tag: String? = null,
    @SerializedName("group_master_id")
    val group_master_id: String? = null,
    @SerializedName("priority_flag")
    val priority_flag: String? = null,
    @SerializedName("recommended_by_doctor")
    val recommended_by_doctor: String? = null,
    @SerializedName("recommended_by_healthcoach")
    val recommended_by_healthcoach: String? = null,
    @SerializedName("phone_number")
    val phone_number: String? = null,
    @SerializedName("bookmark_capability")
    val bookmark_capability: String? = null,
    @SerializedName("share_capability")
    val share_capability: String? = null,
    @SerializedName("like_capability")
    val like_capability: String? = null,
    @SerializedName("scheduled_date")
    val scheduled_date: String? = null,
    @SerializedName("expiry_date")
    val expiry_date: String? = null,
    @SerializedName("expirydate_not_applicable")
    val expirydate_not_applicable: String? = null,
    @SerializedName("xmin_read_time")
    val xmin_read_time: String? = null,
    @SerializedName("time_duration")
    val time_duration: String? = null,
    @SerializedName("duration_unit")
    val duration_unit: String? = null,
    @SerializedName("no_of_bookmark")
    val no_of_bookmark: String? = null,
    @SerializedName("no_of_shares")
    val no_of_shares: String? = null,
    @SerializedName("no_of_likes")
    var no_of_likes: String? = null,
    @SerializedName("no_of_views")
    val no_of_views: String? = null,
    @SerializedName("no_of_comments")
    var no_of_comments: String? = null,
    @SerializedName("comment")
    val comment: Comment? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("kol_speaker")
    val kol_speaker: String? = null,
    @SerializedName("kol_designation")
    val kol_designation: String? = null,
    @SerializedName("kol_qualification")
    val kol_qualification: String? = null,
    @SerializedName("location")
    val location: String? = null,
    @SerializedName("hosted_by")
    val hosted_by: String? = null,
    @SerializedName("external_link_out")
    val external_link_out: String? = null,
    @SerializedName("author")
    val author: String? = null,
    @SerializedName("doctor_as_author")
    val doctor_as_author: String? = null,
    @SerializedName("premium")
    val premium: String? = null,
    @SerializedName("photo_embedded_incontent")
    val photo_embedded_incontent: String? = null,
    @SerializedName("language_master_id")
    val language_master_id: String? = null,
    @SerializedName("audio_hear")
    val audio_hear: String? = null,
    @SerializedName("thumbnail_alt_tag")
    val thumbnail_alt_tag: String? = null,
    @SerializedName("content_id")
    val content_id: String? = null,
    @SerializedName("language_selection")
    val language_selection: String? = null,
    @SerializedName("care_plan_id")
    val care_plan_id: String? = null,
    @SerializedName("publish_date")
    val publish_date: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
    @SerializedName("status")
    val status: String? = null,
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
    @SerializedName("kol_speaker_photo")
    val kol_speaker_photo: String? = null,
    @SerializedName("liked")
    var liked: String? = null,
    @SerializedName("bookmarked")
    var bookmarked: String? = null,
    @SerializedName("topic_name")
    val topic_name: String? = null,
    @SerializedName("genre")
    val genre: String? = null,
    @SerializedName("goal_master_id")
    val goal_master_id: String? = null,
    @SerializedName("fitness_level")
    val fitness_level: String? = null,
    @SerializedName("exercise_tools")
    val exercise_tools: String? = null,
    @SerializedName("media")
    val media: ArrayList<ContentMediaData>? = null,
    var isSelected: Boolean = false,
    var strComment: String = "",
) {

    val getTotalComment: Int
        get() {
            return try {
                comment?.total?.toInt() ?: 0
            } catch (e: Exception) {
                0
            }
        }

    val getShareText: String
        get() {
            return title.plus("\n\n")
                .plus(deep_link)
        }

    val formattedScheduleDate: String
        get() {
            return try {
                DateTimeFormatter.date(scheduled_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }

    val formattedUpdatedDate: String
        get() {
            return try {
                DateTimeFormatter.date(updated_at, DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }

    val getHtmlFormattedDescription: Spanned
        get() {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Html.fromHtml(description, Html.FROM_HTML_MODE_LEGACY)
            } else {
                Html.fromHtml(description)
            }
        }

    var likeCount: Int
        set(value) {
            no_of_likes = value.toString()
        }
        get() {
            return no_of_likes?.toIntOrNull() ?: 0
        }

    /*var commentCount: Int
        set(value) {
            no_of_comments = value.toString()
        }
        get() {
            return no_of_comments?.toIntOrNull() ?: 0
        }*/
}

class ContentMediaData(
    @SerializedName("content_master_media_id")
    val content_master_media_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("media_key")
    val media_key: String? = null,
    @SerializedName("media")
    val media: String? = null,
    @SerializedName("media_type")
    val media_type: String? = null,
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
    @SerializedName("media_url")
    val media_url: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
)

class Comment(
    @SerializedName("comment_data")
    var comment_data: ArrayList<CommentsData>? = null,
    @SerializedName("total")
    var total: String? = null,
)