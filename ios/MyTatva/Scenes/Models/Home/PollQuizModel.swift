//
//	PollQuizModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class PollQuizModel{

	var backgroundUrl : String!
	var cardBackground : String!
	var cat : String!
	var createdAt : String!
	var deepLink : String!
	var descriptionField : String!
	var expiryDate : String!
	var isActive : String!
	var isDeleted : String!
	var questions : [Question]!
	var quizMasterId : String!
	var surveyId : String!
	var title : String!
	var updatedAt : String!
	var updatedBy : String!
    var questionId : String!
    var pollMasterId : String!
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		backgroundUrl = json["background_url"].stringValue
		cardBackground = json["card_background"].stringValue
		cat = json["cat"].stringValue
		createdAt = json["created_at"].stringValue
		deepLink = json["deep_link"].stringValue
		descriptionField = json["description"].stringValue
		expiryDate = json["expiry_date"].stringValue
		isActive = json["is_active"].stringValue
		isDeleted = json["is_deleted"].stringValue
		questions = [Question]()
		let questionsArray = json["questions"].arrayValue
		for questionsJson in questionsArray{
			let value = Question(fromJson: questionsJson)
			questions.append(value)
		}
		quizMasterId = json["quiz_master_id"].stringValue
		surveyId = json["survey_id"].stringValue
		title = json["title"].stringValue
		updatedAt = json["updated_at"].stringValue
		updatedBy = json["updated_by"].stringValue
        questionId = json["question_id"].stringValue
        pollMasterId = json["poll_master_id"].stringValue
	}

}

class Question{

    var questionId : String!
    var quizMasterId : String!
    var quizQuestionsRelId : String!
    var surveyId : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        questionId = json["question_id"].stringValue
        quizMasterId = json["quiz_master_id"].stringValue
        quizQuestionsRelId = json["quiz_questions_rel_id"].stringValue
        surveyId = json["survey_id"].stringValue
    }

}


//MARK: ---------------- Array Model ----------------------
extension PollQuizModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PollQuizModel] {
        var models:[PollQuizModel] = []
        for item in array
        {
            models.append(PollQuizModel(fromJson: item))
        }
        return models
    }
}
