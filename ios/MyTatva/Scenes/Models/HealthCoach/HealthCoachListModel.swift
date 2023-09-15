

import Foundation

class HealthCoachListModel: NSObject {

    var firstName : String!
    var healthCoachId : String!
    var imageUrl : String!
    var lastName : String!
    var profilePic : String!
    var role : String!
    var tagName : String!
    
    var isSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        firstName = json["first_name"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        imageUrl = json["image_url"].stringValue
        lastName = json["last_name"].stringValue
        profilePic = json["profile_pic"].stringValue
        role = json["role"].stringValue
        tagName = json["tag_name"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension HealthCoachListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [HealthCoachListModel] {
        var models:[HealthCoachListModel] = []
        for item in array
        {
            models.append(HealthCoachListModel(fromJson: item))
        }
        return models
    }
}
