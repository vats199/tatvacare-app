

import Foundation

class SearchMedicineModel {
    
    var medicineImage : String!
    var medicineId : String!
    var medicineName : String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
            if json.isEmpty{
                return
            }
            medicineImage = json["medicine_Image"].stringValue
            medicineId = json["medicine_id"].stringValue
            medicineName = json["medicine_name"].stringValue
        }
}

//MARK: ---------------- Array Model ----------------------
extension SearchMedicineModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [SearchMedicineModel] {
        var models:[SearchMedicineModel] = []
        for item in array
        {
            models.append(SearchMedicineModel(fromJson: item))
        }
        return models
    }
}

