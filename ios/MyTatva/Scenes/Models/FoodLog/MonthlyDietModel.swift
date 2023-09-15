//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class MonthlyDietModel{

    var achievedDate : String!
    var achievedValue : Int!
    var caloriesLimit : String!
    var colorCode : String!
    var goalMasterId : String!
    var goalName : String!
    var goalValue : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        achievedDate = json["achieved_date"].stringValue
        achievedValue = json["achieved_value"].intValue
        caloriesLimit = json["calories_limit"].stringValue
        colorCode = json["color_code"].stringValue
        goalMasterId = json["goal_master_id"].stringValue
        goalName = json["goal_name"].stringValue
        goalValue = json["goal_value"].intValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension MonthlyDietModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MonthlyDietModel] {
        var models:[MonthlyDietModel] = []
        for item in array
        {
            models.append(MonthlyDietModel(fromJson: item))
        }
        return models
    }
}
