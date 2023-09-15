

import Foundation

class HealthCoachDetailsModel{
    
    var aboutMe : String!
    var city : String!
    var contactNo : String!
    var createdAt : String!
    var dateOfCompletion : String!
    var degree : String!
    var firstName : String!
    var healthCoachGuid : String!
    var healthCoachId : String!
    var institute : String!
    var isActive : String!
    var isDeleted : String!
    var languageSpoken : String!
    var lastName : String!
    var password : String!
    var profilePic : String!
    var qualification : String!
    var role : String!
    var skillName : String!
    var startDate : String!
    var state : String!
    var updatedAt : String!
    var updatedBy : String!
    var yearsOfExperience : Int!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        aboutMe = json["about_me"].stringValue
        city = json["city"].stringValue
        contactNo = json["contact_no"].stringValue
        createdAt = json["created_at"].stringValue
        dateOfCompletion = json["date_of_completion"].stringValue
        degree = json["degree"].stringValue
        firstName = json["first_name"].stringValue
        healthCoachGuid = json["health_coach_guid"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        institute = json["institute"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        languageSpoken = json["language_spoken"].stringValue
        lastName = json["last_name"].stringValue
        password = json["password"].stringValue
        profilePic = json["profile_pic"].stringValue
        qualification = json["qualification"].stringValue
        role = json["role"].stringValue
        skillName = json["skill_name"].stringValue
        startDate = json["start_date"].stringValue
        state = json["state"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        yearsOfExperience = json["years_of_experience"].intValue
    }
    
}
