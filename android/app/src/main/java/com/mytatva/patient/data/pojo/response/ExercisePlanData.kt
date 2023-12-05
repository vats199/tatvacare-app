package com.mytatva.patient.data.pojo.response

import android.os.Build
import android.text.Html
import android.text.Spanned
import com.google.gson.annotations.SerializedName
import com.mytatva.patient.R
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class ExercisePlanData(
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
    @SerializedName("fitness_level")
    val fitness_level: String? = null,
    @SerializedName("exercise_tools")
    val exercise_tools: String? = null,
    @SerializedName("topic_name")
    val topic_name: String? = null,
    @SerializedName("genre")
    val genre: String? = null,
    @SerializedName("breathing_counts")
    val breathing_counts: String? = null,
    @SerializedName("exercise_counts")
    val exercise_counts: String? = null,
    @SerializedName("exercise_done")
    val exercise_done: String? = null,
    @SerializedName("breathing_done")
    val breathing_done: String? = null,
    @SerializedName("total_days")
    val total_days: String? = null,
    @SerializedName("exercise_restpost_set")
    val exercise_restpost_set: String? = null,
    @SerializedName("exercise_sets")
    val exercise_sets: String? = null,
    @SerializedName("plan_type")
    val plan_type: String? = null,
    @SerializedName("media")
    val media: ArrayList<ContentMediaData>? = null,
    @SerializedName("exercise_added_by")
    val exercise_added_by: String? = null,
    var isSelected: Boolean = false,
) {

    var likeCount: Int
        set(value) {
            no_of_likes = value.toString()
        }
        get() {
            return no_of_likes?.toIntOrNull() ?: 0
        }

    var commentCount: Int
        set(value) {
            no_of_comments = value.toString()
        }
        get() {
            return no_of_comments?.toIntOrNull() ?: 0
        }

    val getTotalDays: Int
        get() {
            return total_days?.toIntOrNull() ?: 0
        }

    val getTotalSets: Int
        get() {
            return exercise_sets?.toIntOrNull() ?: 0
        }

    val getHtmlFormattedDescription: Spanned
        get() {
            return try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    Html.fromHtml(description ?: "", Html.FROM_HTML_MODE_LEGACY)
                } else {
                    Html.fromHtml(description ?: "")
                }
            } catch (e: java.lang.Exception) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    Html.fromHtml("", Html.FROM_HTML_MODE_LEGACY)
                } else {
                    Html.fromHtml("")
                }
            }
        }

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

    val getSubDataList: ArrayList<ExercisePlanSubData>
        get() {
            val list = arrayListOf<ExercisePlanSubData>()
            list.add(ExercisePlanSubData().apply {
                displayTitle = "Breathing"
                exerciseCountLabel = if (breathing_counts == "1") breathing_counts.plus(" Exercise")
                else breathing_counts.plus(" Exercises")
                isDone = breathing_done == "Y"
                iconRes = R.drawable.ic_breathing_icon
            })
            list.add(ExercisePlanSubData().apply {
                displayTitle = "Exercise"
                exerciseCountLabel = if (exercise_counts == "1") exercise_counts.plus(" Exercise")
                else exercise_counts.plus(" Exercises")
                isDone = exercise_done == "Y"
                iconRes = R.drawable.ic_exercise_icon
            })
            return list
        }
}

/*
"day": "Monday",
      "day_date": "2022-02-07",
      "exercise_plan_day_id": "c625bc8d-84ea-11ec-8229-4984b9153df0",
      "content_master_id": "a60c7a60-84ea-11ec-8229-4984b9153df0",
      "is_rest_day": 0,
      "routine_data": [
        {
          "routine": 1,
          "title": "Routine 1 for the day",
          "breathing_count": 2,
          "breathing_done": "N"
        }
      ]
 */

