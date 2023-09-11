//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class MealTypeListModel{

    var createdAt : String!
    var mealType : String!
    var mealTypesId : String!
    var updatedAt : String!

    var isSelected = false

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        mealType = json["meal_type"].stringValue
        mealTypesId = json["meal_types_id"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension MealTypeListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MealTypeListModel] {
        var models:[MealTypeListModel] = []
        for item in array
        {
            models.append(MealTypeListModel(fromJson: item))
        }
        return models
    }
}
