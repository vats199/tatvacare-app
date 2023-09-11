//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class MenuItemListModel: NSObject {
    
    var brandId : Int!
    var businessId : Int!
    var businessUserId : Int!
    var categoryId : Int!
    var createdAt : String!
    var dealDiscount : Int!
    var dealStatus : Int!
    var descriptionField : String!
    var id : Int!
    var image : String!
    var isAvailable : Int!
    var name : String!
    var price : Int!
    var status : String!
    var type : String!
    var updatedAt : String!
    
    override init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        brandId = json["brand_id"].intValue
        businessId = json["business_id"].intValue
        businessUserId = json["business_user_id"].intValue
        categoryId = json["category_id"].intValue
        createdAt = json["created_at"].stringValue
        dealDiscount = json["deal_discount"].intValue
        dealStatus = json["deal_status"].intValue
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        isAvailable = json["is_available"].intValue
        name = json["name"].stringValue
        price = json["price"].intValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension MenuItemListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MenuItemListModel] {
        var models:[MenuItemListModel] = []
        for item in array
        {
            models.append(MenuItemListModel(fromJson: item))
        }
        return models
    }
}

