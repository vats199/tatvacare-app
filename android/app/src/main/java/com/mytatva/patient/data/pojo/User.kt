package com.mytatva.patient.data.pojo

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.response.DoctorData
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.data.pojo.response.MyDevicesData
import com.mytatva.patient.data.pojo.response.PatientPlanData
import com.mytatva.patient.data.pojo.response.SpirometerTestResData
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_HEIGHT_FEET
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_HEIGHT_INCH
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_HEIGHT_FEET
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_HEIGHT_INCH

data class User(
    @SerializedName("country")
    val country: String? = null,
    @SerializedName("account_role")
    val account_role: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("sync_at")
    val sync_at: String? = null,
    @SerializedName("address")
    val address: String? = null,
    @SerializedName("study_id")
    val study_id: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("country_code")
    val country_code: String? = null,
    @SerializedName("languages_id")
    val languages_id: String? = null,
    @SerializedName("language_name")
    val language_name: String? = null,
    @SerializedName("severity_name")
    val severity_name: String? = null,
    @SerializedName("email")
    val email: String? = null,
    @SerializedName("patient_guid")
    val patient_guid: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("dob")
    val dob: String? = null,
    @SerializedName("active_deactive_id")
    val active_deactive_id: String? = null,
    @SerializedName("last_login_date")
    val last_login_date: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("restore_id")
    val restore_id: String? = null,
    @SerializedName("is_accept_terms_accept")
    val is_accept_terms_accept: String? = null,
    @SerializedName("city")
    val city: String? = null,
    @SerializedName("state")
    val state: String? = null,
    @SerializedName("email_verified")
    var email_verified: String? = null,
    @SerializedName("gender")
    val gender: String? = null,
    @SerializedName("patient_age")
    val patient_age: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("contact_no")
    val contact_no: String? = null,
    @SerializedName("height")
    val height: String? = null,
    @SerializedName("weight")
    val weight: String? = null,
    @SerializedName("token")
    val token: String? = null,
    @SerializedName("whatsapp_optin")
    val whatsapp_optin: String? = null,
    @SerializedName("profile_pic")
    val profile_pic: String? = null,
    @SerializedName("profile_completion")
    val profile_completion: String? = null,
    @SerializedName("profile_completion_status")
    val profile_completion_status: ProfileCompletionStatus? = null,
    @SerializedName("doctor_says")
    val doctor_says: DoctorSays? = null,
    @SerializedName("password")
    val password: String? = null,
    @SerializedName("patient_link_doctor_details")
    val patient_link_doctor_details: ArrayList<DoctorData>? = null,
    @SerializedName("medical_condition_name")
    val medical_condition_name: ArrayList<MedicalConditionNames>? = null,
    @SerializedName("unread_notifications")
    val unread_notifications: String? = null,
    @SerializedName("patient_plans")
    var patient_plans: ArrayList<PatientPlanData> = arrayListOf(),
    @SerializedName("hc_service_longest_plan")
    val hc_service_longest_plan: PatientPlanData? = null,
    @SerializedName("bmr_details")
    val bmr_details: BmrDetails? = null,
    @SerializedName("unit_data")
    var unit_data: ArrayList<UnitData>? = null,
    @SerializedName("height_unit")
    val height_unit: String? = null,
    @SerializedName("weight_unit")
    val weight_unit: String? = null,
    @SerializedName("hc_list")
    val hc_list: ArrayList<HealthCoachData>? = null,
    @SerializedName("settings")
    val settings: ArrayList<Settings>? = null,
    @SerializedName("bca_sync")
    val bca_sync: BcaSync? = null,// last BCA device sync date
    @SerializedName("spirometer_sync")
    val spirometer_sync: SpirometerTestResData? = null,// last BCA device sync date

    //
    @SerializedName("temp_patient_id")
    val temp_patient_id: String? = null,
    @SerializedName("severity_id")
    val severity_id: String? = null,
    @SerializedName("medical_condition_group_id")
    val medical_condition_group_id: String? = null,
    @SerializedName("indication_name")
    val indication_name: String? = null,
    @SerializedName("access_code")
    val access_code: String? = null,
    @SerializedName("temp_patient_signup_id")
    val temp_patient_signup_id: String? = null,
    @SerializedName("step")
    val step: String? = null,
    @SerializedName("doctor_access_code")
    val doctor_access_code: String? = null,
    @SerializedName("relation")
    val relation: String? = null,
    @SerializedName("sub_relation")
    val sub_relation: String? = null,
    //profile completion
    @SerializedName("ethnicity")
    var ethnicity: String? = null,
    @SerializedName("spirometer_target_vol")
    var spirometer_target_vol: String? = null,
    @SerializedName("devices")
    val devices: ArrayList<MyDevicesData>? = null,
    @SerializedName("image_url")
    var image_url: String? = null,
    @SerializedName("devices_name")
    val devices_name: DeviceName? = null
) {

    val getGenderCodeForSpirometer: String
        get() {
            return if (gender == "M") "MALE" else "FEMALE"
        }

    val lastBcaSyncDate: String?
        get() {
            return bca_sync?.created_at
        }

    val lastSpirometerSyncDate: String?
        get() {
            return spirometer_sync?.test_date_time
        }

    val allCurrentPlanIds: String
        get() {
            val sbPlanId = StringBuilder()
            patient_plans?.forEachIndexed { index, patientPlanData ->
                sbPlanId.append(patientPlanData.plan_master_id).append(", ")
            }
            return sbPlanId.toString().trim().removeSuffix(",")
        }

    val allCurrentPlanNames: String
        get() {
            val sbPlanName = StringBuilder()
            patient_plans?.forEachIndexed { index, patientPlanData ->
                sbPlanName.append(patientPlanData.plan_name).append(", ")
            }
            return sbPlanName.toString().trim().removeSuffix(",")
        }

    val allCurrentPlanTypes: String
        get() {
            val sbPlanType = StringBuilder()
            if (patient_plans?.any {
                    it.plan_type == Common.MyTatvaPlanType.SUBSCRIPTION || it.plan_type == Common.MyTatvaPlanType.INDIVIDUAL
                } == true) {
                sbPlanType.append("Paid - ")
            } else {
                sbPlanType.append("Free - ")
            }
            patient_plans?.forEachIndexed { index, patientPlanData ->
                sbPlanType.append(patientPlanData.plan_type).append(", ")
            }
            return sbPlanType.toString().trim().removeSuffix(",")
        }

    val currentPlan: PatientPlanData?
        get() {
            return hc_service_longest_plan
            /*return patient_plans?.find {
                it.plan_type == Common.MyTatvaPlanType.SUBSCRIPTION || it.plan_type == Common.MyTatvaPlanType.TRIAL || it.plan_type == Common.MyTatvaPlanType.FREE
            }*/
        }

    val currentPlanName: String
        get() {
            return currentPlan?.plan_name ?: ""
        }

    val getNutritionistHCName: String
        get() {
            val nutritionist = hc_list?.find {
                it.role == "Nutritionist"
            }
            return if (nutritionist != null)
                "${nutritionist.first_name} ${nutritionist.last_name}"
            else
                ""
        }

    val isToHideChatBot: Boolean
        get() {
            return settings?.firstOrNull {
                it.attribute_name == "chat_bot"
            }?.attribute_value == "N"
        }

    val isToHideEngagePage: Boolean
        get() {
            return settings?.firstOrNull {
                it.attribute_name == "engage_page"
            }?.attribute_value == "N"
        }

    val isNaflOrNashPatient: Boolean
        get() {
            return medical_condition_name?.firstOrNull()?.medical_condition_name?.contains(
                "NASH",
                true
            ) == true
                    || medical_condition_name?.firstOrNull()?.medical_condition_name?.contains(
                "NAFL",
                true
            ) == true
        }

    val isCopdorAshthmaAPatient: Boolean
        get() {
            return medical_condition_name?.firstOrNull()?.medical_condition_name?.contains(
                "COPD",
                true
            ) == true
                    || medical_condition_name?.firstOrNull()?.medical_condition_name?.contains(
                "Asthma",
                true
            ) == true
        }

    val getHeightValue: Int?
        get() {
            return height?.toDoubleOrNull()?.toInt()
        }

    val getWeightValue: Int?
        get() {
            return weight?.toDoubleOrNull()?.toInt()
        }

    val getAgeValue: Int?
        get() {
            return patient_age?.toDoubleOrNull()?.toInt()
        }

    val isToShowDoctorAppointmentModule: Boolean
        get() {
            return patient_guid.isNullOrBlank().not()
        }

    val weightKgUnitData: UnitData
        get() {
            return unit_data?.firstOrNull {
                it.unit_key == WeightUnit.KG.unitKey
            } ?: UnitData()
        }

    val weightLbsUnitData: UnitData
        get() {
            return unit_data?.firstOrNull {
                it.unit_key == WeightUnit.LBS.unitKey
            } ?: UnitData()
        }

    val heightCmUnitData: UnitData
        get() {
            return unit_data?.firstOrNull {
                it.unit_key == HeightUnit.CM.unitKey
            } ?: UnitData()
        }

    val heightFeetInchUnitData: UnitData
        get() {
            return unit_data?.firstOrNull {
                it.unit_key == HeightUnit.FEET_INCHES.unitKey
            } ?: UnitData()
        }

    companion object {
        const val KEY = "user"
    }
}

