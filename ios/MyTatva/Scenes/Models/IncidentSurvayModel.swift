//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class IncidentSurvayModel {

    var createdAt : String!
    var deepLink : String!
    var durationQueId : String!
    var incidentTrackingMasterId : String!
    var isActive : String!
    var isDeleted : String!
    var medicalConditionGroupId : String!
    var occurQueId : String!
    var surveyId : String!
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
        createdAt = json["created_at"].stringValue
        deepLink = json["deep_link"].stringValue
        durationQueId = json["duration_que_id"].stringValue
        incidentTrackingMasterId = json["incident_tracking_master_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        occurQueId = json["occur_que_id"].stringValue
        surveyId = json["survey_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}
