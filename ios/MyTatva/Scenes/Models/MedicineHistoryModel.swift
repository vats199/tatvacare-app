
import Foundation
import SwiftyJSON

class MedicineHistoryModel {

    var createdAt : String!
    var doseDays : String!
    var doseId : String!
    var doseTaken : String!
    var doseTakenData : [DoseTakenData]!
    var doseTakenDate : String!
    var doseTimeSlot : String!
    var endDate : String!
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
        createdAt = json["created_at"].stringValue
        doseDays = json["dose_days"].stringValue
        doseId = json["dose_id"].stringValue
        doseTaken = json["dose_taken"].stringValue
        doseTakenData = [DoseTakenData]()
        let doseTakenDataArray = json["dose_taken_data"].arrayValue
        for doseTakenDataJson in doseTakenDataArray{
            let value = DoseTakenData(fromJson: doseTakenDataJson)
            doseTakenData.append(value)
        }
        doseTakenDate = json["dose_taken_date"].stringValue
        doseTimeSlot = json["dose_time_slot"].stringValue
        endDate = json["end_date"].stringValue
        imageUrl = json["image_url"].stringValue
        medecineId = json["medecine_id"].stringValue
        medicineName = json["medicine_name"].stringValue
        patientDoseRelId = json["patient_dose_rel_id"].stringValue
        startDate = json["start_date"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension MedicineHistoryModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MedicineHistoryModel] {
        var models:[MedicineHistoryModel] = []
        for item in array
        {
            models.append(MedicineHistoryModel(fromJson: item))
        }
        return models
    }
}



class DoseTakenData{

    var achievedValue : Int!
    var doseDay : String!
    var goalValue : Int!


    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        achievedValue = json["achieved_value"].intValue
        doseDay = json["dose_day"].stringValue
        goalValue = json["goal_value"].intValue
    }

}
