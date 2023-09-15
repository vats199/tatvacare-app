//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class HospitalDetailsModel {
    
    var zydusAddress : String!
    var zydusEmail : String!
    var zydusName : String!
    var zydusPdf : String!
    var zydusPhone : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        zydusAddress = json["zydus_address"].stringValue
        zydusEmail = json["zydus_email"].stringValue
        zydusName = json["zydus_name"].stringValue
        zydusPdf = json["zydus_pdf"].stringValue
        zydusPhone = json["zydus_phone"].stringValue
    }
}
