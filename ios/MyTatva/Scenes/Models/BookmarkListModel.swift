

import Foundation

class BookmarkListModel{

    var data : [ContentListModel]!
    var displayValue : String!
    var type : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        data = [ContentListModel]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = ContentListModel(fromJson: dataJson)
            data.append(value)
        }
        displayValue = json["display_value"].stringValue
        type = json["type"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension BookmarkListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [BookmarkListModel] {
        var models:[BookmarkListModel] = []
        for item in array
        {
            models.append(BookmarkListModel(fromJson: item))
        }
        return models
    }
}
