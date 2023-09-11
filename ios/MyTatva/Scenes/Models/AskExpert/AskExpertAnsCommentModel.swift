class AskExpertAnsCommentModel{

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
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        userType = json["user_type"].stringValue
        username = json["username"].stringValue
        visibility = json["visibility"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension AskExpertAnsCommentModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [AskExpertAnsCommentModel] {
        var models:[AskExpertAnsCommentModel] = []
        for item in array
        {
            models.append(AskExpertAnsCommentModel(fromJson: item))
        }
        return models
    }
}
