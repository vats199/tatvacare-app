//
//  DeviceDetailsModel.swift
//  MyTatva
//
//  Created by 2022M43 on 28/06/23.
//

import Foundation
import SwiftyJSON

enum BTDeviceType: String {
    case spirometer, bca
}

class DeviceDetailsModel : NSObject, NSCoding{
    
    var key : String!
    var lastSyncDate : String!
    var title : String!
    
    var icon: String {
        switch BTDeviceType(rawValue: self.key) {
        case .bca : return "icon_BCA"
        case .spirometer: return "icon_Spirometer"
        case .none: return ""
        }
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        key = json["key"].stringValue
        lastSyncDate = json["last_sync_date"].stringValue
        title = json["title"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if key != nil{
            dictionary["key"] = key
        }
        if lastSyncDate != nil{
            dictionary["last_sync_date"] = lastSyncDate
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         key = aDecoder.decodeObject(forKey: "key") as? String
         lastSyncDate = aDecoder.decodeObject(forKey: "last_sync_date") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if key != nil{
            aCoder.encode(key, forKey: "key")
        }
        if lastSyncDate != nil{
            aCoder.encode(lastSyncDate, forKey: "last_sync_date")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }

    }

}
