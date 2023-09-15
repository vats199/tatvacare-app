//
//  DurationDetailModel.swift
//  MyTatva
//
//  Created by Hlink on 13/06/23.
//

import Foundation

class DurationDetailModel{
    
    var isSelected = false
    
    var androidFinalAmount : Double!
    var androidGstAmount : Double!
    var androidPackageId : String!
    var androidPrice : Int!
    var appFeaturesSessionCount : Int!
    var createdAt : String!
    var deviceList : String!
    var deviceNames : String!
    var diagnosticTestSessionCount : Int!
    var diagnosticTests : String!
    var diagnosticTestsNames : String!
    var discountPercentage : String!
    var duration : Int!
    var durationName : String!
    var durationTitle : String!
    var iosPackageId : String!
    var iosPrice : Int!
    var iosProductId : String!
    var isActive : String!
    var isDeleted : String!
    var isRecommended : String!
    var nutritionistSessionCount : Int!
    var offerPrice : Int!
    var offerTag : String!
    var orderNo : Int!
    var physiotherapistSessionCount : Int!
    var planMasterId : String!
    var planPackageDurationRelId : String!
    var razorpayPlanId : String!
    var rentBuyType : String!
    var updatedAt : String!
    var updatedBy : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        androidFinalAmount = json["android_final_amount"].doubleValue
        androidGstAmount = json["android_gst_amount"].doubleValue
        androidPackageId = json["android_package_id"].stringValue
        androidPrice = json["android_price"].intValue
        appFeaturesSessionCount = json["app_features_session_count"].intValue
        createdAt = json["created_at"].stringValue
        deviceList = json["device_list"].stringValue
        deviceNames = json["device_names"].stringValue
        diagnosticTestSessionCount = json["diagnostic_test_session_count"].intValue
        diagnosticTests = json["diagnostic_tests"].stringValue
        diagnosticTestsNames = json["diagnostic_tests_names"].stringValue
        discountPercentage = json["discount_percentage"].stringValue
        duration = json["duration"].intValue
        durationName = json["duration_name"].stringValue
        durationTitle = json["duration_title"].stringValue
        iosPackageId = json["ios_package_id"].stringValue
        iosPrice = json["ios_price"].intValue
        iosProductId = json["ios_product_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        isRecommended = json["is_recommended"].stringValue
        nutritionistSessionCount = json["nutritionist_session_count"].intValue
        offerPrice = json["offer_price"].intValue
        offerTag = json["offer_tag"].stringValue
        orderNo = json["order_no"].intValue
        physiotherapistSessionCount = json["physiotherapist_session_count"].intValue
        planMasterId = json["plan_master_id"].stringValue
        planPackageDurationRelId = json["plan_package_duration_rel_id"].stringValue
        razorpayPlanId = json["razorpay_plan_id"].stringValue
        rentBuyType = json["rent_buy_type"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if androidFinalAmount != nil{
            dictionary["android_final_amount"] = androidFinalAmount
        }
        if androidGstAmount != nil{
            dictionary["android_gst_amount"] = androidGstAmount
        }
        if androidPackageId != nil{
            dictionary["android_package_id"] = androidPackageId
        }
        if androidPrice != nil{
            dictionary["android_price"] = androidPrice
        }
        if appFeaturesSessionCount != nil{
            dictionary["app_features_session_count"] = appFeaturesSessionCount
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deviceList != nil{
            dictionary["device_list"] = deviceList
        }
        if deviceNames != nil{
            dictionary["device_names"] = deviceNames
        }
        if diagnosticTestSessionCount != nil{
            dictionary["diagnostic_test_session_count"] = diagnosticTestSessionCount
        }
        if diagnosticTests != nil{
            dictionary["diagnostic_tests"] = diagnosticTests
        }
        if diagnosticTestsNames != nil{
            dictionary["diagnostic_tests_names"] = diagnosticTestsNames
        }
        if discountPercentage != nil{
            dictionary["discount_percentage"] = discountPercentage
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if durationName != nil{
            dictionary["duration_name"] = durationName
        }
        if durationTitle != nil{
            dictionary["duration_title"] = durationTitle
        }
        if iosPackageId != nil{
            dictionary["ios_package_id"] = iosPackageId
        }
        if iosPrice != nil{
            dictionary["ios_price"] = iosPrice
        }
        if iosProductId != nil{
            dictionary["ios_product_id"] = iosProductId
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if isRecommended != nil{
            dictionary["is_recommended"] = isRecommended
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
        if orderNo != nil{
            dictionary["order_no"] = orderNo
        }
        if physiotherapistSessionCount != nil{
            dictionary["physiotherapist_session_count"] = physiotherapistSessionCount
        }
        if planMasterId != nil{
            dictionary["plan_master_id"] = planMasterId
        }
        if planPackageDurationRelId != nil{
            dictionary["plan_package_duration_rel_id"] = planPackageDurationRelId
        }
        if razorpayPlanId != nil{
            dictionary["razorpay_plan_id"] = razorpayPlanId
        }
        if rentBuyType != nil{
            dictionary["rent_buy_type"] = rentBuyType
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if updatedBy != nil{
            dictionary["updated_by"] = updatedBy
        }
        return dictionary
    }
    
}
