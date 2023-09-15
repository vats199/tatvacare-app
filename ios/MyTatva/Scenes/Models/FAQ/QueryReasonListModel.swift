//
//	QueryReasonListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class QueryReasonListModel{

	var createdAt : String!
	var queryReason : String!
	var queryReasonMasterId : String!
	var updatedAt : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		createdAt = json["created_at"].stringValue
		queryReason = json["query_reason"].stringValue
		queryReasonMasterId = json["query_reason_master_id"].stringValue
		updatedAt = json["updated_at"].stringValue
	}

}

//MARK: ---------------- Array Model ----------------------
extension QueryReasonListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [QueryReasonListModel] {
        var models:[QueryReasonListModel] = []
        for item in array
        {
            models.append(QueryReasonListModel(fromJson: item))
        }
        return models
    }
}
