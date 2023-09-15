//
//  NotificationReminderListModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 28/01/22.
//

import Foundation

class NotificationReminderListModel {
    
    var detailPage : String!
    var isActive : String!
    var keys : String!
    var notificationMasterId : String!
    var title : String!
    
    var isSelected = false
    
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
        notificationMasterId = json["notification_master_id"].stringValue
        title = json["title"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension NotificationReminderListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [NotificationReminderListModel] {
        var models:[NotificationReminderListModel] = []
        for item in array
        {
            models.append(NotificationReminderListModel(fromJson: item))
        }
        return models
    }
}
