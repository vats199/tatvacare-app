//
//	PlanDataModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class PlanDataModel{
    
    var addedBy : String!
    var audioHear : String!
    var author : String!
    var bookmarkCapability : String!
    var breathingCounts : String!
    var breathingDone : String!
    var breathingExercise : String!
    var carePlanId : String!
    var contentId : String!
    var contentMasterId : String!
    var contentType : String!
    var createdAt : String!
    var deepLink : String!
    var descriptionField : String!
    var descriptionBasedTag : String!
    var doctorAsAuthor : String!
    var exerciseCounts : String!
    var exerciseDone : String!
    var exerciseOfTheWeek : Int!
    var exerciseRestPost : Int!
    var exerciseRestpostSet : Int!
    var exerciseSets : Int!
    var exerciseTools : String!
    var expiryDate : String!
    var expirydateNotApplicable : String!
    var externalLinkOut : String!
    var fitnessLevel : String!
    var groupMasterId : String!
    var healthCoachId : String!
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
    var location : String!
    var medicalConditionGroupId : String!
    var moleculeBasedTag : String!
    var noOfBookmark : Int!
    var noOfComments : Int!
    var noOfLikes : Int!
    var noOfReport : Int!
    var noOfShares : Int!
    var noOfViews : Int!
    var phoneNumber : String!
    var photoEmbeddedIncontent : String!
    var planType : String!
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
    var totalDays : Int!
    var updatedAt : String!
    var updatedBy : String!
    var url : String!
    var xminReadTime : Int!
    
    var exercisePlanId : String!
    var reportAction : String!
    var exerciseAddedBy : String!
 

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
        breathingCounts = json["breathing_counts"].stringValue
        breathingDone = json["breathing_done"].stringValue
        breathingExercise = json["breathing_exercise"].stringValue
        carePlanId = json["care_plan_id"].stringValue
        contentId = json["content_id"].stringValue
        contentMasterId = json["content_master_id"].stringValue
        contentType = json["content_type"].stringValue
        createdAt = json["created_at"].stringValue
        deepLink = json["deep_link"].stringValue
        descriptionField = json["description"].stringValue
        descriptionBasedTag = json["description_based_tag"].stringValue
        doctorAsAuthor = json["doctor_as_author"].stringValue
        exerciseCounts = json["exercise_counts"].stringValue
        exerciseDone = json["exercise_done"].stringValue
        exerciseOfTheWeek = json["exercise_of_the_week"].intValue
        exerciseRestPost = json["exercise_rest_post"].intValue
        exerciseRestpostSet = json["exercise_restpost_set"].intValue
        exerciseSets = json["exercise_sets"].intValue
        exerciseTools = json["exercise_tools"].stringValue
        expiryDate = json["expiry_date"].stringValue
        expirydateNotApplicable = json["expirydate_not_applicable"].stringValue
        externalLinkOut = json["external_link_out"].stringValue
        fitnessLevel = json["fitness_level"].stringValue
        groupMasterId = json["group_master_id"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
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
        location = json["location"].stringValue
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        moleculeBasedTag = json["molecule_based_tag"].stringValue
        noOfBookmark = json["no_of_bookmark"].intValue
        noOfComments = json["no_of_comments"].intValue
        noOfLikes = json["no_of_likes"].intValue
        noOfReport = json["no_of_report"].intValue
        noOfShares = json["no_of_shares"].intValue
        noOfViews = json["no_of_views"].intValue
        phoneNumber = json["phone_number"].stringValue
        photoEmbeddedIncontent = json["photo_embedded_incontent"].stringValue
        planType = json["plan_type"].stringValue
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
        totalDays = json["total_days"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        url = json["url"].stringValue
        xminReadTime = json["xmin_read_time"].intValue
        
        exercisePlanId = json["exercise_plan_id"].stringValue
        reportAction = json["report_action"].stringValue
        exerciseAddedBy = json["exercise_added_by"].stringValue

    }
}

//MARK: ---------------- Array Model ----------------------
extension PlanDataModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PlanDataModel] {
        var models:[PlanDataModel] = []
        for item in array
        {
            models.append(PlanDataModel(fromJson: item))
        }
        return models
    }
}

struct PlanType {
    var title : String!
    var plantypeCount : String!
    var isDone : String!
    var image : UIImage!
}
