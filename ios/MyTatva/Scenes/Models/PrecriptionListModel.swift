

import Foundation

class PrecriptionListModel {
    
    var createdAt : String!
    var doseDays : String!
    var doseId : String!
    var doseTimeSlot : String!
    var doseType : String!
    var endDate : String!
    var imageUrl : String!
    var isActive : String!
    var isDeleted : String!
    var medecineId : String!
    var medicineName : String!
    var patientDoseRelId : String!
    var patientId : String!
    var startDate : String!
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
        doseDays = json["dose_days"].stringValue
        doseId = json["dose_id"].stringValue
        doseTimeSlot = json["dose_time_slot"].stringValue
        doseType = json["dose_type"].stringValue
        endDate = json["end_date"].stringValue
        imageUrl = json["image_url"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        medecineId = json["medecine_id"].stringValue
        medicineName = json["medicine_name"].stringValue
        patientDoseRelId = json["patient_dose_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        startDate = json["start_date"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension PrecriptionListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PrecriptionListModel] {
        var models:[PrecriptionListModel] = []
        for item in array
        {
            models.append(PrecriptionListModel(fromJson: item))
        }
        return models
    }
}

