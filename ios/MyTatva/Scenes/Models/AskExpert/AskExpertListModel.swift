
class AskExpertListModel {
    
    var bookmarked : String!
    var contentMasterId : String!
    var createdAt : String!
    var documents : [MediaModel]!
    var liked : String!
    var name : String!
    var recentAnswers : [RecentAnswer]!
    var reported : String!
    var title : String!
    var topAnswer : RecentAnswer!
    var topics : [TopicListModel]!
    var totalAnswers : Int!
    var updatedAt : String!
    var updatedBy : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookmarked = json["bookmarked"].stringValue
        contentMasterId = json["content_master_id"].stringValue
        createdAt = json["created_at"].stringValue
        documents = [MediaModel]()
        let documentsArray = json["documents"].arrayValue
        for documentsJson in documentsArray{
            let value = MediaModel(fromJson: documentsJson)
            documents.append(value)
        }
        liked = json["liked"].stringValue
        name = json["name"].stringValue
        recentAnswers = [RecentAnswer]()
        let recentAnswersArray = json["recent_answers"].arrayValue
        for recentAnswersJson in recentAnswersArray{
            let value = RecentAnswer(fromJson: recentAnswersJson)
            recentAnswers.append(value)
        }
        reported = json["reported"].stringValue
        title = json["title"].stringValue
        let topAnswerJson = json["top_answer"]
        if !topAnswerJson.isEmpty{
            topAnswer = RecentAnswer(fromJson: topAnswerJson)
        }
        topics = [TopicListModel]()
        let topicsArray = json["topics"].arrayValue
        for topicsJson in topicsArray{
            let value = TopicListModel(fromJson: topicsJson)
            topics.append(value)
        }
        totalAnswers = json["total_answers"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension AskExpertListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [AskExpertListModel] {
        var models:[AskExpertListModel] = []
        for item in array
        {
            models.append(AskExpertListModel(fromJson: item))
        }
        return models
    }
}

class RecentAnswer{
    
    var comment : String!
    var contentCommentsId : String!
    var contentMasterId : String!
    var contentType : String!
    var createdAt : String!
    var deepLink : String!
    var healthCoachId : String!
    var isActive : String!
    var isDeleted : String!
    var likeCount : Int!
    var liked : String!
    var parentId : String!
    var patientId : String!
    var reportCount : Int!
    var reportStatus : String!
    var reported : String!
    var tagId : String!
    var updatedAt : String!
    var updatedBy : String!
    var userType : String!
    var username : String!
    var visibility : String!
    var totalComments : Int!
    var userTitle : String!
    
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        comment = json["comment"].stringValue
        contentCommentsId = json["content_comments_id"].stringValue
        contentMasterId = json["content_master_id"].stringValue
        contentType = json["content_type"].stringValue
        createdAt = json["created_at"].stringValue
        deepLink = json["deep_link"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        likeCount = json["like_count"].intValue
        liked = json["liked"].stringValue
        parentId = json["parent_id"].stringValue
        patientId = json["patient_id"].stringValue
        reportCount = json["report_count"].intValue
        reportStatus = json["report_status"].stringValue
        reported = json["reported"].stringValue
        tagId = json["tag_id"].stringValue
        totalComments = json["total_comments"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        userTitle = json["user_title"].stringValue
        userType = json["user_type"].stringValue
        username = json["username"].stringValue
        visibility = json["visibility"].stringValue
    }


}
