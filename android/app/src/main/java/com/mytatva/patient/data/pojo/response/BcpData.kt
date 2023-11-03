package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize
import kotlin.math.roundToInt

class BcpPurchasedData(
    @SerializedName("plan_name")
    val plan_name: String? = null,
    @SerializedName("what_to_expect")
    val what_to_expect: String? = null,
    @SerializedName("appointment")
    val appointment: String? = null,
    @SerializedName("my_devices")
    val my_devices: String? = null,
    @SerializedName("diagnostic_tests")
    val diagnostic_tests: String? = null,
    @SerializedName("plan_details")
    val plan_details: BcpPlanData? = null,
    @SerializedName("duration_details")
    val duration_details: BcpDuration? = null,
    @SerializedName("plan_active")
    val plan_active: String? = null,
)

class BcpMainData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("key")
    val key: String? = null,
    @SerializedName("plans")
    val plans: ArrayList<BcpPlanData>? = null,
)

@Parcelize
class BcpPlanData(
    //BCP plan listing keys
    @SerializedName("patient_plan_rel_id")
    var patient_plan_rel_id: String? = null,
    @SerializedName("plan_master_id")
    val plan_master_id: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
    @SerializedName("plan_type")
    val plan_type: String? = null,
    @SerializedName("enable_rent_buy")
    val enable_rent_buy: String? = null,
    @SerializedName("device")
    val devices: ArrayList<MyDevicesData>? = null,

    //BCP plan details keys, coming in details response
    @SerializedName("plan_name")
    val plan_name: String? = null,
    @SerializedName("sub_title")
    val sub_title: String? = null,
    @SerializedName("card_image")
    val card_image: String? = null,
    @SerializedName("card_image_detail")
    val card_image_detail: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("review_description")
    val review_description: String? = null,
    @SerializedName("what_to_expect")
    val what_to_expect: String? = null,
    @SerializedName("colour_scheme")
    val colour_scheme: String? = null,
    @SerializedName("renewal_reminder_days")
    val renewal_reminder_days: String? = null,
    @SerializedName("start_at")
    val start_at: String? = null,
    @SerializedName("discount_percentage")
    val discount_percentage: String? = null,
    @SerializedName("actual_price")
    val actual_price: String? = null,
    @SerializedName("gst_percentage")
    val gst_percentage: String? = null,
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

    @SerializedName("device_type")
    val device_type: String? = null,

    @SerializedName("remaining_days")
    val remaining_days: String? = null,
    @SerializedName("total_days")
    val total_days: String? = null,
    @SerializedName("expiry_date")
    val expiry_date: String? = null,
    @SerializedName("start_date")
    val start_date: String? = null,
    @SerializedName("show_renew")
    val show_renew: String? = null,



    var isActivePlan: Boolean = false,
    //var isShowHeader: Boolean = false,
    var headerTitle: String = "",
    var isSelected: Boolean = false,
) : Parcelable {
    val isPlanPurchased: Boolean
        get() {
            return patient_plan_rel_id.isNullOrBlank().not()
        }

    val getGstPercentage: Double
        get() {
            return gst_percentage?.toDoubleOrNull() ?: 0.0
        }

//    val isDefaultFreePlan: Boolean
//        get() {
//            return plan_type == "Free"
//        }
//
//    val getDiscountPercentage: Double
//        get() {
//            return discount_percentage?.toDoubleOrNull() ?: 0.0
//        }
//
//    val getActualPriceStrikeThrough: Int
//        /*Double*/
//        get() {
//            return actual_price?.toDoubleOrNull()?.toInt() ?: 0
//        }
//
//    val getPrice: String
//        get() {
//            return try {
//                if (isActivePlan) {
//                    /*android_per_month_price?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "0"*/
//                    android_per_month_price?.toDoubleOrNull()?.toInt().toString() ?: "0"
//                } else {
//                    /*start_at?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "0"*/
//                    start_at?.toDoubleOrNull()?.toInt().toString() ?: "0"
//                }
//            } catch (e: java.lang.Exception) {
//                "0"
//            }
//        }
//
//    val getHtmlFormattedDescription: Spanned
//        get() {
//            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT)
//            } else {
//                Html.fromHtml(description)
//            }
//        }
//
//    val getHtmlFormattedDescriptionAsString: String
//        get() {
//            return removeHtml(description ?: "")
//            /*return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT).toString()
//            } else {
//                Html.fromHtml(description).toString()
//            }*/
//        }
//
//    private fun removeHtml(html1: String): String {
//        var noHTMLString: String = html1.replace("\\<.*?\\>", "")
//        noHTMLString = noHTMLString.replace("\r".toRegex(), "<br/>")
//        noHTMLString = noHTMLString.replace("<([bip])>.*?</\u0001>".toRegex(), "")
//        //noHTMLString = noHTMLString.replace("\n".toRegex(), " ")
//        noHTMLString = noHTMLString.replace("\"".toRegex(), "&quot;")
//        noHTMLString =
//            noHTMLString.replace("<(.*?)\\>".toRegex(), " ") //Removes all items in brackets
//        noHTMLString = noHTMLString.replace("<(.*?)\\\n".toRegex(), " ") //Must be undeneath
//        noHTMLString = noHTMLString.replaceFirst("(.*?)\\>".toRegex(), " ")
//        noHTMLString = noHTMLString.replace("&nbsp;".toRegex(), " ")
//        noHTMLString = noHTMLString.replace("&amp;".toRegex(), " ")
//        return noHTMLString.trim()
//    }
//
//    val getFormattedPlanPurchaseDate: String
//        get() {
//            return try {
//                DateTimeFormatter.date(plan_purchase_datetime, DateTimeFormatter.FORMAT_yyyyMMdd)
//                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
//            } catch (e: Exception) {
//                ""
//            }
//        }
//
//    val getFormattedPlanStartDate: String
//        get() {
//            return try {
//                DateTimeFormatter.date(plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd)
//                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MM_yyyy)
//            } catch (e: Exception) {
//                ""
//            }
//        }
//
//    val getFormattedPlanEndDate: String
//        get() {
//            return try {
//                DateTimeFormatter.date(plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd)
//                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MM_yyyy)
//            } catch (e: Exception) {
//                ""
//            }
//        }
//
//    fun getServicePeriodLabel(centerText: String): String {
//        val startDate = try {
//            DateTimeFormatter.date(plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd)
//                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
//        } catch (e: Exception) {
//            ""
//        }
//        val endDate = try {
//            DateTimeFormatter.date(plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd)
//                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
//        } catch (e: Exception) {
//            ""
//        }
//
//        return "$startDate $centerText $endDate"
//    }
}

