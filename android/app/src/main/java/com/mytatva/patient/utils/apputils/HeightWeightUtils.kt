package com.mytatva.patient.utils.apputils

import androidx.appcompat.widget.AppCompatEditText
import com.mytatva.patient.R
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.reading.ReadingMinMax
import com.mytatva.patient.utils.Validator
import com.mytatva.patient.utils.formatToDecimalPointSkipRounding
import kotlin.math.roundToInt


object HeightWeightUtils {

    /**
     * Unit conversion methods
     */
    fun convertCmToFeetInches(heightCmStr: String): Pair<String, String> {
        return try {
            val heightCM = heightCmStr.trim().toIntOrNull() ?: 0
            val totalInches = heightCM / 2.54
            var feet = (totalInches / 12).toInt()
            var inch = (totalInches % 12).roundToInt()

            // if round to int makes inch to 12 then make inch 0 and increase feet by 1
            if (inch > 11) {
                inch = 0
                feet++
            }

            Pair(feet.toString(), inch.toString())
        } catch (e: Exception) {
            Pair("", "")
        }
    }

    fun convertFeetInchesToCm(feetStr: String, inchesStr: String): String {
        return try {
            val feet = feetStr.trim().toIntOrNull() ?: 0
            val inch = inchesStr.trim().toIntOrNull() ?: 0
            val heightCM = (feet * 30.48) + (inch * 2.54)
            heightCM.roundToInt().toString()
        } catch (e: Exception) {
            ""
        }
    }

    fun convertKgToLbs(kgStr: String): String {
        // new code for decimal value format on conversion
        return try {
            val kg = kgStr.trim().toDoubleOrNull() ?: 0.0
            val lbs = kg * 2.205
            lbs.formatToDecimalPointSkipRounding(1)
        } catch (e: Exception) {
            ""
        }

        // old working code for integer format value
        /*return try {
            val kg = kgStr.trim().toIntOrNull() ?: 0
            val lbs = kg * 2.205
            lbs.roundToInt().toString()
        } catch (e: Exception) {
            ""
        }*/
    }

    fun convertLbsToKg(lbsStr: String): String {
        // new code for decimal value format on conversion
        return try {
            val lbs = lbsStr.trim().toDoubleOrNull() ?: 0.0
            val kg = lbs * 0.454
            kg.formatToDecimalPointSkipRounding(1)
        } catch (e: Exception) {
            ""
        }

        // old working code for integer format value
        /*return try {
            val lbs = lbsStr.trim().toIntOrNull() ?: 0
            val kg = lbs * 0.454
            kg.roundToInt().toString()
        } catch (e: Exception) {
            ""
        }*/
    }

