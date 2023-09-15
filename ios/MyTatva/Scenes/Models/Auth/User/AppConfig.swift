//
//  AppConfig.swift
//

//

import Foundation

class AppConfig {

    var accessKey : String = ""
    var bucket : String = ""
    var region : String = ""
    var secretAccessKey = ""
    var url : String = ""

    init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accessKey = json["access_key"].stringValue
        bucket = json["bucket"].stringValue
        region = json["region"].stringValue
        secretAccessKey = json["secret_access_key"].stringValue
        url = json["url"].stringValue
    }
}
