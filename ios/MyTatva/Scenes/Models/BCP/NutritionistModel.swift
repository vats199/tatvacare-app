//
//  NutritionistModel.swift
//  MyTatva
//
//  Created by 2022M43 on 20/06/23.
//

import Foundation
import SwiftyJSON


class NutritionistModel : NSObject, NSCoding{

    var aboutMe : String!
    var addedBy : String!
    var chatInitiate : String!
    var city : String!
    var contactNo : String!
    var createdAt : String!
    var dateOfCompletion : String!
    var degree : String!
    var email : String!
    var firstName : String!
    var freshchatAgentId : String!
    var healthCoachGuid : String!
    var healthCoachId : String!
    var institute : String!
    var isActive : String!
    var isDeleted : String!
    var isNotify : String!
    var languageSpoken : String!
    var lastName : String!
    var lockTill : String!
    var password : String!
    var patientHealthCoachRelId : String!
    var patientId : String!
    var profilePic : String!
    var qualification : String!
    var role : String!
    var startDate : String!
    var state : String!
    var token : String!
    var updatedAt : String!
    var updatedBy : String!
    var yearsOfExperience : Int!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        aboutMe = json["about_me"].stringValue
        addedBy = json["added_by"].stringValue
        chatInitiate = json["chat_initiate"].stringValue
        city = json["city"].stringValue
        contactNo = json["contact_no"].stringValue
        createdAt = json["created_at"].stringValue
        dateOfCompletion = json["date_of_completion"].stringValue
        degree = json["degree"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        freshchatAgentId = json["freshchat_agent_id"].stringValue
        healthCoachGuid = json["health_coach_guid"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        institute = json["institute"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        isNotify = json["is_notify"].stringValue
        languageSpoken = json["language_spoken"].stringValue
        lastName = json["last_name"].stringValue
        lockTill = json["lock_till"].stringValue
        password = json["password"].stringValue
        patientHealthCoachRelId = json["patient_health_coach_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        profilePic = json["profile_pic"].stringValue
        qualification = json["qualification"].stringValue
        role = json["role"].stringValue
        startDate = json["start_date"].stringValue
        state = json["state"].stringValue
        token = json["token"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        yearsOfExperience = json["years_of_experience"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aboutMe != nil{
            dictionary["about_me"] = aboutMe
        }
        if addedBy != nil{
            dictionary["added_by"] = addedBy
        }
        if chatInitiate != nil{
            dictionary["chat_initiate"] = chatInitiate
        }
        if city != nil{
            dictionary["city"] = city
        }
        if contactNo != nil{
            dictionary["contact_no"] = contactNo
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if dateOfCompletion != nil{
            dictionary["date_of_completion"] = dateOfCompletion
        }
        if degree != nil{
            dictionary["degree"] = degree
        }
        if email != nil{
            dictionary["email"] = email
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if freshchatAgentId != nil{
            dictionary["freshchat_agent_id"] = freshchatAgentId
        }
        if healthCoachGuid != nil{
            dictionary["health_coach_guid"] = healthCoachGuid
        }
        if healthCoachId != nil{
            dictionary["health_coach_id"] = healthCoachId
        }
        if institute != nil{
            dictionary["institute"] = institute
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if isNotify != nil{
            dictionary["is_notify"] = isNotify
        }
        if languageSpoken != nil{
            dictionary["language_spoken"] = languageSpoken
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if lockTill != nil{
            dictionary["lock_till"] = lockTill
        }
        if password != nil{
            dictionary["password"] = password
        }
        if patientHealthCoachRelId != nil{
            dictionary["patient_health_coach_rel_id"] = patientHealthCoachRelId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if qualification != nil{
            dictionary["qualification"] = qualification
        }
        if role != nil{
            dictionary["role"] = role
        }
        if startDate != nil{
            dictionary["start_date"] = startDate
        }
        if state != nil{
            dictionary["state"] = state
        }
        if token != nil{
            dictionary["token"] = token
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if updatedBy != nil{
            dictionary["updated_by"] = updatedBy
        }
        if yearsOfExperience != nil{
            dictionary["years_of_experience"] = yearsOfExperience
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         aboutMe = aDecoder.decodeObject(forKey: "about_me") as? String
         addedBy = aDecoder.decodeObject(forKey: "added_by") as? String
         chatInitiate = aDecoder.decodeObject(forKey: "chat_initiate") as? String
         city = aDecoder.decodeObject(forKey: "city") as? String
         contactNo = aDecoder.decodeObject(forKey: "contact_no") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         dateOfCompletion = aDecoder.decodeObject(forKey: "date_of_completion") as? String
         degree = aDecoder.decodeObject(forKey: "degree") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         freshchatAgentId = aDecoder.decodeObject(forKey: "freshchat_agent_id") as? String
         healthCoachGuid = aDecoder.decodeObject(forKey: "health_coach_guid") as? String
         healthCoachId = aDecoder.decodeObject(forKey: "health_coach_id") as? String
         institute = aDecoder.decodeObject(forKey: "institute") as? String
         isActive = aDecoder.decodeObject(forKey: "is_active") as? String
         isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
         isNotify = aDecoder.decodeObject(forKey: "is_notify") as? String
         languageSpoken = aDecoder.decodeObject(forKey: "language_spoken") as? String
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         lockTill = aDecoder.decodeObject(forKey: "lock_till") as? String
         password = aDecoder.decodeObject(forKey: "password") as? String
         patientHealthCoachRelId = aDecoder.decodeObject(forKey: "patient_health_coach_rel_id") as? String
         patientId = aDecoder.decodeObject(forKey: "patient_id") as? String
         profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
         qualification = aDecoder.decodeObject(forKey: "qualification") as? String
         role = aDecoder.decodeObject(forKey: "role") as? String
         startDate = aDecoder.decodeObject(forKey: "start_date") as? String
         state = aDecoder.decodeObject(forKey: "state") as? String
         token = aDecoder.decodeObject(forKey: "token") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
         yearsOfExperience = aDecoder.decodeObject(forKey: "years_of_experience") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if aboutMe != nil{
            aCoder.encode(aboutMe, forKey: "about_me")
        }
        if addedBy != nil{
            aCoder.encode(addedBy, forKey: "added_by")
        }
        if chatInitiate != nil{
            aCoder.encode(chatInitiate, forKey: "chat_initiate")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if contactNo != nil{
            aCoder.encode(contactNo, forKey: "contact_no")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if dateOfCompletion != nil{
            aCoder.encode(dateOfCompletion, forKey: "date_of_completion")
        }
        if degree != nil{
            aCoder.encode(degree, forKey: "degree")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if freshchatAgentId != nil{
            aCoder.encode(freshchatAgentId, forKey: "freshchat_agent_id")
        }
        if healthCoachGuid != nil{
            aCoder.encode(healthCoachGuid, forKey: "health_coach_guid")
        }
        if healthCoachId != nil{
            aCoder.encode(healthCoachId, forKey: "health_coach_id")
        }
        if institute != nil{
            aCoder.encode(institute, forKey: "institute")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if isNotify != nil{
            aCoder.encode(isNotify, forKey: "is_notify")
        }
        if languageSpoken != nil{
            aCoder.encode(languageSpoken, forKey: "language_spoken")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if lockTill != nil{
            aCoder.encode(lockTill, forKey: "lock_till")
        }
        if password != nil{
            aCoder.encode(password, forKey: "password")
        }
        if patientHealthCoachRelId != nil{
            aCoder.encode(patientHealthCoachRelId, forKey: "patient_health_coach_rel_id")
        }
        if patientId != nil{
            aCoder.encode(patientId, forKey: "patient_id")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if qualification != nil{
            aCoder.encode(qualification, forKey: "qualification")
        }
        if role != nil{
            aCoder.encode(role, forKey: "role")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
        if yearsOfExperience != nil{
            aCoder.encode(yearsOfExperience, forKey: "years_of_experience")
        }

    }

}
