package com.mytatva.patient.data.pojo.response

import android.os.Build
import android.text.Html
import android.text.Spanned
import com.google.gson.annotations.SerializedName

class FaqMainData(
    @SerializedName("category_name")
    val category_name: String? = null,
    @SerializedName("data")
    val data: ArrayList<FaqData>? = null,
    var isSelected: Boolean = false,
)

class FaqData(
    @SerializedName("faq_master_id")
    val faq_master_id: String? = null,
    @SerializedName("faq_question")
    val faq_question: String? = null,
    @SerializedName("faq_answer")
    val faq_answer: String? = null,
    @SerializedName("answer_prefix")
    val answer_prefix: String? = null,
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
    var isSelected: Boolean = false,
) {
    val getHtmlFormattedAns:Spanned
        get() {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Html.fromHtml("${answer_prefix?:""} ${faq_answer?:""}", Html.FROM_HTML_MODE_COMPACT)
            } else {
                Html.fromHtml("${answer_prefix?:""} ${faq_answer?:""}")
            }
        }
}