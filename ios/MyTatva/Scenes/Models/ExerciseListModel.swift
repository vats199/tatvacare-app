

import Foundation

class ExerciseListModel {
    
    var createdAt : String!
    var exerciseMasterId : String!
    var exerciseName : String!
    var isActive : String!
    var isDeleted : String!
    var updatedAt : String!
    var updatedBy : String!
    var exerciseValue: String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        exerciseMasterId = json["exercise_master_id"].stringValue
        exerciseName = json["exercise_name"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        exerciseValue = json["exercise_value"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension ExerciseListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ExerciseListModel] {
        var models:[ExerciseListModel] = []
        for item in array
        {
            models.append(ExerciseListModel(fromJson: item))
        }
        return models
    }
}