data class Settings(
    @SerializedName("settings_master_id")
    val settings_master_id: String? = null,
    @SerializedName("attribute_name")
    val attribute_name: String? = null, //engage_page,chat_bot
    @SerializedName("attribute_value")
    val attribute_value: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
)

data class BcaSync(
    @SerializedName("bca_sync_logs_id")
    val bca_sync_logs_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("device_id")
    val device_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null
)


data class BmrDetails(
    @SerializedName("patient_goal_weight_rel_id")
    val patient_goal_weight_rel_id: String? = null,
    @SerializedName("rate")
    val rate: String? = null,
    @SerializedName("months")
    val months: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("current_weight")
    val current_weight: String? = null,
    @SerializedName("goal_weight")
    val goal_weight: String? = null,
    @SerializedName("height")
    val height: String? = null,
    @SerializedName("activity_level")
    val activity_level: String? = null,
    @SerializedName("bmr")
    val bmr: String? = null,
    @SerializedName("target_calories")
    val target_calories: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
)

data class MedicalConditionNames(
    @SerializedName("medical_condition_name")
    val medical_condition_name: String? = null,
)

data class ProfileCompletionStatus(
    @SerializedName("drug_prescription")
    val drug_prescription: String? = null,
    @SerializedName("goal_reading")
    val goal_reading: String? = null,
    @SerializedName("location")
    val location: String? = null,
)

