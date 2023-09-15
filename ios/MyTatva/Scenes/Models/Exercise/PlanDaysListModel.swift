//
//	PlanDaysListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class PlanDaysListModel {
    
    var contentMasterId : String!
    var day : String!
    var dayDate : String!
    var exercisePlanDayId : String!
    var isRestDay : Int!
    var routineData : [RoutineData]!

    //for normal plan api response
    var brRepeatInDay : Int!
    var breathingCounts : Int!
    var breathingDescription : String!
    var breathingDone : String!
    var breathingDuration : Int!
    var createdAt : String!
    var date : Int!
    var dayType : String!
    var exRepeatInDay : Int!
    var exerciseCounts : Int!
    var exerciseDescription : String!
    var exerciseDone : String!
    var exerciseDuration : Int!
    var goalDate : String!
    var isActive : String!
    var isDeleted : String!
    var isTrial : Int!
    var month : String!
    var orderNo : Int!
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
        contentMasterId = json["content_master_id"].stringValue
        day = json["day"].stringValue
        dayDate = json["day_date"].stringValue
        exercisePlanDayId = json["exercise_plan_day_id"].stringValue
        isRestDay = json["is_rest_day"].intValue
        routineData = [RoutineData]()
        let routineDataArray = json["routine_data"].arrayValue
        for routineDataJson in routineDataArray{
            let value = RoutineData(fromJson: routineDataJson)
            routineData.append(value)
        }
        
        brRepeatInDay = json["br_repeat_in_day"].intValue
        breathingCounts = json["breathing_counts"].intValue
        breathingDescription = json["breathing_description"].stringValue
        breathingDone = json["breathing_done"].stringValue
        breathingDuration = json["breathing_duration"].intValue
        contentMasterId = json["content_master_id"].stringValue
        createdAt = json["created_at"].stringValue
        date = json["date"].intValue
        day = json["day"].stringValue
        dayDate = json["day_date"].stringValue
        dayType = json["day_type"].stringValue
        exRepeatInDay = json["ex_repeat_in_day"].intValue
        exerciseCounts = json["exercise_counts"].intValue
        exerciseDescription = json["exercise_description"].stringValue
        exerciseDone = json["exercise_done"].stringValue
        exerciseDuration = json["exercise_duration"].intValue
        exercisePlanDayId = json["exercise_plan_day_id"].stringValue
        goalDate = json["goal_date"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        isRestDay = json["is_rest_day"].intValue
        isTrial = json["is_trial"].intValue
        month = json["month"].stringValue
        orderNo = json["order_no"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}

//MARK: ------ RoutineData ----------
class RoutineData {
    
    var breathingCount : Int!
    var breathingDone : String!
    var exerciseCount : Int!
    var exerciseDone : String!
    var routine : Int!
    var title : String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        breathingCount = json["breathing_count"].intValue
        breathingDone = json["breathing_done"].stringValue
        exerciseCount = json["exercise_count"].intValue
        exerciseDone = json["exercise_done"].stringValue
        routine = json["routine"].intValue
        title = json["title"].stringValue
    }
    
}


extension PlanDaysListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PlanDaysListModel] {
        var models:[PlanDaysListModel] = []
        for item in array
        {
            models.append(PlanDaysListModel(fromJson: item))
        }
        return models
    }
}