//class BcpFeatureRes(
//    @SerializedName("plan_features_id")
//    val plan_features_id: String? = null,
//    @SerializedName("feature")
//    val feature: String? = null,
//    @SerializedName("order_no")
//    val order_no: String? = null,
//    @SerializedName("is_active")
//    val is_active: String? = null,
//    @SerializedName("created_at")
//    val created_at: String? = null,
//    @SerializedName("sub_features_ids")
//    val sub_features_ids: String? = null,
//    @SerializedName("sub_features_keys")
//    val sub_features_keys: String? = null,
//    @SerializedName("sub_features_names")
//    val sub_features_names: String? = null,
//    @SerializedName("feature_keys")
//    val feature_keys: String? = null,
//)
//

class BcpDetailsMainData(
    @SerializedName("plan_details")
    val plan_details: BcpPlanData? = null,
    @SerializedName("duration_details")
    val duration_details: ArrayList<BcpDuration>? = null,
    @SerializedName("data")
    val data: ArrayList<BcpFeatureTableData>? = null,
)

class BcpFeatureTableData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("data")
    val data: ArrayList<String>? = null,
    /*@SerializedName("parent_title") // not using this, added to res to handle iOS side table
    val parent_title: String? = null,*/
)

@Parcelize
class BcpDuration(
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

    //new keys in BCP duration than normal plan duration
    @SerializedName("rent_buy_type")
    val rent_buy_type: String? = null,
    @SerializedName("device_list")
    val device_list: String? = null,
    @SerializedName("device_names")
    val device_names: String? = null,
    @SerializedName("diagnostic_tests")
    val diagnostic_tests: String? = null,
    @SerializedName("diagnostic_tests_names")
    val diagnostic_tests_names: String? = null,
    @SerializedName("diagnostic_test_used_count")
    var diagnostic_test_used_count: String? = null,
    @SerializedName("diagnostic_test_session_count")
    val diagnostic_test_session_count: String? = null,
    @SerializedName("physiotherapist_session_count")
    val physiotherapist_session_count: String? = null,
    @SerializedName("nutritionist_session_count")
    val nutritionist_session_count: String? = null,
    @SerializedName("app_features_session_count")
    val app_features_session_count: String? = null,
    @SerializedName("is_recommended")
    val is_recommended: String? = null,
    @SerializedName("android_gst_amount")
    val android_gst_amount: String? = null,
    @SerializedName("android_final_amount")
    var android_final_amount: String? = null,

    var couponCodeDiscountAmount:Int = 0// set this when coupon code is applied to update the androidFinalAmount

    ) : Parcelable {

    val getDiscountAmount:Int
        get() {
            return (offerPrice.toDoubleOrNull()?.toInt() ?: 0) - androidPrice
        }

    val androidGstAmount: Int
        /*Double*/
        get() {
            return android_gst_amount?.toDoubleOrNull()?.roundToInt() ?: 0
        }

    val androidFinalAmountBeforeCouponDiscount: Int
        /*Double*/
        get() {
            return (android_final_amount?.toDoubleOrNull()?.roundToInt() ?: 0)
        }

    val androidFinalAmount: Int
        /*Double*/
        get() {
            return (android_final_amount?.toDoubleOrNull()?.roundToInt() ?: 0) - couponCodeDiscountAmount
        }

    val isContainsTestOrDevice: Boolean
        get() {
            return device_names.isNullOrBlank().not() || diagnostic_tests.isNullOrBlank().not()
        }

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
                offer_per_month_price?.toDoubleOrNull()?.toInt()?.toString() ?: "0"
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
            return (androidPrice) == 0
            /*return (androidPerMonthPrice.toDoubleOrNull()?.toInt() ?: 0) == 0*/
        }

    val offerPrice: String
        get() {
            return try {
                offer_price?.toDoubleOrNull()?.toInt()?.toString() ?: "0"
            } catch (e: Exception) {
                "0"
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


//class PaymentHistoryData(
//    @SerializedName("test_payment")
//    val test_payment: ArrayList<PaymentHistorySubData>? = null,
//    @SerializedName("plan_payment")
//    val plan_payment: ArrayList<PaymentHistorySubData>? = null,
//)
//
//class PaymentHistorySubData(
//    @SerializedName("offer_price")
//    val offer_price: String? = null,
//    @SerializedName("android_price")
//    val android_price: String? = null,
//    @SerializedName("ios_price")
//    val ios_price: String? = null,
//    @SerializedName("plan_name")
//    val plan_name: String? = null,
//    @SerializedName("sub_title")
//    val sub_title: String? = null,
//    @SerializedName("plan_purchase_datetime")
//    val plan_purchase_datetime: String? = null,
//    @SerializedName("plan_start_date")
//    val plan_start_date: String? = null,
//    @SerializedName("plan_end_date")
//    val plan_end_date: String? = null,
//    @SerializedName("image_url")
//    val image_url: String? = null,
//    @SerializedName("device_type")
//    val device_type: String? = null,
//    @SerializedName("transaction_type")
//    val transaction_type: String? = null,
//    var isSelected: Boolean = false,
//    var type: String = "", //plan/test
//) {
//
//
//    private fun removeHtml(html1: String): String {
//        var noHTMLString: String = html1.replace("\\<.*?\\>", "")
//        noHTMLString = noHTMLString.replace("\r".toRegex(), "<br/>")
//        noHTMLString = noHTMLString.replace("<([bip])>.*?</\u0001>".toRegex(), "")
//        //noHTMLString = noHTMLString.replace("\n".toRegex(), " ")
//        noHTMLString = noHTMLString.replace("\"".toRegex(), "&quot;")
//        noHTMLString =
//            noHTMLString.replace("<(.*?)\\>".toRegex(), " ") //Removes all items in brackets
//        noHTMLString = noHTMLString.replace("<(.*?)\\\n".toRegex(), " ") //Must be undeneath
//        noHTMLString = noHTMLString.replaceFirst("(.*?)\\>".toRegex(), " ")
//        noHTMLString = noHTMLString.replace("&nbsp;".toRegex(), " ")
//        noHTMLString = noHTMLString.replace("&amp;".toRegex(), " ")
//        return noHTMLString.trim()
//    }
//
//    val getFormattedPlanPurchaseDate: String
//        get() {
//            return try {
//                DateTimeFormatter.date(plan_purchase_datetime, DateTimeFormatter.FORMAT_yyyyMMdd)
//                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
//            } catch (e: Exception) {
//                ""
//            }
//        }
//
//
//    fun getServicePeriodLabel(centerText: String): String {
//        val startDate = try {
//            DateTimeFormatter.date(plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd)
//                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
//        } catch (e: Exception) {
//            ""
//        }
//        val endDate = try {
//            DateTimeFormatter.date(plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd)
//                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_dash)
//        } catch (e: Exception) {
//            ""
//        }
//
//        return "$startDate $centerText $endDate"
//    }
//
//}