//
//  BCAReadingModel.swift
//  MyTatva
//
//  Created by Hlink on 17/05/23.
//

import Foundation
import SwiftyJSON

class BCAReadingModel{

    var bMI : Float!
    var bMR : Int!
    var boneMass : Float!
    var deviceId : String!
    var fatMass : Float!
    var fatMassKg : Float!
    var hydration : Float!
    var hydrationKg : Float!
    var metabolicAge : Int!
    var muscleMass : Float!
    var muscleMassPercent : Float!
    var protein : Float!
    var proteinKg : Float!
    var ranges : BCAVitalRangeModel!
    var skeletalMuscleKg : Float!
    var skeletalMusclePercent : Float!
    var subcutaneousFat : String!
    var subcutaneousFatKg : Float!
    var subcutaneousFatPercent : Float!
    var visceralFat : Int!
    var weight : Float!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bMI = json["BMI"].floatValue
        bMR = json["BMR"].intValue
        boneMass = json["bone_mass"].floatValue
        deviceId = json["device_id"].stringValue
        fatMass = json["fat_mass"].floatValue
        fatMassKg = json["fat_mass_kg"].floatValue
        hydration = json["hydration"].floatValue
        hydrationKg = json["hydration_kg"].floatValue
        metabolicAge = json["metabolic_age"].intValue
        muscleMass = json["muscle_mass"].floatValue
        muscleMassPercent = json["muscle_mass_percent"].floatValue
        protein = json["protein"].floatValue
        proteinKg = json["protein_kg"].floatValue
        let rangesJson = json["ranges"]
        if !rangesJson.isEmpty{
            ranges = BCAVitalRangeModel(fromJson: rangesJson)
        }
        skeletalMuscleKg = json["skeletal_muscle_kg"].floatValue
        skeletalMusclePercent = json["skeletal_muscle_percent"].floatValue
        subcutaneousFat = json["subcutaneous_fat"].stringValue
        subcutaneousFatKg = json["subcutaneous_fat_kg"].floatValue
        subcutaneousFatPercent = json["subcutaneous_fat_percent"].floatValue
        visceralFat = json["visceral_fat"].intValue
        weight = json["weight"].floatValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bMI != nil{
            dictionary["BMI"] = bMI
        }
        if bMR != nil{
            dictionary["BMR"] = bMR
        }
        if boneMass != nil{
            dictionary["bone_mass"] = boneMass
        }
        if deviceId != nil{
            dictionary["device_id"] = deviceId
        }
        if fatMass != nil{
            dictionary["fat_mass"] = fatMass
        }
        if fatMassKg != nil{
            dictionary["fat_mass_kg"] = fatMassKg
        }
        if hydration != nil{
            dictionary["hydration"] = hydration
        }
        if hydrationKg != nil{
            dictionary["hydration_kg"] = hydrationKg
        }
        if metabolicAge != nil{
            dictionary["metabolic_age"] = metabolicAge
        }
        if muscleMass != nil{
            dictionary["muscle_mass"] = muscleMass
        }
        if muscleMassPercent != nil{
            dictionary["muscle_mass_percent"] = muscleMassPercent
        }
        if protein != nil{
            dictionary["protein"] = protein
        }
        if proteinKg != nil{
            dictionary["protein_kg"] = proteinKg
        }
        if ranges != nil{
            dictionary["ranges"] = ranges.toDictionary()
        }
        if skeletalMuscleKg != nil{
            dictionary["skeletal_muscle_kg"] = skeletalMuscleKg
        }
        if skeletalMusclePercent != nil{
            dictionary["skeletal_muscle_percent"] = skeletalMusclePercent
        }
        if subcutaneousFat != nil{
            dictionary["subcutaneous_fat"] = subcutaneousFat
        }
        if subcutaneousFatKg != nil{
            dictionary["subcutaneous_fat_kg"] = subcutaneousFatKg
        }
        if subcutaneousFatPercent != nil{
            dictionary["subcutaneous_fat_percent"] = subcutaneousFatPercent
        }
        if visceralFat != nil{
            dictionary["visceral_fat"] = visceralFat
        }
        if weight != nil{
            dictionary["weight"] = weight
        }
        return dictionary
    }

}
