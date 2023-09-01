//
//  BCPTestPriceData.swift
//  MyTatva
//
//  Created by Hlink on 29/06/23.
//

import Foundation

class BcpTestPriceData {

    var bcpFinalAmountToPay : Int!
    var bcpHomeCollectionCharge : Int!
    var bcpHomeCollectionChargeOld : Int!
    var bcpServiceCharge : Int!
    var bcpTotalAmount : Int!
    var bcpTotalAmountOld : Int!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bcpFinalAmountToPay = json["bcp_final_amount_to_pay"].intValue
        bcpHomeCollectionCharge = json["bcp_home_collection_charge"].intValue
        bcpHomeCollectionChargeOld = json["bcp_home_collection_charge_old"].intValue
        bcpServiceCharge = json["bcp_service_charge"].intValue
        bcpTotalAmount = json["bcp_total_amount"].intValue
        bcpTotalAmountOld = json["bcp_total_amount_old"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bcpFinalAmountToPay != nil{
            dictionary["bcp_final_amount_to_pay"] = bcpFinalAmountToPay
        }
        if bcpHomeCollectionCharge != nil{
            dictionary["bcp_home_collection_charge"] = bcpHomeCollectionCharge
        }
        if bcpHomeCollectionChargeOld != nil{
            dictionary["bcp_home_collection_charge_old"] = bcpHomeCollectionChargeOld
        }
        if bcpServiceCharge != nil{
            dictionary["bcp_service_charge"] = bcpServiceCharge
        }
        if bcpTotalAmount != nil{
            dictionary["bcp_total_amount"] = bcpTotalAmount
        }
        if bcpTotalAmountOld != nil{
            dictionary["bcp_total_amount_old"] = bcpTotalAmountOld
        }
        return dictionary
    }

}
