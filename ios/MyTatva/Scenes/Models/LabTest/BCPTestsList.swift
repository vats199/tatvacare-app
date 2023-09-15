//
//  BCPTestsList.swift
//  MyTatva
//
//  Created by Hlink on 23/06/23.
//

import Foundation

class BcpTestsList{

    var code : String!
    var discountPercent : Int!
    var discountPrice : Int!
    var imageLocation : String!
    var labTestId : String!
    var name : String!
    var price : Int!
    var testNames : String!
    var bcpAddressData : LabAddressListModel!
    var bcpTestsList : [BcpTestsList]!
    var isBcpTestsAdded : Bool!
    var patientPlanRelId : String!
    var planName : String!
    var type : String!
    var isLabTest = false
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        discountPercent = json["discount_percent"].intValue
        discountPrice = json["discount_price"].intValue
        imageLocation = json["imageLocation"].stringValue
        labTestId = json["lab_test_id"].stringValue
        name = json["name"].stringValue
        price = json["price"].intValue
        testNames = json["testNames"].stringValue
        let bcpAddressDataJson = json["bcp_address_data"]
        if !bcpAddressDataJson.isEmpty{
            bcpAddressData = LabAddressListModel(fromJson: bcpAddressDataJson)
        }
        bcpTestsList = [BcpTestsList]()
        let bcpTestsListArray = json["bcp_tests_list"].arrayValue
        for bcpTestsListJson in bcpTestsListArray{
            let value = BcpTestsList(fromJson: bcpTestsListJson)
            bcpTestsList.append(value)
        }
        isBcpTestsAdded = json["is_bcp_tests_added"].boolValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        planName = json["plan_name"].stringValue
        type = json["type"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if discountPercent != nil{
            dictionary["discount_percent"] = discountPercent
        }
        if discountPrice != nil{
            dictionary["discount_price"] = discountPrice
        }
        if imageLocation != nil{
            dictionary["imageLocation"] = imageLocation
        }
        if labTestId != nil{
            dictionary["lab_test_id"] = labTestId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if price != nil{
            dictionary["price"] = price
        }
        if testNames != nil{
            dictionary["testNames"] = testNames
        }
        if bcpAddressData != nil{
            dictionary["bcp_address_data"] = bcpAddressData.toDictionary()
        }
        if bcpTestsList != nil{
            var dictionaryElements = [[String:Any]]()
            for bcpTestsListElement in bcpTestsList {
                dictionaryElements.append(bcpTestsListElement.toDictionary())
            }
            dictionary["bcp_tests_list"] = dictionaryElements
        }
        if isBcpTestsAdded != nil{
            dictionary["is_bcp_tests_added"] = isBcpTestsAdded
        }
        if patientPlanRelId != nil{
            dictionary["patient_plan_rel_id"] = patientPlanRelId
        }
        if planName != nil{
            dictionary["plan_name"] = planName
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }

}
