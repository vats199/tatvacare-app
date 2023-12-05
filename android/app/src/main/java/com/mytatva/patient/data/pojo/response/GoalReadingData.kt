package com.mytatva.patient.data.pojo.response

import android.content.Context
import android.os.Parcelable
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import com.google.gson.annotations.SerializedName
import com.mytatva.patient.R
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.model.getFattyLiverGradeTitle
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.utils.TimeAgo
import com.mytatva.patient.utils.apputils.HeightWeightUtils
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.formatToDecimalPoint
import kotlinx.parcelize.Parcelize

@Parcelize
class GoalReadingData(
    @SerializedName("readings_master_id")
    val readings_master_id: String? = null,
    @SerializedName("reading_name")
    val reading_name: String? = null,
    @SerializedName("reading_range")
    val reading_range: String? = null,
    @SerializedName("x_value")
    val x_value: String? = null,
    @SerializedName("reading_value")
    val reading_value: String? = null,
    @SerializedName("reading_values")
    val reading_values: ArrayList<String>? = null,
    @SerializedName("reading_value_data")
    val reading_value_data: ReadingValueData? = null,
    @SerializedName("measurements")
    val measurements: String? = null,
    @SerializedName("information")
    val information: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
    @SerializedName("img_extn")
    val img_extn: String? = null,
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
    @SerializedName("reading_datetime")
    val reading_datetime: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
    @SerializedName("image_icon_url")
    val image_icon_url: String? = null,
    @SerializedName("background_color")
    val background_color: String? = null,
    /*@SerializedName("image_color")
    val image_color: String? = null,*/
    @SerializedName("goal_master_id")
    val goal_master_id: String? = null,
    @SerializedName("goal_name")
    val goal_name: String? = null,
    @SerializedName("goal_measurement")
    val goal_measurement: String? = null,
    @SerializedName("goal_defaul_val")
    val goal_defaul_val: String? = null,
    @SerializedName("mandatory")
    val mandatory: String? = null,
    @SerializedName("color_code")
    val color_code: String? = null,

    @SerializedName("goal_value")
    var goal_value: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("start_time")
    val start_time: String? = null,
    @SerializedName("end_time")
    val end_time: String? = null,
    @SerializedName("todays_achieved_value")
    var todays_achieved_value: String? = null,

    // for chart response
    @SerializedName("fast")
    val fast: String? = null,
    @SerializedName("pp")
    val pp: String? = null,
    @SerializedName("diastolic")
    val diastolic: String? = null,
    @SerializedName("systolic")
    val systolic: String? = null,
    @SerializedName("weight")
    val weight: String? = null,
    @SerializedName("height")
    val height: String? = null,

    @SerializedName("cap")
    val cap: String? = null,
    @SerializedName("lsm")
    val lsm: String? = null,

    @SerializedName("reading_value_min")
    val reading_value_min: String? = null,
    @SerializedName("reading_value_max")
    val reading_value_max: String? = null,

    @SerializedName("goals_required")
    val goals_required: String? = null,
    @SerializedName("reading_required")
    val reading_required: String? = null,

    @SerializedName("total_reading_average")
    val total_reading_average: String? = null,

    @SerializedName("avg_current")
    val avg_current: String? = null,
    @SerializedName("avg_other")
    val avg_other: String? = null,

    @SerializedName("default_reading")
    val default_reading: String? = null,

    @SerializedName("standard_value")
    val standard_value: String? = null,

    @SerializedName("graph")
    val graph: String? = null,
    @SerializedName("in_range")
    val in_range: InRangeData? = null,

    @SerializedName("not_configured")
    val not_configured: String? = null,

    var isSelected: Boolean = false,
    var isBreathingOrExerciseDone: Boolean = false,
    var goalValueToUpdate: String = "",
) : Parcelable {

    fun getReadingAvgLabel(label: String): String {
        return label.plus(" ${total_reading_average ?: ""} $measurements")
    }

    fun getStandardReadingLabel(label: String): String {
        return default_reading ?: ""
    }

    fun getGoalAverageLabel(context: Context): String {
        return context.resources.getString(
            R.string.label_average_goal_adherence,
            goal_name,
            avg_current.plus(" ").plus(goal_measurement),
            goal_name,
            avg_other.plus(" ").plus(goal_measurement)
        )
    }

    fun getStandardGoalLabel(label: String): String {
        return standard_value ?: ""
    }

    val getReadingValue: Int?
        get() {
            return reading_value?.toDoubleOrNull()?.toInt()
        }

    val getReadingValueDouble: Double?
        get() {
            return reading_value?.toDoubleOrNull()
        }

    val getFormattedReadingValue: String
        get() {
            return if (keys == Readings.HbA1c.readingKey
                || keys == Readings.BodyWeight.readingKey
                || keys == Readings.BMI.readingKey
                || keys == Readings.SerumCreatinine.readingKey
                || keys == Readings.BoneMass.readingKey
                || keys == Readings.SubcutaneousFat.readingKey
                || keys == Readings.MuscleMass.readingKey
                || keys == Readings.VisceralFat.readingKey
            ) {
                getReadingValueDouble?.formatToDecimalPoint(1) ?: ""
            } else if (keys == Readings.FEV1.readingKey
                || keys == Readings.FVC.readingKey
                || keys == Readings.FEV1FVC_RATIO.readingKey
                || keys == Readings.AQI.readingKey
                || keys == Readings.HUMIDITY.readingKey
                || keys == Readings.TEMPERATURE.readingKey
            ) {
                getReadingValueDouble?.formatToDecimalPoint(2) ?: ""
            } else if (keys == Readings.FIB4Score.readingKey) {
                getReadingValueDouble?.formatToDecimalPoint(2) ?: ""
            } else if (keys == Readings.FattyLiverUSGGrade.readingKey) {
                getReadingValueDouble?.toInt()?.getFattyLiverGradeTitle() ?: ""
            } else {
                getReadingValue?.toString() ?: ""
            }
        }

    val getFastBgValue: Int?
        get() {
            return reading_value_data?.fast?.toDoubleOrNull()?.toInt()
        }

    val getPPBgValue: Int?
        get() {
            return reading_value_data?.pp?.toDoubleOrNull()?.toInt()
        }

    val getDiastolicValue: Int?
        get() {
            return reading_value_data?.diastolic?.toDoubleOrNull()?.toInt()
        }

    val getSystolicValue: Int?
        get() {
            return reading_value_data?.systolic?.toDoubleOrNull()?.toInt()
        }

    val getHeightValue: Int?
        get() {
            return reading_value_data?.height?.toDoubleOrNull()?.toInt()
        }

    val getWeightValue: Double?
        get() {
            return reading_value_data?.weight?.toDoubleOrNull()
        }

    val getReadingLabel: String
        get() {
            return if (keys == Readings.BloodPressure.readingKey) {
                if (reading_value_data?.diastolic.isNullOrBlank()
                    && reading_value_data?.systolic.isNullOrBlank()
                ) {
                    ""
                } else {
                    (getSystolicValue?.toString() ?: "0")
                        .plus("/")
                        .plus(
                            getDiastolicValue?.toString()
                                ?: "0"
                        )
                }
            } else if (keys == Readings.BloodGlucose.readingKey) {
                if (reading_value_data?.fast.isNullOrBlank()
                    && reading_value_data?.pp.isNullOrBlank()
                ) {
                    ""
                } else {
                    (getFastBgValue?.toString() ?: "0")
                        .plus("/")
                        .plus(getPPBgValue?.toString() ?: "0")
                }
            } else if (keys == Readings.FibroScan.readingKey) {
                if (reading_value_data?.lsm.isNullOrBlank()
                    && reading_value_data?.cap.isNullOrBlank()
                ) {
                    ""
                } else {
                    (getLsmValue?.formatToDecimalPoint(1) ?: "0.0")
                        .plus("/")
                        .plus(getCapValue?.toString() ?: "0")
                }
            } else if (reading_value.isNullOrBlank().not()) {
                if (keys == Readings.HbA1c.readingKey
                    || keys == Readings.BodyWeight.readingKey
                    || keys == Readings.BMI.readingKey
                    || keys == Readings.SerumCreatinine.readingKey
                    || keys == Readings.BoneMass.readingKey
                    || keys == Readings.SubcutaneousFat.readingKey
                    || keys == Readings.MuscleMass.readingKey
                    || keys == Readings.VisceralFat.readingKey
                ) {
                    reading_value?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: ""
                } else if (keys == Readings.FEV1.readingKey
                    || keys == Readings.FVC.readingKey
                    || keys == Readings.FEV1FVC_RATIO.readingKey
                    || keys == Readings.AQI.readingKey
                    || keys == Readings.HUMIDITY.readingKey
                    || keys == Readings.TEMPERATURE.readingKey
                ) {
                    reading_value?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: ""
                } else if (keys == Readings.FIB4Score.readingKey) {
                    reading_value?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: ""
                } else if (keys == Readings.FattyLiverUSGGrade.readingKey) {
                    reading_value?.toDoubleOrNull()?.toInt()?.getFattyLiverGradeTitle() ?: ""
                } else {
                    reading_value?.toDoubleOrNull()?.toInt()?.toString() ?: ""
                }
            } else {
                ""
            }
        }

    /*val getReadingLabelWithUnit: String
        get() {
            return if (keys == Readings.BloodPressure.readingKey) {
                if (reading_value_data?.diastolic.isNullOrBlank()) {
                    ""
                } else {
                    (getDiastolicValue?.toString() ?: "")
                        .plus("/")
                        .plus(getSystolicValue?.toString() ?: "")
                        .plus(" $measurements")
                }
            } else if (keys == Readings.BloodGlucose.readingKey) {
                if (reading_value_data?.fast.isNullOrBlank()) {
                    ""
                } else {
                    (getFastBgValue?.toString() ?: "")
                        .plus("/")
                        .plus(getPPBgValue?.toString() ?: "")
                        .plus(" $measurements")
                }
            } else if (keys == Readings.FibroScan.readingKey) {
                if (reading_value_data?.lsm.isNullOrBlank()) {
                    ""
                } else {
                    (getLsmValue?.toString() ?: "")
                        .plus(
                            if (measurements.isNullOrBlank().not() && measurements!!.contains(","))
                                " ${measurements.split(",")[0]}"
                            else
                                " $measurements"
                        ).plus("/")
                        .plus(getCapValue?.toString() ?: "")
                        .plus(
                            if (measurements.isNullOrBlank().not() && measurements!!.contains(","))
                                " ${measurements.split(",")[1]}"
                            else
                                " $measurements"
                        )
                }
            } else if (reading_value.isNullOrBlank().not()) {
                var readingValue = ""
                if (keys == Readings.HbA1c.readingKey) {
                    readingValue = (reading_value?.toDoubleOrNull()?.formatToDecimalPoint(1) ?: "")
                } else if (keys == Readings.FIB4Score.readingKey) {
                    readingValue = (reading_value?.toDoubleOrNull()?.formatToDecimalPoint(4) ?: "")
                } else {
                    readingValue = (reading_value?.toDoubleOrNull()?.toInt()?.toString() ?: "")
                }
                if (readingValue.isBlank()) "" else readingValue.plus(" $measurements")
            } else {
                ""
            }
        }*/

    val formattedUpdatedDate: String
        get() {
            return try {
                val dateTime =
                    if (keys == Readings.CaloriesBurned.readingKey || keys == Readings.SedentaryTime.readingKey) updated_at else reading_datetime
                TimeAgo.getTimeAgoElseDate(
                    DateTimeFormatter
                        //dateUTC
                        .date(
                            dateTime /*reading_datetime*/ /*updated_at*/,
                            DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                        ).date!!.time,
                    DateTimeFormatter.FORMAT_ddMMMyyyy
                ) ?: ""
            } catch (e: Exception) {
                ""
            }
        }

    val getLsmValue: Double?
        get() {
            return reading_value_data?.lsm?.toDoubleOrNull()
        }

    val getCapValue: Int?
        get() {
            return reading_value_data?.cap?.toDoubleOrNull()?.toInt()
        }

    val getSgptValue: Int?
        get() {
            return reading_value_data?.sgpt?.toDoubleOrNull()?.toInt()
        }

    val getSgotValue: Int?
        get() {
            return reading_value_data?.sgot?.toDoubleOrNull()?.toInt()
        }

    val getPlateletValue: Int?
        get() {
            return reading_value_data?.platelet?.toDoubleOrNull()?.toInt()
        }

    val getLdlValue: Int?
        get() {
            return reading_value_data?.ldl_cholesterol?.toDoubleOrNull()?.toInt()
        }

    val getHdlValue: Int?
        get() {
            return reading_value_data?.hdl_cholesterol?.toDoubleOrNull()?.toInt()
        }

    val getTriglyceridesValue: Int?
        get() {
            return reading_value_data?.triglycerides?.toDoubleOrNull()?.toInt()
        }

    val getReadingsMeasurement: String
        get() {
            return if (keys == Readings.FibroScan.readingKey)
                ""
            else
                measurements ?: ""
        }


    /*fun setReadingValueLabelUIAndData(textViewValue: AppCompatTextView) {
        textViewValue.text = getReadingLabel
        when (keys) {
            Readings.BloodPressure.readingKey -> {
                if (getDiastolicValue != null && in_range?.diastolic == "N" && getSystolicValue != null && in_range?.systolic == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.pink1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.pink1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else if (getDiastolicValue != null && in_range?.diastolic == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.pink1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else if (getSystolicValue != null && in_range?.systolic == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.textBlack1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.pink1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.textBlack1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                }
            }
            Readings.BloodGlucose.readingKey -> {
                if (getFastBgValue != null && in_range?.fast == "N" && getPPBgValue != null && in_range?.pp == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.pink1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.pink1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else if (getFastBgValue != null && in_range?.fast == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.pink1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else if (getPPBgValue != null && in_range?.pp == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.textBlack1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.pink1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.textBlack1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                }
            }
            Readings.FibroScan.readingKey -> {
                if (getLsmValue != null && in_range?.lsm == "N" && getCapValue != null && in_range?.cap == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.pink1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.pink1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else if (getLsmValue != null && in_range?.lsm == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.pink1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else if (getCapValue != null && in_range?.cap == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.textBlack1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.pink1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                } else {
                    TextDecorator.decorate(textViewValue, getReadingLabel)
                        .setTextColor(R.color.textBlack1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .build()
                }
            }
            else -> {
                textViewValue.setTextColor(
                    ContextCompat.getColor(
                        textViewValue.context,
                        if (in_range?.in_range == "N") R.color.pink1 else R.color.textBlack1
                    )
                )
            }
        }
    }*/


    //v2 handled unit size with formatter in single textview
    /*fun setReadingValueLabelUIAndDataV2(textViewValue: AppCompatTextView) {
        textViewValue.text = getReadingLabelWithUnit
        when (keys) {
            Readings.BloodPressure.readingKey -> {
                if (getDiastolicValue != null && in_range?.diastolic == "N" && getSystolicValue != null && in_range?.systolic == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.pink1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.pink1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                } else if (getDiastolicValue != null && in_range?.diastolic == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.pink1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                } else if (getSystolicValue != null && in_range?.systolic == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.textBlack1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.pink1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                } else {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.textBlack1, getDiastolicValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getSystolicValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                }
            }
            Readings.BloodGlucose.readingKey -> {
                if (getFastBgValue != null && in_range?.fast == "N" && getPPBgValue != null && in_range?.pp == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.pink1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.pink1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                } else if (getFastBgValue != null && in_range?.fast == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.pink1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                } else if (getPPBgValue != null && in_range?.pp == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.textBlack1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.pink1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                } else {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.textBlack1, getFastBgValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getPPBgValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            measurements
                        )
                        .setTextColor(R.color.textBlack1, measurements)
                        .build()
                }
            }
            Readings.FibroScan.readingKey -> {

                val m1 = measurements!!.split(",")[0]
                val m2 = measurements!!.split(",")[1]

                if (getLsmValue != null && in_range?.lsm == "N" && getCapValue != null && in_range?.cap == "N") {

                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.pink1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.pink1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            m1,
                            m2
                        )
                        .setTextColor(R.color.textBlack1, m1, m2)
                        .build()

                } else if (getLsmValue != null && in_range?.lsm == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.pink1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            m1,
                            m2
                        )
                        .setTextColor(R.color.textBlack1, m1, m2)
                        .build()
                } else if (getCapValue != null && in_range?.cap == "N") {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.textBlack1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.pink1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            m1,
                            m2
                        )
                        .setTextColor(R.color.textBlack1, m1, m2)
                        .build()
                } else {
                    TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                        .setTextColor(R.color.textBlack1, getLsmValue.toString())
                        .setTextColorOfLast(R.color.textBlack1, getCapValue.toString())
                        .setTextColor(R.color.textBlack1, "/")
                        .setAbsoluteSize(
                            textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                            m1,
                            m2
                        )
                        .setTextColor(R.color.textBlack1, m1, m2)
                        .build()
                }
            }
            else -> {

                TextDecorator.decorate(textViewValue, getReadingLabelWithUnit)
                    .setTextColor(R.color.textBlack1, getLsmValue.toString())
                    .setTextColorOfLast(R.color.textBlack1, getCapValue.toString())
                    .setTextColor(R.color.textBlack1, "/")
                    .setAbsoluteSize(
                        textViewValue.context.resources.getDimension(R.dimen.dp_10).toInt(),
                        measurements
                    )
                    .setTextColor(R.color.textBlack1, measurements)
                    .build()


                textViewValue.setTextColor(
                    ContextCompat.getColor(
                        textViewValue.context,
                        if (in_range?.in_range == "N") R.color.pink1 else R.color.textBlack1
                    )
                )
            }
        }
    }*/


    //handled with different views for values and unit
    fun setReadingValueLabelUIAndData(
        textViewValueOne: AppCompatTextView,
        textViewValueTwo: AppCompatTextView,
        textViewUnitOne: AppCompatTextView,
        textViewUnitTwo: AppCompatTextView,
        textViewValueSeparator: AppCompatTextView,
        user: User,
    ) {
        //textViewValueOne.text = getReadingLabel
        when (keys) {
            Readings.BloodPressure.readingKey -> {
                textViewValueOne.isVisible = true
                textViewUnitOne.isVisible = true
                textViewValueSeparator.isVisible = true
                textViewValueTwo.isVisible = true
                textViewUnitTwo.isVisible = true

                textViewValueOne.text = getSystolicValue?.toString() ?: "0"
                textViewValueTwo.text = getDiastolicValue?.toString() ?: "0"
                textViewUnitOne.text = getReadingsMeasurement
                textViewUnitTwo.text = getReadingsMeasurement

                textViewValueOne.setTextColor(
                    ContextCompat.getColor(
                        textViewValueOne.context,
                        if (/*getDiastolicValue != null && */in_range?.systolic == "N") R.color.pink1
                        else R.color.textBlack1
                    )
                )
                textViewValueTwo.setTextColor(
                    ContextCompat.getColor(
                        textViewValueTwo.context,
                        if (/*getSystolicValue != null && */in_range?.diastolic == "N") R.color.pink1
                        else R.color.textBlack1
                    )
                )
            }

            Readings.BloodGlucose.readingKey -> {

                textViewValueOne.isVisible = true
                textViewUnitOne.isVisible = true
                textViewValueSeparator.isVisible = true
                textViewValueTwo.isVisible = true
                textViewUnitTwo.isVisible = true

                textViewValueOne.text = getFastBgValue?.toString() ?: "0"
                textViewValueTwo.text = getPPBgValue?.toString() ?: "0"
                textViewUnitOne.text = getReadingsMeasurement
                textViewUnitTwo.text = getReadingsMeasurement

                textViewValueOne.setTextColor(
                    ContextCompat.getColor(
                        textViewValueOne.context,
                        if (/*getFastBgValue != null && */in_range?.fast == "N") R.color.pink1
                        else R.color.textBlack1
                    )
                )
                textViewValueTwo.setTextColor(
                    ContextCompat.getColor(
                        textViewValueTwo.context,
                        if (/*getPPBgValue != null && */in_range?.pp == "N") R.color.pink1
                        else R.color.textBlack1
                    )
                )
            }

            Readings.FibroScan.readingKey -> {

                textViewValueOne.isVisible = true
                textViewUnitOne.isVisible = true
                textViewValueSeparator.isVisible = true
                textViewValueTwo.isVisible = true
                textViewUnitTwo.isVisible = true

                textViewValueOne.text = getLsmValue?.formatToDecimalPoint(1) ?: "0.0"
                textViewValueTwo.text = getCapValue?.toString() ?: "0"
                textViewUnitOne.text = if (measurements != null && measurements.contains(","))
                    measurements.split(",")[0]
                else ""
                textViewUnitTwo.text = if (measurements != null && measurements.contains(","))
                    measurements.split(",")[1]
                else ""

                textViewValueOne.setTextColor(
                    ContextCompat.getColor(
                        textViewValueOne.context,
                        if (/*getLsmValue != null && */in_range?.lsm == "N") R.color.pink1
                        else R.color.textBlack1
                    )
                )
                textViewValueTwo.setTextColor(
                    ContextCompat.getColor(
                        textViewValueTwo.context,
                        if (/*getCapValue != null && */in_range?.cap == "N") R.color.pink1
                        else R.color.textBlack1
                    )
                )
            }

            else -> {
                textViewValueOne.isVisible = true
                textViewUnitOne.isVisible = true
                textViewValueTwo.isVisible = false
                textViewUnitTwo.isVisible = false
                textViewValueSeparator.isVisible = false

                if (keys == Readings.BodyWeight.readingKey) {
                    // for body weight show value as per selected unit
                    if (user.weight_unit == WeightUnit.LBS.unitKey) {
                        textViewValueOne.text = HeightWeightUtils.convertKgToLbs(getReadingLabel)
                        textViewUnitOne.text = user.weightLbsUnitData.unit_title
                    } else {
                        textViewValueOne.text = getReadingLabel
                        textViewUnitOne.text = user.weightKgUnitData.unit_title
                    }
                } else {
                    textViewValueOne.text = getReadingLabel
                    textViewUnitOne.text = getReadingsMeasurement
                }

                textViewValueOne.setTextColor(
                    ContextCompat.getColor(
                        textViewValueOne.context,
                        if (in_range?.in_range == "N") R.color.pink1 else R.color.textBlack1
                    )
                )
            }
        }
    }

}

