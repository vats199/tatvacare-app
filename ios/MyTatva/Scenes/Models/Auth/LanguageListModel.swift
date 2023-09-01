

import Foundation

class LanguageListModel {

    var createdAt : String!
    var currentVersion : String!
    var isActive : String!
    var isDeleted : String!
    var languageName : String!
    var languagesId : String!
    var updatedAt : String!
    var updatedBy : String!
    var useFor : String!
    
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
        currentVersion = json["current_version"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        languageName = json["language_name"].stringValue
        languagesId = json["languages_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        useFor = json["use_for"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension LanguageListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [LanguageListModel] {
        var models:[LanguageListModel] = []
        for item in array
        {
            models.append(LanguageListModel(fromJson: item))
        }
        return models
    }
}

