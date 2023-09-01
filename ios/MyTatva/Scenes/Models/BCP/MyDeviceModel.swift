//
//  MyDeviceModel.swift
//  MyTatva
//
//  Created by 2022M43 on 21/06/23.
//

import Foundation
import SwiftyJSON


class MyDeviceModel {

    var addressData : LabAddressListModel!
    var devices : [DeviceDetailsModel]!
    var patientDetails : UserModel!
    var status : String!
    var transactionId : String!

    init() {}

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let addressDataJson = json["address_data"]
        if !addressDataJson.isEmpty{
            addressData = LabAddressListModel(fromJson: addressDataJson)
        }
        devices = [DeviceDetailsModel]()
        let devicesArray = json["devices"].arrayValue
        for devicesJson in devicesArray{
            let value = DeviceDetailsModel(fromJson: devicesJson)
            devices.append(value)
        }
        devices = devices.filter({ $0.key != "spirometer" })
        let patientDetailsJson = json["patient_details"]
        if !patientDetailsJson.isEmpty{
            patientDetails = UserModel(fromJson: patientDetailsJson)
        }
        status = json["status"].stringValue
        transactionId = json["transaction_id"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if devices != nil{
            var dictionaryElements = [[String:Any]]()
            for devicesElement in devices {
                dictionaryElements.append(devicesElement.toDictionary())
            }
            dictionary["devices"] = dictionaryElements
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         addressData = aDecoder.decodeObject(forKey: "address_data") as? LabAddressListModel
         devices = aDecoder.decodeObject(forKey: "devices") as? [DeviceDetailsModel]
         patientDetails = aDecoder.decodeObject(forKey: "patient_details") as? UserModel

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if addressData != nil{
            aCoder.encode(addressData, forKey: "address_data")
        }
        if devices != nil{
            aCoder.encode(devices, forKey: "devices")
        }
        if patientDetails != nil{
            aCoder.encode(patientDetails, forKey: "patient_details")
        }

    }

}
