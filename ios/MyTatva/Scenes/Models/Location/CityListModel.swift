

import Foundation

class CityListModel {
    
    var cityMasterId : String!
    var cityName : String!
    var createdAt : String!
    var isActive : String!
    var isDeleted : String!
    var stateId : String!
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
        cityMasterId = json["city_master_id"].stringValue
        cityName = json["city_name"].stringValue
        createdAt = json["created_at"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        stateId = json["state_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension CityListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [CityListModel] {
        var models:[CityListModel] = []
        for item in array
        {
            models.append(CityListModel(fromJson: item))
        }
        return models
    }
}

