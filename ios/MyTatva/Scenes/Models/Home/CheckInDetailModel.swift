//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class CheckInDetailModel {

    var checkInId : Int!
    var createdAt : String!
    var datingMode : String!
    var gender : String!
    var id : Int!
    var pheromoneMode : String!
    var updatedAt : String!
    var userId : Int!

    init(){
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        checkInId = json["check_in_id"].intValue
        createdAt = json["created_at"].stringValue
        datingMode = json["dating_mode"].stringValue
        gender = json["gender"].stringValue
        id = json["id"].intValue
        pheromoneMode = json["pheromone_mode"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].intValue
    }

}
