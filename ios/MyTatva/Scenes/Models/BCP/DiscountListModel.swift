//
//  DiscountListModel.swift
//  MyTatva
//
//  Created by Uttam patel on 01/09/23.
//

import Foundation

class DiscountModel {
    
    var couponCodeData : DiscountListModel!
    var discountAmount : Int!
    var finalPrice : Int!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let couponCodeDataJson = json["coupon_code_data"]
        if !couponCodeDataJson.isEmpty{
            couponCodeData = DiscountListModel(fromJson: couponCodeDataJson)
        }
        discountAmount = json["discount_amount"].intValue
        finalPrice = json["final_price"].intValue
        
    }
}

class DiscountListModel {
    var applyOn : String!
    var createdAt : String!
    var createdBy : String!
    var descriptionField : String!
    var discountAmount : String!
    var discountAvailableFor : String!
    var discountCode : String!
    var discountLimit : String!
    var discountName : String!
    var discountPercentage : String!
    var discountType : String!
    var discountsMasterId : String!
    var endDate : String!
    var isActive : String!
    var isDeleted : String!
    var label : String!
    var maxDiscountPrice : String!
    var minCartPrice : String!
    var prefixKeyword : String!
    var startDate : String!
    var updatedAt : String!
    var updatedBy : String!
    var onlydescription : String!
    
    var isSelected = false
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        applyOn = json["apply_on"].stringValue
        createdAt = json["created_at"].stringValue
        createdBy = json["created_by"].stringValue
        descriptionField = json["description"].stringValue
        discountAmount = json["discount_amount"].stringValue
        discountAvailableFor = json["discount_available_for"].stringValue
        discountCode = json["discount_code"].stringValue
        discountLimit = json["discount_limit"].stringValue
        discountName = json["discount_name"].stringValue
        discountPercentage = json["discount_percentage"].stringValue
        discountType = json["discount_type"].stringValue
        discountsMasterId = json["discounts_master_id"].stringValue
        endDate = json["end_date"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        label = json["label"].stringValue
        maxDiscountPrice = json["max_discount_price"].stringValue
        minCartPrice = json["min_cart_price"].stringValue
        prefixKeyword = json["prefix_keyword"].stringValue
        startDate = json["start_date"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        onlydescription = json["onlydescription"].stringValue
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension DiscountListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [DiscountListModel] {
        var models:[DiscountListModel] = []
        for item in array
        {
            models.append(DiscountListModel(fromJson: item))
        }
        return models
    }
}
