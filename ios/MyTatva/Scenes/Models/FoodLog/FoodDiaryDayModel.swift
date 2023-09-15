//
//  FoodDiaryDayModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 30/10/21.
//

import Foundation

class FoodDiaryDayModel {
    
    var foodData : [FoodData]!
    var goalValue : String!
    var totalCaloriesConsumed : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        foodData = [FoodData]()
        let foodDataArray = json["data"].arrayValue
        for foodDataJson in foodDataArray{
            let value = FoodData(fromJson: foodDataJson)
            foodData.append(value)
        }
        goalValue = json["goal_value"].stringValue
        totalCaloriesConsumed = json["total_calories_consumed"].intValue
    }

}

class FoodData{

    var createdAt : String!
    var imageUrl : [String]!
    var isActive : String!
    var isDeleted : String!
    var mealData : [MealData]!
    var mealType : String!
    var mealTypesId : String!
    var patientId : String!
    var patientMealRelId : String!
    var totalCal : String!
    var totalCarbs : String!
    var totalFat : String!
    var totalProtein : String!
    var updatedAt : String!
    var updatedBy : String!

    var isSelected = false

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        
        imageUrl = [String]()
        let imageUrlJson = json["image_url"].arrayObject
        if imageUrlJson != nil{
            imageUrl.append(contentsOf: imageUrlJson as? [String] ?? [""])
        }
        
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        mealData = [MealData]()
        let mealDataArray = json["meal_data"].arrayValue
        for mealDataJson in mealDataArray{
            let value = MealData(fromJson: mealDataJson)
            mealData.append(value)
        }
        mealType = json["meal_type"].stringValue
        mealTypesId = json["meal_types_id"].stringValue
        patientId = json["patient_id"].stringValue
        patientMealRelId = json["patient_meal_rel_id"].stringValue
        totalCal = json["total_cal"].stringValue
        totalCarbs = json["total_carbs"].stringValue
        totalFat = json["total_fat"].stringValue
        totalProtein = json["total_protein"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}

class MealData{

    var calories : String!
    var carbohydrate : String!
    var createdAt : String!
    var fat : String!
    var foodItemId : Int!
    var foodName : String!
    var isActive : String!
    var isDeleted : String!
    var patientFoodLogsId : String!
    var patientMealRelId : String!
    var protein : String!
    var quantity : Int!
    var unitName : String!
    var updatedAt : String!
    var updatedBy : String!
    var updatedFrom : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        calories = json["calories"].stringValue
        carbohydrate = json["carbohydrate"].stringValue
        createdAt = json["created_at"].stringValue
        fat = json["fat"].stringValue
        foodItemId = json["food_item_id"].intValue
        foodName = json["food_name"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientFoodLogsId = json["patient_food_logs_id"].stringValue
        patientMealRelId = json["patient_meal_rel_id"].stringValue
        protein = json["protein"].stringValue
        quantity = json["quantity"].intValue
        unitName = json["unit_name"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        updatedFrom = json["updated_from"].stringValue
    }

}
