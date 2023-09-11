
import Foundation
import SwiftyJSON

class RecordListModel{

    var createdAt : String!
    var descriptionField : String!
    var documentName : String!
    var documentUrl : [String]?
    var isActive : String!
    var isDeleted : String!
    var patientId : String!
    var patientRecordsId : String!
    var testTypeId : String!
    var title : String!
    var updatedAt : String!
    var updatedBy : String!
    var testName: String!
    var addedBy : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        addedBy = json["added_by"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        documentName = json["document_name"].stringValue
        
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientId = json["patient_id"].stringValue
        patientRecordsId = json["patient_records_id"].stringValue
        testTypeId = json["test_type_id"].stringValue
        title = json["title"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        testName = json["test_name"].stringValue
        
        documentUrl = [String]()
        let documentUrlJson = json["document_url"].arrayObject
        if documentUrlJson != nil{
            documentUrl?.append(contentsOf: documentUrlJson as? [String] ?? [""])
        }
    }
}

//MARK: ---------------- Array Model ----------------------
extension RecordListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [RecordListModel] {
        var models:[RecordListModel] = []
        for item in array
        {
            models.append(RecordListModel(fromJson: item))
        }
        return models
    }
}
