

import Foundation

class LabPatientListModel {
    
    var age : Int!
    var createdAt : String!
    var email : String!
    var gender : String!
    var isActive : String!
    var isDeleted : String!
    var name : String!
    var patientId : String!
    var patientMemberRelId : String!
    var relation : String!
    var updatedAt : String!
    

    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        age = json["age"].intValue
        createdAt = json["created_at"].stringValue
        email = json["email"].stringValue
        gender = json["gender"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        name = json["name"].stringValue
        patientId = json["patient_id"].stringValue
        patientMemberRelId = json["patient_member_rel_id"].stringValue
        relation = json["relation"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

    
}

//MARK: ---------------- Array Model ----------------------
extension LabPatientListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [LabPatientListModel] {
        var models:[LabPatientListModel] = []
        for item in array
        {
            models.append(LabPatientListModel(fromJson: item))
        }
        return models
    }
}

