import Foundation

class AppointmentTimeSlotModel: NSObject {
    
  
    var responseCode : Int!
    var result : TimeSlotResult!
    var statusUpdate : String!
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        responseCode = json["ResponseCode"].intValue
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = TimeSlotResult(fromJson: resultJson)
        }
        statusUpdate = json["status_update"].stringValue
    }
}

class TimeSlotResult {

    var timeSlot : [TimeSlot]!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        timeSlot = [TimeSlot]()
        let timeSlotArray = json["time_slot"].arrayValue
        for timeSlotJson in timeSlotArray{
            let value = TimeSlot(fromJson: timeSlotJson)
            timeSlot.append(value)
        }
    }
}

//MARK: ---------------- Array Model ----------------------
extension AppointmentTimeSlotModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [AppointmentTimeSlotModel] {
        var models:[AppointmentTimeSlotModel] = []
        for item in array
        {
            models.append(AppointmentTimeSlotModel(fromJson: item))
        }
        return models
    }
}

class TimeSlot{

    var slots : [String]!
    var title : String!
    var icon_url : String!

    var isSelected = false

    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(){}
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        slots = [String]()
        let timeSlotJson = json["slots"].arrayObject
        if timeSlotJson != nil{
            slots.append(contentsOf: timeSlotJson as? [String] ?? [""])
        }
        
        title = json["title"].stringValue
        icon_url = json["icon_url"].stringValue
        
    }
}

//MARK: ---------------- Array Model ----------------------
extension TimeSlot {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [TimeSlot] {
        var models:[TimeSlot] = []
        for item in array
        {
            models.append(TimeSlot(fromJson: item))
        }
        return models
    }
}


