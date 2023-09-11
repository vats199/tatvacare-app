

import Foundation

class IncidentHistoryDetailModel {
    
    var quesAnsList : [QuesAnsList]!
    var questionOccurance : QuestionOccurance!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        quesAnsList = [QuesAnsList]()
        let quesAnsListArray = json["ques_ans_list"].arrayValue
        for quesAnsListJson in quesAnsListArray{
            let value = QuesAnsList(fromJson: quesAnsListJson)
            quesAnsList.append(value)
        }
        let questionOccuranceJson = json["question_occurance"]
        if !questionOccuranceJson.isEmpty{
            questionOccurance = QuestionOccurance(fromJson: questionOccuranceJson)
        }
    }
}

class QuestionOccurance{

    var durationAnswer : String!
    var durationCreatedAt : String!
    var durationIncidentTrackingMasterId : String!
    var durationIsActive : String!
    var durationIsDeleted : String!
    var durationPatientIncidentRelId : String!
    var durationQuestion : String!
    var durationQuestionId : String!
    var durationUpdatedAt : String!
    var durationUpdatedBy : String!
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
    var surveyId : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        durationAnswer = json["duration_answer"].stringValue
        durationCreatedAt = json["duration_created_at"].stringValue
        durationIncidentTrackingMasterId = json["duration_incident_tracking_master_id"].stringValue
        durationIsActive = json["duration_is_active"].stringValue
        durationIsDeleted = json["duration_is_deleted"].stringValue
        durationPatientIncidentRelId = json["duration_patient_incident_rel_id"].stringValue
        durationQuestion = json["duration_question"].stringValue
        durationQuestionId = json["duration_question_id"].stringValue
        durationUpdatedAt = json["duration_updated_at"].stringValue
        durationUpdatedBy = json["duration_updated_by"].stringValue
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
        surveyId = json["survey_id"].stringValue
    }

}

class QuesAnsList{

    var answer : String!
    var createdAt : String!
    var incidentTrackingMasterId : String!
    var isActive : String!
    var isDeleted : String!
    var patientId : String!
    var patientIncidentAddRelId : String!
    var patientIncidentRelId : String!
    var question : String!
    var questionId : String!
    var surveyId : String!
    var updatedAt : String!
    var updatedBy : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        answer = json["answer"].stringValue
        createdAt = json["created_at"].stringValue
        incidentTrackingMasterId = json["incident_tracking_master_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientId = json["patient_id"].stringValue
        patientIncidentAddRelId = json["patient_incident_add_rel_id"].stringValue
        patientIncidentRelId = json["patient_incident_rel_id"].stringValue
        question = json["question"].stringValue
        questionId = json["question_id"].stringValue
        surveyId = json["survey_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}
