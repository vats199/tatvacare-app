//
//  NotificationWaterReminderModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 01/02/22.
//

import Foundation

class NotificationWaterReminderModel {
    
    var basicDetails : BasicDetail!
    var details : [DetailModel]!
    var everydayRemind : EverydayRemind!
    var hoursData : [HoursData]!
    var timesData : [HoursData]!
    var type : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let basicDetailsJson = json["basic_details"]
        if !basicDetailsJson.isEmpty{
            basicDetails = BasicDetail(fromJson: basicDetailsJson)
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
        hoursData = [HoursData]()
        let hoursDataArray = json["hours_data"].arrayValue
        for hoursDataJson in hoursDataArray{
            let value = HoursData(fromJson: hoursDataJson)
            hoursData.append(value)
        }
        timesData = [HoursData]()
        let timesDataArray = json["times_data"].arrayValue
        for timesDataJson in timesDataArray{
            let value = HoursData(fromJson: timesDataJson)
            timesData.append(value)
        }
        type = json["type"].stringValue
    }
    
}

class HoursData{
    
    var title : String!
    var value : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        title = json["title"].stringValue
        value = json["value"].intValue
    }
    
}

class BasicDetail{
    
    var notifyFrom : String!
    var notifyTo : String!
    var remindType : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
            if json.isEmpty{
                return
            }
            notifyFrom = json["notify_from"].stringValue
            notifyTo = json["notify_to"].stringValue
            remindType = json["remind_type"].stringValue
        }
}
