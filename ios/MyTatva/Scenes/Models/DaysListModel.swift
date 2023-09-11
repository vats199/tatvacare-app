

import Foundation

class DaysListModel {
    
    var createdAt : String!
    var day : String!
    var daysKeys : String!
    var languageId : String!
    var updatedAt : String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        day = json["day"].stringValue
        daysKeys = json["days_keys"].stringValue
        languageId = json["language_id"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension DaysListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [DaysListModel] {
        var models:[DaysListModel] = []
        for item in array
        {
            models.append(DaysListModel(fromJson: item))
        }
        return models
    }
}

