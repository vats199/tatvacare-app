//
//  CarePlanDetailsModel.swift
//  MyTatva
//
//  Created by Hlink on 13/06/23.
//

import Foundation
class CarePlanDetailsModel {
    
    var arrData : [PlanDataDetailModel]!
    var durationDetails : [DurationDetailModel]!
    var planDetails : CPDetailsModel!
    
    init() { }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        arrData = [PlanDataDetailModel]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = PlanDataDetailModel(fromJson: dataJson)
            arrData.append(value)
        }
        durationDetails = [DurationDetailModel]()
        let durationDetailsArray = json["duration_details"].arrayValue
        for durationDetailsJson in durationDetailsArray{
            let value = DurationDetailModel(fromJson: durationDetailsJson)
            durationDetails.append(value)
            durationDetails[0].isSelected = true
        }
        let planDetailsJson = json["plan_details"]
        if !planDetailsJson.isEmpty{
            planDetails = CPDetailsModel(fromJson: planDetailsJson)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if arrData != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in arrData {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        if durationDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for durationDetailsElement in durationDetails {
                dictionaryElements.append(durationDetailsElement.toDictionary())
            }
            dictionary["duration_details"] = dictionaryElements
        }
        if planDetails != nil{
            dictionary["plan_details"] = planDetails.toDictionary()
        }
        return dictionary
    }
    
}
