//
//  NotificationMealReminderModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 31/01/22.
//

import Foundation

class NotificationMealReminderModel {

    var details : [MealDetailModel]!
    var everydayRemind : EverydayRemind!
    var type : String!

    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        details = [MealDetailModel]()
        let detailsArray = json["details"].arrayValue
        for detailsJson in detailsArray{
            let value = MealDetailModel(fromJson: detailsJson)
            details.append(value)
        }
        let everydayRemindJson = json["everyday_remind"]
        if !everydayRemindJson.isEmpty{
            everydayRemind = EverydayRemind(fromJson: everydayRemindJson)
        }
        type = json["type"].stringValue
    }
}

class MealDetailModel {
    
    var isActive : String!
    var keys : String!
    var mealTime : String!
    var mealType : String!
    var mealTypesId : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        isActive = json["is_active"].stringValue
        keys = json["keys"].stringValue
        mealTime = json["meal_time"].stringValue
        mealType = json["meal_type"].stringValue
        mealTypesId = json["meal_types_id"].stringValue
    }
}
