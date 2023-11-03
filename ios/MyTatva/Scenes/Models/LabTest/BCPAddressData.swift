//
//  BCPAddressData.swift
//  MyTatva
//
//  Created by Hlink on 23/06/23.
//

import Foundation

/*class BcpAddressData{

    var address : String!
    var addressType : String!
    var contactNo : String!
    var createdAt : String!
    var isActive : String!
    var isDeleted : String!
    var name : String!
    var patientAddressRelId : String!
    var patientId : String!
    var pincode : Int!
    var street : String!
    var updatedAt : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        addressType = json["address_type"].stringValue
        contactNo = json["contact_no"].stringValue
        createdAt = json["created_at"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        name = json["name"].stringValue
        patientAddressRelId = json["patient_address_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        pincode = json["pincode"].intValue
        street = json["street"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if addressType != nil{
            dictionary["address_type"] = addressType
        }
        if contactNo != nil{
            dictionary["contact_no"] = contactNo
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if name != nil{
            dictionary["name"] = name
        }
        if patientAddressRelId != nil{
            dictionary["patient_address_rel_id"] = patientAddressRelId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if pincode != nil{
            dictionary["pincode"] = pincode
        }
        if street != nil{
            dictionary["street"] = street
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }

}
*/