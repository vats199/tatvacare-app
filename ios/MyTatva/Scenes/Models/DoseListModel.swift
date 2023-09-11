

import Foundation

class DoseListModel {
    
    var createdAt : String!
    var doseMasterId : String!
    var doseType : String!
    var isActive : String!
    var isDeleted : String!
    var suggestedTimeSlots : [String]!
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
        doseMasterId = json["dose_master_id"].stringValue
        doseType = json["dose_type"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        
        suggestedTimeSlots = [String]()
        let suggestedTimeSlotsJson = json["suggested_time_slots"].arrayObject
        if suggestedTimeSlotsJson != nil{
            suggestedTimeSlots.append(contentsOf: suggestedTimeSlotsJson as? [String] ?? [""])
        }
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension DoseListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [DoseListModel] {
        var models:[DoseListModel] = []
        for item in array
        {
            models.append(DoseListModel(fromJson: item))
        }
        return models
    }
}


class DoseTimeslotModel {
    
    var time : String!
    var isSelected = false
    
    init(){}
}
