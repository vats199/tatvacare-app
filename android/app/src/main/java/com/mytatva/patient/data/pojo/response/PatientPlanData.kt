package com.mytatva.patient.data.pojo.response

import android.os.Build
import android.text.Html
import android.text.Spanned
import com.google.gson.annotations.SerializedName
import com.mytatva.patient.core.Common
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class PaymentHistoryData(
    @SerializedName("test_payment")
    val test_payment: ArrayList<PaymentHistorySubData>? = null,
    @SerializedName("plan_payment")
    val plan_payment: ArrayList<PaymentHistorySubData>? = null,
)

class PaymentHistorySubData(
    @SerializedName("offer_price")
    val offer_price: String? = null,
    @SerializedName("android_price")
    val android_price: String? = null,
    @SerializedName("ios_price")
    val ios_price: String? = null,
    @SerializedName("plan_name")
    val plan_name: String? = null,
    @SerializedName("sub_title")
    val sub_title: String? = null,
    @SerializedName("plan_purchase_datetime")
    val plan_purchase_datetime: String? = null,
    @SerializedName("plan_start_date")
    val plan_start_date: String? = null,
    @SerializedName("plan_end_date")
    val plan_end_date: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
    @SerializedName("device_type")
    val device_type: String? = null,
    @SerializedName("transaction_type")
    val transaction_type: String? = null,
    @SerializedName("invoice_url")
    val invoice_url: String? = null,
    @SerializedName("is_get_invoice")
    val is_get_invoice: String? = null,
    var isSelected: Boolean = false,
    var type: String = "", //plan/test
) {
    val isGetInvoice: Boolean
        get() = is_get_invoice == "Y"

    private fun removeHtml(html1: String): String {
        var noHTMLString: String = html1.replace("\\<.*?\\>", "")
        noHTMLString = noHTMLString.replace("\r".toRegex(), "<br/>")
        noHTMLString = noHTMLString.replace("<([bip])>.*?</\u0001>".toRegex(), "")
        //noHTMLString = noHTMLString.replace("\n".toRegex(), " ")
        noHTMLString = noHTMLString.replace("\"".toRegex(), "&quot;")
        noHTMLString =
            noHTMLString.replace("<(.*?)\\>".toRegex(), " ") //Removes all items in brackets
        noHTMLString = noHTMLString.replace("<(.*?)\\\n".toRegex(), " ") //Must be undeneath
        noHTMLString = noHTMLString.replaceFirst("(.*?)\\>".toRegex(), " ")
        noHTMLString = noHTMLString.replace("&nbsp;".toRegex(), " ")
        noHTMLString = noHTMLString.replace("&amp;".toRegex(), " ")
        return noHTMLString.trim()
    }

    val getFormattedPlanPurchaseDate: String
        get() {
            return try {
                DateTimeFormatter.date(plan_purchase_datetime, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }


    fun getServicePeriodLabel(centerText: String): String {
        val startDate = try {
            DateTimeFormatter.date(plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
        } catch (e: Exception) {
            ""
        }
        val endDate = try {
            DateTimeFormatter.date(plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
        } catch (e: Exception) {
            ""
        }

        return "$startDate $centerText $endDate"
    }

}

class PatientPlanMainData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("plan_details")
    val plan_details: ArrayList<PatientPlanData>? = null,
)

class PatientPlanData(
    @SerializedName("patient_plan_rel_id")
    val patient_plan_rel_id: String? = null,
    @SerializedName("plan_master_id")
    val plan_master_id: String? = null,
    @SerializedName("plan_name")
    val plan_name: String? = null,
    @SerializedName("sub_title")
    val sub_title: String? = null,
    @SerializedName("card_image")
    val card_image: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("colour_scheme")
    val colour_scheme: String? = null,
    @SerializedName("renewal_reminder_days")
    val renewal_reminder_days: String? = null,
    @SerializedName("plan_type")
    val plan_type: String? = null,
    @SerializedName("device_type")
    val device_type: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("actual_price")
    val actual_price: String? = null,
    @SerializedName("discount_percentage")
    val discount_percentage: String? = null,
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
    @SerializedName("offer_price")
    val offer_price: String? = null,
    @SerializedName("offer_per_month_price")
    val offer_per_month_price: String? = null,
    @SerializedName("android_price")
    val android_price: String? = null,
    @SerializedName("android_per_month_price")
    val android_per_month_price: String? = null,
    @SerializedName("ios_price")
    val ios_price: String? = null,
    @SerializedName("ios_per_month_price")
    val ios_per_month_price: String? = null,
    @SerializedName("plan_start_date")
    val plan_start_date: String? = null,
    @SerializedName("plan_end_date")
    val plan_end_date: String? = null,
    @SerializedName("plan_purchase_datetime")
    val plan_purchase_datetime: String? = null,
    @SerializedName("features_res")
    val features_res: ArrayList<FeatureRes>? = null,
    @SerializedName("duration")
    val duration: ArrayList<Duration>? = null,
    @SerializedName("start_at")
    val start_at: String? = null,
    @SerializedName("plan_purchased")
    val plan_purchased: String? = null,
    @SerializedName("expiry_date")
    val expiry_date: String? = null,
    var isActivePlan: Boolean = false,
    //var isShowHeader: Boolean = false,
    var headerTitle: String = "",
    var isSelected: Boolean = false,
) {

    val isDefaultFreePlan: Boolean
        get() {
            return plan_type == Common.MyTatvaPlanType.FREE
        }

    val getDiscountPercentage: Double
        get() {
            return discount_percentage?.toDoubleOrNull() ?: 0.0
        }

    val getActualPriceStrikeThrough: Int
        /*Double*/
        get() {
            return actual_price?.toDoubleOrNull()?.toInt() ?: 0
        }

    val getPrice: String
        get() {
            return try {
                if (isActivePlan) {
                    /*android_per_month_price?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "0"*/
                    android_per_month_price?.toDoubleOrNull()?.toInt().toString() ?: "0"
                } else {
                    /*start_at?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "0"*/
                    start_at?.toDoubleOrNull()?.toInt().toString() ?: "0"
                }
            } catch (e: java.lang.Exception) {
                "0"
            }
        }

    val getHtmlFormattedDescription: Spanned
        get() {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT)
            } else {
                Html.fromHtml(description)
            }
        }

    val getHtmlFormattedDescriptionAsString: String
        get() {
            return removeHtml(description ?: "")
            /*return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT).toString()
            } else {
                Html.fromHtml(description).toString()
            }*/
        }

    private fun removeHtml(html1: String): String {
        var noHTMLString: String = html1.replace("\\<.*?\\>", "")
        noHTMLString = noHTMLString.replace("\r".toRegex(), "<br/>")
        noHTMLString = noHTMLString.replace("<([bip])>.*?</\u0001>".toRegex(), "")
        //noHTMLString = noHTMLString.replace("\n".toRegex(), " ")
        noHTMLString = noHTMLString.replace("\"".toRegex(), "&quot;")
        noHTMLString =
            noHTMLString.replace("<(.*?)\\>".toRegex(), " ") //Removes all items in brackets
        noHTMLString = noHTMLString.replace("<(.*?)\\\n".toRegex(), " ") //Must be undeneath
        noHTMLString = noHTMLString.replaceFirst("(.*?)\\>".toRegex(), " ")
        noHTMLString = noHTMLString.replace("&nbsp;".toRegex(), " ")
        noHTMLString = noHTMLString.replace("&amp;".toRegex(), " ")
        return noHTMLString.trim()
    }

    val getFormattedPlanPurchaseDate: String
        get() {
            return try {
                DateTimeFormatter.date(plan_purchase_datetime, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }

    val getFormattedPlanStartDate: String
        get() {
            return try {
                DateTimeFormatter.date(plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MM_yyyy)
            } catch (e: Exception) {
                ""
            }
        }

    val getFormattedPlanEndDate: String
        get() {
            return try {
                DateTimeFormatter.date(plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MM_yyyy)
            } catch (e: Exception) {
                ""
            }
        }

    fun getServicePeriodLabel(centerText: String): String {
        val startDate = try {
            DateTimeFormatter.date(plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
        } catch (e: Exception) {
            ""
        }
        val endDate = try {
            DateTimeFormatter.date(plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
        } catch (e: Exception) {
            ""
        }

        return "$startDate $centerText $endDate"
    }
}

class FeatureRes(
    @SerializedName("plan_features_id")
    val plan_features_id: String? = null,
    @SerializedName("feature")
    val feature: String? = null,
    @SerializedName("order_no")
    val order_no: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("sub_features_ids")
    val sub_features_ids: String? = null,
    @SerializedName("sub_features_keys")
    val sub_features_keys: String? = null,
    @SerializedName("sub_features_names")
    val sub_features_names: String? = null,
    @SerializedName("feature_keys")
    val feature_keys: String? = null,
)

class Duration(
    @SerializedName("plan_package_duration_rel_id")
    val plan_package_duration_rel_id: String? = null,
    @SerializedName("plan_master_id")
    val plan_master_id: String? = null,
    @SerializedName("duration_name")
    val duration_name: String? = null,
    @SerializedName("duration_title")
    val duration_title: String? = null,
    @SerializedName("duration")
    val duration: String? = null,
    @SerializedName("razorpay_plan_id")
    val razorpay_plan_id: String? = null,
    @SerializedName("android_package_id")
    val android_package_id: String? = null,
    @SerializedName("ios_package_id")
    val ios_package_id: String? = null,
    @SerializedName("offer_price")
    val offer_price: String? = null,
    @SerializedName("offer_tag")
    val offer_tag: String? = null,
    @SerializedName("order_no")
    val order_no: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("offer_per_month_price")
    val offer_per_month_price: String? = null,
    @SerializedName("android_per_month_price")
    val android_per_month_price: String? = null,
    @SerializedName("android_price")
    val android_price: String? = null,
    @SerializedName("discount_percentage")
    val discount_percentage: String? = null,
) {
    val getDurationDays: Int
        get() {
            return duration?.toDoubleOrNull()?.toInt() ?: 0
        }

    val discountPercent: Int
        get() {
            return discount_percentage?.toDoubleOrNull()?.toInt() ?: 0
        }

    val offerPerMonthPrice: String
        get() {
            return try {
                /*offer_per_month_price?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "0"*/
                offer_per_month_price?.toDoubleOrNull()?.toInt().toString() ?: "0"
            } catch (e: Exception) {
                "0"
            }
        }

    val androidPerMonthPrice: String
        get() {
            return try {
                /*android_per_month_price?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "0"*/
                android_per_month_price?.toDoubleOrNull()?.toInt()?.toString() ?: "0"
            } catch (e: Exception) {
                "0"
            }
        }

    val isFree: Boolean
        get() {
            return (androidPerMonthPrice.toDoubleOrNull()?.toInt() ?: 0) == 0
        }

    val offerPrice: Int
        get() {
            return try {
                offer_price?.toDoubleOrNull()?.toInt() ?: 0
            } catch (e: Exception) {
                0
            }
        }

    val androidPrice: Int
        get() {
            return try {
                android_price?.toDoubleOrNull()?.toInt() ?: 0
            } catch (e: Exception) {
                0
            }
        }

    val androidPriceFormatted: String
        get() {
            return try {
                android_price?.toDoubleOrNull()?.toInt()?.toString()/*.formatToDecimalPoint(1)*/
                    ?: "0"
            } catch (e: Exception) {
                "0.0"
            }
        }
}