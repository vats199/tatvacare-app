//
//    Data.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class VerifyUserModel {
    
    var accessCode : String!
    var accountRole : String!
    var contactNo : String!
    var createdAt : String!
    var dob : String!
    var email : String!
    var gender : String!
    var indicationName : String!
    var isActive : String!
    var isDeleted : String!
    var medicalConditionGroupId : String!
    var name : String!
    var patientGuid : String!
    var severityId : String!
    var severityName : String!
    var tempPatientId : String!
    var updatedAt : String!
    
    var doctorAccessCode : String!
    var imageUrl : String!
    var patientId : String!
    var relation : String!
    var step : Int!
    var subRelation : String!
    var tempPatientSignupId : String!
    var token : String!
    

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accessCode = json["access_code"].stringValue
        accountRole = json["account_role"].stringValue
        contactNo = json["contact_no"].stringValue
        createdAt = json["created_at"].stringValue
        dob = json["dob"].stringValue
        email = json["email"].stringValue
        gender = json["gender"].stringValue
        indicationName = json["indication_name"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        name = json["name"].stringValue
        patientGuid = json["patient_guid"].stringValue
        severityId = json["severity_id"].stringValue
        severityName = json["severity_name"].stringValue
        tempPatientId = json["temp_patient_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        imageUrl = json["image_url"].stringValue
        patientId = json["patient_id"].stringValue
        step = json["step"].intValue
        tempPatientSignupId = json["temp_patient_signup_id"].stringValue
        token = json["token"].stringValue
        doctorAccessCode = json["doctor_access_code"].stringValue
        relation = json["relation"].stringValue
        subRelation = json["sub_relation"].stringValue
        
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accessCode != nil{
            dictionary["access_code"] = accessCode
        }
        if accountRole != nil{
            dictionary["account_role"] = accountRole
        }
        if contactNo != nil{
            dictionary["contact_no"] = contactNo
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if dob != nil{
            dictionary["dob"] = dob
        }
        if doctorAccessCode != nil{
            dictionary["doctor_access_code"] = doctorAccessCode
        }
        if email != nil{
            dictionary["email"] = email
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if indicationName != nil{
            dictionary["indication_name"] = indicationName
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if medicalConditionGroupId != nil{
            dictionary["medical_condition_group_id"] = medicalConditionGroupId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if patientGuid != nil{
            dictionary["patient_guid"] = patientGuid
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if relation != nil{
            dictionary["relation"] = relation
        }
        if severityId != nil{
            dictionary["severity_id"] = severityId
        }
        if severityName != nil{
            dictionary["severity_name"] = severityName
        }
        if step != nil{
            dictionary["step"] = step
        }
        if subRelation != nil{
            dictionary["sub_relation"] = subRelation
        }
        if tempPatientId != nil{
            dictionary["temp_patient_id"] = tempPatientId
        }
        if tempPatientSignupId != nil{
            dictionary["temp_patient_signup_id"] = tempPatientSignupId
        }
        if token != nil{
            dictionary["token"] = token
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
}


extension VerifyUserModel {
    
    static var VerifyUser : VerifyUserModel! {
        set{
            guard let unwarrapedKey = newValue else {
                return
            }
            UserDefaults.standard.set(unwarrapedKey.toDictionary(), forKey: "VerifyUser")
            UserDefaults.standard.synchronize()
            
        } get {
            guard let userDict =  UserDefaults.standard.object(forKey: "VerifyUserModel") else {
                return nil
            }
            return VerifyUserModel(fromJson: JSON(userDict))
        }
    }
    
    class func removeVerifyUser(){
        if UserDefaults.standard.value(forKey: "VerifyUserModel") != nil {
            UserDefaults.standard.removeObject(forKey: "VerifyUserModel")
            UserDefaults.standard.synchronize()
        }
    }
}

