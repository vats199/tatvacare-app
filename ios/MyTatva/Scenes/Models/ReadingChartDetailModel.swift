

import Foundation

class ReadingChartDetailModel{
    
    var average : Average!
    var colorCode1 : String!
    var colorCode2 : String!
    var lastReadingDate : String!
    var readingsData : [ReadingsData]!
    
    var capStandardMax : String!
    var capStandardMin : String!
    var diastolicStandardMax : String!
    var diastolicStandardMin : String!
    var fastStandardMax : String!
    var fastStandardMin : String!
    var lsmStandardMax : String!
    var lsmStandardMin : String!
    var ppStandardMax : String!
    var ppStandardMin : String!
    var standardMax : String!
    var standardMin : String!
    var systolicStandardMax : String!
    var systolicStandardMin : String!
    var thresholdShow : String!

    init(){}
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let averageJson = json["average"]
        if !averageJson.isEmpty{
            average = Average(fromJson: averageJson)
        }
        colorCode1 = json["color_code_1"].stringValue
        colorCode2 = json["color_code_2"].stringValue
        lastReadingDate = json["last_reading_date"].stringValue
        readingsData = [ReadingsData]()
        let readingsDataArray = json["readings_data"].arrayValue
        for readingsDataJson in readingsDataArray{
            let value = ReadingsData(fromJson: readingsDataJson)
            readingsData.append(value)
        }
        capStandardMax = json["cap_standard_max"].stringValue
        capStandardMin = json["cap_standard_min"].stringValue
        diastolicStandardMax = json["diastolic_standard_max"].stringValue
        diastolicStandardMin = json["diastolic_standard_min"].stringValue
        fastStandardMax = json["fast_standard_max"].stringValue
        fastStandardMin = json["fast_standard_min"].stringValue
        lsmStandardMax = json["lsm_standard_max"].stringValue
        lsmStandardMin = json["lsm_standard_min"].stringValue
        ppStandardMax = json["pp_standard_max"].stringValue
        ppStandardMin = json["pp_standard_min"].stringValue
        standardMax = json["standard_max"].stringValue
        standardMin = json["standard_min"].stringValue
        systolicStandardMax = json["systolic_standard_max"].stringValue
        systolicStandardMin = json["systolic_standard_min"].stringValue
        thresholdShow = json["threshold_show"].stringValue
    }
}

class ReadingsData{

    var colorCode : String!
    var createdAt : String!
    var diastolic : Double!
    var fast : Double!
    var height : Double!
    var imgExtn : String!
    var isActive : String!
    var isDeleted : String!
    var keys : String!
    var maxLimit : String!
    var measurements : String!
    var minLimit : String!
    var pp : Double!
    var readingDatetime : String!
    var readingName : String!
    var readingValue : Double!
    var readingValueMax : Double!
    var readingValueMin : Double!
    var readingsMasterId : String!
    var systolic : Double!
    var updatedAt : String!
    var updatedBy : String!
    var weight : Double!
    var xValue : String!
    var reading_values: [String]!
    var cap : Double!
    var lsm : Double!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        colorCode = json["color_code"].stringValue
        createdAt = json["created_at"].stringValue
        diastolic = json["diastolic"].doubleValue
        fast = json["fast"].doubleValue
        height = json["height"].doubleValue
        imgExtn = json["img_extn"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        keys = json["keys"].stringValue
        maxLimit = json["max_limit"].stringValue
        measurements = json["measurements"].stringValue
        minLimit = json["min_limit"].stringValue
        pp = json["pp"].doubleValue
        readingDatetime = json["reading_datetime"].stringValue
        readingName = json["reading_name"].stringValue
        readingValue = json["reading_value"].doubleValue
        readingValueMax = json["reading_value_max"].doubleValue
        readingValueMin = json["reading_value_min"].doubleValue
        readingsMasterId = json["readings_master_id"].stringValue
        systolic = json["systolic"].doubleValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        weight = json["weight"].doubleValue
        xValue = json["x_value"].stringValue
        reading_values = [String]()
        let reading_valuesJson = json["reading_values"].arrayObject
        if reading_valuesJson != nil{
            reading_values.append(contentsOf: reading_valuesJson as? [String] ?? [""])
        }
        cap = json["cap"].doubleValue
        lsm = json["lsm"].doubleValue
    }
}

class Average{

    var diastolic : Int!
    var fast : Int!
    var pp : Int!
    var readingValue : Double!
    var systolic : Int!
    var lsm : Int!
    var cap : Int!


    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        diastolic = json["diastolic"].intValue
        fast = json["fast"].intValue
        pp = json["pp"].intValue
        readingValue = json["reading_value"].doubleValue
        systolic = json["systolic"].intValue
        lsm = json["lsm"].intValue
        cap = json["cap"].intValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension ReadingsData {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ReadingsData] {
        var models:[ReadingsData] = []
        for item in array
        {
            models.append(ReadingsData(fromJson: item))
        }
        return models
    }
}
