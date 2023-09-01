//
//  VitalRange.swift
//  MyTatva
//
//  Created by Hlink on 17/05/23.
//

import Foundation
import SwiftyJSON


class VitalRange {

    var from : Float!
    var label : String!
    var to : Float!
    var color: UIColor!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        from = json["from"].floatValue
        label = json["label"].stringValue
        to = json["to"].floatValue
        color = (BCAVitalRange(rawValue: label) ?? .Low).bgColor
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if from != nil{
            dictionary["from"] = from
        }
        if label != nil{
            dictionary["label"] = label
        }
        if to != nil{
            dictionary["to"] = to
        }
        return dictionary
    }

}
