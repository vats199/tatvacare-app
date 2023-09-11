//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class DealListModel: NSObject {
    
    var businessId : Int!
    var businessUserId : Int!
    var createdAt : String!
    var dealId : Int!
    var descriptionField : String!
    var discountType : String!
    var discountValue : Int!
    var endTime : String!
    var id : Int!
    var image : String!
    var isAvailable : Int!
    var name : String!
    var recurringDates : String!
    var recurringDays : String!
    var recurringType : String!
    var startTime : String!
    var status : String!
    var type : String!
    var updatedAt : String!
    var isSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        businessId = json["business_id"].intValue
        businessUserId = json["business_user_id"].intValue
        createdAt = json["created_at"].stringValue
        dealId = json["deal_id"].intValue
        descriptionField = json["description"].stringValue
        discountType = json["discount_type"].stringValue
        discountValue = json["discount_value"].intValue
        endTime = json["end_time"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        isAvailable = json["is_available"].intValue
        name = json["name"].stringValue
        recurringDates = json["recurring_dates"].stringValue
        recurringDays = json["recurring_days"].stringValue
        recurringType = json["recurring_type"].stringValue
        startTime = json["start_time"].stringValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension DealListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [DealListModel] {
        var models:[DealListModel] = []
        for item in array
        {
            models.append(DealListModel(fromJson: item))
        }
        return models
    }
}

