//
//  LabTestOrderSummaryModel.swift
//  MyTatva
//

//

import Foundation

class LabTestOrderSummaryModel {
    
    var address : LabAddressListModel!
    var appointmentDate : String!
    var bcpTestPriceData : BcpTestPriceData!
    var createdAt : String!
    var finalPayableAmount : Int!
    var homeCollectionCharge : Int!
    var items : [LabItem]!
    var lab : LabDetailsModel!
    var member : LabPatientListModel!
    var orderId : String!
    var orderMasterId : String!
    var orderTotal : Int!
    var payableAmount : Int!
    var slotTime : String!
    var totalItems : Int!
    var orderStatusData : [OrderStatusData]!
    
    var orderStatus : String!
    var refOrderId : String!
    
    var orderLeadId : String!
    var orderMobile : String!
    var orderProcess : String!
    var serviceCharge : String!
    var serviceDateTime : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = LabAddressListModel(fromJson: addressJson)
        }
        appointmentDate = json["appointment_date"].stringValue
        let bcpTestPriceDataJson = json["bcp_test_price_data"]
        if !bcpTestPriceDataJson.isEmpty{
            bcpTestPriceData = BcpTestPriceData(fromJson: bcpTestPriceDataJson)
        }
        createdAt = json["created_at"].stringValue
        finalPayableAmount = json["final_payable_amount"].intValue
        homeCollectionCharge = json["home_collection_charge"].intValue
        items = [LabItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = LabItem(fromJson: itemsJson)
            items.append(value)
        }
        let labJson = json["lab"]
        if !labJson.isEmpty{
            lab = LabDetailsModel(fromJson: labJson)
        }
        let memberJson = json["member"]
        if !memberJson.isEmpty{
            member = LabPatientListModel(fromJson: memberJson)
        }
        orderId = json["order_id"].stringValue
        orderMasterId = json["order_master_id"].stringValue
        orderTotal = json["order_total"].intValue
        payableAmount = json["payable_amount"].intValue
        slotTime = json["slot_time"].stringValue
        totalItems = json["total_items"].intValue
        orderStatusData = [OrderStatusData]()
        let orderStatusDataArray = json["order_status_data"].arrayValue
        for orderStatusDataJson in orderStatusDataArray{
            let value = OrderStatusData(fromJson: orderStatusDataJson)
            orderStatusData.append(value)
        }
        orderStatus = json["order_status"].stringValue
        refOrderId = json["ref_order_id"].stringValue

        orderLeadId = json["order_lead_id"].stringValue
        orderMobile = json["order_mobile"].stringValue

        serviceCharge = json["service_charge"].stringValue
        serviceDateTime = json["service_date_time"].stringValue
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class LabItem {
    
    var createdAt : String!
    var customerRate : Int!
    var data : LabItemData!
    var orderItemRelId : String!
    var orderMasterId : String!
    var orderNo : String!
    var orderStatus : String!
    var orderStatusData : [OrderStatusData]!
    var patientId : String!
    var process : String!
    var refOrderId : String!
    var serviceType : String!
    var testCode : String!
    var type: String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        customerRate = json["customer_rate"].intValue
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = LabItemData(fromJson: dataJson)
        }
        orderItemRelId = json["order_item_rel_id"].stringValue
        orderMasterId = json["order_master_id"].stringValue
        orderNo = json["order_no"].stringValue
        orderStatus = json["order_status"].stringValue
        orderStatusData = [OrderStatusData]()
        let orderStatusDataArray = json["order_status_data"].arrayValue
        for orderStatusDataJson in orderStatusDataArray{
            let value = OrderStatusData(fromJson: orderStatusDataJson)
            orderStatusData.append(value)
        }
        patientId = json["patient_id"].stringValue
        process = json["process"].stringValue
        refOrderId = json["ref_order_id"].stringValue
        serviceType = json["service_type"].stringValue
        testCode = json["test_code"].stringValue
        type = json["type"].stringValue
    }

}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class OrderStatusData {

    var done : String!
    var index : Int!
    var status : String!


    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        done = json["done"].stringValue
        index = json["index"].intValue
        status = json["status"].stringValue
    }


}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class LabItemData{

    var discountPercent : Int!
    var discountPrice : Int!
    var name : String!
    var price : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        discountPercent = json["discount_percent"].intValue
        discountPrice = json["discount_price"].intValue
        name = json["name"].stringValue
        price = json["price"].intValue
    }

}
