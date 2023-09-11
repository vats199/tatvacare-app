//
//  BCAVitalRangeModel.swift
//  MyTatva
//
//  Created by Hlink on 17/05/23.
//

import Foundation
import SwiftyJSON


class BCAVitalRangeModel {

    var bmi : [VitalRange]!
    var boneMass : [VitalRange]!
    var fat : [VitalRange]!
    var hydration : [VitalRange]!
    var metabolicAge : [VitalRange]!
    var muscleMass : [VitalRange]!
    var protein : [VitalRange]!
    var skeletalMuscle : [VitalRange]!
    var subcutaneousFat : [VitalRange]!
    var visceralFat : [VitalRange]!
    var weight : [VitalRange]!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bmi = [VitalRange]()
        let bmiArray = json["bmi"].arrayValue
        for bmiJson in bmiArray{
            let value = VitalRange(fromJson: bmiJson)
            bmi.append(value)
        }
        boneMass = [VitalRange]()
        let boneMassArray = json["bone_mass"].arrayValue
        for boneMassJson in boneMassArray{
            let value = VitalRange(fromJson: boneMassJson)
            boneMass.append(value)
        }
        fat = [VitalRange]()
        let fatArray = json["fat"].arrayValue
        for fatJson in fatArray{
            let value = VitalRange(fromJson: fatJson)
            fat.append(value)
        }
        hydration = [VitalRange]()
        let hydrationArray = json["hydration"].arrayValue
        for hydrationJson in hydrationArray{
            let value = VitalRange(fromJson: hydrationJson)
            hydration.append(value)
        }
        metabolicAge = [VitalRange]()
        let metabolicAgeArray = json["metabolic_age"].arrayValue
        for metabolicAgeJson in metabolicAgeArray{
            let value = VitalRange(fromJson: metabolicAgeJson)
            metabolicAge.append(value)
        }
        muscleMass = [VitalRange]()
        let muscleMassArray = json["muscle_mass"].arrayValue
        for muscleMassJson in muscleMassArray{
            let value = VitalRange(fromJson: muscleMassJson)
            muscleMass.append(value)
        }
        protein = [VitalRange]()
        let proteinArray = json["protein"].arrayValue
        for proteinJson in proteinArray{
            let value = VitalRange(fromJson: proteinJson)
            protein.append(value)
        }
        skeletalMuscle = [VitalRange]()
        let skeletalMuscleArray = json["skeletal_muscle"].arrayValue
        for skeletalMuscleJson in skeletalMuscleArray{
            let value = VitalRange(fromJson: skeletalMuscleJson)
            skeletalMuscle.append(value)
        }
        subcutaneousFat = [VitalRange]()
        let subcutaneousFatArray = json["subcutaneous_fat"].arrayValue
        for subcutaneousFatJson in subcutaneousFatArray{
            let value = VitalRange(fromJson: subcutaneousFatJson)
            subcutaneousFat.append(value)
        }
        visceralFat = [VitalRange]()
        let visceralFatArray = json["visceral_fat"].arrayValue
        for visceralFatJson in visceralFatArray{
            let value = VitalRange(fromJson: visceralFatJson)
            visceralFat.append(value)
        }
        weight = [VitalRange]()
        let weightArray = json["weight"].arrayValue
        for weightJson in weightArray{
            let value = VitalRange(fromJson: weightJson)
            weight.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bmi != nil{
            var dictionaryElements = [[String:Any]]()
            for bmiElement in bmi {
                dictionaryElements.append(bmiElement.toDictionary())
            }
            dictionary["bmi"] = dictionaryElements
        }
        if boneMass != nil{
            var dictionaryElements = [[String:Any]]()
            for boneMassElement in boneMass {
                dictionaryElements.append(boneMassElement.toDictionary())
            }
            dictionary["bone_mass"] = dictionaryElements
        }
        if fat != nil{
            var dictionaryElements = [[String:Any]]()
            for fatElement in fat {
                dictionaryElements.append(fatElement.toDictionary())
            }
            dictionary["fat"] = dictionaryElements
        }
        if hydration != nil{
            var dictionaryElements = [[String:Any]]()
            for hydrationElement in hydration {
                dictionaryElements.append(hydrationElement.toDictionary())
            }
            dictionary["hydration"] = dictionaryElements
        }
        if metabolicAge != nil{
            var dictionaryElements = [[String:Any]]()
            for metabolicAgeElement in metabolicAge {
                dictionaryElements.append(metabolicAgeElement.toDictionary())
            }
            dictionary["metabolic_age"] = dictionaryElements
        }
        if muscleMass != nil{
            var dictionaryElements = [[String:Any]]()
            for muscleMassElement in muscleMass {
                dictionaryElements.append(muscleMassElement.toDictionary())
            }
            dictionary["muscle_mass"] = dictionaryElements
        }
        if protein != nil{
            var dictionaryElements = [[String:Any]]()
            for proteinElement in protein {
                dictionaryElements.append(proteinElement.toDictionary())
            }
            dictionary["protein"] = dictionaryElements
        }
        if skeletalMuscle != nil{
            var dictionaryElements = [[String:Any]]()
            for skeletalMuscleElement in skeletalMuscle {
                dictionaryElements.append(skeletalMuscleElement.toDictionary())
            }
            dictionary["skeletal_muscle"] = dictionaryElements
        }
        if subcutaneousFat != nil{
            var dictionaryElements = [[String:Any]]()
            for subcutaneousFatElement in subcutaneousFat {
                dictionaryElements.append(subcutaneousFatElement.toDictionary())
            }
            dictionary["subcutaneous_fat"] = dictionaryElements
        }
        if visceralFat != nil{
            var dictionaryElements = [[String:Any]]()
            for visceralFatElement in visceralFat {
                dictionaryElements.append(visceralFatElement.toDictionary())
            }
            dictionary["visceral_fat"] = dictionaryElements
        }
        if weight != nil{
            var dictionaryElements = [[String:Any]]()
            for weightElement in weight {
                dictionaryElements.append(weightElement.toDictionary())
            }
            dictionary["weight"] = dictionaryElements
        }
        return dictionary
    }

}