data class DoctorSays(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("doctor_says_master_id")
    val doctor_says_master_id: String? = null,
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
)

data class UnitData(
    @SerializedName("sub_reading_key")
    val sub_reading_key: String? = null,
    @SerializedName("reading_key")
    val reading_key: String? = null,
    @SerializedName("unit_key")
    val unit_key: String? = null,
    @SerializedName("unit_title")
    val unit_title: String? = null,
    @SerializedName("min")
    val min: String? = null,
    @SerializedName("max")
    val max: String? = null,
    @SerializedName("min_feet")
    val min_feet: String? = null,
    @SerializedName("max_feet")
    val max_feet: String? = null,
    @SerializedName("min_inch")
    val min_inch: String? = null,
    @SerializedName("max_inch")
    val max_inch: String? = null,
) {

    val maxValue: Int?
        get() = max?.toDoubleOrNull()?.toInt()
    val minValue: Int?
        get() = min?.toDoubleOrNull()?.toInt()

    val maxValueDecimal: Double?
        get() = max?.toDoubleOrNull()
    val minValueDecimal: Double?
        get() = min?.toDoubleOrNull()

    /**
     * maxValue - returns max validation value as configured from Admin,
     * if it's null then returns default value
     */
    fun maxValue(defaultValue: Int): Int {
        return max?.toDoubleOrNull()?.toInt() ?: defaultValue
    }

    /**
     * minValue - returns min validation value as configured from Admin,
     * if it's null then returns default value
     */
    fun minValue(defaultValue: Int): Int {
        return min?.toDoubleOrNull()?.toInt() ?: defaultValue
    }

    val maxFeet: Int
        get() {
            return max_feet?.toDoubleOrNull()?.toInt() ?: MAX_HEIGHT_FEET
        }

    val minFeet: Int
        get() {
            return min_feet?.toDoubleOrNull()?.toInt() ?: MIN_HEIGHT_FEET
        }

    val maxInch: Int
        get() {
            return max_inch?.toDoubleOrNull()?.toInt() ?: MAX_HEIGHT_INCH
        }

    val minInch: Int
        get() {
            return min_inch?.toDoubleOrNull()?.toInt() ?: MIN_HEIGHT_INCH
        }

}

data class DeviceName(
    @SerializedName("device_names")
    val device_names: String? = "",
)

