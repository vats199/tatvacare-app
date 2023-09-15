

import Foundation

class ParentPaymentHistoryListModel {
    
    var title = ""
    var type: PaymentHistoryType = .plan
    var arr = [PaymentHistoryListModel]()
}

class PaymentHistoryListModel {
    
    var androidPrice : String!
    var deviceType : String!
    var imageUrl : String!
    var iosPrice : Int!
    var offerPrice : Int!
    var planEndDate : String!
    var planName : String!
    var planPurchaseDatetime : String!
    var planStartDate : String!
    var subTitle : String!
    var transactionType : String!
    var invoiceURL: String!
    
    var isSelected = false
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        androidPrice = json["android_price"].stringValue
        deviceType = json["device_type"].stringValue
        imageUrl = json["image_url"].stringValue
        iosPrice = json["ios_price"].intValue
        offerPrice = json["offer_price"].intValue
        planEndDate = json["plan_end_date"].stringValue
        planName = json["plan_name"].stringValue
        planPurchaseDatetime = json["plan_purchase_datetime"].stringValue
        planStartDate = json["plan_start_date"].stringValue
        subTitle = json["sub_title"].stringValue
        transactionType = json["transaction_type"].stringValue
        invoiceURL = json["invoice_url"].stringValue
    }
}

//MARK: ---------------- Array Model ----------------------
extension PaymentHistoryListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PaymentHistoryListModel] {
        var models:[PaymentHistoryListModel] = []
        for item in array
        {
            models.append(PaymentHistoryListModel(fromJson: item))
        }
        return models
    }
}

