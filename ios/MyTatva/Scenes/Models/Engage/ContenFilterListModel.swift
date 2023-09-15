

import Foundation

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class ContenFilterListModel{
    
    var contentType : [FilterContenTypeListModel]!
    var genre : [FilterGenreListModel]!
    var language : [LanguageListModel]!
    var topic : [TopicListModel]!
    var questionType : [FilterQuestionType]!

    var isShowContentFromDocHealthCoach = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        contentType = [FilterContenTypeListModel]()
        let contentTypeArray = json["content_type"].arrayValue
        for contentTypeJson in contentTypeArray{
            let value = FilterContenTypeListModel(fromJson: contentTypeJson)
            contentType.append(value)
        }
        genre = [FilterGenreListModel]()
        let genreArray = json["genre"].arrayValue
        for genreJson in genreArray{
            let value = FilterGenreListModel(fromJson: genreJson)
            genre.append(value)
        }
        language = [LanguageListModel]()
        let languageArray = json["language"].arrayValue
        for languageJson in languageArray{
            let value = LanguageListModel(fromJson: languageJson)
            language.append(value)
        }
        topic = [TopicListModel]()
        let topicArray = json["topic"].arrayValue
        for topicJson in topicArray{
            let value = TopicListModel(fromJson: topicJson)
            topic.append(value)
        }
        questionType = [FilterQuestionType]()
        let questionTypeArray = json["question_type"].arrayValue
        for questionTypeJson in questionTypeArray{
            let value = FilterQuestionType(fromJson: questionTypeJson)
            questionType.append(value)
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class FilterGenreListModel: NSObject {
    
    var createdAt : String!
    var genre : String!
    var genreMasterId : String!
    var isActive : String!
    var isDeleted : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var isSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
            if json.isEmpty{
                return
            }
            createdAt = json["created_at"].stringValue
            genre = json["genre"].stringValue
            genreMasterId = json["genre_master_id"].stringValue
            isActive = json["is_active"].stringValue
            isDeleted = json["is_deleted"].stringValue
            updatedAt = json["updated_at"].stringValue
            updatedBy = json["updated_by"].stringValue
        }
    
}

//MARK: ---------------- Array Model ----------------------
extension FilterGenreListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [FilterGenreListModel] {
        var models:[FilterGenreListModel] = []
        for item in array
        {
            models.append(FilterGenreListModel(fromJson: item))
        }
        return models
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class FilterContenTypeListModel: NSObject {
    
    var contentType : String!
    var contentTypeId : String!
    var createdAt : String!
    var isActive : String!
    var isDeleted : String!
    var keys : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var isSelected = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
                return
            }
            contentType = json["content_type"].stringValue
            contentTypeId = json["content_type_id"].stringValue
            createdAt = json["created_at"].stringValue
            isActive = json["is_active"].stringValue
            isDeleted = json["is_deleted"].stringValue
            keys = json["keys"].stringValue
            updatedAt = json["updated_at"].stringValue
            updatedBy = json["updated_by"].stringValue
        }
}

//MARK: ---------------- Array Model ----------------------
extension FilterContenTypeListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [FilterContenTypeListModel] {
        var models:[FilterContenTypeListModel] = []
        for item in array
        {
            models.append(FilterContenTypeListModel(fromJson: item))
        }
        return models
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class FilterQuestionType {

    var title : String!
    var value : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        title = json["title"].stringValue
        value = json["value"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension FilterQuestionType {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [FilterQuestionType] {
        var models:[FilterQuestionType] = []
        for item in array
        {
            models.append(FilterQuestionType(fromJson: item))
        }
        return models
    }
}
