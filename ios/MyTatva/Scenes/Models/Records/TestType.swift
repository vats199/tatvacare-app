//
//	TestType.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class TestType{

	var createdAt : String!
	var testName : String!
	var testTypeId : String!
	var updatedAt : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		createdAt = json["created_at"].stringValue
		testName = json["test_name"].stringValue
		testTypeId = json["test_type_id"].stringValue
		updatedAt = json["updated_at"].stringValue
	}

}