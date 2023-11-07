package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class QuizPoleMainData(
    @SerializedName("poll_data")
    val poll_data: ArrayList<QuizPoleData>? = null,
    @SerializedName("quiz_data")
    val quiz_data: ArrayList<QuizPoleData>? = null,
)

class QuizPoleData(
    @SerializedName("poll_master_id")
    val poll_master_id: String? = null,
    @SerializedName("survey_id")
    val survey_id: String? = null,
    @SerializedName("question_id")
    val question_id: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("card_background")
    val card_background: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
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
    @SerializedName("background_url")
    val background_url: String? = null,
    @SerializedName("quiz_master_id")
    val quiz_master_id: String? = null,
    @SerializedName("expiry_date")
    val expiry_date: String? = null,
    @SerializedName("cat")
    val cat: String? = null,
    @SerializedName("questions")
    val questions: ArrayList<Questions>? = null,
) {
    val isQuiz: Boolean
        get() {
            return quiz_master_id.isNullOrBlank().not()
        }
}

class Questions(
    @SerializedName("quiz_questions_rel_id")
    val quiz_questions_rel_id: String? = null,
    @SerializedName("quiz_master_id")
    val quiz_master_id: String? = null,
    @SerializedName("survey_id")
    val survey_id: String? = null,
    @SerializedName("question_id")
    val question_id: String? = null,
)