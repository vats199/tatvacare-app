

import Foundation

class IncidentHistoryListModel {
    
    var durationAnswer : String!
    var durationCreatedAt : String!
    var durationIsActive : String!
    var durationIsDeleted : String!
    var durationPatientIncidentRelId : String!
    var durationQuestion : String!
    var durationQuestionId : String!
    var durationUpdatedAt : String!
    var durationUpdatedBy : String!
    var incidentTrackingMasterId : String!
    var occurAnswer : String!
    var occurCreatedAt : String!
    var occurIncidentTrackingMasterId : String!
    var occurIsActive : String!
    var occurIsDeleted : String!
    var occurPatientIncidentRelId : String!
    var occurQuestion : String!
    var occurQuestionId : String!
    var occurUpdatedAt : String!
    var occurUpdatedBy : String!
    var patientId : String!
    var patientIncidentAddRelId : String!
    var surveyId : String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
            if json.isEmpty{
                return
            }
            durationAnswer = json["duration_answer"].stringValue
            durationCreatedAt = json["duration_created_at"].stringValue
            durationIsActive = json["duration_is_active"].stringValue
            durationIsDeleted = json["duration_is_deleted"].stringValue
            durationPatientIncidentRelId = json["duration_patient_incident_rel_id"].stringValue
            durationQuestion = json["duration_question"].stringValue
            durationQuestionId = json["duration_question_id"].stringValue
            durationUpdatedAt = json["duration_updated_at"].stringValue
            durationUpdatedBy = json["duration_updated_by"].stringValue
            incidentTrackingMasterId = json["incident_tracking_master_id"].stringValue
            occurAnswer = json["occur_answer"].stringValue
            occurCreatedAt = json["occur_created_at"].stringValue
            occurIncidentTrackingMasterId = json["occur_incident_tracking_master_id"].stringValue
            occurIsActive = json["occur_is_active"].stringValue
            occurIsDeleted = json["occur_is_deleted"].stringValue
            occurPatientIncidentRelId = json["occur_patient_incident_rel_id"].stringValue
            occurQuestion = json["occur_question"].stringValue
            occurQuestionId = json["occur_question_id"].stringValue
            occurUpdatedAt = json["occur_updated_at"].stringValue
            occurUpdatedBy = json["occur_updated_by"].stringValue
            patientId = json["patient_id"].stringValue
            patientIncidentAddRelId = json["patient_incident_add_rel_id"].stringValue
            surveyId = json["survey_id"].stringValue
        }
}

//MARK: ---------------- Array Model ----------------------
extension IncidentHistoryListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [IncidentHistoryListModel] {
        var models:[IncidentHistoryListModel] = []
        for item in array
        {
            models.append(IncidentHistoryListModel(fromJson: item))
        }
        return models
    }
}

