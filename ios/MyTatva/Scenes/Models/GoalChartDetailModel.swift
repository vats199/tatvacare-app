//
//  GoalChartDetailModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 06/10/21.
//

import Foundation

class GoalChartDetailModel {

    var average : AverageGoal!
    var goalData : [GoalData]!
    var lastReadingDate : String!
    var keys : String!
    var goalTime: String!


    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let averageJson = json["average"]
        if !averageJson.isEmpty{
            average = AverageGoal(fromJson: averageJson)
        }
        goalData = [GoalData]()
        let goalDataArray = json["goal_data"].arrayValue
        for goalDataJson in goalDataArray{
            let value = GoalData(fromJson: goalDataJson)
            goalData.append(value)
        }
        lastReadingDate = json["last_reading_date"].stringValue
        keys = json["keys"].stringValue
        goalTime = json["goal_time"].stringValue

    }

}

class GoalData{

    var achievedDatetime : String!
    var achievedValue : Int!
    var colorCode : String!
    var createdAt : String!
    var goalMasterId : String!
    var goalMeasurement : String!
    var goalName : String!
    var goalValue : Int!
    var imgExtn : String!
    var isActive : String!
    var isDeleted : String!
    var keys : String!
    var updatedAt : String!
    var updatedBy : String!
    var xValue : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        achievedDatetime = json["achieved_datetime"].stringValue
        achievedValue = json["achieved_value"].intValue
        colorCode = json["color_code"].stringValue
        createdAt = json["created_at"].stringValue
        goalMasterId = json["goal_master_id"].stringValue
        goalMeasurement = json["goal_measurement"].stringValue
        goalName = json["goal_name"].stringValue
        goalValue = json["goal_value"].intValue
        imgExtn = json["img_extn"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        keys = json["keys"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        xValue = json["x_value"].stringValue
    }

}

class AverageGoal {

    var goalValue : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        goalValue = json["goal_value"].intValue
    }

}
