

import Foundation

class LabTestSlotModel {
    
    var id : String!
    var slot : String!
    var slotMasterId : String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        slot = json["slot"].stringValue
        slotMasterId = json["slotMasterId"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension LabTestSlotModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [LabTestSlotModel] {
        var models:[LabTestSlotModel] = []
        for item in array
        {
            models.append(LabTestSlotModel(fromJson: item))
        }
        return models
    }
}

