package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import java.io.Serializable


class FoodItemData(
    @SerializedName("food_item_id")
    var food_item_id: String? = null,
    @SerializedName("meal_date")
    var meal_date: String? = null,
    @SerializedName("meal_types_id")
    var meal_types_id: String? = null,
    @SerializedName("food_name")
    var food_name: String? = null,
    @SerializedName("common_names")
    val common_names: String? = null,
    @SerializedName("calories_calculated_for")
    val calories_calculated_for: String? = null,
    @SerializedName("Energy_kcal")
    var Energy_kcal: String? = null,
    @SerializedName("added_sugar")
    val added_sugar: String? = null,
    @SerializedName("gi_est")
    val gi_est: String? = null,
    @SerializedName("gi_der")
    val gi_der: String? = null,
    @SerializedName("food_group")
    val food_group: String? = null,
    @SerializedName("food_time_name")
    val food_time_name: String? = null,
    @SerializedName("unit_name")
    var unit_name: String? = null,
    @SerializedName("unit_option_name")
    val unit_option_name: String? = null,
    /*@SerializedName("basic_unit_measure")
    val basic_unit_measure: String? = null,*/
    @SerializedName("BASIC_UNIT_MEASURE")
    val BASIC_UNIT_MEASURE: String? = null,
    @SerializedName("class_name")
    val class_name: String? = null,
    @SerializedName("cuisine")
    val cuisine: String? = null,
    @SerializedName("food_type")
    val food_type: String? = null,
    @SerializedName("priority1")
    val priority1: String? = null,
    @SerializedName("priority2")
    val priority2: String? = null,
    @SerializedName("priority3")
    val priority3: String? = null,
    @SerializedName("cook_time")
    val cook_time: String? = null,
    @SerializedName("prep_time")
    val prep_time: String? = null,
    @SerializedName("packaged_food")
    val packaged_food: String? = null,
    @SerializedName("processed")
    val processed: String? = null,
    @SerializedName("end_product")
    val end_product: String? = null,
    @SerializedName("searchable")
    val searchable: String? = null,
    @SerializedName("recommendable")
    val recommendable: String? = null,
    @SerializedName("recipe_link")
    val recipe_link: String? = null,
    @SerializedName("servings")
    val servings: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("ndb_no")
    val ndb_no: String? = null,

    //
    @SerializedName("Carbohydrate, by difference")
    val carbohydrateByDifference: String? = null,
    @SerializedName("Protein")
    val protein: String? = null,
    @SerializedName("Total lipid (fat)")
    val totalLipid: String? = null,
    @SerializedName("Fiber, total dietary")
    val fiberTotalDietary: String? = null,
    @SerializedName("Sugars, total")
    val sugarsTotal: String? = null,
    @SerializedName("Sodium, Na")
    val sodiumNa: String? = null,
    @SerializedName("Fatty acids, total saturated")
    val fattyAcidsTotalSaturated: String? = null,
    @SerializedName("Fatty acids, total monounsaturated")
    val fattyAcidsTotalMonounsaturated: String? = null,
    @SerializedName("Fatty acids, total polyunsaturated")
    val fattyAcidsTotalPolyunsaturated: String? = null,
    @SerializedName("Potassium, K")
    val potassiumK: String? = null,
    @SerializedName("Cholesterol")
    val cholesterol: String? = null,
    @SerializedName("cal_unit_name")
    val cal_unit_name: String? = "Cal",
) : Serializable {
    @SerializedName("quantity")
    var quantity: Int = 1 // default 1
    var isAddedByUser: Boolean = false // when not found in search, added manually by user
    //get() = food_item_id == "0"

    val getCalculatedCalorieLabel: String
        get() {
            return calculatedCalorie.toString()/*.formatToDecimalPoint(1)*/
                .plus(" ").plus(cal_unit_name)
        }

    val getGmsLabel: String
        get() {
            return if (BASIC_UNIT_MEASURE.isNullOrBlank()) ""
            else BASIC_UNIT_MEASURE.toString().plus(" gm")
        }

    val calculatedCalorie: Int
        /*Double*/
        get() {
            val reg = Regex("[^0-9.]")
            val calorie = reg.replace(Energy_kcal ?: "", "")
            return if (isAddedByUser || food_item_id == "0") {
                // if user added then do not multiply with quantity
                (calorie.toDoubleOrNull()?.toInt() ?: 0)
            } else {
                (calorie.toDoubleOrNull()?.toInt() ?: 0) * quantity
            }
        }
}

class AddedPatientMealData(
    @SerializedName("food_data")
    val food_data: ArrayList<FoodItemData>? = null,
    @SerializedName("image_data")
    val image_data: ArrayList<ImageData>? = null,
)

class ImageData(
    @SerializedName("patient_food_image_rel_id")
    val patient_food_image_rel_id: String? = null,
    @SerializedName("patient_meal_rel_id")
    val patient_meal_rel_id: String? = null,
    @SerializedName("image_name")
    val image_name: String? = null,
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
    var imagePath: String? = null,//for added images
)