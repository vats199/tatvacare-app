//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class IncidentFreeModel{

    var days : String!
    var lastIncidentDate : String!


    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        days = json["days"].stringValue
        lastIncidentDate = json["last_incident_date"].stringValue
    }

}
