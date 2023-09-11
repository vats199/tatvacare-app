//
//  HomeModel.swift
//

//

import Foundation

class HomeModel {

    var businessList : [BusinessList]!
    var userList : [UserList]!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        businessList = [BusinessList]()
        let businessListArray = json["business_list"].arrayValue
        for businessListJson in businessListArray{
            let value = BusinessList(fromJson: businessListJson)
            businessList.append(value)
        }
        
        userList = [UserList]()
        let userListArray = json["user_list"].arrayValue
        for userListJson in userListArray{
            let value = UserList(fromJson: userListJson)
            userList.append(value)
        }
        let checkInDetailsJson = json["check_in_details"]
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class BusinessList {

    var address : String!
    var businessUserId : Int!
    var countryCode : String!
    var descriptionField : String!
    var distance : Double!
    var email : String!
    var id : Int!
    var latitude : String!
    var longitude : String!
    var mobile : String!
    var name : String!
    var totalCheckIn : Int!
    var images = [String]()
    var type: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        businessUserId = json["business_user_id"].intValue
        countryCode = json["country_code"].stringValue
        descriptionField = json["description"].stringValue
        distance = json["distance"].doubleValue
        email = json["email"].stringValue
        id = json["id"].intValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        mobile = json["mobile"].stringValue
        name = json["name"].stringValue
        totalCheckIn = json["total_check_in"].intValue
        let imagesJson = json["images"].arrayObject
        if imagesJson != nil{
            images.append(contentsOf: imagesJson as? [String] ?? [""])
        }
        type = json["type"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension BusinessList {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [BusinessList] {
        var models:[BusinessList] = []
        for item in array
        {
            models.append(BusinessList(fromJson: item))
        }
        return models
    }
}


//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class UserList {

    var address : String!
    var businessUserId : Int!
    var countryCode : String!
    var descriptionField : String!
    var distance : Double!
    var email : String!
    var id : Int!
    var latitude : String!
    var longitude : String!
    var mobile : String!
    var name : String!
    var totalCheckIn : Int!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        businessUserId = json["business_user_id"].intValue
        countryCode = json["country_code"].stringValue
        descriptionField = json["description"].stringValue
        distance = json["distance"].doubleValue
        email = json["email"].stringValue
        id = json["id"].intValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        mobile = json["mobile"].stringValue
        name = json["name"].stringValue
        totalCheckIn = json["total_check_in"].intValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension UserList {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [UserList] {
        var models:[UserList] = []
        for item in array
        {
            models.append(UserList(fromJson: item))
        }
        return models
    }
}
