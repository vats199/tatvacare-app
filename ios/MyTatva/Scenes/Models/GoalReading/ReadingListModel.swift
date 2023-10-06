

import Foundation

class ReadingListModel: NSObject, NSCoding{
    
    var backgroundColor : String!
    var imageIconUrl : String!
    
    var colorCode : String!
    var createdAt : String!
    var imageUrl : String!
    var imgExtn : String!
    var isActive : String!
    var isDeleted : String!
    var keys : String!
    var mandatory : String!
    var maxLimit : String!
    var measurements : String!
    var minLimit : String!
    var readingName : String!
    var readingsMasterId : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var readingDatetime : String!
    var readingValue : Double!
    var readingValueData = ReadingValueData()
    var information : String!
    var duration : Int!
    var readingRequired : String!
    var totalReadingAverage : String!
    var defaultReading : String!
    
    var graph : String!
    var inRange : InRange!

    
    var isSelected = false
    var isTopBigCell = false
    var notConfigured : String!
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        colorCode = json["color_code"].stringValue
        createdAt = json["created_at"].stringValue
        imageUrl = json["image_url"].stringValue
        imgExtn = json["img_extn"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        keys = json["keys"].stringValue
        mandatory = json["mandatory"].stringValue
        maxLimit = json["max_limit"].stringValue
        measurements = json["measurements"].stringValue
        minLimit = json["min_limit"].stringValue
        readingName = json["reading_name"].stringValue
        readingsMasterId = json["readings_master_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        readingDatetime = json["reading_datetime"].stringValue
        readingValue = json["reading_value"].doubleValue
        let readingValueDataJson = json["reading_value_data"]
        if !readingValueDataJson.isEmpty{
            readingValueData = ReadingValueData(fromJson: readingValueDataJson)
        }
        
        backgroundColor = json["background_color"].stringValue
        imageIconUrl = json["image_icon_url"].stringValue
        information = json["information"].stringValue
        duration = json["duration"].intValue
        readingRequired = json["reading_required"].stringValue
        totalReadingAverage = json["total_reading_average"].stringValue
        defaultReading = json["default_reading"].stringValue
        graph = json["graph"].stringValue
        let inRangeJson = json["in_range"]
        if !inRangeJson.isEmpty{
            inRange = InRange(fromJson: inRangeJson)
        }
        notConfigured = json["not_configured"].stringValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        backgroundColor = aDecoder.decodeObject(forKey: "background_color") as? String
        colorCode = aDecoder.decodeObject(forKey: "color_code") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        duration = aDecoder.decodeObject(forKey: "duration") as? Int
        imageIconUrl = aDecoder.decodeObject(forKey: "image_icon_url") as? String
        imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
        information = aDecoder.decodeObject(forKey: "information") as? String
        keys = aDecoder.decodeObject(forKey: "keys") as? String
        measurements = aDecoder.decodeObject(forKey: "measurements") as? String
        readingDatetime = aDecoder.decodeObject(forKey: "reading_datetime") as? String
        readingName = aDecoder.decodeObject(forKey: "reading_name") as? String
        readingRequired = aDecoder.decodeObject(forKey: "reading_required") as? String
        readingValue = aDecoder.decodeObject(forKey: "reading_value") as? Double
        readingValueData = aDecoder.decodeObject(forKey: "reading_value_data") as? ReadingValueData ?? ReadingValueData()
        readingsMasterId = aDecoder.decodeObject(forKey: "readings_master_id") as? String
        totalReadingAverage = aDecoder.decodeObject(forKey: "total_reading_average") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if backgroundColor != nil{
            aCoder.encode(backgroundColor, forKey: "background_color")
        }
        if colorCode != nil{
            aCoder.encode(colorCode, forKey: "color_code")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if duration != nil{
            aCoder.encode(duration, forKey: "duration")
        }
        if imageIconUrl != nil{
            aCoder.encode(imageIconUrl, forKey: "image_icon_url")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "image_url")
        }
        if information != nil{
            aCoder.encode(information, forKey: "information")
        }
        if keys != nil{
            aCoder.encode(keys, forKey: "keys")
        }
        if measurements != nil{
            aCoder.encode(measurements, forKey: "measurements")
        }
        if readingDatetime != nil{
            aCoder.encode(readingDatetime, forKey: "reading_datetime")
        }
        if readingName != nil{
            aCoder.encode(readingName, forKey: "reading_name")
        }
        if readingRequired != nil{
            aCoder.encode(readingRequired, forKey: "reading_required")
        }
        if readingValue != nil{
            aCoder.encode(readingValue, forKey: "reading_value")
        }
        if readingValueData != nil{
            aCoder.encode(readingValueData, forKey: "reading_value_data")
        }
        if readingsMasterId != nil{
            aCoder.encode(readingsMasterId, forKey: "readings_master_id")
        }
        if totalReadingAverage != nil{
            aCoder.encode(totalReadingAverage, forKey: "total_reading_average")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
    }
}

//MARK: ---------------- Array Model ----------------------
extension ReadingListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ReadingListModel] {
        var models:[ReadingListModel] = []
        for item in array
        {
            models.append(ReadingListModel(fromJson: item))
        }
        return models
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class ReadingValueData: NSObject, NSCoding{
    
    //blood_glucose
    var fast                : String!
    var pp                  : String!
    
    //BMI
    var height              : String!
    var weight              : String!
    
    //bloodpressure
    var diastolic           : String!
    var systolic            : String!
    
    //Fibro scan
    var lsm                 : String!
    var cap                 : String!
    
    //FIB4 Score
    var sgot                : String!
    var sgpt                : String!
    var platelet            : String!
    
    //Total cholesterol
    var hdl_cholesterol     : String!
    var ldl_cholesterol     : String!
    var triglycerides       : String!
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        fast = json["fast"].stringValue
        pp = json["pp"].stringValue
        height = json["height"].stringValue
        weight = json["weight"].stringValue
        diastolic = json["diastolic"].stringValue
        systolic = json["systolic"].stringValue
        
        lsm = json["lsm"].stringValue
        cap = json["cap"].stringValue
        sgot = json["sgot"].stringValue
        sgpt = json["sgpt"].stringValue
        platelet = json["platelet"].stringValue
        hdl_cholesterol = json["hdl_cholesterol"].stringValue
        ldl_cholesterol = json["ldl_cholesterol"].stringValue
        triglycerides = json["triglycerides"].stringValue
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        height = aDecoder.decodeObject(forKey: "height") as? String
        weight = aDecoder.decodeObject(forKey: "weight") as? String
        
        fast = aDecoder.decodeObject(forKey: "fast") as? String
        pp = aDecoder.decodeObject(forKey: "pp") as? String
        
        diastolic = aDecoder.decodeObject(forKey: "diastolic") as? String
        systolic = aDecoder.decodeObject(forKey: "systolic") as? String
        
        lsm = aDecoder.decodeObject(forKey: "lsm") as? String
        cap = aDecoder.decodeObject(forKey: "cap") as? String
        sgot = aDecoder.decodeObject(forKey: "sgot") as? String
        sgpt = aDecoder.decodeObject(forKey: "sgpt") as? String
        platelet = aDecoder.decodeObject(forKey: "platelet") as? String
        hdl_cholesterol = aDecoder.decodeObject(forKey: "hdl_cholesterol") as? String
        ldl_cholesterol = aDecoder.decodeObject(forKey: "ldl_cholesterol") as? String
        triglycerides = aDecoder.decodeObject(forKey: "triglycerides") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if weight != nil{
            aCoder.encode(weight, forKey: "weight")
        }
        
        if fast != nil{
            aCoder.encode(fast, forKey: "fast")
        }
        if pp != nil{
            aCoder.encode(pp, forKey: "pp")
        }
        
        if diastolic != nil{
            aCoder.encode(diastolic, forKey: "diastolic")
        }
        if systolic != nil{
            aCoder.encode(systolic, forKey: "systolic")
        }
        if lsm != nil {
            aCoder.encode(lsm, forKey: "lsm")
        }
        if cap != nil {
            aCoder.encode(cap, forKey: "cap")
        }
        if sgot != nil {
            aCoder.encode(sgot, forKey: "sgot")
        }
        if sgpt != nil {
            aCoder.encode(sgpt, forKey: "sgpt")
        }
        if platelet != nil {
            aCoder.encode(platelet, forKey: "platelet")
        }
        if hdl_cholesterol != nil {
            aCoder.encode(hdl_cholesterol, forKey: "hdl_cholesterol")
        }
        if ldl_cholesterol != nil {
            aCoder.encode(ldl_cholesterol, forKey: "ldl_cholesterol")
        }
        if triglycerides != nil {
            aCoder.encode(triglycerides, forKey: "triglycerides")
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class InRange{


    var inRange             : String!
    
    var fast                : String!
    var pp                  : String!
    
    //BMI
    var height              : String!
    var weight              : String!
    
    //bloodpressure
    var diastolic           : String!
    var systolic            : String!
    
    //Fibro scan
    var lsm                 : String!
    var cap                 : String!
    
    //FIB4 Score
    var sgot                : String!
    var sgpt                : String!
    var platelet            : String!
    
    //Total cholesterol
    var hdl_cholesterol     : String!
    var ldl_cholesterol     : String!
    var triglycerides       : String!
    

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        inRange = json["in_range"].stringValue
        fast = json["fast"].stringValue
        pp = json["pp"].stringValue
        height = json["height"].stringValue
        weight = json["weight"].stringValue
        diastolic = json["diastolic"].stringValue
        systolic = json["systolic"].stringValue
        lsm = json["lsm"].stringValue
        cap = json["cap"].stringValue
        sgot = json["sgot"].stringValue
        sgpt = json["sgpt"].stringValue
        platelet = json["platelet"].stringValue
        hdl_cholesterol = json["hdl_cholesterol"].stringValue
        ldl_cholesterol = json["ldl_cholesterol"].stringValue
        triglycerides = json["triglycerides"].stringValue
        
    }

}
