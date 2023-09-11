//
//  AppoitementModel.swift
//  MyTatva
//
//  Created by 2022M43 on 20/06/23.
//

import Foundation
import SwiftyJSON


class AppointmentModel {
    
    var date : String!
    var nutritionist : NutritionistModel!
    var nutritionistAvailabilityDate : String!
    var nutritionistDay : String!
    var nutritionistEndTime : String!
    var nutritionistStartTime : String!
    var nutritionistTimeType : String!
    var physiotherapist : NutritionistModel!
    var physiotherapistAvailabilityDate : String!
    var physiotherapistDay : String!
    var physiotherapistEndTime : String!
    var physiotherapistStartTime : String!
    var physiotherapistTimeType : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        date = json["date"].stringValue
        let nutritionistJson = json["nutritionist"]
        if !nutritionistJson.isEmpty{
            nutritionist = NutritionistModel(fromJson: nutritionistJson)
        }
        nutritionistAvailabilityDate = json["nutritionist_availability_date"].stringValue
        nutritionistDay = json["nutritionist_day"].stringValue
        nutritionistEndTime = json["nutritionist_end_time"].stringValue
        nutritionistStartTime = json["nutritionist_start_time"].stringValue
        nutritionistTimeType = json["nutritionist_time_type"].stringValue
        let physiotherapistJson = json["physiotherapist"]
        if !physiotherapistJson.isEmpty{
            physiotherapist = NutritionistModel(fromJson: physiotherapistJson)
        }
        physiotherapistAvailabilityDate = json["physiotherapist_availability_date"].stringValue
        physiotherapistDay = json["physiotherapist_day"].stringValue
        physiotherapistEndTime = json["physiotherapist_end_time"].stringValue
        physiotherapistStartTime = json["physiotherapist_start_time"].stringValue
        physiotherapistTimeType = json["physiotherapist_time_type"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if nutritionist != nil{
            dictionary["nutritionist"] = nutritionist
        }
        if nutritionistAvailabilityDate != nil{
            dictionary["nutritionist_availability_date"] = nutritionistAvailabilityDate
        }
        if nutritionistDay != nil{
            dictionary["nutritionist_day"] = nutritionistDay
        }
        if nutritionistEndTime != nil{
            dictionary["nutritionist_end_time"] = nutritionistEndTime
        }
        if nutritionistStartTime != nil{
            dictionary["nutritionist_start_time"] = nutritionistStartTime
        }
        if nutritionistTimeType != nil{
            dictionary["nutritionist_time_type"] = nutritionistTimeType
        }
        if physiotherapist != nil{
            dictionary["physiotherapist"] = physiotherapist
        }
        if physiotherapistAvailabilityDate != nil{
            dictionary["physiotherapist_availability_date"] = physiotherapistAvailabilityDate
        }
        if physiotherapistDay != nil{
            dictionary["physiotherapist_day"] = physiotherapistDay
        }
        if physiotherapistEndTime != nil{
            dictionary["physiotherapist_end_time"] = physiotherapistEndTime
        }
        if physiotherapistStartTime != nil{
            dictionary["physiotherapist_start_time"] = physiotherapistStartTime
        }
        if physiotherapistTimeType != nil{
            dictionary["physiotherapist_time_type"] = physiotherapistTimeType
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        date = aDecoder.decodeObject(forKey: "date") as? String
        nutritionist = aDecoder.decodeObject(forKey: "nutritionist") as? NutritionistModel
        nutritionistAvailabilityDate = aDecoder.decodeObject(forKey: "nutritionist_availability_date") as? String
        nutritionistDay = aDecoder.decodeObject(forKey: "nutritionist_day") as? String
        nutritionistEndTime = aDecoder.decodeObject(forKey: "nutritionist_end_time") as? String
        nutritionistStartTime = aDecoder.decodeObject(forKey: "nutritionist_start_time") as? String
        nutritionistTimeType = aDecoder.decodeObject(forKey: "nutritionist_time_type") as? String
        physiotherapist = aDecoder.decodeObject(forKey: "physiotherapist") as? NutritionistModel
        physiotherapistAvailabilityDate = aDecoder.decodeObject(forKey: "physiotherapist_availability_date") as? String
        physiotherapistDay = aDecoder.decodeObject(forKey: "physiotherapist_day") as? String
        physiotherapistEndTime = aDecoder.decodeObject(forKey: "physiotherapist_end_time") as? String
        physiotherapistStartTime = aDecoder.decodeObject(forKey: "physiotherapist_start_time") as? String
        physiotherapistTimeType = aDecoder.decodeObject(forKey: "physiotherapist_time_type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if nutritionist != nil{
            aCoder.encode(nutritionist, forKey: "nutritionist")
        }
        if nutritionistAvailabilityDate != nil{
            aCoder.encode(nutritionistAvailabilityDate, forKey: "nutritionist_availability_date")
        }
        if nutritionistDay != nil{
            aCoder.encode(nutritionistDay, forKey: "nutritionist_day")
        }
        if nutritionistEndTime != nil{
            aCoder.encode(nutritionistEndTime, forKey: "nutritionist_end_time")
        }
        if nutritionistStartTime != nil{
            aCoder.encode(nutritionistStartTime, forKey: "nutritionist_start_time")
        }
        if nutritionistTimeType != nil{
            aCoder.encode(nutritionistTimeType, forKey: "nutritionist_time_type")
        }
        if physiotherapist != nil{
            aCoder.encode(physiotherapist, forKey: "physiotherapist")
        }
        if physiotherapistAvailabilityDate != nil{
            aCoder.encode(physiotherapistAvailabilityDate, forKey: "physiotherapist_availability_date")
        }
        if physiotherapistDay != nil{
            aCoder.encode(physiotherapistDay, forKey: "physiotherapist_day")
        }
        if physiotherapistEndTime != nil{
            aCoder.encode(physiotherapistEndTime, forKey: "physiotherapist_end_time")
        }
        if physiotherapistStartTime != nil{
            aCoder.encode(physiotherapistStartTime, forKey: "physiotherapist_start_time")
        }
        if physiotherapistTimeType != nil{
            aCoder.encode(physiotherapistTimeType, forKey: "physiotherapist_time_type")
        }
        
    }
    
}
