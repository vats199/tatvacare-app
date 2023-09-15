import Foundation

class DietDetailsModel{

    var calories : String!
    var carbs : String!
    var createdAt : String!
    var documentName : String!
    var documentTitle : String!
    var documentUrl : String!
    var fats : String!
    var firstName : String!
    var healthCoachId : String!
    var isActive : String!
    var isDeleted : String!
    var lastName : String!
    var patientHealthcoachDietPlanId : String!
    var patientId : String!
    var protein : String!
    var updatedAt : String!
    var updatedBy : String!
    var validTill : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        calories = json["calories"].stringValue
        carbs = json["carbs"].stringValue
        createdAt = json["created_at"].stringValue
        documentName = json["document_name"].stringValue
        documentTitle = json["document_title"].stringValue
        documentUrl = json["document_url"].stringValue
        fats = json["fats"].stringValue
        firstName = json["first_name"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        lastName = json["last_name"].stringValue
        patientHealthcoachDietPlanId = json["patient_healthcoach_diet_plan_id"].stringValue
        patientId = json["patient_id"].stringValue
        protein = json["protein"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        validTill = json["valid_till"].stringValue
    }

}
