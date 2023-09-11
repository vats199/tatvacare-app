//
//	FAQListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class FAQListModel{
    
    var categoryName : String!
    var data : [FAQData]!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryName = json["category_name"].stringValue
        data = [FAQData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = FAQData(fromJson: dataJson)
            data.append(value)
        }
    }
}

class FAQData{

    var createdAt : String!
    var faqAnswer : String!
    var faqCategoryMasterId : String!
    var faqMasterId : String!
    var faqQuestion : String!
    var isActive : String!
    var isDeleted : String!
    var updatedAt : String!
    var updatedBy : String!
    var answerPrefix: String!
    
    var isSelected = false

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        faqAnswer = json["faq_answer"].stringValue
        faqCategoryMasterId = json["faq_category_master_id"].stringValue
        faqMasterId = json["faq_master_id"].stringValue
        faqQuestion = json["faq_question"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        answerPrefix = json["answer_prefix"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension FAQListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [FAQListModel] {
        var models:[FAQListModel] = []
        for item in array
        {
            models.append(FAQListModel(fromJson: item))
        }
        return models
    }
}
