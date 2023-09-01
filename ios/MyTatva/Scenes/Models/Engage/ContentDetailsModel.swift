
import Foundation

class ContentDetailsModel: NSObject {
    
    var audioHear : String!
    var author : String!
    var bookmarkCapability : String!
    var carePlanId : String!
    var contentId : String!
    var contentMasterId : String!
    var contentType : String!
    var createdAt : String!
    var deepLink : String!
    var descriptionField : String!
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
        carePlanId = json["care_plan_id"].stringValue
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
    }
    
}
