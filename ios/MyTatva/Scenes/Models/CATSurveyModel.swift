//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class CATSurveyModel {
    
    var catSurveyMasterId : String!
    var createdAt : String!
    var deepLink : String!
    var isActive : String!
    var isDeleted : String!
    var medicalConditionGroupId : String!
    var readingName : String!
    var readingsMasterId : String!
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
        catSurveyMasterId = json["cat_survey_master_id"].stringValue
        createdAt = json["created_at"].stringValue
        deepLink = json["deep_link"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        readingName = json["reading_name"].stringValue
        readingsMasterId = json["readings_master_id"].stringValue
        surveyId = json["survey_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
}