class ExercisePlanDayData(
    @SerializedName("day_date")
    val day_date: String? = null,
    @SerializedName("routine_data")
    val routine_data: ArrayList<RoutineData>? = null,
    @SerializedName("exercise_plan_day_id")
    val exercise_plan_day_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("day")
    val day: String? = null,
    @SerializedName("breathing_counts")
    val breathing_counts: String? = null,
    @SerializedName("exercise_counts")
    val exercise_counts: String? = null,
    @SerializedName("breathing_duration")
    val breathing_duration: String? = null,
    @SerializedName("breathing_duration_unit")
    val breathing_duration_unit: String? = null,
    @SerializedName("exercise_duration_unit")
    val exercise_duration_unit: String? = null,
    @SerializedName("exercise_duration")
    val exercise_duration: String? = null,
    @SerializedName("breathing_description")
    val breathing_description: String? = null,
    @SerializedName("exercise_description")
    val exercise_description: String? = null,
    @SerializedName("is_rest_day")
    val is_rest_day: String? = null,
    @SerializedName("is_trial")
    val is_trial: String? = null,
    @SerializedName("order_no")
    val order_no: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("breathing_done")
    var breathing_done: String? = null,
    @SerializedName("exercise_done")
    var exercise_done: String? = null,
    @SerializedName("goal_date")
    val goal_date: String? = null,
    @SerializedName("month")
    val month: String? = null,
    @SerializedName("date")
    val date: String? = null,
    @SerializedName("exercise_restpost_set")
    val exercise_restpost_set: String? = null,
    @SerializedName("exercise_restpost_set_unit")
    val exercise_restpost_set_unit: String? = null,
    @SerializedName("exercise_rest_post")
    val exercise_rest_post: String? = null,
    @SerializedName("exercise_rest_post_unit")
    val exercise_rest_post_unit: String? = null,
    @SerializedName("exercise_data")
    val exercise_data: ArrayList<ExerciseBreathingDayData>? = null,
    @SerializedName("breathing_data")
    val breathing_data: ArrayList<ExerciseBreathingDayData>? = null,
) {
    val getDayTitleLabel: String
        get() {
            return "$day, $date $month"
        }

    val getDayTitleLabelNew: String
        get() {
            return try {
                val dateLabel = DateTimeFormatter.date(day_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dMMMM)
                "$day, $dateLabel"
            } catch (e: Exception) {
                ""
            }
        }

    val getSubDataList: ArrayList<ExercisePlanSubData>
        get() {
            val list = arrayListOf<ExercisePlanSubData>()
            list.add(ExercisePlanSubData().apply {
                displayTitle = "Breathing"
                exerciseCountLabel = if (breathing_counts == "1") breathing_counts.plus(" Exercise")
                else breathing_counts.plus(" Exercises")
                isDone = breathing_done == "Y"
                iconRes = R.drawable.ic_breathing_icon
            })
            list.add(ExercisePlanSubData().apply {
                displayTitle = "Exercise"
                exerciseCountLabel = if (exercise_counts == "1") exercise_counts.plus(" Exercise")
                else exercise_counts.plus(" Exercises")
                isDone = exercise_done == "Y"
                iconRes = R.drawable.ic_exercise_icon
            })
            return list
        }
}

class RoutineData(
    @SerializedName("routine")
    val routine: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("breathing_count")
    val breathing_count: String? = null,
    @SerializedName("breathing_done")
    val breathing_done: String? = null,
    @SerializedName("exercise_count")
    val exercise_count: String? = null,
    @SerializedName("exercise_done")
    val exercise_done: String? = null,
    var isSelected: Boolean = false,
) {
    val exerciseCountLabel: String
        get() {
            return if (exercise_count == "1") exercise_count.plus(" Exercise")
            else exercise_count.plus(" Exercises")
        }
    val breathingCountLabel: String
        get() {
            return if (breathing_count == "1") breathing_count.plus(" Exercise")
            else breathing_count.plus(" Exercises")
        }
}

class ExerciseBreathingDayData(
    @SerializedName("exercise_plan_day_rel_id")
    val exercise_plan_day_rel_id: String? = null,
    @SerializedName("exercise_plan_day_id")
    val exercise_plan_day_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("order_no")
    val order_no: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("unit_no")
    val unit_no: String? = null,
    @SerializedName("unit")
    val unit: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("content_data")
    val content_data: ExercisePlanData? = null,
    var isDescriptionType: Boolean = false,
    var description: String = "",
) {
    val getHtmlFormattedDescription: Spanned
        get() {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT)
            } else {
                Html.fromHtml(description)
            }
        }
}


/**
 * @class :- ExercisePlanSubData
 * class to generate sub list of plan to display
 * not as per API response
 */
class ExercisePlanSubData(
    var displayTitle: String? = null,
    var exerciseCountLabel: String? = null,
    var isDone: Boolean = false,
    var iconRes: Int = R.drawable.ic_breathing_icon,
)