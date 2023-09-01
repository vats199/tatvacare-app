//
//  HCServicesLongestPlan.swift
//  MyTatva
//
//  Created by Hlink on 11/07/23.
//

import Foundation
class HCServicesLongestPlan {
    
    var androidPackageId : String!
    var appFeaturesSessionCount : Int!
    var cardImage : String!
    var cardImageDetail : String!
    var colourScheme : String!
    var createdAt : String!
    var descriptionField : String!
    var deviceNames : String!
    var deviceType : String!
    var diagnosticTestSessionCount : Int!
    var diagnosticTestUsedCount : String!
    var diagnosticTests : String!
    var discountPercentage : String!
    var durationName : String!
    var durationTitle : String!
    var enableRentBuy : String!
    var expiryDate : String!
    var gstPercentage : String!
    var iosPackageId : String!
    var isActive : String!
    var isDeleted : String!
    var nutritionistSessionCount : Int!
    var offerPrice : Int!
    var offerTag : String!
    var orderId : String!
    var orderNo : Int!
    var originalTransactionId : String!
    var patientAddressRelId : String!
    var patientId : String!
    var patientPlanRelId : String!
    var physiotherapistSessionCount : Int!
    var planCancelDatetime : String!
    var planMasterId : String!
    var planName : String!
    var planPackageDurationRelId : String!
    var planPurchaseDatetime : String!
    var planType : String!
    var purchaseAmount : String!
    var purchasedAt : String!
    var receiptData : String!
    var renewalReminderDays : Int!
    var rentBuyType : String!
    var subTitle : String!
    var subscriptionId : String!
    var transactionId : String!
    var transactionType : String!
    var updatedAt : String!
    var updatedBy : String!
    var whatToExpect : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        androidPackageId = json["android_package_id"].stringValue
        appFeaturesSessionCount = json["app_features_session_count"].intValue
        cardImage = json["card_image"].stringValue
        cardImageDetail = json["card_image_detail"].stringValue
        colourScheme = json["colour_scheme"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        deviceNames = json["device_names"].stringValue
        deviceType = json["device_type"].stringValue
        diagnosticTestSessionCount = json["diagnostic_test_session_count"].intValue
        diagnosticTestUsedCount = json["diagnostic_test_used_count"].stringValue
        diagnosticTests = json["diagnostic_tests"].stringValue
        discountPercentage = json["discount_percentage"].stringValue
        durationName = json["duration_name"].stringValue
        durationTitle = json["duration_title"].stringValue
        enableRentBuy = json["enable_rent_buy"].stringValue
        expiryDate = json["expiry_date"].stringValue
        gstPercentage = json["gst_percentage"].stringValue
        iosPackageId = json["ios_package_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        nutritionistSessionCount = json["nutritionist_session_count"].intValue
        offerPrice = json["offer_price"].intValue
        offerTag = json["offer_tag"].stringValue
        orderId = json["order_id"].stringValue
        orderNo = json["order_no"].intValue
        originalTransactionId = json["original_transaction_id"].stringValue
        patientAddressRelId = json["patient_address_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        physiotherapistSessionCount = json["physiotherapist_session_count"].intValue
        planCancelDatetime = json["plan_cancel_datetime"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        planName = json["plan_name"].stringValue
        planPackageDurationRelId = json["plan_package_duration_rel_id"].stringValue
        planPurchaseDatetime = json["plan_purchase_datetime"].stringValue
        planType = json["plan_type"].stringValue
        purchaseAmount = json["purchase_amount"].stringValue
        purchasedAt = json["purchased_at"].stringValue
        receiptData = json["receipt_data"].stringValue
        renewalReminderDays = json["renewal_reminder_days"].intValue
        rentBuyType = json["rent_buy_type"].stringValue
        subTitle = json["sub_title"].stringValue
        subscriptionId = json["subscription_id"].stringValue
        transactionId = json["transaction_id"].stringValue
        transactionType = json["transaction_type"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        whatToExpect = json["what_to_expect"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if androidPackageId != nil{
            dictionary["android_package_id"] = androidPackageId
        }
        if appFeaturesSessionCount != nil{
            dictionary["app_features_session_count"] = appFeaturesSessionCount
        }
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
        if deviceNames != nil{
            dictionary["device_names"] = deviceNames
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if diagnosticTestSessionCount != nil{
            dictionary["diagnostic_test_session_count"] = diagnosticTestSessionCount
        }
        if diagnosticTestUsedCount != nil{
            dictionary["diagnostic_test_used_count"] = diagnosticTestUsedCount
        }
        if diagnosticTests != nil{
            dictionary["diagnostic_tests"] = diagnosticTests
        }
        if discountPercentage != nil{
            dictionary["discount_percentage"] = discountPercentage
        }
        if durationName != nil{
            dictionary["duration_name"] = durationName
        }
        if durationTitle != nil{
            dictionary["duration_title"] = durationTitle
        }
        if enableRentBuy != nil{
            dictionary["enable_rent_buy"] = enableRentBuy
        }
        if expiryDate != nil{
            dictionary["expiry_date"] = expiryDate
        }
        if gstPercentage != nil{
            dictionary["gst_percentage"] = gstPercentage
        }
        if iosPackageId != nil{
            dictionary["ios_package_id"] = iosPackageId
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if nutritionistSessionCount != nil{
            dictionary["nutritionist_session_count"] = nutritionistSessionCount
        }
        if offerPrice != nil{
            dictionary["offer_price"] = offerPrice
        }
        if offerTag != nil{
            dictionary["offer_tag"] = offerTag
        }
        if orderId != nil{
            dictionary["order_id"] = orderId
        }
        if orderNo != nil{
            dictionary["order_no"] = orderNo
        }
        if originalTransactionId != nil{
            dictionary["original_transaction_id"] = originalTransactionId
        }
        if patientAddressRelId != nil{
            dictionary["patient_address_rel_id"] = patientAddressRelId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if patientPlanRelId != nil{
            dictionary["patient_plan_rel_id"] = patientPlanRelId
        }
        if physiotherapistSessionCount != nil{
            dictionary["physiotherapist_session_count"] = physiotherapistSessionCount
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
        if planPackageDurationRelId != nil{
            dictionary["plan_package_duration_rel_id"] = planPackageDurationRelId
        }
        if planPurchaseDatetime != nil{
            dictionary["plan_purchase_datetime"] = planPurchaseDatetime
        }
        if planType != nil{
            dictionary["plan_type"] = planType
        }
        if purchaseAmount != nil{
            dictionary["purchase_amount"] = purchaseAmount
        }
        if purchasedAt != nil{
            dictionary["purchased_at"] = purchasedAt
        }
        if receiptData != nil{
            dictionary["receipt_data"] = receiptData
        }
        if renewalReminderDays != nil{
            dictionary["renewal_reminder_days"] = renewalReminderDays
        }
        if rentBuyType != nil{
            dictionary["rent_buy_type"] = rentBuyType
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
        return dictionary
    }
}
