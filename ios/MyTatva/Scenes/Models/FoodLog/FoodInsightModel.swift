//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class FoodInsightModel{

    var macronutritionAnalysis : [MacronutritionAnalysi]!
    var mealEnergyDistribution : [MealEnergyDistribution]!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        macronutritionAnalysis = [MacronutritionAnalysi]()
        let macronutritionAnalysisArray = json["macronutrition_analysis"].arrayValue
        for macronutritionAnalysisJson in macronutritionAnalysisArray{
            let value = MacronutritionAnalysi(fromJson: macronutritionAnalysisJson)
            macronutritionAnalysis.append(value)
        }
        mealEnergyDistribution = [MealEnergyDistribution]()
        let mealEnergyDistributionArray = json["meal_energy_distribution"].arrayValue
        for mealEnergyDistributionJson in mealEnergyDistributionArray{
            let value = MealEnergyDistribution(fromJson: mealEnergyDistributionJson)
            mealEnergyDistribution.append(value)
        }
    }

}


class MealEnergyDistribution{

    var calUnitName : String!
    var caloriesTaken : Int!
    var colorCode : String!
    var limit : String!
    var mealType : String!
    var recommended : Int!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        calUnitName = json["cal_unit_name"].stringValue
        caloriesTaken = json["calories_taken"].intValue
        colorCode = json["color_code"].stringValue
        limit = json["limit"].stringValue
        mealType = json["meal_type"].stringValue
        recommended = json["recommended"].intValue
    }

}

class MacronutritionAnalysi{

    var colorCode : String!
    var key : String!
    var label : String!
    var limit : String!
    var recommended : Float!
    var taken : Float!
    var unitName : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        colorCode = json["color_code"].stringValue
        key = json["key"].stringValue
        label = json["label"].stringValue
        limit = json["limit"].stringValue
        recommended = json["recommended"].floatValue
        taken = json["taken"].floatValue
        unitName = json["unit_name"].stringValue
    }

}
