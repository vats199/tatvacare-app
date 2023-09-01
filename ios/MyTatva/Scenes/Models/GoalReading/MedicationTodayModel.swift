
import Foundation


class MedicationTodayModel{
    
    var achievedValue : Int!
    var goalValue : Int!
    var medication : [MedicationTodayList]!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        achievedValue = json["achieved_value"].intValue
        goalValue = json["goal_value"].intValue
        medication = [MedicationTodayList]()
        let medicationArray = json["medication"].arrayValue
        for medicationJson in medicationArray{
            let value = MedicationTodayList(fromJson: medicationJson)
            medication.append(value)
        }
    }
}

class MedicationTodayList {
    
    var achievedValue : Int!
    var createdAt : String!
    var doseDays : String!
    var doseId : String!
    var doseTaken : String!
    var doseTimeSlot : [DoseTimeSlot]!
    var endDate : String!
    var goalValue : Int!
    var imageUrl : String!
    var medecineId : String!
    var medicineName : String!
    var patientDoseRelId : String!
    var startDate : String!
    var updatedAt : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        achievedValue = json["achieved_value"].intValue
        createdAt = json["created_at"].stringValue
        doseDays = json["dose_days"].stringValue
        doseId = json["dose_id"].stringValue
        doseTaken = json["dose_taken"].stringValue
        doseTimeSlot = [DoseTimeSlot]()
        let doseTimeSlotArray = json["dose_time_slot"].arrayValue
        for doseTimeSlotJson in doseTimeSlotArray{
            let value = DoseTimeSlot(fromJson: doseTimeSlotJson)
            doseTimeSlot.append(value)
        }
        endDate = json["end_date"].stringValue
        goalValue = json["goal_value"].intValue
        imageUrl = json["image_url"].stringValue
        medecineId = json["medecine_id"].stringValue
        medicineName = json["medicine_name"].stringValue
        patientDoseRelId = json["patient_dose_rel_id"].stringValue
        startDate = json["start_date"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension MedicationTodayModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MedicationTodayModel] {
        var models:[MedicationTodayModel] = []
        for item in array
        {
            models.append(MedicationTodayModel(fromJson: item))
        }
        return models
    }
}



class DoseTimeSlot{
    
    var taken : String!
    var time : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        taken = json["taken"].stringValue
        time = json["time"].stringValue
    }
    
}
