//
//  BuisnessDetailModel.swift
//

//

import Foundation

class BusinessDetailModel {

    var address : String!
    var businessUserId : Int!
    var checkInDetails : CheckInDetailModel!
    var countryCode : String!
    var descriptionField : String!
    var email : String!
    var id : Int!
    var latitude : String!
    var longitude : String!
    var mobile : String!
    var name : String!
    var totalCheckIn : Int!
    var totalFemaleCheckIn : Int!
    var totalMaleCheckIn : Int!
    var type : String!
    
    var images = [String]()
    
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        businessUserId = json["business_user_id"].intValue
        let checkInDetailsJson = json["check_in_details"]
        if !checkInDetailsJson.isEmpty{
            checkInDetails = CheckInDetailModel(fromJson: checkInDetailsJson)
        }
        countryCode = json["country_code"].stringValue
        descriptionField = json["description"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        mobile = json["mobile"].stringValue
        name = json["name"].stringValue
        totalCheckIn = json["total_check_in"].intValue
        totalFemaleCheckIn = json["total_female_check_in"].intValue
        totalMaleCheckIn = json["total_male_check_in"].intValue
        type = json["type"].stringValue
        let imagesJson = json["images"].arrayObject
        if imagesJson != nil{
            images.append(contentsOf: imagesJson as? [String] ?? [""])
        }
    }
}

//MARK: ---------------- Array Model ----------------------
extension BusinessDetailModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [BusinessDetailModel] {
        var models:[BusinessDetailModel] = []
        for item in array
        {
            models.append(BusinessDetailModel(fromJson: item))
        }
        return models
    }
}
