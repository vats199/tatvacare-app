//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class CategoryListModel: NSObject {
    
    var id : Int!
    var name: String!
    var isSelected = false
    
    override init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension CategoryListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [CategoryListModel] {
        var models:[CategoryListModel] = []
        for item in array
        {
            models.append(CategoryListModel(fromJson: item))
        }
        return models
    }
}

