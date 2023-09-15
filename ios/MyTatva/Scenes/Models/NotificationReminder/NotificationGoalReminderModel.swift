//
//  NotificationGoalReminderModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 31/01/22.
//

import Foundation

class NotificationGoalReminderModel {

    var days : [DaysListModel]!
    var details : [DetailModel]!
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
        details = [DetailModel]()
        let detailsArray = json["details"].arrayValue
        for detailsJson in detailsArray{
            let value = DetailModel(fromJson: detailsJson)
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

class Frequency{

    var frequencyName : String!
    var key : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        frequencyName = json["frequency_name"].stringValue
        key = json["key"].stringValue
    }

}

class EverydayRemind{

    var detailPage : String!
    var isActive : String!
    var keys : String!
    var remindEveryday : String!
    var remindEverydayTime : String!
    var title : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        detailPage = json["detail_page"].stringValue
        isActive = json["is_active"].stringValue
        keys = json["keys"].stringValue
        remindEveryday = json["remind_everyday"].stringValue
        remindEverydayTime = json["remind_everyday_time"].stringValue
        title = json["title"].stringValue
    }

}

class DetailModel{

    var title : String!
    var value : String!
    var valueType : String!

    var isActive = "N"
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        title = json["title"].stringValue
        value = json["value"].stringValue
        valueType = json["value_type"].stringValue
    }

}
