//
//	Data.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

extension WalkthroughListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [WalkthroughListModel] {
        var models:[WalkthroughListModel] = []
        for item in array
        {
            models.append(WalkthroughListModel(fromJson: item))
        }
        return models
    }
}


class WalkthroughListModel : Mappable{

	var createdAt : String!
	var descriptionField : String!
	var image : String!
	var imageUrl : String!
	var isActive : String!
	var isDeleted : String!
	var orderNo : Int!
	var signupOnbordingId : String!
	var title : String!
	var updatedAt : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON){
	
		createdAt = json["created_at"].stringValue
		descriptionField = json["description"].stringValue
		image = json["image"].stringValue
		imageUrl = json["image_url"].stringValue
		isActive = json["is_active"].stringValue
		isDeleted = json["is_deleted"].stringValue
		orderNo = json["order_no"].intValue
		signupOnbordingId = json["signup_onbording_id"].stringValue
		title = json["title"].stringValue
		updatedAt = json["updated_at"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if image != nil{
			dictionary["image"] = image
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if isActive != nil{
			dictionary["is_active"] = isActive
		}
		if isDeleted != nil{
			dictionary["is_deleted"] = isDeleted
		}
		if orderNo != nil{
			dictionary["order_no"] = orderNo
		}
		if signupOnbordingId != nil{
			dictionary["signup_onbording_id"] = signupOnbordingId
		}
		if title != nil{
			dictionary["title"] = title
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         image = aDecoder.decodeObject(forKey: "image") as? String
         imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
         isActive = aDecoder.decodeObject(forKey: "is_active") as? String
         isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
         orderNo = aDecoder.decodeObject(forKey: "order_no") as? Int
         signupOnbordingId = aDecoder.decodeObject(forKey: "signup_onbording_id") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if imageUrl != nil{
			aCoder.encode(imageUrl, forKey: "image_url")
		}
		if isActive != nil{
			aCoder.encode(isActive, forKey: "is_active")
		}
		if isDeleted != nil{
			aCoder.encode(isDeleted, forKey: "is_deleted")
		}
		if orderNo != nil{
			aCoder.encode(orderNo, forKey: "order_no")
		}
		if signupOnbordingId != nil{
			aCoder.encode(signupOnbordingId, forKey: "signup_onbording_id")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}
