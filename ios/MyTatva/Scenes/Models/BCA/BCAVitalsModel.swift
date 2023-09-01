//
//  BCAVitalsModel.swift
//  MyTatva
//
//  Created by Hlink on 16/05/23.
//

import Foundation
import SwiftyJSON


class BCAVitalsModel : NSObject, NSCoding{
    
    var colorCode : String!
    var colorCode1 : String!
    var imageUrl : String!
    var keys : String!
    var measurements : String!
    var readingName : String!
    var formattedReadingName : String!
    var readingRange : String!
    var readingValue : String!
    var reading: Double!
    var readingsMasterId : String!
    var readingValueData = ReadingValueData()
    var isSelected = false
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        colorCode = json["color_code"].stringValue
        colorCode1 = json["color_code_1"].stringValue
        imageUrl = json["image_url"].stringValue
        keys = json["keys"].stringValue
        measurements = json["measurements"].stringValue
        readingName = json["reading_name"].stringValue
        formattedReadingName = readingName + " (" + measurements + ")"
        readingRange = json["reading_range"].stringValue
        readingValue = json["reading_value"].stringValue
        reading = json["reading_value"].doubleValue
        readingsMasterId = json["readings_master_id"].stringValue
        let readingValueDataJson = json["reading_value_data"]
        if !readingValueDataJson.isEmpty{
            readingValueData = ReadingValueData(fromJson: readingValueDataJson)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if colorCode != nil{
            dictionary["color_code"] = colorCode
        }
        if colorCode1 != nil{
            dictionary["color_code_1"] = colorCode1
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if keys != nil{
            dictionary["keys"] = keys
        }
        if measurements != nil{
            dictionary["measurements"] = measurements
        }
        if readingName != nil{
            dictionary["reading_name"] = readingName
        }
        if readingRange != nil{
            dictionary["reading_range"] = readingRange
        }
        if readingValue != nil{
            dictionary["reading_value"] = readingValue
        }
        if reading != nil{
            dictionary["reading_value"] = reading
        }
        if readingsMasterId != nil{
            dictionary["readings_master_id"] = readingsMasterId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        colorCode = aDecoder.decodeObject(forKey: "color_code") as? String
        colorCode1 = aDecoder.decodeObject(forKey: "color_code_1") as? String
        imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
        keys = aDecoder.decodeObject(forKey: "keys") as? String
        measurements = aDecoder.decodeObject(forKey: "measurements") as? String
        readingName = aDecoder.decodeObject(forKey: "reading_name") as? String
        readingRange = aDecoder.decodeObject(forKey: "reading_range") as? String
        readingValue = aDecoder.decodeObject(forKey: "reading_value") as? String
        reading = aDecoder.decodeObject(forKey: "reading_value") as? Double
        readingsMasterId = aDecoder.decodeObject(forKey: "readings_master_id") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if colorCode != nil{
            aCoder.encode(colorCode, forKey: "color_code")
        }
        if colorCode1 != nil{
            aCoder.encode(colorCode1, forKey: "color_code_1")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "image_url")
        }
        if keys != nil{
            aCoder.encode(keys, forKey: "keys")
        }
        if measurements != nil{
            aCoder.encode(measurements, forKey: "measurements")
        }
        if readingName != nil{
            aCoder.encode(readingName, forKey: "reading_name")
        }
        if readingRange != nil{
            aCoder.encode(readingRange, forKey: "reading_range")
        }
        if readingValue != nil{
            aCoder.encode(readingValue, forKey: "reading_value")
        }
        if reading != nil{
            aCoder.encode(reading, forKey: "reading_value")
        }
        if readingsMasterId != nil{
            aCoder.encode(readingsMasterId, forKey: "readings_master_id")
        }
        
    }
    
}
