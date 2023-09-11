//
//  PlanDataDetailModel.swift
//  MyTatva
//
//  Created by Hlink on 13/06/23.
//

import Foundation
class PlanDataDetailModel {
    
    var parentTitle : String!
    var title : String!
    var type : String!
    var arrData: [String]!
    var height: CGFloat = 0.0
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        parentTitle = json["parent_title"].stringValue
        title = json["title"].stringValue
        type = json["type"].stringValue
        arrData = json["data"].arrayValue.map({ $0.stringValue })
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if parentTitle != nil{
            dictionary["parent_title"] = parentTitle
        }
        if title != nil{
            dictionary["title"] = title
        }
        if type != nil{
            dictionary["type"] = type
        }
        if arrData != nil {
            dictionary["data"] = arrData
        }
        return dictionary
    }
}
