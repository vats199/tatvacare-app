//

//

//

import Foundation

class MenuItemDetailModel: NSObject {

    var brandId : Int!
    var brandName : String!
    var businessId : Int!
    var businessUserId : Int!
    var categoryId : Int!
    var categoryName : String!
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
    
    
    
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        brandId = json["brand_id"].intValue
        brandName = json["brand_name"].stringValue
        businessId = json["business_id"].intValue
        businessUserId = json["business_user_id"].intValue
        categoryId = json["category_id"].intValue
        categoryName = json["category_name"].stringValue
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
extension MenuItemDetailModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MenuItemDetailModel] {
        var models:[MenuItemDetailModel] = []
        for item in array
        {
            models.append(MenuItemDetailModel(fromJson: item))
        }
        return models
    }
}
