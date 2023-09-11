//
//  UserDevice.swift
//
//
//

import Foundation

class UserDevice : NSObject, NSCoding{

    var apiVersion : String!
    var appVersion : String!
    var authToken : String!
    var buildVersionNumber : String!
    var createdAt : String!
    var deviceName : String!
    var deviceToken : String!
    var deviceType : String!
    var id : Int!
    var ip : String!
    var language : String!
    var modelName : String!
    var osVersion : String!
    var type : String!
    var updatedAt : String!
    var userId : Int!
    var uuid : String!
    var versionNumber : String!

    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        apiVersion = json["api_version"].stringValue
        appVersion = json["app_version"].stringValue
        authToken = json["auth_token"].stringValue
        buildVersionNumber = json["build_version_number"].stringValue
        createdAt = json["created_at"].stringValue
        deviceName = json["device_name"].stringValue
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        id = json["id"].intValue
        ip = json["ip"].stringValue
        language = json["language"].stringValue
        modelName = json["model_name"].stringValue
        osVersion = json["os_version"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].intValue
        uuid = json["uuid"].stringValue
        versionNumber = json["version_number"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if apiVersion != nil{
            dictionary["api_version"] = apiVersion
        }
        if appVersion != nil{
            dictionary["app_version"] = appVersion
        }
        if authToken != nil{
            dictionary["auth_token"] = authToken
        }
        if buildVersionNumber != nil{
            dictionary["build_version_number"] = buildVersionNumber
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deviceName != nil{
            dictionary["device_name"] = deviceName
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if id != nil{
            dictionary["id"] = id
        }
        if ip != nil{
            dictionary["ip"] = ip
        }
        if language != nil{
            dictionary["language"] = language
        }
        if modelName != nil{
            dictionary["model_name"] = modelName
        }
        if osVersion != nil{
            dictionary["os_version"] = osVersion
        }
        if type != nil{
            dictionary["type"] = type
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if uuid != nil{
            dictionary["uuid"] = uuid
        }
        if versionNumber != nil{
            dictionary["version_number"] = versionNumber
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         apiVersion = aDecoder.decodeObject(forKey: "api_version") as? String
         appVersion = aDecoder.decodeObject(forKey: "app_version") as? String
         authToken = aDecoder.decodeObject(forKey: "auth_token") as? String
         buildVersionNumber = aDecoder.decodeObject(forKey: "build_version_number") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         deviceName = aDecoder.decodeObject(forKey: "device_name") as? String
         deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
         deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         ip = aDecoder.decodeObject(forKey: "ip") as? String
         language = aDecoder.decodeObject(forKey: "language") as? String
         modelName = aDecoder.decodeObject(forKey: "model_name") as? String
         osVersion = aDecoder.decodeObject(forKey: "os_version") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String
         versionNumber = aDecoder.decodeObject(forKey: "version_number") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if apiVersion != nil{
            aCoder.encode(apiVersion, forKey: "api_version")
        }
        if appVersion != nil{
            aCoder.encode(appVersion, forKey: "app_version")
        }
        if authToken != nil{
            aCoder.encode(authToken, forKey: "auth_token")
        }
        if buildVersionNumber != nil{
            aCoder.encode(buildVersionNumber, forKey: "build_version_number")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if deviceName != nil{
            aCoder.encode(deviceName, forKey: "device_name")
        }
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "device_token")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if ip != nil{
            aCoder.encode(ip, forKey: "ip")
        }
        if language != nil{
            aCoder.encode(language, forKey: "language")
        }
        if modelName != nil{
            aCoder.encode(modelName, forKey: "model_name")
        }
        if osVersion != nil{
            aCoder.encode(osVersion, forKey: "os_version")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if uuid != nil{
            aCoder.encode(uuid, forKey: "uuid")
        }
        if versionNumber != nil{
            aCoder.encode(versionNumber, forKey: "version_number")
        }

    }

}
