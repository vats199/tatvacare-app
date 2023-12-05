package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.TimeAgo
import com.mytatva.patient.utils.datetime.DateTimeFormatter

data class QuestionsData(
    @SerializedName("liked")
    var liked: String? = null,
    @SerializedName("bookmarked")
    var bookmarked: String? = null,
    @SerializedName("reported")
    var reported: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("total_answers")
    val total_answers: String? = null,
    @SerializedName("documents")
    val documents: ArrayList<Documents>? = null,
    @SerializedName("topics")
    val topics: ArrayList<Topics>? = null,
    @SerializedName("top_answer")
    val top_answer: AnswerData? = null,
    @SerializedName("recent_answers")
    val recent_answers: ArrayList<AnswerData>? = null,
    var isSelected: Boolean = false,
) {

    val totalAnswers: Int
        get() {
            return total_answers?.toIntOrNull() ?: 0
        }

    val formattedQuestionTime: String
        get() {
            return try {
                TimeAgo.getTimeAgoElseDate(
                    DateTimeFormatter
                        //dateUTC
                        .date(
                            created_at,
                            DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                        ).date!!.time,
                    DateTimeFormatter.FORMAT_ddMMMyyyy
                ) ?: ""
            } catch (e: Exception) {
                ""
            }
        }

    val formattedTopAnsTime: String
        get() {
            return try {
                TimeAgo.getTimeAgoElseDate(
                    DateTimeFormatter
                        //dateUTC
                        .date(
                            top_answer?.created_at,
                            DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                        ).date!!.time,
                    DateTimeFormatter.FORMAT_ddMMMyyyy
                ) ?: ""
            } catch (e: Exception) {
                ""
            }
        }
}

data class Documents(
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
    @SerializedName("order_no")
    val order_no: String? = null,
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

data class Topics(
    @SerializedName("content_topic_rel_id")
    val content_topic_rel_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
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
    @SerializedName("image_url")
    val image_url: String? = null,
)

data class AnswerData(
    @SerializedName("answer_id")
    val answer_id: String? = null,
    @SerializedName("user")
    val user: String? = null,
    @SerializedName("total_comments")
    var total_comments: String? = null,
    @SerializedName("content_comments_id")
    val content_comments_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("health_coach_id")
    val health_coach_id: String? = null,
    @SerializedName("comment")
    val comment: String? = null,
    @SerializedName("reported")
    var reported: String? = null,
    @SerializedName("report_status")
    val report_status: String? = null,
    @SerializedName("visibility")
    val visibility: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("report_count")
    val report_count: String? = null,
    @SerializedName("like_count")
    var like_count: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("user_type")
    val user_type: String? = null,
    @SerializedName("user_title")
    val user_title: String? = null,
    @SerializedName("tag_id")
    val tag_id: String? = null,
    @SerializedName("content_type")
    val content_type: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
    @SerializedName("parent_id")
    val parent_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("username")
    val username: String? = null,
    @SerializedName("liked")
    var liked: String? = null,
) {

    fun ansGivenBy(selfUserId: String): String {
        return if (patient_id == selfUserId) {
            "You"
        } else {
            username ?: ""
        }
    }

    var likeCount: Int
        set(value) {
            like_count = value.toString()
        }
        get() {
            return like_count?.toIntOrNull() ?: 0
        }

    var commentCount: Int
        set(value) {
            total_comments = value.toString()
        }
        get() {
            return total_comments?.toIntOrNull() ?: 0
        }

    val formattedTopAnsTime: String
        get() {
            return try {
                TimeAgo.getTimeAgoElseDate(
                    DateTimeFormatter
                        //dateUTC
                        .date(
                            created_at,
                            DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                        ).date!!.time,
                    DateTimeFormatter.FORMAT_ddMMMyyyy
                ) ?: ""
            } catch (e: Exception) {
                ""
            }
        }
}

data class AnswerDetailsResData(
    @SerializedName("answer")
    val answer: AnswerData? = null,
    @SerializedName("question")
    val question: QuestionsData? = null,
)

data class AnswerCommentData(
    @SerializedName("content_comments_id")
    val content_comments_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("health_coach_id")
    val health_coach_id: String? = null,
    @SerializedName("comment")
    val comment: String? = null,
    @SerializedName("reported")
    var reported: String? = null,
    @SerializedName("report_status")
    val report_status: String? = null,
    @SerializedName("visibility")
    val visibility: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("report_count")
    val report_count: String? = null,
    @SerializedName("like_count")
    var like_count: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("user_type")
    val user_type: String? = null,
    @SerializedName("tag_id")
    val tag_id: String? = null,
    @SerializedName("content_type")
    val content_type: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
    @SerializedName("parent_id")
    val parent_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("username")
    val username: String? = null,
    @SerializedName("liked")
    var liked: String? = null,
) {

    fun ansGivenBy(selfUserId: String): String {
        return if (patient_id == selfUserId) {
            "You"
        } else {
            username ?: ""
        }
    }

    var likeCount: Int
        set(value) {
            like_count = value.toString()
        }
        get() {
            return like_count?.toIntOrNull() ?: 0
        }

    val formattedTopAnsTime: String
        get() {
            return try {
                TimeAgo.getTimeAgoElseDate(
                    DateTimeFormatter
                        //dateUTC
                        .date(
                            updated_at,
                            DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                        ).date!!.time,
                    DateTimeFormatter.FORMAT_ddMMMyyyy
                ) ?: ""
            } catch (e: Exception) {
                ""
            }
        }
}