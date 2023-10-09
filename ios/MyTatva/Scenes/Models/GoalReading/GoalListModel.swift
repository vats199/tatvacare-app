

import Foundation

class GoalListModel : NSObject, NSCoding {
    
    var colorCode : String!
    var createdAt : String!
    var goalDefaulVal : String!
    var goalMasterId : String!
    var goalMeasurement : String!
    var goalName : String!
    var imageUrl : String!
    var imgExtn : String!
    var isActive : String!
    var isDeleted : String!
    var keys : String!
    var mandatory : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var achievedDatetime : String!
    var endTime : String!
    var goalValue : String!
    var patientGoalRelId : String!
    var patientSubGoalId : String!
    var startTime : String!
    
    var endDate : String!
    var startDate : String!
    
    var achievedValue : Int!
    var todaysAchievedValue : String!
    var goalsRequired : String!
    var orderNo : Int!
    var avgCurrent : Int!
    var avgOther : Int!
    var standardValue : String!
    
    //This var is to store response of get_goal_records api
    var goalChartDetailModel = GoalChartDetailModel()
    var msg                  = ""
    
    var isSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init(fromDic data: NSDictionary) {
        self.colorCode = data["color_code"] as? String
        self.createdAt = data["created_at"] as? String
        self.goalDefaulVal = data["goal_defaul_val"] as? String
        self.goalMasterId = data["goal_master_id"] as? String
        self.goalMeasurement = data["goal_measurement"] as? String
        self.goalName = data["goal_name"] as? String
        self.imageUrl = data["image_url"] as? String
        self.imgExtn = data["img_extn"] as? String
        self.isActive = data["is_active"] as? String
        self.isDeleted = data["is_deleted"] as? String
        self.keys = data["keys"] as? String
        self.mandatory = data["mandatory"] as? String
        self.updatedAt = data["updated_at"] as? String
        self.updatedBy = data["updated_by"] as? String
        self.achievedDatetime = data["achieved_datetime"] as? String
        self.endTime = data["end_time"] as? String
        self.goalValue = "\(data["goal_value"] as? Float ?? 0)"
        self.patientGoalRelId = data["patient_goal_rel_id"] as? String
        self.patientSubGoalId = data["patient_sub_goal_id"] as? String
        self.startTime = data["start_time"] as? String
        self.endDate = data["end_date"] as? String
        self.startDate = data["start_date"] as? String
        self.achievedValue = Int("\(data["achieved_value"] as? String ?? "0")") ?? 0
        self.todaysAchievedValue = "\(data["todays_achieved_value"] as? Float ?? 0)"
        self.goalsRequired = data["goals_required"] as? String
        self.orderNo = data["order_no"] as? Int
        self.avgCurrent = data["avg_current"] as? Int
        self.avgOther = data["avg_other"] as? Int
        self.standardValue = data["standard_value"] as? String
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        colorCode = json["color_code"].stringValue
        createdAt = json["created_at"].stringValue
        goalDefaulVal = json["goal_defaul_val"].stringValue
        goalMasterId = json["goal_master_id"].stringValue
        goalMeasurement = json["goal_measurement"].stringValue
        goalName = json["goal_name"].stringValue
        imageUrl = json["image_url"].stringValue
        imgExtn = json["img_extn"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        keys = json["keys"].stringValue
        mandatory = json["mandatory"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        
        achievedDatetime = json["achieved_datetime"].stringValue
        achievedValue = json["achieved_value"].intValue
        endTime = json["end_time"].stringValue
        goalValue = json["goal_value"].stringValue
        patientGoalRelId = json["patient_goal_rel_id"].stringValue
        patientSubGoalId = json["patient_sub_goal_id"].stringValue
        startTime = json["start_time"].stringValue
        
        startDate = json["start_date"].stringValue
        endDate = json["end_date"].stringValue
        todaysAchievedValue = json["todays_achieved_value"].stringValue
        goalsRequired = json["goals_required"].stringValue
        orderNo = json["order_no"].intValue
        avgCurrent = json["avg_current"].intValue
        avgOther = json["avg_other"].intValue
        standardValue = json["standard_value"].stringValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        achievedDatetime = aDecoder.decodeObject(forKey: "achieved_datetime") as? String
        achievedValue = aDecoder.decodeObject(forKey: "achieved_value") as? Int
        avgCurrent = aDecoder.decodeObject(forKey: "avg_current") as? Int
        avgOther = aDecoder.decodeObject(forKey: "avg_other") as? Int
        colorCode = aDecoder.decodeObject(forKey: "color_code") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        endTime = aDecoder.decodeObject(forKey: "end_time") as? String
        goalMasterId = aDecoder.decodeObject(forKey: "goal_master_id") as? String
        goalMeasurement = aDecoder.decodeObject(forKey: "goal_measurement") as? String
        goalName = aDecoder.decodeObject(forKey: "goal_name") as? String
        goalValue = aDecoder.decodeObject(forKey: "goal_value") as? String
        goalsRequired = aDecoder.decodeObject(forKey: "goals_required") as? String
        imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
        imgExtn = aDecoder.decodeObject(forKey: "img_extn") as? String
        isActive = aDecoder.decodeObject(forKey: "is_active") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        keys = aDecoder.decodeObject(forKey: "keys") as? String
        mandatory = aDecoder.decodeObject(forKey: "mandatory") as? String
        orderNo = aDecoder.decodeObject(forKey: "order_no") as? Int
        patientGoalRelId = aDecoder.decodeObject(forKey: "patient_goal_rel_id") as? String
        patientSubGoalId = aDecoder.decodeObject(forKey: "patient_sub_goal_id") as? String
        startDate = aDecoder.decodeObject(forKey: "start_date") as? String
        startTime = aDecoder.decodeObject(forKey: "start_time") as? String
        todaysAchievedValue = aDecoder.decodeObject(forKey: "todays_achieved_value") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if achievedDatetime != nil{
            aCoder.encode(achievedDatetime, forKey: "achieved_datetime")
        }
        if achievedValue != nil{
            aCoder.encode(achievedValue, forKey: "achieved_value")
        }
        if avgCurrent != nil{
            aCoder.encode(avgCurrent, forKey: "avg_current")
        }
        if avgOther != nil{
            aCoder.encode(avgOther, forKey: "avg_other")
        }
        if colorCode != nil{
            aCoder.encode(colorCode, forKey: "color_code")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "end_time")
        }
        if goalMasterId != nil{
            aCoder.encode(goalMasterId, forKey: "goal_master_id")
        }
        if goalMeasurement != nil{
            aCoder.encode(goalMeasurement, forKey: "goal_measurement")
        }
        if goalName != nil{
            aCoder.encode(goalName, forKey: "goal_name")
        }
        if goalValue != nil{
            aCoder.encode(goalValue, forKey: "goal_value")
        }
        if goalsRequired != nil{
            aCoder.encode(goalsRequired, forKey: "goals_required")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "image_url")
        }
        if imgExtn != nil{
            aCoder.encode(imgExtn, forKey: "img_extn")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if keys != nil{
            aCoder.encode(keys, forKey: "keys")
        }
        if mandatory != nil{
            aCoder.encode(mandatory, forKey: "mandatory")
        }
        if orderNo != nil{
            aCoder.encode(orderNo, forKey: "order_no")
        }
        if patientGoalRelId != nil{
            aCoder.encode(patientGoalRelId, forKey: "patient_goal_rel_id")
        }
        if patientSubGoalId != nil{
            aCoder.encode(patientSubGoalId, forKey: "patient_sub_goal_id")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "start_time")
        }
        if todaysAchievedValue != nil{
            aCoder.encode(todaysAchievedValue, forKey: "todays_achieved_value")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension GoalListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [GoalListModel] {
        var models:[GoalListModel] = []
        for item in array
        {
            models.append(GoalListModel(fromJson: item))
        }
        return models
    }
}

