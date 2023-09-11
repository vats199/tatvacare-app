

import Foundation

class LabTestHistoryModel {
    
    
    var appointmentDate : String!
    var bcpTestPriceData : BcpTestPriceData!
    var createdAt : String!
    var finalPayableAmount : Int!
    var homeCollectionCharge : Int!
    var orderId : String!
    var orderMasterId : String!
    var orderStatus : String!
    var orderTotal : Int!
    var payableAmount : Int!
    var slotTime : String!
    var status : String!
    var totalItems : Int!
    var name : String!
    var refOrderId: String!
    
    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        appointmentDate = json["appointment_date"].stringValue
        let bcpTestPriceDataJson = json["bcp_test_price_data"]
        if !bcpTestPriceDataJson.isEmpty{
            bcpTestPriceData = BcpTestPriceData(fromJson: bcpTestPriceDataJson)
        }
        createdAt = json["created_at"].stringValue
        finalPayableAmount = json["final_payable_amount"].intValue
        homeCollectionCharge = json["home_collection_charge"].intValue
        orderId = json["order_id"].stringValue
        orderMasterId = json["order_master_id"].stringValue
        orderStatus = json["order_status"].stringValue
        orderTotal = json["order_total"].intValue
        payableAmount = json["payable_amount"].intValue
        slotTime = json["slot_time"].stringValue
        status = json["status"].stringValue
        totalItems = json["total_items"].intValue
        name = json["name"].stringValue
        refOrderId = json["ref_order_id"].stringValue
    }
    
}

//MARK: ---------------- Array Model ----------------------
extension LabTestHistoryModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [LabTestHistoryModel] {
        var models:[LabTestHistoryModel] = []
        for item in array
        {
            models.append(LabTestHistoryModel(fromJson: item))
        }
        return models
    }
}

