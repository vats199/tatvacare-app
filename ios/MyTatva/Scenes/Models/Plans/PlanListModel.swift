

import Foundation

class PlanListModel{

    var planDetails : [PlanDetail]!
    var title : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        planDetails = [PlanDetail]()
        let planDetailsArray = json["plans"].arrayValue
        for planDetailsJson in planDetailsArray{
            let value = PlanDetail(fromJson: planDetailsJson)
            planDetails.append(value)
        }
        title = json["title"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension PlanListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PlanListModel] {
        var models:[PlanListModel] = []
        for item in array
        {
            models.append(PlanListModel(fromJson: item))
        }
        return models
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class PlanDetail {
    var androidPerMonthPrice : Double!
    var androidPrice : Double!
    var cardImage : String!
    var colourScheme : String!
    var createdAt : String!
    var descriptionField : String!
    var featuresRes : [FeaturesRe]!
    var imageUrl : String!
    var iosPerMonthPrice : Double!
    var iosPrice : Double!
    var isActive : String!
    var isDeleted : String!
    var isShowRenew : String!
    var offerPerMonthPrice : Double!
    var offerPrice : Double!
    var patientId : String!
    var patientPlanRelId : String!
    var planEndDate : String!
    var planMasterId : String!
    var planName : String!
    var planPurchaseDatetime : String!
    var planStartDate : String!
    var planType : String!
    var renewalReminderDays : Double!
    var subTitle : String!
    var transactionId : String!
    var updatedAt : String!
    var updatedBy : String!
    var startAt : String!
    var iosProductId : String!
    var razorpayPlanId : String!
    
    var actualPrice : String! // for start at
    var cardImageDetail : String!
    var discountPercentage : Double! // 0 means no discount and 100 means Free
    
    var descriptionFieldHTML : String!
    var enableRentBuy: Bool!
    
    var totalDays: String!
    var remainingDays: String!
    var expiryDate: String!
    var startDate: String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        androidPerMonthPrice = json["android_per_month_price"].doubleValue
        androidPrice = json["android_price"].doubleValue
        cardImage = json["card_image"].stringValue
        colourScheme = json["colour_scheme"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        featuresRes = [FeaturesRe]()
        let featuresResArray = json["features_res"].arrayValue
        for featuresResJson in featuresResArray{
            let value = FeaturesRe(fromJson: featuresResJson)
            featuresRes.append(value)
        }
        imageUrl = json["image_url"].stringValue
        iosPerMonthPrice = json["ios_per_month_price"].doubleValue
        iosPrice = json["ios_price"].doubleValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        isShowRenew = json["show_renew"].stringValue
        offerPerMonthPrice = json["offer_per_month_price"].doubleValue
        offerPrice = json["offer_price"].doubleValue
        patientId = json["patient_id"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        planEndDate = json["plan_end_date"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        planName = json["plan_name"].stringValue
        planPurchaseDatetime = json["plan_purchase_datetime"].stringValue
        planStartDate = json["plan_start_date"].stringValue
        planType = json["plan_type"].stringValue
        renewalReminderDays = json["renewal_reminder_days"].doubleValue
        subTitle = json["sub_title"].stringValue
        transactionId = json["transaction_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        startAt = json["start_at"].stringValue
        razorpayPlanId = json["razorpay_plan_id"].stringValue
        iosProductId = json["ios_product_id"].stringValue
        
        actualPrice = json["actual_price"].stringValue
        discountPercentage = json["discount_percentage"].doubleValue
        cardImageDetail = json["card_image_detail"].stringValue
        enableRentBuy = json["enable_rent_buy"].boolValue
        
        remainingDays = json["remaining_days"].stringValue
        expiryDate = json["expiry_date"].stringValue
        startDate = json["start_date"].stringValue
        totalDays = json["total_days"].stringValue
        
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class FeaturesRe : NSObject, NSCoding{

    var feature : String!
    var featureKeys : String!
    var patientPlanRelId : String!
    var planFeaturesId : String!
    var planFeaturesRelId : String!
    var planMasterId : String!
    var subFeaturesIds : String!
    var subFeaturesNames : String!
    var subFeaturesKeys : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        feature = json["feature"].stringValue
        featureKeys = json["feature_keys"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        planFeaturesId = json["plan_features_id"].stringValue
        planFeaturesRelId = json["plan_features_rel_id"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        subFeaturesIds = json["sub_features_ids"].stringValue
        subFeaturesNames = json["sub_features_names"].stringValue
        subFeaturesKeys = json["sub_features_keys"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if feature != nil{
            dictionary["feature"] = feature
        }
        if featureKeys != nil{
            dictionary["feature_keys"] = featureKeys
        }
        if patientPlanRelId != nil{
            dictionary["patient_plan_rel_id"] = patientPlanRelId
        }
        if planFeaturesId != nil{
            dictionary["plan_features_id"] = planFeaturesId
        }
        if planFeaturesRelId != nil{
            dictionary["plan_features_rel_id"] = planFeaturesRelId
        }
        if planMasterId != nil{
            dictionary["plan_master_id"] = planMasterId
        }
        if subFeaturesIds != nil{
            dictionary["sub_features_ids"] = subFeaturesIds
        }
        if subFeaturesNames != nil{
            dictionary["sub_features_names"] = subFeaturesNames
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        feature = aDecoder.decodeObject(forKey: "feature") as? String
        featureKeys = aDecoder.decodeObject(forKey: "feature_keys") as? String
        patientPlanRelId = aDecoder.decodeObject(forKey: "patient_plan_rel_id") as? String
        planFeaturesId = aDecoder.decodeObject(forKey: "plan_features_id") as? String
        planFeaturesRelId = aDecoder.decodeObject(forKey: "plan_features_rel_id") as? String
        planMasterId = aDecoder.decodeObject(forKey: "plan_master_id") as? String
        subFeaturesIds = aDecoder.decodeObject(forKey: "sub_features_ids") as? String
        subFeaturesNames = aDecoder.decodeObject(forKey: "sub_features_names") as? String
        subFeaturesKeys = aDecoder.decodeObject(forKey: "sub_features_keys") as? String
    }
    
    /**
     * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if feature != nil{
            aCoder.encode(feature, forKey: "feature")
        }
        if featureKeys != nil{
            aCoder.encode(featureKeys, forKey: "feature_keys")
        }
        if patientPlanRelId != nil{
            aCoder.encode(patientPlanRelId, forKey: "patient_plan_rel_id")
        }
        if planFeaturesId != nil{
            aCoder.encode(planFeaturesId, forKey: "plan_features_id")
        }
        if planFeaturesRelId != nil{
            aCoder.encode(planFeaturesRelId, forKey: "plan_features_rel_id")
        }
        if planMasterId != nil{
            aCoder.encode(planMasterId, forKey: "plan_master_id")
        }
        if subFeaturesIds != nil{
            aCoder.encode(subFeaturesIds, forKey: "sub_features_ids")
        }
        if subFeaturesNames != nil{
            aCoder.encode(subFeaturesNames, forKey: "sub_features_names")
        }
        if subFeaturesKeys != nil{
            aCoder.encode(subFeaturesKeys, forKey: "sub_features_keys")
        }
    }

}
