//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class ExerciseDetailListModel {
    
    var brRepeatInDay : Int!
    var breathingCounts : Int!
    var breathingData : [BreathingData]!
    var exerciseData : [BreathingData]!
    var breathingDescription : String!
    var breathingDone : String!
    var breathingDuration : Int!
    var contentMasterId : String!
    var createdAt : String!
    var day : String!
    var dayDate : String!
    var exRepeatInDay : Int!
    var exerciseCounts : Int!
    var exerciseDescription : String!
    var exerciseDone : String!
    var exerciseDuration : Int!
    var exercisePlanDayId : String!
    var goalDate : String!
    var isActive : String!
    var isDeleted : String!
    var isRestDay : Int!
    var isTrial : Int!
    var orderNo : Int!
    var updatedAt : String!
    var updatedBy : String!
    var exerciseRestPost : String!
    var exerciseRestpostSet : String!
    var dayType : String!
    
    var date : Int!
    var month : String!
    
    var exerciseRestPostUnit : String!
    var exerciseRestpostSetUnit : String!
    var breathingDurationUnit : String!
    var exerciseDurationUnit : String!

    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        exerciseData = [BreathingData]()
        let exerciseDataArray = json["exercise_data"].arrayValue
        for exerciseDataJson in exerciseDataArray{
            let value = BreathingData(fromJson: exerciseDataJson)
            exerciseData.append(value)
        }
        
        dayType = json["day_type"].stringValue
        brRepeatInDay = json["br_repeat_in_day"].intValue
        breathingCounts = json["breathing_counts"].intValue
        breathingData = [BreathingData]()
        let breathingDataArray = json["breathing_data"].arrayValue
        for breathingDataJson in breathingDataArray{
            let value = BreathingData(fromJson: breathingDataJson)
            breathingData.append(value)
        }
        breathingDescription = json["breathing_description"].stringValue
        breathingDone = json["breathing_done"].stringValue
        breathingDuration = json["breathing_duration"].intValue
        contentMasterId = json["content_master_id"].stringValue
        createdAt = json["created_at"].stringValue
        day = json["day"].stringValue
        dayDate = json["day_date"].stringValue
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
        orderNo = json["order_no"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        exerciseRestPost = json["exercise_rest_post"].stringValue
        exerciseRestpostSet = json["exercise_restpost_set"].stringValue
        date = json["date"].intValue
        month = json["month"].stringValue
            
        exerciseRestPostUnit = json["exercise_rest_post_unit"].stringValue
        exerciseRestpostSetUnit = json["exercise_restpost_set_unit"].stringValue
        breathingDurationUnit = json["breathing_duration_unit"].stringValue
        exerciseDurationUnit = json["exercise_duration_unit"].stringValue

    }

}

class BreathingData{

    var contentData : ContentData!
    var contentMasterId : String!
    var createdAt : String!
    var exercisePlanDayId : String!
    var exercisePlanDayRelId : String!
    var orderNo : Int!
    var type : String!
    var unit : String!
    var unitNo : Int!

    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let contentDataJson = json["content_data"]
        if !contentDataJson.isEmpty{
            contentData = ContentData(fromJson: contentDataJson)
        }
        contentMasterId = json["content_master_id"].stringValue
        createdAt = json["created_at"].stringValue
        exercisePlanDayId = json["exercise_plan_day_id"].stringValue
        exercisePlanDayRelId = json["exercise_plan_day_rel_id"].stringValue
        orderNo = json["order_no"].intValue
        type = json["type"].stringValue
        unit = json["unit"].stringValue
        unitNo = json["unit_no"].intValue
    }

}

class ContentData{

    var addedBy : String!
    var audioHear : String!
    var author : String!
    var bookmarkCapability : String!
    var bookmarked : String!
    var breathingExercise : String!
    var carePlanId : String!
    var comment : Comment!
    var contentId : String!
    var contentMasterId : String!
    var contentType : String!
    var createdAt : String!
    var deepLink : String!
    var descriptionField : String!
    var descriptionBasedTag : String!
    var doctorAsAuthor : String!
    var exerciseOfTheWeek : Int!
    var exerciseRestPost : Int!
    var exerciseRestpostSet : Int!
    var exerciseSets : Int!
    var exerciseTools : String!
    var expiryDate : String!
    var expirydateNotApplicable : String!
    var externalLinkOut : String!
    var fitnessLevel : String!
    var genre : String!
    var goalMasterId : String!
    var groupMasterId : String!
    var hostedBy : String!
    var isActive : String!
    var isDeleted : String!
    var kolDesignation : String!
    var kolQualification : String!
    var kolSpeaker : String!
    var kolSpeakerPhoto : String!
    var languageMasterId : String!
    var languageSelection : String!
    var likeCapability : String!
    var liked : String!
    var location : String!
    var media : [MediaModel]!
    var medicalConditionGroupId : String!
    var moleculeBasedTag : String!
    var noOfBookmark : Int!
    var noOfComments : Int!
    var noOfLikes : Int!
    var noOfShares : Int!
    var noOfViews : Int!
    var phoneNumber : String!
    var photoEmbeddedIncontent : String!
    var posterDesignation : String!
    var premium : String!
    var priorityFlag : String!
    var publishDate : String!
    var recommendedByDoctor : String!
    var recommendedByHealthcoach : String!
    var scheduledDate : String!
    var shareCapability : String!
    var status : String!
    var therapyBasedTags : String!
    var thumbnailAltTag : String!
    var timeDuration : Int!
    var title : String!
    var updatedAt : String!
    var updatedBy : String!
    var url : String!
    var xminReadTime : Int!

