//
//	UtensilsListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class UtensilsListModel{

	var createdAt : String!
	var imageUrl : String!
	var key : String!
	var quantity : String!
	var updatedAt : String!
	var utensilListId : String!
	var utensilName : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		createdAt = json["created_at"].stringValue
		imageUrl = json["image_url"].stringValue
		key = json["key"].stringValue
		quantity = json["quantity"].stringValue
		updatedAt = json["updated_at"].stringValue
		utensilListId = json["utensil_list_id"].stringValue
		utensilName = json["utensil_name"].stringValue
	}

}

//MARK: ---------------- Array Model ----------------------
extension UtensilsListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [UtensilsListModel] {
        var models:[UtensilsListModel] = []
        for item in array
        {
            models.append(UtensilsListModel(fromJson: item))
        }
        return models
    }
}