@Parcelize
class ReadingValueData(
    @SerializedName("fast")
    val fast: String? = null,
    @SerializedName("pp")
    val pp: String? = null,
    @SerializedName("diastolic")
    val diastolic: String? = null,
    @SerializedName("systolic")
    val systolic: String? = null,
    @SerializedName("weight")
    val weight: String? = null,
    @SerializedName("height")
    val height: String? = null,
    @SerializedName("cap")
    val cap: String? = "",
    @SerializedName("lsm")
    val lsm: String? = "",
    @SerializedName("sgot")
    val sgot: String? = null,
    @SerializedName("sgpt")
    val sgpt: String? = null,
    @SerializedName("platelet")
    val platelet: String? = null,
    @SerializedName("ldl_cholesterol")
    val ldl_cholesterol: String? = null,
    @SerializedName("hdl_cholesterol")
    val hdl_cholesterol: String? = null,
    @SerializedName("triglycerides")
    val triglycerides: String? = null,
) : Parcelable

@Parcelize
class InRangeData(
    @SerializedName("in_range")
    val in_range: String? = null,
    @SerializedName("cap")
    val cap: String? = null,
    @SerializedName("lsm")
    val lsm: String? = null,
    @SerializedName("diastolic")
    val diastolic: String? = null,
    @SerializedName("systolic")
    val systolic: String? = null,
    @SerializedName("fast")
    val fast: String? = null,
    @SerializedName("pp")
    val pp: String? = null,
    @SerializedName("icon_color")
    val icon_color: String? = null
) : Parcelable