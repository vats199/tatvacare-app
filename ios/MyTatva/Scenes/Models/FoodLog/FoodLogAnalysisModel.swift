//
//	FoodLogAnalysisModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class FoodLogAnalysisModel{

    var achievedValue : Int!
    var goalMasterId : String!
    var macronutritionAnalysis : [MacronutritionAnalysi]!
    var targetValue : Int!
    var todaysAchievedValue : Int!
    var totalCaloriesConsume : Int!
    var totalCaloriesRequired : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        achievedValue = json["achieved_value"].intValue
        goalMasterId = json["goal_master_id"].stringValue
        macronutritionAnalysis = [MacronutritionAnalysi]()
        let macronutritionAnalysisArray = json["macronutrition_analysis"].arrayValue
        for macronutritionAnalysisJson in macronutritionAnalysisArray{
            let value = MacronutritionAnalysi(fromJson: macronutritionAnalysisJson)
            macronutritionAnalysis.append(value)
        }
        targetValue = json["target_value"].intValue
        todaysAchievedValue = json["todays_achieved_value"].intValue
        totalCaloriesConsume = json["total_calories_consume"].intValue
        totalCaloriesRequired = json["total_calories_required"].intValue
    }

}
