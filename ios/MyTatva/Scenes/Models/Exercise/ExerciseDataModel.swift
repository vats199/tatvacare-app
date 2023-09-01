//
//  ExerciseDataModel.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import Foundation

class ExerciseDataModel {

    var exerciseDetails : [ExerciseDetailModel]!
    var routineNo : String!
    var isSelected = false
    var title: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        exerciseDetails = [ExerciseDetailModel]()
        let exerciseDetailsArray = json["exercise_details"].arrayValue
        for exerciseDetailsJson in exerciseDetailsArray{
            let value = ExerciseDetailModel(fromJson: exerciseDetailsJson)
            exerciseDetails.append(value)
        }
        routineNo = json["routine_no"].stringValue
        title = kRoutine + routineNo
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if exerciseDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for exerciseDetailsElement in exerciseDetails {
                dictionaryElements.append(exerciseDetailsElement.toDictionary())
            }
            dictionary["exercise_details"] = dictionaryElements
        }
        if routineNo != nil{
            dictionary["routine_no"] = routineNo
        }
        return dictionary
    }

}