    var durationUnit : String!
    var exercisePlanId : String!
    var exerciseRestPostUnit : String!
    var exerciseRestpostSetUnit : String!
    var healthCoachId : String!
    var noOfReport : Int!
    var orderNo : Int!
    var planType : String!
    var reportAction : String!
    
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        addedBy = json["added_by"].stringValue
        audioHear = json["audio_hear"].stringValue
        author = json["author"].stringValue
        bookmarkCapability = json["bookmark_capability"].stringValue
        bookmarked = json["bookmarked"].stringValue
        breathingExercise = json["breathing_exercise"].stringValue
        carePlanId = json["care_plan_id"].stringValue
        let commentJson = json["comment"]
        if !commentJson.isEmpty{
            comment = Comment(fromJson: commentJson)
        }
        contentId = json["content_id"].stringValue
        contentMasterId = json["content_master_id"].stringValue
        contentType = json["content_type"].stringValue
        createdAt = json["created_at"].stringValue
        deepLink = json["deep_link"].stringValue
        descriptionField = json["description"].stringValue
        descriptionBasedTag = json["description_based_tag"].stringValue
        doctorAsAuthor = json["doctor_as_author"].stringValue
        exerciseOfTheWeek = json["exercise_of_the_week"].intValue
        exerciseRestPost = json["exercise_rest_post"].intValue
        exerciseRestpostSet = json["exercise_restpost_set"].intValue
        exerciseSets = json["exercise_sets"].intValue
        exerciseTools = json["exercise_tools"].stringValue
        expiryDate = json["expiry_date"].stringValue
        expirydateNotApplicable = json["expirydate_not_applicable"].stringValue
        externalLinkOut = json["external_link_out"].stringValue
        fitnessLevel = json["fitness_level"].stringValue
        genre = json["genre"].stringValue
        goalMasterId = json["goal_master_id"].stringValue
        groupMasterId = json["group_master_id"].stringValue
        hostedBy = json["hosted_by"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        kolDesignation = json["kol_designation"].stringValue
        kolQualification = json["kol_qualification"].stringValue
        kolSpeaker = json["kol_speaker"].stringValue
        kolSpeakerPhoto = json["kol_speaker_photo"].stringValue
        languageMasterId = json["language_master_id"].stringValue
        languageSelection = json["language_selection"].stringValue
        likeCapability = json["like_capability"].stringValue
        liked = json["liked"].stringValue
        location = json["location"].stringValue
        media = [MediaModel]()
        let mediaArray = json["media"].arrayValue
        for mediaJson in mediaArray{
            let value = MediaModel(fromJson: mediaJson)
            media.append(value)
        }
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        moleculeBasedTag = json["molecule_based_tag"].stringValue
        noOfBookmark = json["no_of_bookmark"].intValue
        noOfComments = json["no_of_comments"].intValue
        noOfLikes = json["no_of_likes"].intValue
        noOfShares = json["no_of_shares"].intValue
        noOfViews = json["no_of_views"].intValue
        phoneNumber = json["phone_number"].stringValue
        photoEmbeddedIncontent = json["photo_embedded_incontent"].stringValue
        posterDesignation = json["poster_designation"].stringValue
        premium = json["premium"].stringValue
        priorityFlag = json["priority_flag"].stringValue
        publishDate = json["publish_date"].stringValue
        recommendedByDoctor = json["recommended_by_doctor"].stringValue
        recommendedByHealthcoach = json["recommended_by_healthcoach"].stringValue
        scheduledDate = json["scheduled_date"].stringValue
        shareCapability = json["share_capability"].stringValue
        status = json["status"].stringValue
        therapyBasedTags = json["therapy_based_tags"].stringValue
        thumbnailAltTag = json["thumbnail_alt_tag"].stringValue
        timeDuration = json["time_duration"].intValue
        title = json["title"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        url = json["url"].stringValue
        xminReadTime = json["xmin_read_time"].intValue
        
        durationUnit = json["duration_unit"].stringValue
        exercisePlanId = json["exercise_plan_id"].stringValue
        exerciseRestPostUnit = json["exercise_rest_post_unit"].stringValue
        exerciseRestpostSetUnit = json["exercise_restpost_set_unit"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        noOfReport = json["no_of_report"].intValue
        orderNo = json["order_no"].intValue
        planType = json["plan_type"].stringValue
        reportAction = json["report_action"].stringValue

    }

}
