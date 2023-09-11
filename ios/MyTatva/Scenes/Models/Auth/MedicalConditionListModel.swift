

import Foundation

class MedicalConditionListModel {
    
    var createdAt : String!
    var isActive : String!
    var isDeleted : String!
    var medicalConditionGroupId : String!
    var medicalConditionName : String!
    var updatedAt : String!
    var updatedBy : String!
    var selectedImage : String!
    var unselectedImage : String!
    
    var isSelected = false
    var isOther : String!
    

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        medicalConditionName = json["medical_condition_name"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        selectedImage = json["selected_imagess"].stringValue
        unselectedImage = json["unselected_imagess"].stringValue
        isOther = json["is_other"].stringValue
        
    }
}

//MARK: ---------------- Array Model ----------------------
extension MedicalConditionListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MedicalConditionListModel] {
        var models:[MedicalConditionListModel] = []
        for item in array
        {
            models.append(MedicalConditionListModel(fromJson: item))
        }
        return models
    }
}

