
import Foundation

class TopicListModel: NSObject {
    
  
    var colorCode : String!
    var createdAt : String!
    var icon : String!
    var imageUrl : String!
    var isActive : String!
    var isDeleted : String!
    var name : String!
    var noOfBookmark : String!
    var noOfComments : String!
    var noOfShares : String!
    var noOfViews : String!
    var topicMasterId : String!
    var totalContent : Int!
    var updatedAt : String!
    var updatedBy : String!

    var isSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        colorCode = json["color_code"].stringValue
        createdAt = json["created_at"].stringValue
        icon = json["icon"].stringValue
        imageUrl = json["image_url"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        name = json["name"].stringValue
        noOfBookmark = json["no_of_bookmark"].stringValue
        noOfComments = json["no_of_comments"].stringValue
        noOfShares = json["no_of_shares"].stringValue
        noOfViews = json["no_of_views"].stringValue
        topicMasterId = json["topic_master_id"].stringValue
        totalContent = json["total_content"].intValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension TopicListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [TopicListModel] {
        var models:[TopicListModel] = []
        for item in array
        {
            models.append(TopicListModel(fromJson: item))
        }
        return models
    }
}

