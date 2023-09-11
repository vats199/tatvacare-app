//
//  GoalLogsModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 23/11/21.
//

import Foundation

class GoalLogsModel{

    var achievedDatetime : String!
    var achievedValue : Int!
    var createdAt : String!
    var endTime : String!
    var isActive : String!
    var isDeleted : String!
    var patientGoalLogsId : String!
    var patientGoalRelId : String!
    var patientSubGoalId : String!
    var sourceId : String!
    var sourceName : String!
    var startTime : String!
    var targetValue : Int!
    var todaysAchievedValue : Int!
    var updatedAt : String!
    var updatedBy : String!

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
        createdAt = json["created_at"].stringValue
        endTime = json["end_time"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientGoalLogsId = json["patient_goal_logs_id"].stringValue
        patientGoalRelId = json["patient_goal_rel_id"].stringValue
        patientSubGoalId = json["patient_sub_goal_id"].stringValue
        sourceId = json["source_id"].stringValue
        sourceName = json["source_name"].stringValue
        startTime = json["start_time"].stringValue
        targetValue = json["target_value"].intValue
        todaysAchievedValue = json["todays_achieved_value"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}
