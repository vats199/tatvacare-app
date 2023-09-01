//
//  CPDetailsModel.swift
//  MyTatva
//
//  Created by Hlink on 13/06/23.
//

import Foundation
class CPDetailsModel {
    var cardImage : String!
    var cardImageDetail : String!
    var colourScheme : String!
    var createdAt : String!
    var descriptionField : String!
    var deviceType : String!
    var gstPercentage : String!
    var isActive : String!
    var isDeleted : String!
    var orderId : String!
    var originalTransactionId : String!
    var patientId : String!
    var patientPlanRelId : String!
    var planCancelDatetime : String!
    var planMasterId : String!
    var planName : String!
    var planPurchaseDatetime : String!
    var planType : String!
    var receiptData : String!
    var renewalReminderDays : Int!
    var subTitle : String!
    var subscriptionId : String!
    var transactionId : String!
    var transactionType : String!
    var updatedAt : String!
    var updatedBy : String!
    var whatToExpect : String!
    var enableRentBuy : Bool!
    
    var devices : [DeviceDetailsModel]!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        cardImage = json["card_image"].stringValue
        cardImageDetail = json["card_image_detail"].stringValue
        colourScheme = json["colour_scheme"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        deviceType = json["device_type"].stringValue
        gstPercentage = json["gst_percentage"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        orderId = json["order_id"].stringValue
        originalTransactionId = json["original_transaction_id"].stringValue
        patientId = json["patient_id"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        planCancelDatetime = json["plan_cancel_datetime"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        planName = json["plan_name"].stringValue
        planPurchaseDatetime = json["plan_purchase_datetime"].stringValue
        planType = json["plan_type"].stringValue
        receiptData = json["receipt_data"].stringValue
        renewalReminderDays = json["renewal_reminder_days"].intValue
        subTitle = json["sub_title"].stringValue
        subscriptionId = json["subscription_id"].stringValue
        transactionId = json["transaction_id"].stringValue
        transactionType = json["transaction_type"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        whatToExpect = json["what_to_expect"].stringValue
        enableRentBuy = json["enable_rent_buy"].boolValue
        
        devices = [DeviceDetailsModel]()
        let devicesArray = json["device"].arrayValue
        for devicesJson in devicesArray{
            let value = DeviceDetailsModel(fromJson: devicesJson)
            devices.append(value)
        }
        devices = devices.filter({ $0.key != "spirometer" })
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cardImage != nil{
            dictionary["card_image"] = cardImage
        }
        if cardImageDetail != nil{
            dictionary["card_image_detail"] = cardImageDetail
        }
        if colourScheme != nil{
            dictionary["colour_scheme"] = colourScheme
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if gstPercentage != nil{
            dictionary["gst_percentage"] = gstPercentage
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if orderId != nil{
            dictionary["order_id"] = orderId
        }
        if originalTransactionId != nil{
            dictionary["original_transaction_id"] = originalTransactionId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if patientPlanRelId != nil{
            dictionary["patient_plan_rel_id"] = patientPlanRelId
        }
        if planCancelDatetime != nil{
            dictionary["plan_cancel_datetime"] = planCancelDatetime
        }
        if planMasterId != nil{
            dictionary["plan_master_id"] = planMasterId
        }
        if planName != nil{
            dictionary["plan_name"] = planName
        }
        if planPurchaseDatetime != nil{
            dictionary["plan_purchase_datetime"] = planPurchaseDatetime
        }
        if planType != nil{
            dictionary["plan_type"] = planType
        }
        if receiptData != nil{
            dictionary["receipt_data"] = receiptData
        }
        if renewalReminderDays != nil{
            dictionary["renewal_reminder_days"] = renewalReminderDays
        }
        if subTitle != nil{
            dictionary["sub_title"] = subTitle
        }
        if subscriptionId != nil{
            dictionary["subscription_id"] = subscriptionId
        }
        if transactionId != nil{
            dictionary["transaction_id"] = transactionId
        }
        if transactionType != nil{
            dictionary["transaction_type"] = transactionType
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if updatedBy != nil{
            dictionary["updated_by"] = updatedBy
        }
        if whatToExpect != nil{
            dictionary["what_to_expect"] = whatToExpect
        }
        if enableRentBuy != nil{
            dictionary["enable_rent_buy"] = enableRentBuy
        }
        return dictionary
    }
}
