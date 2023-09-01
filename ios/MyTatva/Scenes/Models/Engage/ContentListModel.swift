
import Foundation

class ContentListModel: NSObject {
    
    var audioHear : String!
    var author : String!
    var bookmarkCapability : String!
    var bookmarked : String!
    var carePlanId : String!
    var comment : Comment!
    var contentId : String!
    var contentMasterId : String!
    var contentType : String!
    var createdAt : String!
    var deepLink : String!
    
    var descriptionField : String!
    var descriptionFieldTemp = ""
    
    var descriptionBasedTag : String!
    var doctorAsAuthor : String!
    var expiryDate : String!
    var expirydateNotApplicable : String!
    var externalLinkOut : String!
    var genre : String!
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
    var title : String!
    var topicName : String!
    var updatedAt : String!
    var updatedBy : String!
    var url : String!
    var xminReadTime : Int!
    var timeDuration: String!
    var addedBy : String!
    var exerciseOfTheWeek : Int!
    var exercisePlanId : String!
    var exerciseRestPost : Int!
    var exerciseRestpostSet : Int!
    var exerciseSets : Int!
    var fitnessLevel : String!
    var healthCoachId : String!
    var noOfReport : Int!
    var orderNo : String!
    var planType : String!
    var reportAction : String!
    
    var breathingExercise : String!
    var exerciseTools : String!
    var goalMasterId : String!
    
    var durationUnit : String!
    var exerciseRestPostUnit : String!
    var exerciseRestpostSetUnit : String!
    
    
    var isSelected = false
    var isCommentSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        audioHear = json["audio_hear"].stringValue
        author = json["author"].stringValue
        bookmarkCapability = json["bookmark_capability"].stringValue
        bookmarked = json["bookmarked"].stringValue
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
        expiryDate = json["expiry_date"].stringValue
        expirydateNotApplicable = json["expirydate_not_applicable"].stringValue
        externalLinkOut = json["external_link_out"].stringValue
        genre = json["genre"].stringValue
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
        title = json["title"].stringValue
        topicName = json["topic_name"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        url = json["url"].stringValue
        xminReadTime = json["xmin_read_time"].intValue
        timeDuration = json["time_duration"].stringValue
        breathingExercise = json["breathing_exercise"].stringValue
        goalMasterId = json["goal_master_id"].stringValue
        exerciseTools = json["exercise_tools"].stringValue
        addedBy = json["added_by"].stringValue
        exerciseOfTheWeek = json["exercise_of_the_week"].intValue
        exercisePlanId = json["exercise_plan_id"].stringValue
        exerciseRestPost = json["exercise_rest_post"].intValue
        exerciseRestpostSet = json["exercise_restpost_set"].intValue
        exerciseSets = json["exercise_sets"].intValue
        fitnessLevel = json["fitness_level"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        noOfReport = json["no_of_report"].intValue
        orderNo = json["order_no"].stringValue
        planType = json["plan_type"].stringValue
        reportAction = json["report_action"].stringValue
        
        durationUnit = json["duration_unit"].stringValue
        exerciseRestPostUnit = json["exercise_rest_post_unit"].stringValue
        exerciseRestpostSetUnit = json["exercise_restpost_set_unit"].stringValue
        
    }
}

//MARK: ---------------- Array Model ----------------------
extension ContentListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ContentListModel] {
        var models:[ContentListModel] = []
        for item in array
        {
            models.append(ContentListModel(fromJson: item))
        }
        return models
    }
}

class MediaModel{
    
    var contentMasterId : String!
    var contentMasterMediaId : String!
    var createdAt : String!
    var imageUrl : String!
    var isActive : String!
    var isDeleted : String!
    var media : String!
    var mediaKey : String!
    var mediaType : String!
    var mediaUrl : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var orderNo : Int!
    var posterImageUrl : String!
    var thumbnailImageUrl : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        contentMasterId = json["content_master_id"].stringValue
        contentMasterMediaId = json["content_master_media_id"].stringValue
        createdAt = json["created_at"].stringValue
        imageUrl = json["image_url"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        media = json["media"].stringValue
        mediaKey = json["media_key"].stringValue
        mediaType = json["media_type"].stringValue
        mediaUrl = json["media_url"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        orderNo = json["order_no"].intValue
        posterImageUrl = json["poster_image_url"].stringValue
        thumbnailImageUrl = json["thumbnail_image_url"].stringValue
    }
}

class Comment{

    var commentData : [CommentData]!
    var total : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        commentData = [CommentData]()
        let commentDataArray = json["comment_data"].arrayValue
        for commentDataJson in commentDataArray{
            let value = CommentData(fromJson: commentDataJson)
            commentData.append(value)
        }
        total = json["total"].intValue
    }

}

class CommentData{

    var comment : String!
    var commentedBy : String!
    var contentCommentsId : String!
    var contentMasterId : String!
    var createdAt : String!
    var isActive : String!
    var isDeleted : String!
    var patientId : String!
    var reportCount : Int!
    var reported : String!
    var updatedAt : String!
    var updatedBy : String!
    var visibility : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        comment = json["comment"].stringValue
        commentedBy = json["commented_by"].stringValue
        contentCommentsId = json["content_comments_id"].stringValue
        contentMasterId = json["content_master_id"].stringValue
        createdAt = json["created_at"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientId = json["patient_id"].stringValue
        reportCount = json["report_count"].intValue
        reported = json["reported"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        visibility = json["visibility"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension CommentData {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [CommentData] {
        var models:[CommentData] = []
        for item in array
        {
            models.append(CommentData(fromJson: item))
        }
        return models
    }
}
