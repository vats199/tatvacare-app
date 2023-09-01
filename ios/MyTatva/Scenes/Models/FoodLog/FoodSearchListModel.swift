
import Foundation
import UIKit
import SwiftyJSON

class FoodSearchListModel {
    
    var carbohydratebydifference : String!
    var cholesterol : String!
    var energyKcal : String!
    var fattyacidstotalmonounsaturated : String!
    var fattyacidstotalpolyunsaturated : String!
    var fattyacidstotalsaturated : String!
    var fibertotaldietary : String!
    var potassiumK : String!
    var protein : String!
    var sodiumNa : String!
    var sugarstotal : String!
    var totallipidfat : String!
    var addedSugar : String!
    var basicUnitMeasure : String!
    var calUnitName : String!
    var caloriesCalculatedFor : String!
    var className : String!
    var commonNames : String!
    var cookTime : String!
    var cuisine : String!
    var descriptionField : String!
    var endProduct : Bool!
    var foodGroup : String!
    var foodItemId : String!
    var foodName : String!
    var foodTimeName : String!
    var foodType : String!
    var giDer : String!
    var giEst : String!
    var ndbNo : String!
    var packagedFood : String!
    var prepTime : String!
    var priority1 : String!
    var priority2 : String!
    var priority3 : String!
    var processed : String!
    var recipeLink : String!
    var recommendable : Bool!
    var searchable : Bool!
    var servings : String!
    var unitName : String!
    var unitOptionName : String!
    var meal_types_id: String!
    var mealDate : String!
    
    var quantity : Int!
    
    
    var aLIASNAME : String!
    var bASICUNITMEASURE : String!
    var cALORIESCALCULATEDFOR : String!
    var fOODID : Int!
    var mEASURE : String!
    var uNITNAME : String!
       
    
    init(){}
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        carbohydratebydifference = json["Carbohydrate,bydifference"].stringValue
        cholesterol = json["Cholesterol"].stringValue
        energyKcal = json["Energy_kcal"].stringValue
        fattyacidstotalmonounsaturated = json["Fattyacids,totalmonounsaturated"].stringValue
        fattyacidstotalpolyunsaturated = json["Fattyacids,totalpolyunsaturated"].stringValue
        fattyacidstotalsaturated = json["Fattyacids,totalsaturated"].stringValue
        fibertotaldietary = json["Fiber,totaldietary"].stringValue
        potassiumK = json["Potassium,K"].stringValue
        protein = json["Protein"].stringValue
        sodiumNa = json["Sodium,Na"].stringValue
        sugarstotal = json["Sugars,total"].stringValue
        totallipidfat = json["Totallipid(fat)"].stringValue
        addedSugar = json["added_sugar"].stringValue
        basicUnitMeasure = json["basic_unit_measure"].stringValue
        calUnitName = json["cal_unit_name"].stringValue
        caloriesCalculatedFor = json["calories_calculated_for"].stringValue
        className = json["class_name"].stringValue
        commonNames = json["common_names"].stringValue
        cookTime = json["cook_time"].stringValue
        cuisine = json["cuisine"].stringValue
        descriptionField = json["description"].stringValue
        endProduct = json["end_product"].boolValue
        foodGroup = json["food_group"].stringValue
        foodItemId = json["food_item_id"].stringValue
        foodName = json["food_name"].stringValue
        foodTimeName = json["food_time_name"].stringValue
        foodType = json["food_type"].stringValue
        giDer = json["gi_der"].stringValue
        giEst = json["gi_est"].stringValue
        ndbNo = json["ndb_no"].stringValue
        packagedFood = json["packaged_food"].stringValue
        prepTime = json["prep_time"].stringValue
        priority1 = json["priority1"].stringValue
        priority2 = json["priority2"].stringValue
        priority3 = json["priority3"].stringValue
        processed = json["processed"].stringValue
        recipeLink = json["recipe_link"].stringValue
        recommendable = json["recommendable"].boolValue
        searchable = json["searchable"].boolValue
        servings = json["servings"].stringValue
        unitName = json["unit_name"].stringValue
        unitOptionName = json["unit_option_name"].stringValue
        meal_types_id  = json["meal_types_id"].stringValue
        mealDate = json["meal_date"].stringValue
        quantity = json["quantity"].intValue
        
        aLIASNAME = json["ALIAS_NAME"].stringValue
        bASICUNITMEASURE = json["BASIC_UNIT_MEASURE"].stringValue
        cALORIESCALCULATEDFOR = json["CALORIES_CALCULATED_FOR"].stringValue
        fOODID = json["FOOD_ID"].intValue
        mEASURE = json["MEASURE"].stringValue
        uNITNAME = json["UNIT_NAME"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension FoodSearchListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [FoodSearchListModel] {
        var models:[FoodSearchListModel] = []
        for item in array
        {
            models.append(FoodSearchListModel(fromJson: item))
        }
        return models
    }
}


class FoodImageModel {

    var createdAt : String!
    var imageName : String!
    var imageUrl : String!
    var isActive : String!
    var isDeleted : String!
    var patientFoodImageRelId : String!
    var patientMealRelId : String!
    var updatedAt : String!
    var updatedBy : String!
    var newImage: UIImage!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        imageName = json["image_name"].stringValue
        imageUrl = json["image_url"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientFoodImageRelId = json["patient_food_image_rel_id"].stringValue
        patientMealRelId = json["patient_meal_rel_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension FoodImageModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [FoodImageModel] {
        var models:[FoodImageModel] = []
        for item in array
        {
            models.append(FoodImageModel(fromJson: item))
        }
        return models
    }
}