    /**
     * UI update methods
     */
    fun updateWeightValuesAndUI(
        editTextWeight: AppCompatEditText,
        selectedWeightUnit: WeightUnit,
    ) {
        if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
            if (editTextWeight.text.toString().trim().isNotBlank()) {
                val weightLbs = convertKgToLbs(editTextWeight.text.toString())
                editTextWeight.setText(weightLbs)
            }
        } else {
            if (editTextWeight.text.toString().trim().isNotBlank()) {
                val weightKg = convertLbsToKg(editTextWeight.text.toString())
                editTextWeight.setText(weightKg)
            }
        }
    }

    fun updateWeightValuesAndUIV1(
        editTextWeight: AppCompatEditText,
        weightInKg: String,
        selectedWeightUnit: WeightUnit,
    ) {
        if(weightInKg.isNotBlank()) {
            if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {
                editTextWeight.setText(String.format("%s %s", convertKgToLbs(weightInKg), selectedWeightUnit.unitName))
            } else {
                editTextWeight.setText(String.format("%s %s", weightInKg, selectedWeightUnit.unitName))
            }
        }
    }

    fun validateHeightFields(
        validator: Validator,
        selectedHeightUnit: HeightUnit,
        editTextHeightFeet: AppCompatEditText,
        editTextHeightInches: AppCompatEditText,
        editTextHeight: AppCompatEditText,
    ) {

        if (selectedHeightUnit.unitKey == HeightUnit.FEET_INCHES.unitKey) {

            validator.submit(editTextHeightFeet).checkEmpty()
                .errorMessage(editTextHeight.context.resources.getString(R.string.validation_empty_height))
                .check()

            if ((editTextHeightFeet.text.toString().toIntOrNull()
                    ?: 0) < ReadingMinMax.MIN_HEIGHT_FEET || (editTextHeightFeet.text.toString()
                    .toIntOrNull() ?: 0) > ReadingMinMax.MAX_HEIGHT_FEET
            ) {
                throw ApplicationException("Please enter height between ${ReadingMinMax.MIN_HEIGHT_FEET} - ${ReadingMinMax.MAX_HEIGHT_FEET}")
            }

            validator.submit(editTextHeightInches).checkEmpty()
                .errorMessage(editTextHeight.context.resources.getString(R.string.validation_empty_height))
                .check()

            /*if ((binding.editTextHeightInches.text.toString().toIntOrNull()
                    ?: 0) < MIN_HEIGHT_INCH
                || (binding.editTextHeightInches.text.toString().toIntOrNull()
                    ?: 0) > MAX_HEIGHT_INCH
            ) {
                throw ApplicationException("Please enter inch between $MIN_HEIGHT_INCH - $MAX_HEIGHT_INCH")
            }*/

        } else {

            validator.submit(editTextHeight).checkEmpty()
                .errorMessage(editTextHeight.context.resources.getString(R.string.validation_empty_height))
                .check()

            if ((editTextHeight.text.toString().toIntOrNull()
                    ?: 0) < ReadingMinMax.MIN_HEIGHT_CM || (editTextHeight.text.toString()
                    .toIntOrNull() ?: 0) > ReadingMinMax.MAX_HEIGHT_CM
            ) {
                throw ApplicationException("Please enter height between ${ReadingMinMax.MIN_HEIGHT_CM} - ${ReadingMinMax.MAX_HEIGHT_CM}")
            }
        }

    }

    fun validateWeightFields(
        validator: Validator,
        selectedWeightUnit: WeightUnit,
        editTextWeight: AppCompatEditText,
        editTextWeightGoal: AppCompatEditText? = null,
    ) {//
        if (selectedWeightUnit.unitKey == WeightUnit.LBS.unitKey) {

            validator.submit(editTextWeight).checkEmpty()
                .errorMessage(editTextWeight.context.resources.getString(R.string.validation_empty_weight))
                .check()
            val weight = editTextWeight.text.toString().toDoubleOrNull() ?: 0.0
            if (weight < ReadingMinMax.MIN_BODYWEIGHT_LBS || weight > ReadingMinMax.MAX_BODYWEIGHT_LBS) {
                throw ApplicationException("Please enter Body Weight in the range of ${ReadingMinMax.MIN_BODYWEIGHT_LBS} - ${ReadingMinMax.MAX_BODYWEIGHT_LBS}")
            }

            if (editTextWeightGoal != null) {
                validator.submit(editTextWeightGoal).checkEmpty()
                    .errorMessage(editTextWeight.context.resources.getString(R.string.validation_empty_target_weight))
                    .check()
                val targetWeight = editTextWeightGoal.text.toString().toDoubleOrNull() ?: 0.0
                if (targetWeight < ReadingMinMax.MIN_BODYWEIGHT_LBS || targetWeight > ReadingMinMax.MAX_BODYWEIGHT_LBS) {
                    throw ApplicationException("Please enter Target Weight in the range of ${ReadingMinMax.MIN_BODYWEIGHT_LBS} - ${ReadingMinMax.MAX_BODYWEIGHT_LBS}")
                }
            }

        } else {

            validator.submit(editTextWeight).checkEmpty()
                .errorMessage(editTextWeight.context.resources.getString(R.string.validation_empty_weight))
                .check()
            val weight = editTextWeight.text.toString().toDoubleOrNull() ?: 0.0
            if (weight < ReadingMinMax.MIN_BODYWEIGHT_KG || weight > ReadingMinMax.MAX_BODYWEIGHT_KG) {
                throw ApplicationException("Please enter Body Weight in the range of ${ReadingMinMax.MIN_BODYWEIGHT_KG} - ${ReadingMinMax.MAX_BODYWEIGHT_KG}")
            }

            if (editTextWeightGoal != null) {
                validator.submit(editTextWeightGoal).checkEmpty()
                    .errorMessage(editTextWeight.context.resources.getString(R.string.validation_empty_target_weight))
                    .check()
                val targetWeight = editTextWeightGoal.text.toString().toDoubleOrNull() ?: 0.0
                if (targetWeight < ReadingMinMax.MIN_BODYWEIGHT_KG || targetWeight > ReadingMinMax.MAX_BODYWEIGHT_KG) {
                    throw ApplicationException("Please enter Target Weight in the range of ${ReadingMinMax.MIN_BODYWEIGHT_KG} - ${ReadingMinMax.MAX_BODYWEIGHT_KG}")
                }
            }

        }
    }

}