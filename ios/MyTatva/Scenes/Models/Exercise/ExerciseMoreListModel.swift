
//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class ExerciseMoreListModel {

    var contentData : [ContentListModel]!
    var createdAt : String!
    var genre : String!
    var genreMasterId : String!
    var isActive : String!
    var isDeleted : String!
    var type : String!
    var updatedAt : String!
    var updatedBy : String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        contentData = [ContentListModel]()
        let contentDataArray = json["content_data"].arrayValue
        for contentDataJson in contentDataArray{
            let value = ContentListModel(fromJson: contentDataJson)
            contentData.append(value)
        }
        createdAt = json["created_at"].stringValue
        genre = json["genre"].stringValue
        genreMasterId = json["genre_master_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension ExerciseMoreListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ExerciseMoreListModel] {
        var models:[ExerciseMoreListModel] = []
        for item in array
        {
            models.append(ExerciseMoreListModel(fromJson: item))
        }
        return models
    }
}
