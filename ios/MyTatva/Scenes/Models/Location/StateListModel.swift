

import Foundation

class StateListModel {
    
    var createdAt : String!
    var isActive : String!
    var isDeleted : String!
    var stateMasterId : String!
    var stateName : String!
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
        createdAt = json["created_at"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        stateMasterId = json["state_master_id"].stringValue
        stateName = json["state_name"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension StateListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [StateListModel] {
        var models:[StateListModel] = []
        for item in array
        {
            models.append(StateListModel(fromJson: item))
        }
        return models
    }
}

