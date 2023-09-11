//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NotificationListModel: NSObject {
    
    var v : Int!
    var id : String!
    var createdAt : String!
    var deepLink : String!
    var imageUrl : String!
    var mesage : String!
    var patientId : String!
    var title : String!
    var updatedAt : String!
    var weNotificationId : String!
    var isRead : Int!
    var data : PushData!
      
    var isSelected = false
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        v = json["__v"].intValue
        id = json["_id"].stringValue
        createdAt = json["createdAt"].stringValue
        deepLink = json["deep_link"].stringValue
        imageUrl = json["image_url"].stringValue
        mesage = json["mesage"].stringValue
        patientId = json["patient_id"].stringValue
        title = json["title"].stringValue
        updatedAt = json["updatedAt"].stringValue
        weNotificationId = json["we_notification_id"].stringValue
        isRead = json["is_read"].intValue
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = PushData(fromJson: dataJson)
        }
    }
}

//MARK: ---------------- Array Model ----------------------
extension NotificationListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [NotificationListModel] {
        var models:[NotificationListModel] = []
        for item in array
        {
            models.append(NotificationListModel(fromJson: item))
        }
        return models
    }
}

class PushData{

    //var alert : Alert!
    var custom : PushCustom!
    var priority : String!
    var silent : Bool!
    var topic : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let alertJson = json["alert"]
//        if !alertJson.isEmpty{
//            alert = Alert(fromJson: alertJson)
//        }
        let customJson = json["custom"]
        if !customJson.isEmpty{
            custom = PushCustom(fromJson: customJson)
        }
        priority = json["priority"].stringValue
        silent = json["silent"].boolValue
        topic = json["topic"].stringValue
    }

}

class PushCustom{

    var body : String!
    var flag : String!
    var message : PushMessage!
    var title : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        body = json["body"].stringValue
        flag = json["flag"].stringValue
        let messageJson = json["message"]
        if !messageJson.isEmpty{
            message = PushMessage(fromJson: messageJson)
        }
        title = json["title"].stringValue
    }

}

class PushMessage{

    var flag : String!
    var message : String!
    var otherDetails : PushOtherDetail!
    var title : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        flag = json["flag"].stringValue
        message = json["message"].stringValue
        let otherDetailsJson = json["other_details"]
        if !otherDetailsJson.isEmpty{
            otherDetails = PushOtherDetail(fromJson: otherDetailsJson)
        }
        title = json["title"].stringValue
    }

}

class PushOtherDetail{

    var goalMasterId : String!
    var key : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        goalMasterId = json["goal_master_id"].stringValue
        key = json["key"].stringValue
    }

}
