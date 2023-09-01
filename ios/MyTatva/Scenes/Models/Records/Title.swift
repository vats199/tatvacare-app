//
//	Title.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class Title{

	var createdAt : String!
	var recordsTitleMasterId : String!
	var title : String!
	var updatedAt : String!
    var isCustom = false

    init(){ }
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		createdAt = json["created_at"].stringValue
		recordsTitleMasterId = json["records_title_master_id"].stringValue
		title = json["title"].stringValue
		updatedAt = json["updated_at"].stringValue
	}

}

