//
//  BCASync.swift
//  MyTatva
//
//  Created by Hlink on 17/05/23.
//

import Foundation
import SwiftyJSON

class BCASync {

    var bcaSyncLogsId : String!
    var createdAt : String!
    var deviceId : String!
    var patientId : String!
    var ranges : String!
    var updatedAt : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bcaSyncLogsId = json["bca_sync_logs_id"].stringValue
        createdAt = json["created_at"].stringValue
        deviceId = json["device_id"].stringValue
        patientId = json["patient_id"].stringValue
        ranges = json["ranges"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bcaSyncLogsId != nil{
            dictionary["bca_sync_logs_id"] = bcaSyncLogsId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deviceId != nil{
            dictionary["device_id"] = deviceId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if ranges != nil{
            dictionary["ranges"] = ranges
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }

}
