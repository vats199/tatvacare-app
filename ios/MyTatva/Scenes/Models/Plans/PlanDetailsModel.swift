//
//  PlanDetailsModel.swift
//  MyTatva
//
//  Created by Darshan Joshi on 03/01/22.
//

class PlanDetailsModel {
    var cardImage : String!
    var colourScheme : String!
    var createdAt : String!
    var descriptionField : String!
    var duration : [PlanDuration]!
    var featuresRes : [FeaturesRe]!
    var imageUrl : String!
    var isActive : String!
    var isDeleted : String!
    var patientId : String!
    var patientPlanRelId : String!
    var planMasterId : String!
    var planName : String!
    var planPurchaseDatetime : String!
    var planPurchased : String!
    var planType : String!
    var renewalReminderDays : Int!
    var subTitle : String!
    var transactionId : String!
    var updatedAt : String!
    var updatedBy : String!
    var startAt : String!
    var originalTransactionId: String!
    var receiptData: String!
    
    var cardImageDetail : String!
    var deviceType : String!
    var subscriptionId : String!
    var enableRentBuy : Bool!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        cardImage = json["card_image"].stringValue
        colourScheme = json["colour_scheme"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        duration = [PlanDuration]()
        let durationArray = json["duration"].arrayValue
        for durationJson in durationArray{
            let value = PlanDuration(fromJson: durationJson)
            duration.append(value)
        }
        featuresRes = [FeaturesRe]()
        let featuresResArray = json["features_res"].arrayValue
        for featuresResJson in featuresResArray{
            let value = FeaturesRe(fromJson: featuresResJson)
            featuresRes.append(value)
        }
        imageUrl = json["image_url"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        originalTransactionId = json["original_transaction_id"].stringValue
        patientId = json["patient_id"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        planName = json["plan_name"].stringValue
        planPurchaseDatetime = json["plan_purchase_datetime"].stringValue
        planPurchased = json["plan_purchased"].stringValue
        planType = json["plan_type"].stringValue
        receiptData = json["receipt_data"].stringValue
        renewalReminderDays = json["renewal_reminder_days"].intValue
        subTitle = json["sub_title"].stringValue
        transactionId = json["transaction_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        cardImageDetail = json["card_image_detail"].stringValue
        deviceType = json["device_type"].stringValue
        subscriptionId = json["subscription_id"].stringValue
        enableRentBuy = json["enable_rent_buy"].boolValue
    }
}

class PlanDuration{
    
    
    var androidPackageId : String!
    var androidPerMonthPrice : Double!
    var androidPrice : Double!
    var createdAt : String!
    var duration : Int!
    var durationName : String!
    var durationTitle : String!
    var iosPackageId : String!
    var iosPerMonthPrice : Double!
    var iosPrice : Double!
    var iosProductId : String!
    var isActive : String!
    var isDeleted : String!
    var offerPerMonthPrice : Double!
    var offerPrice : Double!
    var offerTag : String!
    var orderNo : Int!
    var planEndDate : String!
    var planMasterId : String!
    var planPackageDurationRelId : String!
    var planStartDate : String!
    var razorpayPlanId : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var expiryDate : String!
    var patientId : String!
    var patientPlanRelId : String!
    var purchasedAt : String!
    var discountPercentage : Int!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        androidPackageId = json["android_package_id"].stringValue
        androidPerMonthPrice = json["android_per_month_price"].doubleValue
        androidPrice = json["android_price"].doubleValue
        createdAt = json["created_at"].stringValue
        duration = json["duration"].intValue
        durationName = json["duration_name"].stringValue
        durationTitle = json["duration_title"].stringValue
        iosPackageId = json["ios_package_id"].stringValue
        iosPerMonthPrice = json["ios_per_month_price"].doubleValue
        iosPrice = json["ios_price"].doubleValue
        iosProductId = json["ios_product_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        offerPerMonthPrice = json["offer_per_month_price"].doubleValue
        offerPrice = json["offer_price"].doubleValue
        offerTag = json["offer_tag"].stringValue
        orderNo = json["order_no"].intValue
        planEndDate = json["plan_end_date"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        planPackageDurationRelId = json["plan_package_duration_rel_id"].stringValue
        planStartDate = json["plan_start_date"].stringValue
        razorpayPlanId = json["razorpay_plan_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        expiryDate = json["expiry_date"].stringValue
        patientId = json["patient_id"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        purchasedAt = json["purchased_at"].stringValue
        discountPercentage = json["discount_percentage"].intValue

        
        
    }
    
}

