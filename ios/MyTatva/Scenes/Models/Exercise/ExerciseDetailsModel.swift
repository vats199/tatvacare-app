//
//  ExerciseDetailsModel.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import Foundation

class MediaContent {

    var imageUrl : String!
    var mediaUrl : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        imageUrl = json["image_url"].stringValue
        mediaUrl = json["media_url"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if mediaUrl != nil{
            dictionary["media_url"] = mediaUrl
        }
        return dictionary
    }

}

class ExerciseDetailModel{

    var breathingExercise : String!
    var contentMasterId : String!
    var contentType : String!
    var createdAt : String!
    var date : String!
    var dayNo : String!
    var descriptionField : String!
    var difficultyLevel : String!
    var done : String!
    var doneDuration : String!
    var durationUnit : String!
    var media : MediaContent!
    var orderNo : String!
    var patientExercisePlansId : String!
    var patientExercisePlansListRelId : String!
    var reps : String!
    var restDay : String!
    var restPostExercise : String!
    var restPostExerciseUnit : String!
    var restPostSets : String!
    var restPostSetsUnit : String!
    var routineNo : String!
    var sets : String!
    var timeDuration : Int!
    var title : String!
    var updatedAt : String!
    var weekNo : String!
    var isDone: Bool!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        breathingExercise = json["breathing_exercise"].stringValue
        contentMasterId = json["content_master_id"].stringValue
        contentType = json["content_type"].stringValue
        createdAt = json["created_at"].stringValue
        date = json["date"].stringValue
        dayNo = json["day_no"].stringValue
        descriptionField = json["description"].stringValue
        difficultyLevel = json["difficulty_level"].stringValue
        done = json["done"].stringValue
        isDone = json["done"].boolValue
        doneDuration = json["done_duration"].stringValue
        durationUnit = json["duration_unit"].stringValue
        let mediaJson = json["media"]
        if !mediaJson.isEmpty{
            media = MediaContent(fromJson: mediaJson)
        }
        orderNo = json["order_no"].stringValue
        patientExercisePlansId = json["patient_exercise_plans_id"].stringValue
        patientExercisePlansListRelId = json["patient_exercise_plans_list_rel_id"].stringValue
        reps = json["reps"].stringValue
        restDay = json["rest_day"].stringValue
        restPostExercise = json["rest_post_exercise"].stringValue
        restPostExerciseUnit = json["rest_post_exercise_unit"].stringValue
        restPostSets = json["rest_post_sets"].stringValue
        restPostSetsUnit = json["rest_post_sets_unit"].stringValue
        routineNo = json["routine_no"].stringValue
        sets = json["sets"].stringValue
        timeDuration = json["time_duration"].intValue
        title = json["title"].stringValue
        updatedAt = json["updated_at"].stringValue
        weekNo = json["week_no"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if breathingExercise != nil{
            dictionary["breathing_exercise"] = breathingExercise
        }
        if contentMasterId != nil{
            dictionary["content_master_id"] = contentMasterId
        }
        if contentType != nil{
            dictionary["content_type"] = contentType
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if date != nil{
            dictionary["date"] = date
        }
        if dayNo != nil{
            dictionary["day_no"] = dayNo
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if difficultyLevel != nil{
            dictionary["difficulty_level"] = difficultyLevel
        }
        if done != nil{
            dictionary["done"] = done
        }
        if doneDuration != nil{
            dictionary["done_duration"] = doneDuration
        }
        if durationUnit != nil{
            dictionary["duration_unit"] = durationUnit
        }
        if media != nil{
            dictionary["media"] = media.toDictionary()
        }
        if orderNo != nil{
            dictionary["order_no"] = orderNo
        }
        if patientExercisePlansId != nil{
            dictionary["patient_exercise_plans_id"] = patientExercisePlansId
        }
        if patientExercisePlansListRelId != nil{
            dictionary["patient_exercise_plans_list_rel_id"] = patientExercisePlansListRelId
        }
        if reps != nil{
            dictionary["reps"] = reps
        }
        if restDay != nil{
            dictionary["rest_day"] = restDay
        }
        if restPostExercise != nil{
            dictionary["rest_post_exercise"] = restPostExercise
        }
        if restPostExerciseUnit != nil{
            dictionary["rest_post_exercise_unit"] = restPostExerciseUnit
        }
        if restPostSets != nil{
            dictionary["rest_post_sets"] = restPostSets
        }
        if restPostSetsUnit != nil{
            dictionary["rest_post_sets_unit"] = restPostSetsUnit
        }
        if routineNo != nil{
            dictionary["routine_no"] = routineNo
        }
        if sets != nil{
            dictionary["sets"] = sets
        }
        if timeDuration != nil{
            dictionary["time_duration"] = timeDuration
        }
        if title != nil{
            dictionary["title"] = title
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if weekNo != nil{
            dictionary["week_no"] = weekNo
        }
        return dictionary
    }

}
