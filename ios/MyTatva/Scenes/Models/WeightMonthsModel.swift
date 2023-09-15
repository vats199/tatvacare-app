import Foundation

class WeightMonthsModel {
    
    var months : String!
    var rate : Float!
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
        months = json["months"].stringValue
        rate = json["rate"].floatValue
        type = json["type"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension WeightMonthsModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [WeightMonthsModel] {
        var models:[WeightMonthsModel] = []
        for item in array
        {
            models.append(WeightMonthsModel(fromJson: item))
        }
        return models
    }
}
