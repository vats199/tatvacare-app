//
//  VitalTrendsAnalyticsModel.swift
//  MyTatva
//
//  Created by Hlink on 17/05/23.
//

import Foundation
import SwiftyJSON


class VitalTrendsAnalyticsModel{

    var bcaStandardValues : [VitalRange]!
    var increasedBy : Float!
    var information : String!
    var lastReading : String!
    var trendGraph : ReadingChartDetailModel!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bcaStandardValues = [VitalRange]()
        let bcaStandardValuesArray = json["bca_standard_values"].arrayValue
        for bcaStandardValuesJson in bcaStandardValuesArray{
            let value = VitalRange(fromJson: bcaStandardValuesJson)
            bcaStandardValues.append(value)
        }
        increasedBy = json["increased_by"].floatValue
        information = json["information"].stringValue
        lastReading = json["last_reading"].stringValue
        let trendGraphJson = json["trend_graph"]
        if !trendGraphJson.isEmpty{
            trendGraph = ReadingChartDetailModel(fromJson: trendGraphJson)
        }
    }
    
}
