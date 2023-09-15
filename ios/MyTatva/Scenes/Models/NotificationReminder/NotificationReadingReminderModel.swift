//
//  NotificationReadingReminderModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 01/02/22.
//

import Foundation

class NotificationReadingReminderModel {

    var days : [DaysListModel]!
    var details : [ReadingDetailModel]!
    var everydayRemind : EverydayRemind!
    var frequency : [Frequency]!
    var type : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        days = [DaysListModel]()
        let daysArray = json["days"].arrayValue
        for daysJson in daysArray{
            let value = DaysListModel(fromJson: daysJson)
            days.append(value)
        }
        details = [ReadingDetailModel]()
        let detailsArray = json["details"].arrayValue
        for detailsJson in detailsArray{
            let value = ReadingDetailModel(fromJson: detailsJson)
            details.append(value)
        }
        let everydayRemindJson = json["everyday_remind"]
        if !everydayRemindJson.isEmpty{
            everydayRemind = EverydayRemind(fromJson: everydayRemindJson)
        }
        frequency = [Frequency]()
        let frequencyArray = json["frequency"].arrayValue
        for frequencyJson in frequencyArray{
            let value = Frequency(fromJson: frequencyJson)
            frequency.append(value)
        }
        type = json["type"].stringValue
    }

}

class ReadingDetailModel{

    var dayTime : String!
    var daysOfWeek : String!
    var frequency : String!
    var isActive : String!
    var keys : String!
    var readingName : String!
    var readingsMasterId : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        dayTime = json["day_time"].stringValue
        daysOfWeek = json["days_of_week"].stringValue
        frequency = json["frequency"].stringValue
        isActive = json["is_active"].stringValue
        keys = json["keys"].stringValue
        readingName = json["reading_name"].stringValue
        readingsMasterId = json["readings_master_id"].stringValue
    }

}
