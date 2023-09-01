//
//  ExerciseFilterModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 28/10/21.
//

import UIKit

enum ExerciseFilterType: String {
    case exercise_tool
    case genre
    case fitness_level
    case time
}

class ExerciseFilterModel {

    var arrExercise_tools : [exercise_tools]!
    var filterGenreList : [FilterGenreListModel]!
    var arrFitnessLevel : [FitnessLevelModel]!
    var arrTime: [TimeFilterModel]!
    var label : String!
    var type : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        arrExercise_tools = [exercise_tools]()
        let arr1Array = json["data"].arrayValue
        for arr1Json in arr1Array{
            let value = exercise_tools(fromJson: arr1Json)
            arrExercise_tools.append(value)
        }
        filterGenreList = [FilterGenreListModel]()
        let arr2Array = json["data"].arrayValue
        for arr2Json in arr2Array{
            let value = FilterGenreListModel(fromJson: arr2Json)
            filterGenreList.append(value)
        }
        arrFitnessLevel = [FitnessLevelModel]()
        let arr3Array = json["data"].arrayValue
        for arr3Json in arr3Array{
            let value = FitnessLevelModel(fromJson: arr3Json)
            arrFitnessLevel.append(value)
        }
        
        arrTime = [TimeFilterModel]()
        let arr4Array = json["data"].arrayValue
        for arr4Json in arr4Array{
            let value = TimeFilterModel(fromJson: arr4Json)
            arrTime.append(value)
        }
        
        label = json["label"].stringValue
        type = json["type"].stringValue
    }
}

class FitnessLevelModel{

    var fitnessLevel : String!

    var isSelected = false

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        fitnessLevel = json["fitness_level"].stringValue
    }

}

class exercise_tools{

    var exerciseTools : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        exerciseTools = json["exercise_tools"].stringValue
    }
}

class TimeFilterModel{

    var createdAt : String!
    var fromTime : Int!
    var showTime : String!
    var toTime : Int!
    var updatedAt : String!

    var isSelected = false

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        fromTime = json["from_time"].intValue
        showTime = json["show_time"].stringValue
        toTime = json["to_time"].intValue
        updatedAt = json["updated_at"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension ExerciseFilterModel {
    class func modelsFromDictionaryArray(array:[JSON]) -> [ExerciseFilterModel] {
        var models:[ExerciseFilterModel] = []
        for item in array
        {
            models.append(ExerciseFilterModel(fromJson: item))
        }
        return models
    }
}

